Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08870320A09
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246126; cv=none; b=bzXj6Jw83F5nW+SYd7acU4PrRldI9i370DgEcKslgJXENUOO50nMgMeaB5zbY4UqQfNHjx9lpcjL6ojbLt+YkKo0xn5vm/IrqC3e/Fukn0oBuJi2ti44PxcA8YxoveuVQgteHRGkHtCoHNgD5FsLOrtiiEXa4Kk5pAOv6zLlLYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246126; c=relaxed/simple;
	bh=cF1SrwFUz0aBiEwsFE0dTWI91lmrP4xlRA143q9JWuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfrgicd7Sv4MfHFxcdrdJe5c4lyZrkhZ3EoqkW6uPWXEBwp/cJ4I/2uzWcAJru8TYI3wgqQ205Zcz0v+X7ca7x5amfPdJPMmixobRtyAjhChHxkUenyKci3gv9InTB8GaGIb6m4kvy54CMu+rH98lQ/FEMBhuwwJtIo2QMqB+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3Jte956; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3Jte956"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so10156270a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246123; x=1768850923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hw+SyBhpJj8Dk0rbLbmvCfZKQJWCvJPz8EnXuKWjIzw=;
        b=l3Jte956WVCyRw/GXg2tGdpUIQzjoG5cMeo+qKSZWIZAuhqBO7ySzM1vhS94ULxwTH
         iNIZWssXZ1DUBfRdUt0WLov+boooCDx6eyEH1buYUAnX0gr0inZCgCo2SaHGbuh5mzcK
         HVbjQUUYxdzvodJ5VXqR4XBrs5TPfoHCYViCjQeKM/jsSMgrPbhJcvaWHkEmx9hHzbSg
         Fh8dVx+LblUhypobh5kKXCIdLk3+BNcNeDePRXsVM4Dw+RC4ORhAM2GamgHQgdTWwaLo
         VkWDC1BI4e9XolJJhZaBD855RkOm6qDsvKiNd7efciVvL9sVjtlo9gEXYmOteQG1lj6r
         880w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246123; x=1768850923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hw+SyBhpJj8Dk0rbLbmvCfZKQJWCvJPz8EnXuKWjIzw=;
        b=Bvw9QtxqtmLfvqmygfNUvinv1zw7N4eKE/0WaQcFznCkbNoR8pIlVl8UlPe8KgINcZ
         HwzxfkJa8UYAOHQ8Q2twp7DP/p11gWWp+E0byLkoAcCa615oDKPMH6DxqQ64NvP5Rf/b
         rRpSPGyNgXCOfymGaQ3et43fOpAuOBF86LmGeqzNL+i1MdlLjbuOpl2722tATvou6Ies
         38tPv4fMJsAw/wzX+wbsT31z/iSTVX7GIMuAxC3rvp2fZfzxanPWhXQyaV354mtTgA3u
         LyTGTJ4426x3YE31bj1+4VhxmgLwOZkOfn2T/qSxv5CGZgU8kIU5bGtzqx9gUZ4m4+3D
         FAzw==
X-Forwarded-Encrypted: i=1; AJvYcCUdHSuAjXCHnrxqiBkfwiij460MYqc5bk6DDgNVxfQtDxI9vCiybJ381yewO0E7uLHkxH+7e7nN1EF0EPg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl4e+awOz8fxKlNi76XLZqquOp7A2ir2TRecx5FRQWgOGhry97
	IZSTHP78U9S88ibDsB9vv+8RlEcOC/S8CzrXqxzLa90+nnZ+H5i0P9bI
X-Gm-Gg: AY/fxX6fz6X4gjAgg7CPGJ0rHtXiFVjXgUOC7Vh4Qr013klnLehz1/y2JqaqKmGgBR4
	L/QZXfnZqylimMFSqmOMINCVMVlrYrtfNaxjpFbTpQSc5vU73qrN1LBhCy09QkDnGMhaunyoqto
	J2kmNu/hYc1a9ZdcYnxpgxFn+RFSiTH4l0vSGoboWGcz0sl4NPFFMZYpfiQYALWsz5MrIte2Uja
	mhbLbT6/hKhDGN8av/slSCfFJMmFEzdF56nN4nvciUZt4Bcac7+oZ0uCTGBJyg0cLQawhBH3IlT
	h3sT5+jcapKKVE6r0tKCpy8mYNQweEzmZ6QgnzzXUS2FWTmV4Jwv/4vHwPMaA0+86PsTjhjMUS5
	8xvilbpTtDy3egeEIgW34O1JiSvC/x++ot7v2A6YShiTzPGk0RxAx/JUnZ250JuJC2ec7LvhpCe
	+VDTX2uUImHP99CsB7cBV03xErMgUhNxC9J7F4smHv5+8dIdyEJQ==
X-Google-Smtp-Source: AGHT+IFpEfk67Wu3s+my7vAAjgYzI8tk25YBO54kBfzlkDE0wM0gQSWTlCzqTfS+7VeyIp6Wy6teeA==
X-Received: by 2002:a05:6402:1e8c:b0:64b:6007:d8dc with SMTP id 4fb4d7f45d1cf-65097dcd890mr17558013a12.7.1768246122989;
        Mon, 12 Jan 2026 11:28:42 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:42 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 2/6] kfuzztest: implement core module and input processing
Date: Mon, 12 Jan 2026 20:28:23 +0100
Message-ID: <20260112192827.25989-3-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the core runtime implementation for KFuzzTest. This includes the
module initialization, and the logic for receiving and processing
user-provided inputs through debugfs.

On module load, the framework discovers all of the simple test targets
(FUZZ_TEST_SIMPLE) by iterating over the .kfuzztest_simple_target
section, creating a corresponding debugfs directory with a write-only
'input_simple' file for each of them.

Writing to an 'input_simple' file triggers the following fuzzing
sequence:
1. The binary input is allocated and copied from userspace into a
   kernel buffer.
2. The buffer and its length are passed immediately to the user-defined
   test logic.
3. The kernel is tainted with TAINT_TEST to indicate that untrusted input
   has been fed directly to the internal kernel functions.

This lightweight implementation relies on the caller (e.g., a fuzzer or
script) to provide raw binary data that the target function can process.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Remove parsing, relocation, and KASAN poisoning logic to support the
  move to a simple-only design.
- Remove the '_config' debugfs directory and associated state tracking
  (minimum alignment, invocation counts) to reduce complexity.
- Enforce zero offset in `kfuzztest_write_cb_common` to ensure inputs
  are passed down as single, contiguous blocks.
PR v3:
- Handle FUZZ_TEST_SIMPLE targets by creating a write-only
  'input_simple' under the fuzz target's directory.
- Add implementation for `kfuzztest_write_input_cb`.
PR v2:
- Fix build issues identified by the kernel test robot <lkp@intel.com>.
- Address some nits pointed out by Alexander Potapenko.
PR v1:
- Update kfuzztest/parse.c interfaces to take `unsigned char *` instead
  of `void *`, reducing the number of pointer casts.
- Expose minimum region alignment via a new debugfs file.
- Expose number of successful invocations via a new debugfs file.
- Refactor module init function, add _config directory with entries
  containing KFuzzTest state information.
- Account for kasan_poison_range() return value in input parsing logic.
- Validate alignment of payload end.
- Move static sizeof assertions into /lib/kfuzztest/main.c.
- Remove the taint in kfuzztest/main.c. We instead taint the kernel as
  soon as a fuzz test is invoked for the first time, which is done in
  the primary FUZZ_TEST macro.
RFC v2:
- The module's init function now taints the kernel with TAINT_TEST.
---
---
 lib/Makefile           |   2 +
 lib/kfuzztest/Makefile |   4 ++
 lib/kfuzztest/input.c  |  47 ++++++++++++++
 lib/kfuzztest/main.c   | 142 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 195 insertions(+)
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/input.c
 create mode 100644 lib/kfuzztest/main.c

diff --git a/lib/Makefile b/lib/Makefile
index 392ff808c9b9..02789bf88499 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -325,6 +325,8 @@ obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
 obj-$(CONFIG_OBJAGG) += objagg.o
 
+obj-$(CONFIG_KFUZZTEST) += kfuzztest/
+
 # pldmfw library
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
diff --git a/lib/kfuzztest/Makefile b/lib/kfuzztest/Makefile
new file mode 100644
index 000000000000..3cf5da5597a4
--- /dev/null
+++ b/lib/kfuzztest/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KFUZZTEST) += kfuzztest.o
+kfuzztest-objs := main.o input.o
diff --git a/lib/kfuzztest/input.c b/lib/kfuzztest/input.c
new file mode 100644
index 000000000000..aae966ea76b3
--- /dev/null
+++ b/lib/kfuzztest/input.c
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KFuzzTest input handling.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+int kfuzztest_write_cb_common(struct file *filp, const char __user *buf, size_t len, loff_t *off, void **test_buffer)
+{
+	void *buffer;
+	ssize_t ret;
+
+	/*
+	 * Enforce a zero-offset to ensure that all data is passed down in a
+	 * single contiguous blob and not fragmented across multiple write
+	 * system calls.
+	 */
+	if (*off)
+		return -EINVAL;
+
+	/*
+	 * Taint the kernel on the first fuzzing invocation. The debugfs
+	 * interface provides a high-risk entry point for userspace to
+	 * call kernel functions with untrusted input.
+	 */
+	if (!test_taint(TAINT_TEST))
+		add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
+
+	if (len > KFUZZTEST_MAX_INPUT_SIZE) {
+		pr_warn("kfuzztest: user input of size %zu is too large", len);
+		return -EINVAL;
+	}
+
+	buffer = kzalloc(len, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	ret = simple_write_to_buffer(buffer, len, off, buf, len);
+	if (ret != len) {
+		kfree(buffer);
+		return -EFAULT;
+	}
+
+	*test_buffer = buffer;
+	return 0;
+}
diff --git a/lib/kfuzztest/main.c b/lib/kfuzztest/main.c
new file mode 100644
index 000000000000..40a9e56c81ad
--- /dev/null
+++ b/lib/kfuzztest/main.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KFuzzTest core module initialization and debugfs interface.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/atomic.h>
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/kasan.h>
+#include <linux/kfuzztest.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ethan Graham <ethan.w.s.graham@gmail.com>");
+MODULE_DESCRIPTION("Kernel Fuzz Testing Framework (KFuzzTest)");
+
+extern const struct kfuzztest_simple_target __kfuzztest_simple_targets_start[];
+extern const struct kfuzztest_simple_target __kfuzztest_simple_targets_end[];
+
+struct target_fops {
+	struct file_operations target_simple;
+};
+
+/**
+ * struct kfuzztest_state - global state for the KFuzzTest module
+ *
+ * @kfuzztest_dir: The root debugfs directory, /sys/kernel/debug/kfuzztest/.
+ * @num_targets: number of registered targets.
+ * @target_fops: array of file operations for each registered target.
+ */
+struct kfuzztest_state {
+	struct dentry *kfuzztest_dir;
+	struct target_fops *target_fops;
+	size_t num_targets;
+};
+
+static struct kfuzztest_state state;
+
+static void cleanup_kfuzztest_state(struct kfuzztest_state *st)
+{
+	debugfs_remove_recursive(st->kfuzztest_dir);
+	st->num_targets = 0;
+	kfree(st->target_fops);
+	st->target_fops = NULL;
+}
+
+static const umode_t KFUZZTEST_INPUT_PERMS = 0222;
+
+static int initialize_target_dir(struct kfuzztest_state *st, const struct kfuzztest_simple_target *targ,
+				 struct target_fops *fops)
+{
+	struct dentry *dir, *input_simple;
+	int err = 0;
+
+	dir = debugfs_create_dir(targ->name, st->kfuzztest_dir);
+	if (!dir)
+		err = -ENOMEM;
+	else if (IS_ERR(dir))
+		err = PTR_ERR(dir);
+	if (err) {
+		pr_info("kfuzztest: failed to create /kfuzztest/%s dir", targ->name);
+		goto out;
+	}
+
+	input_simple = debugfs_create_file("input_simple", KFUZZTEST_INPUT_PERMS, dir, NULL, &fops->target_simple);
+	if (!input_simple)
+		err = -ENOMEM;
+	else if (IS_ERR(input_simple))
+		err = PTR_ERR(input_simple);
+	if (err)
+		pr_info("kfuzztest: failed to create /kfuzztest/%s/input_simple", targ->name);
+out:
+	return err;
+}
+
+/**
+ * kfuzztest_init - initializes the debug filesystem for KFuzzTest
+ *
+ * Each registered target in the ".kfuzztest_simple_target" section gets its own
+ * subdirectory under "/sys/kernel/debug/kfuzztest/<test-name>" containing one
+ * write-only "input_simple" file used for receiving binary inputs from
+ * userspace.
+ *
+ * @return 0 on success or an error
+ */
+static int __init kfuzztest_init(void)
+{
+	const struct kfuzztest_simple_target *targ;
+	int err = 0;
+	int i = 0;
+
+	state.num_targets = __kfuzztest_simple_targets_end - __kfuzztest_simple_targets_start;
+	state.target_fops = kzalloc(sizeof(struct target_fops) * state.num_targets, GFP_KERNEL);
+	if (!state.target_fops)
+		return -ENOMEM;
+
+	/* Create the main "kfuzztest" directory in /sys/kernel/debug. */
+	state.kfuzztest_dir = debugfs_create_dir("kfuzztest", NULL);
+	if (!state.kfuzztest_dir) {
+		pr_warn("kfuzztest: could not create 'kfuzztest' debugfs directory");
+		return -ENOMEM;
+	}
+	if (IS_ERR(state.kfuzztest_dir)) {
+		pr_warn("kfuzztest: could not create 'kfuzztest' debugfs directory");
+		err = PTR_ERR(state.kfuzztest_dir);
+		state.kfuzztest_dir = NULL;
+		return err;
+	}
+
+	for (targ = __kfuzztest_simple_targets_start; targ < __kfuzztest_simple_targets_end; targ++, i++) {
+		state.target_fops[i].target_simple = (struct file_operations){
+			.owner = THIS_MODULE,
+			.write = targ->write_input_cb,
+		};
+		err = initialize_target_dir(&state, targ, &state.target_fops[i]);
+		/*
+		 * Bail out if a single target fails to initialize. This avoids
+		 * partial setup, and a failure here likely indicates an issue
+		 * with debugfs.
+		 */
+		if (err)
+			goto cleanup_failure;
+		pr_info("kfuzztest: registered target %s", targ->name);
+	}
+	return 0;
+
+cleanup_failure:
+	cleanup_kfuzztest_state(&state);
+	return err;
+}
+
+static void __exit kfuzztest_exit(void)
+{
+	pr_info("kfuzztest: exiting");
+	cleanup_kfuzztest_state(&state);
+}
+
+module_init(kfuzztest_init);
+module_exit(kfuzztest_exit);
-- 
2.51.0

