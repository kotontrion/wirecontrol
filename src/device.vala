namespace Wirecontrol {
    [GtkTemplate (ui = "/com/github/kotontrion/wirecontrol/device.ui")]
    public class Device : Gtk.ListBoxRow {

        public AstalWp.Device device { get; construct; }
        public ListStore profiles { get; private set; }

        [GtkChild]
        private unowned Gtk.DropDown profile;

        public Device (AstalWp.Device device) {
            Object(device: device);

            this.profiles = new ListStore(typeof(AstalWp.Profile));
            device.profiles.foreach((profile) => {
                profiles.append(profile);
            });

            device.notify["active-profile-id"].connect(() => {
                uint position;
                bool found = profiles.find(device.get_profile(device.active_profile_id), out position);
                profile.selected = position;
            });
            uint position;
            bool found = profiles.find(device.get_profile(device.active_profile_id), out position);
            profile.selected = position;

            profile.notify["selected"].connect(() => {
                var selected_profile = profiles.get_item(profile.selected) as AstalWp.Profile;
                device.active_profile_id = selected_profile.index;
            });


        }

    }
}
