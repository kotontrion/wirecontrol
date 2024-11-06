namespace Wirecontrol {
    public class Application : Adw.Application {
        public Application () {
            Object (application_id: "com.github.kotontrion.wirecontrol", flags: ApplicationFlags.DEFAULT_FLAGS);
        }

        construct {
            ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "quit", this.quit }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null) {
                win = new Wirecontrol.Window (this);
            }
            win.present ();
        }

        private void on_about_action () {
            string[] developers = { "kotontrion" };
            var about = new Adw.AboutDialog () {
                application_name = "wirecontrol",
                application_icon = "com.github.kotontrion.wirecontrol",
                developer_name = "kotontrion",
                version = "0.1.0",
                developers = developers,
                copyright = "© 2024 kotontrion",
                issue_url = "https://github.com/kotontrion/wirecontrol/issues",
                license_type = Gtk.License.GPL_3_0,

            };

            about.present (this.active_window);
        }
    }
}
