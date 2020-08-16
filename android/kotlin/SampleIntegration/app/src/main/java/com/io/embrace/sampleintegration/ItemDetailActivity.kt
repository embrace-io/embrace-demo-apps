package com.io.embrace.sampleintegration

import android.content.Intent
import android.os.Bundle
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import io.embrace.android.embracesdk.Embrace

class ItemDetailActivity : AppCompatActivity() {

    private var itemId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_item_detail)
        setSupportActionBar(findViewById(R.id.detail_toolbar))

        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        if (savedInstanceState == null) {
            val fragment = ItemDetailFragment().apply {
                arguments = Bundle().apply {
                    itemId = intent.getStringExtra(ItemDetailFragment.ARG_ITEM_ID)
                    putString(
                        ItemDetailFragment.ARG_ITEM_ID,
                        itemId
                    )
                }
            }

            supportFragmentManager.beginTransaction()
                .add(R.id.item_detail_container, fragment)
                .commit()
        }
    }

    override fun onOptionsItemSelected(item: MenuItem) =
        when (item.itemId) {
            android.R.id.home -> {
                // EMBRACE HINT:
                // Here we are again using the light weight breadcrumb event to track navigation in our application
                // It is important to find Navigation and branching points that your users care about and ensure
                // you have breadcrumbs for those events, even if that means adding API to ensure you capture them.
                val msg = String.format("Returning from detail page for: %s", itemId)
                Embrace.getInstance().logBreadcrumb(msg)

                navigateUpTo(Intent(this, ItemListActivity::class.java))
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
}