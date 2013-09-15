From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V4 14/15] Hibernate: notify bootloader regenerate key-pair for snapshot verification
Date: Sun, 15 Sep 2013 08:57:00 +0800
Message-ID: <1379206621-18639-15-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <opensuse-kernel+bounces-5108-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

This patch introduced SNAPSHOT_REGEN_KEYS kernel config, enable this
option let kernel notify booloader (e.g. shim) to regenerate key-pair of
snapshot verification for each hibernate.

Kernel loaded S4 sign key in efi stub, so the private key forward from
efi bootloader to kernel in UEFI secure environment. Regenerate key-pair
for each hibernate will gain more security but it hurt the lifetime of
EFI flash memory.

Kernel write an non-volatile runtime efi variable, the name is
GenS4Key-fe141863-c070-478e-b8a3-878a5dc9ef21, to notify efi bootloader
regenerate key-pair for next hibernate cycle.

Userland hibernate tool can write GenS4Key at runtime, kernel will
respect the value but not overwrite it when S4. This mechanism let
userland tool can also notify bootloader to regenerate key-pair through
GenS4Key flag.

V4:
- Use efivar API to access GenS4Key variable.
- Call set_key_regen_flag() in hibernate.c and user.c

Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 kernel/power/Kconfig          |   15 +++++++++
 kernel/power/hibernate.c      |    4 ++-
 kernel/power/hibernate_keys.c |   67 +++++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h          |    5 +++
 kernel/power/user.c           |    6 +++-
 5 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 79b34fa..63bda98 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -78,6 +78,21 @@ config SNAPSHOT_VERIFICATION
 	  dependent on UEFI environment. EFI bootloader should generate the
 	  key-pair.
 
+config SNAPSHOT_REGEN_KEYS
+	bool "Regenerate key-pair for each snapshot verification"
+        depends on SNAPSHOT_VERIFICATION
+	help
+	  Enabled this option let kernel notify booloader (e.g. shim) to
+	  regenerate key-pair of snapshot verification for each hibernate.
+	  Linux kernel write an non-volatile runtime EFI variable, the name
+	  is GenS4Key-fe141863-c070-478e-b8a3-878a5dc9ef21, to notify EFI
+	  bootloader regenerate key-pair for next hibernate cycle.
+
+	  Userland hibernate tool can write GenS4Key at runtime then kernel
+	  will respect the value but not overwrite it when S4. This mechanism
+	  let userland tool can also notify bootloader to regenerate key-pair
+	  through GenS4Key flag.
+
 choice
 	prompt "Which hash algorithm should snapshot be signed with?"
         depends on SNAPSHOT_VERIFICATION
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 90a25c7..6336499 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -675,8 +675,10 @@ int hibernate(void)
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write(flags);
 		swsusp_free();
-		if (!error)
+		if (!error) {
+			set_key_regen_flag();
 			power_down();
+		}
 		in_suspend = 0;
 		pm_restore_gfp_mask();
 	} else {
diff --git a/kernel/power/hibernate_keys.c b/kernel/power/hibernate_keys.c
index daf08e0..72d5c7a 100644
--- a/kernel/power/hibernate_keys.c
+++ b/kernel/power/hibernate_keys.c
@@ -14,6 +14,8 @@ struct forward_info {
 	unsigned char                   skey_data_buf[SKEY_DBUF_MAX_SIZE];
 };
 
+static efi_char16_t efi_gens4key_name[9] = { 'G', 'e', 'n', 'S', '4', 'K', 'e', 'y', 0 };
+
 static void *skey_data;
 static void *forward_info_buf;
 static unsigned long skey_dsize;
@@ -301,6 +303,70 @@ bool sig_enforced(void)
 	return sig_enforce;
 }
 
+int set_key_regen_flag(void)
+{
+#ifdef CONFIG_SNAPSHOT_REGEN_KEYS
+	struct efivar_entry *entry;
+	unsigned long datasize;
+	u8 gens4key;
+	int ret;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	memcpy(entry->var.VariableName, efi_gens4key_name, sizeof(efi_gens4key_name));
+	memcpy(&(entry->var.VendorGuid), &EFI_HIBERNATE_GUID, sizeof(efi_guid_t));
+
+	/* existing flag may set by userland, respect it do not overwrite */
+	datasize = 0;
+	ret = efivar_entry_size(entry, &datasize);
+	if (!ret && datasize > 0) {
+		kfree(entry);
+		return 0;
+	}
+
+	/* set flag of key-pair regeneration */
+	gens4key = 1;
+	ret = efivar_entry_set(entry,
+			       EFI_VARIABLE_NON_VOLATILE |
+			       EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			       EFI_VARIABLE_RUNTIME_ACCESS,
+			       1, (void *)&gens4key, false);
+	if (ret)
+		pr_err("PM: Set GenS4Key flag fail: %d\n", ret);
+
+	kfree(entry);
+
+	return ret;
+#else
+	return 0;
+#endif
+}
+
+static int clean_key_regen_flag(void)
+{
+	struct efivar_entry *entry;
+	int ret;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	memcpy(entry->var.VariableName, efi_gens4key_name, sizeof(efi_gens4key_name));
+	memcpy(&(entry->var.VendorGuid), &EFI_HIBERNATE_GUID, sizeof(efi_guid_t));
+
+	/* clean flag of key-pair regeneration */
+	ret = efivar_entry_set(entry,
+			       EFI_VARIABLE_NON_VOLATILE |
+			       EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			       EFI_VARIABLE_RUNTIME_ACCESS,
+			       0, NULL, false);
+	kfree(entry);
+
+	return ret;
+}
+
 static int __init init_sign_key_data(void)
 {
 	skey_data = (void *)get_zeroed_page(GFP_KERNEL);
@@ -311,6 +377,7 @@ static int __init init_sign_key_data(void)
 		efi_erase_s4_skey_data();
 		pr_info("PM: Load s4 sign key from EFI\n");
 	}
+	clean_key_regen_flag();
 
 	return 0;
 }
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 4f411ac..da5733f 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -188,6 +188,7 @@ extern bool swsusp_page_is_sign_key(struct page *page);
 extern unsigned long get_sig_forward_info_pfn(void);
 extern void fill_sig_forward_info(void *page_addr, int sig_check_ret);
 extern bool sig_enforced(void);
+extern int set_key_regen_flag(void);
 #else
 static inline bool skey_data_available(void)
 {
@@ -202,6 +203,10 @@ static inline unsigned long get_sig_forward_info_pfn(void)
 {
 	return 0;
 }
+static inline int set_key_regen_flag(void)
+{
+	return 0;
+}
 #endif /* !CONFIG_SNAPSHOT_VERIFICATION */
 
 /* kernel/power/block_io.c */
diff --git a/kernel/power/user.c b/kernel/power/user.c
index e2088af..3d3632b 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -323,6 +323,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		/* set regenerate S4 key flag */
+		set_key_regen_flag();
 		/*
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
@@ -336,8 +338,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_POWER_OFF:
-		if (data->platform_support)
+		if (data->platform_support) {
+			set_key_regen_flag();
 			error = hibernation_platform_enter();
+		}
 		break;
 
 	case SNAPSHOT_SET_SWAP_AREA:
-- 
1.6.0.2
