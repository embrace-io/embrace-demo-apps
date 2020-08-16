package com.io.embrace.sampleintegration.models

import java.util.*

object Item {

    /**
     * An array of sample items.
     */
    val ITEMS: MutableList<DummyItem> = ArrayList()

    /**
     * A map of sample items, by ID.
     */
    val ITEM_MAP: MutableMap<String, DummyItem> = HashMap()

    private const val COUNT = 25

    init {
        // Add some sample items.
        for (i in 1..COUNT) {
            addItem(createDummyItem(i))
        }
    }

    fun createDummyItem(position: Int): DummyItem {
        return DummyItem(position.toString(), "Item $position", makeDetails(position), false)
    }

    private fun addItem(item: DummyItem) {
        ITEMS.add(item)
        ITEM_MAP[item.id] = item
    }

    private fun makeDetails(position: Int): String {
        val builder = StringBuilder()
        builder.append("Details about Item: ").append(position)
        for (i in 0 until position) {
            builder.append("\nMore details information here.")
        }
        return builder.toString()
    }

    /**
     * An item representing a piece of content.
     */
    data class DummyItem(
        val id: String,
        val content: String,
        val details: String,
        var showMenu: Boolean
    ) {
        override fun toString(): String = content
    }
}