package com.io.embrace.sampleintegration

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.google.android.material.appbar.CollapsingToolbarLayout
import com.io.embrace.sampleintegration.models.Item

class ItemDetailFragment : Fragment() {

    private var item: Item.DummyItem? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        arguments?.let {
            if (it.containsKey(ARG_ITEM_ID)) {
                item = Item.ITEM_MAP[it.getString(ARG_ITEM_ID)]
                activity?.findViewById<CollapsingToolbarLayout>(R.id.toolbar_layout)?.title =
                    item?.content
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val rootView = inflater.inflate(R.layout.item_detail, container, false)

        // Show the item content as text in a TextView.
        item?.let {
            rootView.findViewById<TextView>(R.id.item_detail).text = it.details
        }

        return rootView
    }

    companion object {
        const val ARG_ITEM_ID = "item_id"
    }
}