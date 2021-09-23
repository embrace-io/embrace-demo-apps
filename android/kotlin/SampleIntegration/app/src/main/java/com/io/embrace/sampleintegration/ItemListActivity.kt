package com.io.embrace.sampleintegration

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.widget.NestedScrollView
import androidx.recyclerview.widget.DefaultItemAnimator
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.RecyclerView.ViewHolder
import com.io.embrace.sampleintegration.models.Item
import io.embrace.android.embracesdk.Embrace
import kotlinx.android.synthetic.main.activity_item_list.*


class ItemListActivity : AppCompatActivity() {

    private var twoPane: Boolean = false
    private var adapter: SimpleItemRecyclerViewAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_item_list)

        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        toolbar.title = title

        if (findViewById<NestedScrollView>(R.id.item_detail_container) != null) {
            twoPane = true
        }

        setupRecyclerView(findViewById(R.id.item_list))

        add_item.setOnClickListener {
            adapter?.addNewItem()
        }

        // EMBRACE HINT:
        // Event logging is how you can ensure that events are available in alerts as they happen, rather than when sessions end.
        // If you are tracking down a difficult bug, or trying to understand a complex interaction -- logging is an appropriate API to use
        // For lighter weight tracking like navigation events, look into breadcrumbs.
        Handler().postDelayed({
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
            val properties: MutableMap<String, Any> = HashMap()
            properties["property_a"] = "value_a"
            properties["property_b"] = "value_b"

            Embrace.getInstance().logError("Loading not finished in time.", properties, true)

        }, 2000)
    }

    override fun onBackPressed() {
        adapter?.let { a ->
            a.isAnyMenuShown()?.let { item ->
                a.closeMenu(item.content)
            } ?: run {
                super.onBackPressed()
            }
        } ?: run {
            super.onBackPressed()
        }
    }

    private fun setupRecyclerView(recyclerView: RecyclerView) {
        adapter = SimpleItemRecyclerViewAdapter(this, Item.ITEMS, twoPane)
        recyclerView.adapter = adapter

        // Add item animator listener to handle animation's states
        recyclerView.itemAnimator = object : DefaultItemAnimator() {
            override fun onAddFinished(item: ViewHolder?) {
                super.onAddFinished(item)
                // EMBRACE HINT:
                // This is where we end our add item moment. We wanted to measure this interaction
                // as it is core to our user experience. By measuring user interactions in this
                // manner you can start to understand how app performance impacts your user journey.
                Embrace.getInstance().endEvent(ADD_ITEM_MOMENT_NAME)
            }

            override fun onRemoveFinished(item: ViewHolder?) {
                super.onRemoveFinished(item)
                // EMBRACE HINT:
                // We wrap the animation with a moment to try to understand the performance of this
                // operation as our users will do it often.
                Embrace.getInstance().logBreadcrumb("ending remove item moment")
                Embrace.getInstance().endEvent(REMOVE_ITEM_MOMENT_NAME)
            }
        }

        val touchHelperCallback: ItemTouchHelper.SimpleCallback =
            object : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT) {

                override fun onMove(
                    recyclerView: RecyclerView,
                    viewHolder: ViewHolder,
                    target: ViewHolder
                ): Boolean {
                    return false
                }

                override fun onSwiped(
                    viewHolder: ViewHolder,
                    direction: Int
                ) {
                    adapter?.showMenu(viewHolder.adapterPosition)
                }
            }
        val itemTouchHelper = ItemTouchHelper(touchHelperCallback)
        itemTouchHelper.attachToRecyclerView(recyclerView)
    }

    class SimpleItemRecyclerViewAdapter(
        private val parentActivity: ItemListActivity,
        private val values: MutableList<Item.DummyItem>,
        private val twoPane: Boolean
    ) :
        RecyclerView.Adapter<ViewHolder>() {

        private val navigateDetailListener: View.OnClickListener = View.OnClickListener { v ->
            val item = v.tag as Item.DummyItem

            // EMBRACE HINT:
            // Embrace has two options for logging events, breadcrumbs and logs.  This is an example of breadcrumb.
            // Breadcrumbs are lightweight items that little overhead to your application
            // Use them to track branching and state changes that are relevant to the session but not urgent for alerting.
            val msg = String.format("Navigating to detail page for: %s", item.id)
            Embrace.getInstance().logBreadcrumb(msg)

            if (twoPane) {
                val fragment = ItemDetailFragment().apply {
                    arguments = Bundle().apply {
                        putString(ItemDetailFragment.ARG_ITEM_ID, item.id)
                    }
                }
                parentActivity.supportFragmentManager
                    .beginTransaction()
                    .replace(R.id.item_detail_container, fragment)
                    .commit()
            } else {
                val intent = Intent(v.context, ItemDetailActivity::class.java).apply {
                    putExtra(ItemDetailFragment.ARG_ITEM_ID, item.id)
                }
                v.context.startActivity(intent)
            }
        }
        private val removeListener: View.OnClickListener

        init {

            removeListener = View.OnClickListener { v ->
                val position = v.tag as Int

                removeItem(position)
            }
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {

            val view: View

            return if (viewType == SHOW_MENU) {
                view = LayoutInflater.from(parent.context)
                    .inflate(R.layout.item_list_menu, parent, false)

                MenuViewHolder(view)
            } else {
                view = LayoutInflater.from(parent.context)
                    .inflate(R.layout.item_list_content, parent, false)

                ItemViewHolder(view)
            }
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            val item = values[position]

            if (holder is ItemViewHolder) {
                holder.idView.text = item.id
                holder.contentView.text = item.content

                with(holder.contentView) {
                    tag = item
                    setOnClickListener(navigateDetailListener)
                }
            }

            if (holder is MenuViewHolder) {
                with(holder.removeView) {
                    tag = position
                    setOnClickListener(removeListener)
                }
            }
        }

        override fun getItemViewType(position: Int): Int {
            return if (values[position].showMenu) {
                SHOW_MENU
            } else {
                HIDE_MENU
            }
        }

        override fun getItemCount() = values.size

        fun addNewItem() {
            val pos = values.size + 1
            values.add(Item.createDummyItem(pos))
            // EMBRACE HINT:
            // Moments are a great way to measure the performance and abandonment of workflows within your application
            // Here we are inserting a new item into our recycler view.  The moment is wrapping that action so we can
            // Understand how our database and animation performance is working during this process.
            // Always make sure to end moments you start, Embrace considered any non-ended moment to be an abandonment by the user
            Embrace.getInstance().startEvent(ADD_ITEM_MOMENT_NAME, ITEM_MOMENT_ID, false, null)

            notifyItemInserted(values.size)
            notifyItemRangeChanged(values.size - 1, values.size)
        }

        private fun removeItem(pos: Int) {
            values.removeAt(pos)
            notifyItemRemoved(pos)
            notifyItemRangeChanged(pos, values.size)
            // EMBRACE HINT:
            // This is where we are measuring our remove item workflow.
            val properties: MutableMap<String, Any> = HashMap()
            properties["item_remove"] = "Item $pos"

            Embrace.getInstance().logBreadcrumb("starting remove item moment")
            Embrace.getInstance()
                .startEvent(REMOVE_ITEM_MOMENT_NAME, ITEM_MOMENT_ID, false, properties)
        }

        fun showMenu(position: Int) {
            for (i in 0 until values.size) {
                values[i].showMenu = false
            }
            values[position].showMenu = true
            notifyItemChanged(position)
        }


        fun isAnyMenuShown(): Item.DummyItem? {
            for (i in 0 until values.size) {
                if (values[i].showMenu) {
                    return values[i]
                }
            }
            return null
        }

        fun closeMenu(itemName: String) {
            for (i in 0 until values.size) {
                if (values[i].content == itemName) {
                    values[i].showMenu = false
                    notifyItemChanged(i)
                }
            }
        }

        inner class ItemViewHolder(view: View) : ViewHolder(view) {
            val idView: TextView = view.findViewById(R.id.id_text)
            val contentView: TextView = view.findViewById(R.id.content)
        }

        inner class MenuViewHolder(view: View) : ViewHolder(view) {
            val removeView: TextView = view.findViewById(R.id.remove)
        }

        companion object {
            const val SHOW_MENU = 1
            const val HIDE_MENU = 2
        }
    }

    // EMBRACE HINT:
    // Storing constants like moment or breadcrumb names in a companion object keeps them out of the global namespace
    // while also making typos less likely.
    companion object {
        const val ADD_ITEM_MOMENT_NAME = "embrace_add_item"
        const val REMOVE_ITEM_MOMENT_NAME = "embrace_remove_item"
        const val ITEM_MOMENT_ID = "embrace_moment_id"
    }
}