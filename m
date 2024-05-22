Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814D84C9A;
	Wed, 22 May 2024 19:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716404715; cv=none; b=D11s/wacwHfhAItP1+GyIm36baVollfMz/ix1BZavc/+TTStdgCJKUzOFdKgOwHE658hyJewIgfzK/koY6/SSqwbwlP07cJk8NQVzW5IZJwUQqYtnbUPQsEJuKAIGaeZvb0NaWeXs4i8hsr4+cmV9lcJ663bPBIiwlSHN5ZmhcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716404715; c=relaxed/simple;
	bh=OMsEdF706zMDc6DTElZgQu1W4GvOAtsxz+Uf9uiV0OI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oAVPFbcqRlDRyYrF6AkMpuBXzJRY8DtRx9Lix1K9EGuoiP7wl+jjFi5n4QWleVe184a08aURInOq+5AamBcjXgCjD4RgF1OWWQagDAJdLQdvmWAkCCdy0SlIlbCvYLY64HHMYsfQQ9Eukq1JYlfu2Jr6oT6q9NziA7IPgsgUa+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/Tzk+5Z; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/Tzk+5Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716404714; x=1747940714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OMsEdF706zMDc6DTElZgQu1W4GvOAtsxz+Uf9uiV0OI=;
  b=R/Tzk+5Z1P40P7Rb43pYapCCETQW1EaDoFEMc9daO2eUazZ6SWY2X64T
   z+59aSs6W/ajWZSCq2PnTc9ronQEszIw3TYwKWPYJIx27Phgf+ZLnI+t1
   JGRaqrBXyB/j2OO4z8hnFxm3zPj5ZziXt8kqyfhlFbgXtNtNEimIu2hKR
   GDENwxOjEth1gh8NfooBAurC1/FDpAB1YF4ZNX56c+B9ZUE2cdFyJq9of
   02413D6AGu6WteJRPXChRkGzjXw14cBSTdIhRKxdTtWABfXW1BjxddZH9
   xu25ldw/fSDGR2iTWc4DL/34G4u5bXo19UlXIB5WFzcgwhBu7ZtL0/sX/
   g==;
X-CSE-ConnectionGUID: 4ZFSyZKgRi+Ujp2mf9wBKg==
X-CSE-MsgGUID: bGXJkCNsQ26c/osLCQExZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12798886"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12798886"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 12:05:13 -0700
X-CSE-ConnectionGUID: KVkmJbkoR9azi3BvcMfRhg==
X-CSE-MsgGUID: 7OL0PhrpQRaRADgpNPRC3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="37971239"
Received: from chang-linux-3.sc.intel.com ([172.25.66.177])
  by fmviesa004.fm.intel.com with ESMTP; 22 May 2024 12:05:01 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: ebiggers@kernel.org,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	ardb@kernel.org,
	x86@kernel.org,
	bernie.keany@intel.com,
	chang.seok.bae@intel.com,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9a 08/14] x86/PM/keylocker: Restore the wrapping key on the resume from ACPI S3/4
Date: Wed, 22 May 2024 11:48:35 -0700
Message-Id: <20240522184835.16839-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329015346.635933-9-chang.seok.bae@intel.com>
References: <20240329015346.635933-9-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The primary use case for the feature is bare metal dm-crypt. The key
needs to be restored properly on wakeup, as dm-crypt does not prompt
for the key on resume from suspend. Even if the prompt performs for
unlocking the volume, where the hibernation image is stored, it still
expects to reuse the key handles within the hibernation image once it
is loaded.

== Wrapping-key Restore ==

To meet dm-crypt's expectations, the key handles in the suspend-image has
to remain valid after resuming from an S-state. However, when the system
enters ACPI S3 or S4 sleep states, the wrapping key is discarded.

Key Locker provides a mechanism to back up the wrapping key in
non-volatile storage. Therefore, upon boot, request a backup of the
wrapping key and copy it back to each CPU upon wakeup. If the backup
mechanism is unavailable, disable the feature unless CONFIG_SUSPEND=n.

== Restore Failure ==

In the event of a key restore failure, the kernel proceeds with an
initialized wrapping key state. This action invalidates any key handles
present in the suspend-image, leading to I/O errors in dm-crypt
operations.

However, data integrity remains intact, and access is restored with new
handles created by the new wrapping key at the next boot. At least,
manage a feature-specific flag to communicate with the crypto
implementation, ensuring to stop using AES instructions upon the key
restore failure, instead of abruptly disabling the feature.

== Off-states ==

While the backup may persist in non-volatile media across S5 and G3 "off"
states, it is neither architecturally guaranteed nor expected by
dm-crypt. Therefore, a reboot can address this scenario with a new
wrapping key, as dm-crypt prompts for the key whenever the volume is
started.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
Change from v9:
* Export valid_keylocker() again for the AES-KL module.
---
 arch/x86/include/asm/keylocker.h | 10 ++++
 arch/x86/kernel/cpu/common.c     |  4 +-
 arch/x86/kernel/keylocker.c      | 89 ++++++++++++++++++++++++++++++++
 arch/x86/power/cpu.c             |  2 +
 4 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 1213d273c369..c93102101c41 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -28,5 +28,15 @@ struct iwkey {
 #define KEYLOCKER_CPUID_EBX_WIDE	BIT(2)
 #define KEYLOCKER_CPUID_EBX_BACKUP	BIT(4)
 
+#ifdef CONFIG_X86_KEYLOCKER
+void setup_keylocker(void);
+void restore_keylocker(void);
+extern bool valid_keylocker(void);
+#else
+static inline void setup_keylocker(void) { }
+static inline void restore_keylocker(void) { }
+static inline bool valid_keylocker(void) { return false; }
+#endif
+
 #endif /*__ASSEMBLY__ */
 #endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 605c26c009c8..85946d79cb96 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -62,6 +62,7 @@
 #include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
 #include <asm/fred.h>
+#include <asm/keylocker.h>
 #include <asm/uv/uv.h>
 #include <asm/ia32.h>
 #include <asm/set_memory.h>
@@ -1834,10 +1835,11 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
 
-	/* Set up SMEP/SMAP/UMIP */
+	/* Setup various Intel-specific CPU security features */
 	setup_smep(c);
 	setup_smap(c);
 	setup_umip(c);
+	setup_keylocker();
 
 	/* Enable FSGSBASE instructions if available. */
 	if (cpu_has(c, X86_FEATURE_FSGSBASE)) {
diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
index 8569b92971da..da0830e980ed 100644
--- a/arch/x86/kernel/keylocker.c
+++ b/arch/x86/kernel/keylocker.c
@@ -9,11 +9,26 @@
 
 #include <asm/fpu/api.h>
 #include <asm/keylocker.h>
+#include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 
 static struct iwkey wrapping_key __initdata;
 
+/*
+ * This flag is set when a wrapping key is successfully loaded. If a key
+ * restoration fails, it is reset. This state is exported to the crypto
+ * library, indicating whether Key Locker is usable. Thus, the feature
+ * can be soft-disabled based on this flag.
+ */
+static bool valid_wrapping_key;
+
+bool valid_keylocker(void)
+{
+	return valid_wrapping_key;
+}
+EXPORT_SYMBOL_GPL(valid_keylocker);
+
 static void __init generate_keylocker_data(void)
 {
 	get_random_bytes(&wrapping_key.integrity_key, sizeof(wrapping_key.integrity_key));
@@ -38,9 +53,69 @@ static void __init load_keylocker(struct work_struct *unused)
 	kernel_fpu_end();
 }
 
+/**
+ * copy_keylocker - Copy the wrapping key from the backup.
+ *
+ * Returns:	true if successful, otherwise false.
+ */
+static bool copy_keylocker(void)
+{
+	u64 status;
+
+	wrmsrl(MSR_IA32_COPY_IWKEY_TO_LOCAL, 1);
+	rdmsrl(MSR_IA32_IWKEY_COPY_STATUS, status);
+	return !!(status & BIT(0));
+}
+
+/*
+ * On wakeup, APs copy a wrapping key after the boot CPU verifies a valid
+ * backup status through restore_keylocker(). Subsequently, they adhere
+ * to the error handling protocol by invalidating the flag.
+ */
+void setup_keylocker(void)
+{
+	if (!valid_wrapping_key)
+		return;
+
+	cr4_set_bits(X86_CR4_KEYLOCKER);
+
+	if (copy_keylocker())
+		return;
+
+	pr_err_once("x86/keylocker: Invalid copy status.\n");
+	valid_wrapping_key = false;
+}
+
+/* The boot CPU restores the wrapping key in the first place on wakeup. */
+void restore_keylocker(void)
+{
+	u64 backup_status;
+
+	if (!valid_wrapping_key)
+		return;
+
+	rdmsrl(MSR_IA32_IWKEY_BACKUP_STATUS, backup_status);
+	if (backup_status & BIT(0)) {
+		if (copy_keylocker())
+			return;
+		pr_err("x86/keylocker: Invalid copy state.\n");
+	} else {
+		pr_err("x86/keylocker: The key backup access failed with %s.\n",
+		       (backup_status & BIT(2)) ? "read error" : "invalid status");
+	}
+
+	/*
+	 * Invalidate the feature via this flag to indicate that the
+	 * crypto code should voluntarily stop using the feature, rather
+	 * than abruptly disabling it.
+	 */
+	valid_wrapping_key = false;
+}
+
 static int __init init_keylocker(void)
 {
 	u32 eax, ebx, ecx, edx;
+	bool backup_available;
 
 	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
 		goto disable;
@@ -60,9 +135,23 @@ static int __init init_keylocker(void)
 		goto clear_cap;
 	}
 
+	/*
+	 * The backup is critical for restoring the wrapping key upon
+	 * wakeup.
+	 */
+	backup_available = !!(ebx & KEYLOCKER_CPUID_EBX_BACKUP);
+	if (!backup_available && IS_ENABLED(CONFIG_SUSPEND)) {
+		pr_debug("x86/keylocker: No key backup with possible S3/4.\n");
+		goto clear_cap;
+	}
+
 	generate_keylocker_data();
 	schedule_on_each_cpu(load_keylocker);
 	destroy_keylocker_data();
+	valid_wrapping_key = true;
+
+	if (backup_available)
+		wrmsrl(MSR_IA32_BACKUP_IWKEY_TO_PLATFORM, 1);
 
 	pr_info_once("x86/keylocker: Enabled.\n");
 	return 0;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 63230ff8cf4f..e99be45354cd 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -27,6 +27,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
 #include <asm/microcode.h>
+#include <asm/keylocker.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -264,6 +265,7 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	x86_platform.restore_sched_clock_state();
 	cache_bp_restore();
 	perf_restore_debug_store();
+	restore_keylocker();
 
 	c = &cpu_data(smp_processor_id());
 	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
-- 
2.34.1

