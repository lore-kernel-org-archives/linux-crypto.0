Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9C2D0C8F
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246125; cv=none; b=Re32CPyw1eyhekQ+wO6//x0+KbvyqCHveSUFQVXdp6UC0dexlSzuAus4nSU45/pqaovA40GSKhRN5B4Z2rPzOh/p83taN4wJrW7lfo2xHCjlL/lFsein7YjKNlq91leAlDU9XVpm1LTuokciXSljGGiRO53mpY7uVl5FL5B76w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246125; c=relaxed/simple;
	bh=RfNOTU1rUXZFy81KWIMuzlRH+1v6cHn4VlKbisbvBZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD180ImaPFCS1R95jpACYTYNPVNgNnM7haREoxfBSg4LLs8az3QwUREO1m7vZvfVkc5pYMGdXhAMi/dkhBnZAnO8Uyjmo1GsNe6nGwCW5v/XT4zzrM08jwufIXEzwwDTDMh0yi6DJz/CNAdvRbhubvaTfODXAqXYEL8JRaQt5qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0FD+77D; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0FD+77D"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6505cac9879so11448128a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246122; x=1768850922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6pmlmleIFnHYbLcLeHzqqQV2depV+HvaEyub6pwhNU=;
        b=G0FD+77D2bNI93Aqfu3A9WVv9s0XQFwPwdbqoWyGxsrZlA92ckAmnrpJ6H1j9RmZNA
         Z8Sl73GHmSUaNcv2fDUUGiY1+Zq4658rfZebBt8M2O8MCHhr1OptyqRbmoI7NtUsu1Bb
         DP6QfCQRQAvz2su1IRRU0B/wdAbCR0ggKILjwhVBYDSPma3RX1saC6kL4eZIVQPlzUSQ
         JrYQVUr+CWPTnIssy7UoA80Hy0aPeZOQnr6rd7GmpoREVaDMr3fTGAVSxYz57Wii1qc6
         ZsSXys7YoBUMkKwkyOd0A+oNHdMhvikQyC2qbG2H1mXrTDio3/vXENnWXmzbCB7Wt/yl
         9emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246122; x=1768850922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F6pmlmleIFnHYbLcLeHzqqQV2depV+HvaEyub6pwhNU=;
        b=U0k4LI06YOOAxH1ojTomBf7dJH/bbhfMRV8cfmLwosvbAt5Yc1kRDdNwoXGTPwcdWz
         ZOjNETlbpGNbuTsjvGMSlLXEaDwYWw/ZPzPf74PGBNcorvewrsJ9+kuF8qjPs9fGGDiS
         1f96aUMewdCuUf5Iy/QDCUy162ONvYPKh1uglbj7jbbvMWgVwjPIDH8fSXDzFyAO8Ec2
         tUaO0b82g7SQOgOBLI3nrFyMYB+W/sg70ibqxDOXe7eRUGpl4YQq7+ZqpIp3+xVOBF4m
         H+dfLbZ8RAkrTYPJNgh5l7PfCpugUL4sGcXT00wYTV+FcD1xckPMO9LQIP3qCR3eyeGK
         aFGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXK0JAoZiQA7y5rjR3YaGZNEZLvmcn37EJpKJbPlKT3WD+HSl8XYly5w2MzWlcGKLLrXMoh9AM3PseFZw=@vger.kernel.org
X-Gm-Message-State: AOJu0YysCzb2MwHZm/P/hi1rKhte9ZABCMMZq0k5dSLLyxUGbFoh99rg
	YhEkuqXfk60Fw6vw1plTtlCJUYeRa9ki6fp23apUEf60Q6ZkG/8UzOPe
X-Gm-Gg: AY/fxX4br2jSud+bv1I4gdVbOXbhl2Px6xVcekh2QHjbNtxtTuahOkyacY1TYFLd1lr
	1vj6dMBnktqNao/KCb1APysfOogXvacI5PeouwbxO2C1prb0Rtp38DThUOKg9KZCo5M4VQewyCQ
	/5d14leLynz6BpvwjHJqziGSdw6+SUZsA1cLoxbrHhJb3OLo8R4bxXaAB6AudqI23FUIvrvnMqR
	8//y2MWG68KyuE+CvRjW0PYg3wPxc6OrL3/0fu1Q4bFXsvz/cweyx5WNpN7+balPKi6HDWQKysv
	ULEsc39zQcXHO5h8YOSTP+O3D161HYX4cYDUjfV3+sI6dlIMlqr1SyV8JWuc/vXuVzxpnsQEXny
	pBueZQKfYDJxHFHeiMdzUKky3UA7W4aUdMkTDAkbjd4iJTW6wLFK9CSaGrGtaRMXaSbww/ho7ck
	2VQoiMxceX2mEJwBqerQ0fzBoRasMoBss04ecu8pHR9yqvG/1w1w==
X-Google-Smtp-Source: AGHT+IGy522OXBlgiFW3lPd749jJAYgvouP4QS9c8yndvmWTKnryLyWxg/YRj13+vMvBUdmHcTA0tA==
X-Received: by 2002:a05:6402:42d3:b0:64b:6dfc:dd34 with SMTP id 4fb4d7f45d1cf-65097cde534mr16779217a12.0.1768246121349;
        Mon, 12 Jan 2026 11:28:41 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:40 -0800 (PST)
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
Subject: [PATCH v4 1/6] kfuzztest: add user-facing API and data structures
Date: Mon, 12 Jan 2026 20:28:22 +0100
Message-ID: <20260112192827.25989-2-ethan.w.s.graham@gmail.com>
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

Add the foundational user-facing components for the KFuzzTest framework.
This includes the main API header <linux/kfuzztest.h>, the Kconfig
option to enable the feature, and the required linker script changes
which introduce a new ELF section in vmlinux.

Note that KFuzzTest is intended strictly for debug builds only, and
should never be enabled in a production build. The fact that it exposes
internal kernel functions and state directly to userspace may constitute
a serious security vulnerability if used for any reason other than
testing.

The header defines:
- The FUZZ_TEST_SIMPLE() macro for creating test targets.
- The `struct kfuzztest_simple_target` structure used to register tests.
- The linker section (.kfuzztest_simple_target) where test metadata is
  stored for discovery by the framework.

This patch only adds the public interface and build integration; no
runtime logic is included.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Remove the complex FUZZ_TEST macro and associated dependencies,
  including domain constraints, annotations, and de-serialization,
  dramatically simplifying the flow.
- Drop unused ELF sections (.kfuzztest_constraint, etc...) from the
  linker script, keeping only .kfuzztest_simple_target.
PR v3:
- Reorder definitions in kfuzztest.h for better flow and readability.
- Introduce __KFUZZTEST_CONSTRAINT macro in preparation for the
  introduction of the FUZZ_TEST_SIMPLE macro in the following patch,
  which uses it for manually emitting constraint metadata.
PR v1:
- Move KFuzzTest metadata definitions to generic vmlinux linkage so that
  the framework isn't bound to x86_64.
- Return -EFAULT when simple_write_to_buffer returns a value not equal
  to the input length in the main FUZZ_TEST macro.
- Enforce a maximum input size of 64KiB in the main FUZZ_TEST macro,
  returning -EINVAL when it isn't respected.
- Refactor KFUZZTEST_ANNOTATION_* macros.
- Taint the kernel with TAINT_TEST inside the FUZZ_TEST macro when a
  fuzz target is invoked for the first time.
---
---
 include/asm-generic/vmlinux.lds.h | 14 ++++-
 include/linux/kfuzztest.h         | 88 +++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |  1 +
 lib/kfuzztest/Kconfig             | 16 ++++++
 4 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e..5aa46dbbc9b2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -373,7 +373,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	TRACE_PRINTKS()							\
 	BPF_RAW_TP()							\
 	TRACEPOINT_STR()						\
-	KUNIT_TABLE()
+	KUNIT_TABLE()							\
+	KFUZZTEST_TABLE()
 
 /*
  * Data section helpers
@@ -966,6 +967,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		BOUNDED_SECTION_POST_LABEL(.kunit_init_test_suites, \
 				__kunit_init_suites, _start, _end)
 
+#ifdef CONFIG_KFUZZTEST
+#define KFUZZTEST_TABLE()						\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_simple_targets_start = .;				\
+	KEEP(*(.kfuzztest_simple_target));				\
+	__kfuzztest_simple_targets_end = .;				\
+
+#else /* CONFIG_KFUZZTEST */
+#define KFUZZTEST_TABLE()
+#endif /* CONFIG_KFUZZTEST */
+
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
 	. = ALIGN(4);							\
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
new file mode 100644
index 000000000000..62fce9267761
--- /dev/null
+++ b/include/linux/kfuzztest.h
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The Kernel Fuzz Testing Framework (KFuzzTest) API for defining fuzz targets
+ * for internal kernel functions.
+ *
+ * Copyright 2025 Google LLC
+ */
+#ifndef KFUZZTEST_H
+#define KFUZZTEST_H
+
+#include <linux/fs.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+
+#define KFUZZTEST_MAX_INPUT_SIZE (PAGE_SIZE * 16)
+
+/* Common code for receiving inputs from userspace. */
+int kfuzztest_write_cb_common(struct file *filp, const char __user *buf, size_t len, loff_t *off, void **test_buffer);
+
+struct kfuzztest_simple_target {
+	const char *name;
+	ssize_t (*write_input_cb)(struct file *filp, const char __user *buf, size_t len, loff_t *off);
+};
+
+/**
+ * FUZZ_TEST_SIMPLE - defines a KFuzzTest target
+ *
+ * @test_name: the unique identifier for the fuzz test, which is used to name
+ *             the debugfs entry.
+ *
+ * This macro defines a fuzz target entry point that accepts raw byte buffers
+ * from userspace. It registers a struct kfuzztest_simple_target which the
+ * framework exposes via debugfs.
+ *
+ * When userspace writes to the corresponding debugfs file, the framework
+ * allocates a kernel buffer, copies the user data, and passes it to the
+ * logic defined in the macro body.
+ *
+ * User-provided Logic:
+ * The developer must provide the body of the fuzz test logic within the curly
+ * braces following the macro invocation. Within this scope, the framework
+ * implicitly defines the following variables:
+ *
+ * - `char *data`: A pointer to the raw input data.
+ * - `size_t datalen`: The length of the input data.
+ *
+ * Example Usage:
+ *
+ * // 1. The kernel function that we want to fuzz.
+ * int process_data(const char *data, size_t datalen);
+ *
+ * // 2. Define a fuzz target using the FUZZ_TEST_SIMPLE macro.
+ * FUZZ_TEST_SIMPLE(test_process_data)
+ * {
+ *	// Call the function under test using the `data` and `datalen`
+ *	// variables.
+ *	process_data(data, datalen);
+ * }
+ *
+ */
+#define FUZZ_TEST_SIMPLE(test_name)											\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off);						\
+	static ssize_t kfuzztest_simple_logic_##test_name(char *data, size_t datalen);					\
+	static const struct kfuzztest_simple_target __fuzz_test_simple__##test_name __section(				\
+		".kfuzztest_simple_target") __used = {									\
+		.name = #test_name,											\
+		.write_input_cb = kfuzztest_simple_write_cb_##test_name,						\
+	};														\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off)						\
+	{														\
+		void *buffer;												\
+		int ret;												\
+															\
+		ret = kfuzztest_write_cb_common(filp, buf, len, off, &buffer);						\
+		if (ret < 0)												\
+			goto out;											\
+		ret = kfuzztest_simple_logic_##test_name(buffer, len);							\
+		if (ret == 0)												\
+			ret = len;											\
+		kfree(buffer);												\
+out:															\
+		return ret;												\
+	}														\
+	static ssize_t kfuzztest_simple_logic_##test_name(char *data, size_t datalen)
+
+#endif /* KFUZZTEST_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed075..49a1748b9f24 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1947,6 +1947,7 @@ endmenu
 menu "Kernel Testing and Coverage"
 
 source "lib/kunit/Kconfig"
+source "lib/kfuzztest/Kconfig"
 
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
diff --git a/lib/kfuzztest/Kconfig b/lib/kfuzztest/Kconfig
new file mode 100644
index 000000000000..d8e9caaac108
--- /dev/null
+++ b/lib/kfuzztest/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config KFUZZTEST
+	bool "KFuzzTest - enable support for internal fuzz targets"
+	depends on DEBUG_FS && DEBUG_KERNEL
+	help
+	  Enables support for the kernel fuzz testing framework (KFuzzTest), an
+	  interface for exposing internal kernel functions to a userspace fuzzing
+	  engine. KFuzzTest targets are exposed via a debugfs interface that
+	  accepts raw binary inputs from userspace, and is designed to make it
+	  easier to fuzz deeply nested kernel code that is hard to reach from
+	  the system call boundary. Using a simple macro-based API, developers
+	  can add a new fuzz target with minimal boilerplate code.
+
+	  WARNING: This exposes internal kernel functions directly to userspace
+	  and must NEVER be enabled in production builds.
-- 
2.51.0

