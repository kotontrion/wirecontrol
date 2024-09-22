namespace Wirecontrol {
    [GtkTemplate (ui = "/com/github/kotontrion/wirecontrol/endpoint.ui")]
    public class Endpoint : Gtk.ListBoxRow {

        public AstalWp.Endpoint endpoint { get; construct; }

        [GtkChild]
        private unowned Gtk.Adjustment volume_adjust;
        [GtkChild]
        private unowned Gtk.ToggleButton mute_toggle;
        [GtkChild]
        private unowned Gtk.ToggleButton default_toggle;
        [GtkChild]
        private unowned Gtk.ToggleButton lock_toggle;

        public Endpoint (AstalWp.Endpoint endpoint) {
            Object(endpoint: endpoint);

            endpoint.bind_property("volume", volume_adjust, "value", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            endpoint.bind_property("mute", mute_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            endpoint.bind_property("is-default", default_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            endpoint.bind_property("lock-channels", lock_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            realize.connect(() => {
                get_root().bind_property("max-vol", volume_adjust, "upper", GLib.BindingFlags.SYNC_CREATE);
            });
        }

        [GtkCallback]
        public bool default_toggle_visible(AstalWp.MediaClass media_class) {
            return media_class == AstalWp.MediaClass.AUDIO_SPEAKER
                || media_class == AstalWp.MediaClass.AUDIO_MICROPHONE;
        }
    }
}
