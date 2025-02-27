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
        [GtkChild]
        private unowned Gtk.Box channel_box;

        public Endpoint (AstalWp.Endpoint endpoint) {
            Object(endpoint: endpoint);

            endpoint.bind_property("volume", volume_adjust, "value", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            endpoint.bind_property("mute", mute_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            endpoint.bind_property("is-default", default_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            endpoint.bind_property("lock-channels", lock_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            realize.connect(() => {
                get_root().bind_property("max-vol", volume_adjust, "upper", GLib.BindingFlags.SYNC_CREATE);
            });

            endpoint.notify["channel-volumes"].connect(recreate_channels);
            recreate_channels();
        }

        private void recreate_channels() {
           var widget = channel_box.get_first_child();
                while(widget != null) {
                  channel_box.remove(widget);
                  widget = channel_box.get_first_child();
                }
                if(endpoint.channel_volumes == null) return;
                foreach(var cv in endpoint.channel_volumes) {
                  var channel = new Wirecontrol.VolumeScale(cv);
                  channel_box.append(channel);
                }
        }
    }
}
