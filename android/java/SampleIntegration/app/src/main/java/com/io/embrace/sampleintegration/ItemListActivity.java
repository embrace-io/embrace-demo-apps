package com.io.embrace.sampleintegration;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.ItemTouchHelper;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.io.embrace.sampleintegration.models.Item;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.embrace.android.embracesdk.Embrace;

public class ItemListActivity extends AppCompatActivity {

    // EMBRACE HINT:
    // Storing constants like moment or breadcrumb names in a companion object keeps them out of the global namespace
    // while also making typos less likely.
    private static final String ADD_ITEM_MOMENT_NAME = "embrace_add_item";
    private static final String ADD_ITEM_MOMENT_ID = "embrace_add_moment_id";
    private static final String REMOVE_ITEM_MOMENT_NAME = "embrace_remove_item";
    private static final String REMOVE_ITEM_MOMENT_ID = "embrace_remove_moment_id";
    /**
     * Whether or not the activity is in two-pane mode, i.e. running on a tablet
     * device.
     */
    private boolean mTwoPane;
    private SimpleItemRecyclerViewAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_item_list);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        toolbar.setTitle(getTitle());

        FloatingActionButton fab = findViewById(R.id.add_item);
        fab.setOnClickListener(view -> mAdapter.addNewItem());

        if (findViewById(R.id.item_detail_container) != null) {
            mTwoPane = true;
        }

        View recyclerView = findViewById(R.id.item_list);
        assert recyclerView != null;
        setupRecyclerView((RecyclerView) recyclerView);

        // EMBRACE HINT:
        // Event logging is how you can ensure that events are available in alerts as they happen, rather than when sessions end.
        // If you are tracking down a difficult bug, or trying to understand a complex interaction -- logging is an appropriate API to use
        // For lighter weight tracking like navigation events, look into breadcrumbs.
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                // EMBRACE HINT:
                // When you use logging events, these are immediately sent to our servers and are meant to be the basis for alerting you to
                // real-time issues with your application in production. As such, take care not to over-use logging events as they have a higher impact
                // on the performance of your app vs breadcrumbs.
                // In this example, we are trying to understand loading issues in our application. Users are saying that often the app hangs, failing to
                // load the homescreen, leaving the user with a blank screen. We're adding a log here to track that.
                // Note that our log is a complex object, not a simple string. By breaking out properties like this we can use their values to power
                // our alerting, we can also search and filter on the property values -- we cannot do that if we only send strings.
                // Taking a screenshot is way to see what the user was looking at yourself. Consider the users privacy and the impact on performance
                // when enabling this feature.
                Map<String, Object> properties = new HashMap<>();
                properties.put("property_a", "value_a");
                properties.put("property_b", "value_b");

                Embrace.getInstance().logError("Loading not finished in time.", properties, true);
            }
        }, 2000);
    }

    @Override
    public void onBackPressed() {
        if (mAdapter != null) {
            Item.DummyItem item = mAdapter.isAnyMenuShown();
            if (item != null) {
                mAdapter.closeMenu(item.content);
            } else {
                super.onBackPressed();
            }
        } else {
            super.onBackPressed();
        }
    }

    private void setupRecyclerView(@NonNull RecyclerView recyclerView) {
        mAdapter = new SimpleItemRecyclerViewAdapter(this, Item.ITEMS, mTwoPane);
        recyclerView.setAdapter(mAdapter);

        // Add item animator listener to handle animation's states
        recyclerView.setItemAnimator(new DefaultItemAnimator() {
            @Override
            public void onAddFinished(RecyclerView.ViewHolder item) {
                super.onAddFinished(item);
                // EMBRACE HINT:
                // This is where we end our add item moment. We wanted to measure this interaction
                // as it is core to our user experience. By measuring user interactions in this
                // manner you can start to understand how app performance impacts your user journey.
                Embrace.getInstance().endEvent(ADD_ITEM_MOMENT_NAME);
            }

            @Override
            public void onRemoveFinished(RecyclerView.ViewHolder item) {
                super.onRemoveFinished(item);
                // EMBRACE HINT:
                // We wrap the animation with a moment to try to understand the performance of this
                // operation as our users will do it often.
                Embrace.getInstance().logBreadcrumb("ending remove item moment");
                Embrace.getInstance().endEvent(REMOVE_ITEM_MOMENT_NAME);
            }
        });

        ItemTouchHelper.SimpleCallback touchHelperCallback = new ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT) {

            @Override
            public boolean onMove(@NonNull RecyclerView recyclerView, @NonNull RecyclerView.ViewHolder viewHolder, @NonNull RecyclerView.ViewHolder target) {
                return false;
            }

            @Override
            public void onSwiped(RecyclerView.ViewHolder viewHolder, int direction) {
                mAdapter.showMenu(viewHolder.getAdapterPosition());
            }
        };
        ItemTouchHelper itemTouchHelper = new ItemTouchHelper(touchHelperCallback);
        itemTouchHelper.attachToRecyclerView(recyclerView);
    }

    public static class SimpleItemRecyclerViewAdapter
            extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

        private static final int SHOW_MENU = 1;
        private static final int HIDE_MENU = 2;
        private final ItemListActivity mParentActivity;
        private final List<Item.DummyItem> mValues;
        private final boolean mTwoPane;
        private final View.OnClickListener mNavigateToDetailListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Item.DummyItem item = (Item.DummyItem) view.getTag();

                // EMBRACE HINT:
                // Embrace has two options for logging events, breadcrumbs and logs.  This is an example of breadcrumb.
                // Breadcrumbs are lightweight items that little overhead to your application
                // Use them to track branching and state changes that are relevant to the session but not urgent for alerting.
                String msg = String.format("Navigating to detail page for: %s", item.id);
                Embrace.getInstance().logBreadcrumb(msg);

                if (mTwoPane) {
                    Bundle arguments = new Bundle();
                    arguments.putString(ItemDetailFragment.ARG_ITEM_ID, item.id);
                    ItemDetailFragment fragment = new ItemDetailFragment();
                    fragment.setArguments(arguments);
                    mParentActivity.getSupportFragmentManager().beginTransaction()
                            .replace(R.id.item_detail_container, fragment)
                            .commit();
                } else {
                    Context context = view.getContext();
                    Intent intent = new Intent(context, ItemDetailActivity.class);
                    intent.putExtra(ItemDetailFragment.ARG_ITEM_ID, item.id);

                    context.startActivity(intent);
                }
            }
        };
        private final View.OnClickListener mRemoveListener = view -> {
            int pos = (int) view.getTag();
            removeItem(pos);
        };

        SimpleItemRecyclerViewAdapter(ItemListActivity parent,
                                      List<Item.DummyItem> items,
                                      boolean twoPane) {
            mValues = items;
            mParentActivity = parent;
            mTwoPane = twoPane;
        }

        @Override
        public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            View view;
            if (viewType == SHOW_MENU) {
                view = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_list_menu, parent, false);
                return new MenuViewHolder(view);
            } else {
                view = LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_list_content, parent, false);
                return new ItemViewHolder(view);
            }
        }

        @Override
        public void onBindViewHolder(@NonNull final RecyclerView.ViewHolder holder, int position) {
            Item.DummyItem item = mValues.get(position);

            if (holder instanceof ItemViewHolder) {
                ItemViewHolder itemViewHolder = (ItemViewHolder) holder;
                itemViewHolder.mIdView.setText(item.id);
                itemViewHolder.mContentView.setText(item.content);

                holder.itemView.setTag(item);
                holder.itemView.setOnClickListener(mNavigateToDetailListener);
            }

            if (holder instanceof MenuViewHolder) {
                MenuViewHolder menuViewHolder = (MenuViewHolder) holder;
                menuViewHolder.mRemove.setTag(position);
                menuViewHolder.mRemove.setOnClickListener(mRemoveListener);
            }
        }

        @Override
        public int getItemCount() {
            return mValues.size();
        }

        @Override
        public int getItemViewType(int position) {
            if (mValues.get(position).isShowingMenu()) {
                return SHOW_MENU;
            }

            return HIDE_MENU;
        }

        public void addNewItem() {
            int pos = mValues.size() + 1;
            mValues.add(Item.createDummyItem(pos));
            // EMBRACE HINT:
            // Moments are a great way to measure the performance and abandonment of workflows within your application
            // Here we are inserting a new item into our recycler view.  The moment is wrapping that action so we can
            // Understand how our database and animation performance is working during this process.
            // Always make sure to end moments you start, Embrace considered any non-ended moment to be an abandonment by the user
            Embrace.getInstance().startEvent(ADD_ITEM_MOMENT_NAME, ADD_ITEM_MOMENT_ID, false, null);

            notifyItemInserted(mValues.size());
            notifyItemRangeChanged(mValues.size() - 1, mValues.size());
        }

        private void removeItem(int pos) {
            mValues.remove(pos);
            notifyItemRemoved(pos);
            notifyItemRangeChanged(pos, mValues.size());
            // EMBRACE HINT:
            // This is where we are measuring our remove item workflow.
            Map<String, Object> properties = new HashMap<>();
            properties.put("item_remove", String.format("Item %s", pos));

            Embrace.getInstance().logBreadcrumb("starting remove item moment");
            Embrace.getInstance()
                    .startEvent(REMOVE_ITEM_MOMENT_NAME, REMOVE_ITEM_MOMENT_ID, false, properties);
        }

        public void showMenu(int position) {
            for (int i = 0; i < mValues.size(); i++) {
                mValues.get(i).setShowMenu(false);
            }
            mValues.get(position).setShowMenu(true);
            notifyDataSetChanged();
        }


        public Item.DummyItem isAnyMenuShown() {
            for (Item.DummyItem item : mValues) {
                if (item.isShowingMenu()) {
                    return item;
                }
            }

            return null;
        }

        public void closeMenu(String itemName) {
            for (int i = 0; i < mValues.size(); i++) {
                if (mValues.get(i).content.equals(itemName)) {
                    mValues.get(i).setShowMenu(false);
                    notifyItemChanged(i);
                }
            }
        }

        static class ItemViewHolder extends RecyclerView.ViewHolder {
            public final TextView mIdView;
            public final TextView mContentView;

            ItemViewHolder(View view) {
                super(view);
                mIdView = view.findViewById(R.id.id_text);
                mContentView = view.findViewById(R.id.content);
            }
        }

        static class MenuViewHolder extends RecyclerView.ViewHolder {
            public final TextView mRemove;

            MenuViewHolder(View view) {
                super(view);
                mRemove = view.findViewById(R.id.remove);
            }
        }
    }
}