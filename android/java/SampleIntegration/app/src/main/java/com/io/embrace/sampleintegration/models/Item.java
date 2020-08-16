package com.io.embrace.sampleintegration.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Item {

    /**
     * An array of sample items.
     */
    public static final List<DummyItem> ITEMS = new ArrayList<DummyItem>();

    /**
     * A map of sample items, by ID.
     */
    public static final Map<String, DummyItem> ITEM_MAP = new HashMap<String, DummyItem>();

    private static final int COUNT = 25;

    static {
        // Add some sample items.
        for (int i = 1; i <= COUNT; i++) {
            addItem(createDummyItem(i));
        }
    }

    private static void addItem(DummyItem item) {
        ITEMS.add(item);
        ITEM_MAP.put(item.id, item);
    }

    private static String makeDetails(int position) {
        StringBuilder builder = new StringBuilder();
        builder.append("Details about Item: ").append(position);
        for (int i = 0; i < position; i++) {
            builder.append("\nMore details information here.");
        }
        return builder.toString();
    }

    public static DummyItem createDummyItem(int position) {
        return new DummyItem(String.valueOf(position), "Item " + position, makeDetails(position), false);
    }

    /**
     * An item representing a piece of content.
     */
    public static class DummyItem {
        public final String id;
        public final String content;
        public final String details;
        public boolean showMenu;

        public DummyItem(String id, String content, String details, boolean showMenu) {
            this.id = id;
            this.content = content;
            this.details = details;
            this.showMenu = showMenu;
        }

        @Override
        public String toString() {
            return content;
        }

        public boolean isShowingMenu() {
            return showMenu;
        }

        public void setShowMenu(boolean showMenu) {
            this.showMenu = showMenu;
        }
    }
}