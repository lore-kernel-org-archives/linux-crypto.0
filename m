Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E27331B803
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246128; cv=none; b=oiFlEMrvs4hl5qsAmH9tTGmsEnc9rq7NVfPKK4SycJsc+O3Lo2YiuRr2nBY3598AwvejQx1zSwFtwDd8lnIjqGQ85b15YQkW/64ZrCeOo+oo7W5VFJWQMBYdf5P/buaAhHAKP25T3CssaATpzg1mF9kMN8RMLzwTeCuV3qhXEZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246128; c=relaxed/simple;
	bh=jFLv86BSbm6LGv1/W2jurRZOHf2tOTo1lOReNMLMGX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCGawqYcmmN4YcXradNwX9IboGingn5cjLd/yGHEX4d8jScA+WjLI3xNuqKT58MENzOEXZShiXr0mOylB76hloX17CJMXbE64Az65hKsXmVVe+7F6r7VLfxhpjKkCkocRFIME0Ix8C1DzxOc8ZtJmjoxwed5aLiF5UuMsjeecGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YBZrAN42; arc=none smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YBZrAN42"
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-b8708930695so279842266b.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246125; x=1768850925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTAiuUIttCbMVHuYgOxGCwhf3npydnD/rY6k0kTCwMc=;
        b=YBZrAN42i2+QICBwQn8zRbzUK9JPjZU1Je3e1mgy5QGj663VcNe2zcl9EBp7PK2t6p
         21lD7NJKlgrqZtVPRVgEvvHuQV4gmlNWlP6aFhv/FQ93hE991W9/zIEf3mGbJ6eVqSuO
         Y6kAC4GDf/NoeX2PimiPfl37vaDXZbSI86uM0CfNse7Cczy4C5IH6Iwi9IkyIFsw2srv
         6zK7MDdzoRwzZ1N8eKYirLFHaxr5Emgfo1y+Z9MUPbXeAr4IkxDUOJ92DB5s6LcDQ/Rw
         isgcj9BP4SaqrPgkFLsHzjZbDm0SWzbwAckYGQWc0C9NHg3LhilhtBzKdhwFU60M6GbW
         Dyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246125; x=1768850925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CTAiuUIttCbMVHuYgOxGCwhf3npydnD/rY6k0kTCwMc=;
        b=Hv3pk5VZ5sIdUNtpfqZyj9RVJ5lqisfoi9dLM+KoRzEQWPaWRpH961Jn3TQFiCuQgX
         cuS8r/RyHHwcF2L4DK+9dbeIrkriIejSedb5TIpZJ0tJGgFQg0k8RP5gokWlka0voNX8
         UiHswrorE+KmQb6iZ1iX/VJO6yDIZ2g9kvKnMLLd+Holn5nSNpqqa5ySaWIfsT64MaTG
         fiiAR05sFfcaeOqv5/OiryUOrHVnz+tO+OtktCKsB/gNXwtgR5LUoTcL4s526MB9Q11i
         7AWwof+nqA2wp9PUQ0sqLKn6B6tklZt6ied1YZapz/LAC8pxtzQfq0YsagrUD6GxTlEI
         Qlcw==
X-Forwarded-Encrypted: i=1; AJvYcCVKCscgyyaqQxoEp8NXkZ/XBQd4bz7gslnSTIgZdhg5VYZiahSGMWje5uUuqMLc18A+n6rOixK1/nDSY64=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPFAKF8+nxOFhHgIXh9po9kg24EOFMEDrAy2BA3tFmmn93ellz
	5+nXDbC2ED3T1yCCrx0UYPnwOe10SyLYWFOFsQWf9OPjBbFU6MTVY+uA
X-Gm-Gg: AY/fxX7DlsL6VhZcFo6qcrwewZmTh8MzDAIZER7ytXobCloHwl8T0DKfYHDKiKT7yfU
	GzV9V4t5idHKnHvRWuXDQI8kZ14aSHiSNXvoyCUMeZZRg7es93fPiBJlW/bMSftgPAd12+GVqMd
	jYGZrRyhTTc6jnHkn3VCdtDBQ+crNepKNYs2YyOSacY2aEDX6x05q9EjG58nXqgJdTILRDHegGz
	KjLZknd0zMTlhEtACwMsKLtSqAFJ6cLVUwZ4y/YOUlXs18pwzDKDLZ5q5cftQa4WHLaOvClx4w0
	sy0ln64LlA7jQNzU+mw1Od+Bhq8+HkxOD4zzWX8uJ2VQ0kv7K0/uzJSVe2i5JrIVMLMn4Wx9N7d
	lPasnViVbRpDmF9v4kxQwCzjSfAc8pyfHsEPuoNdg0FcXXMhnnbLQZydb38mw416UNsnQ6Yxd0c
	nziejgHJmMeU+rTLgYWXyuaP6+GOXm+qbgVnPuPqmuVsTTvOzjDw==
X-Google-Smtp-Source: AGHT+IFg3EfHyzwE3s5+1CIr8vfZlNWItuYnwllGRGRLiahyarhLhMPRBnC81D17BfEIAlYLna4bQw==
X-Received: by 2002:a17:906:c141:b0:b87:1c74:a8c6 with SMTP id a640c23a62f3a-b871c74ab49mr405692366b.57.1768246124624;
        Mon, 12 Jan 2026 11:28:44 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:44 -0800 (PST)
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
Subject: [PATCH v4 3/6] kfuzztest: add ReST documentation
Date: Mon, 12 Jan 2026 20:28:24 +0100
Message-ID: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
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

Add Documentation/dev-tools/kfuzztest.rst and reference it in the
dev-tools index.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Rework documentation to focus exclusively on the `FUZZ_TEST_SIMPLE`
  macro, removing all references to the legacy complex targets and
  serialization format.
- Remove obsolete sections describing DWARF constraints, annotations,
  and the userspace bridge tool.
- Add examples demonstrating basic usage with standard command-line
  tools.
---
---
 Documentation/dev-tools/index.rst     |   1 +
 Documentation/dev-tools/kfuzztest.rst | 152 ++++++++++++++++++++++++++
 include/linux/kfuzztest.h             |   2 +
 3 files changed, 155 insertions(+)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 65c54b27a60b..00ccc4da003b 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -32,6 +32,7 @@ Documentation/process/debugging/index.rst
    kfence
    kselftest
    kunit/index
+   kfuzztest
    ktap
    checkuapi
    gpio-sloppy-logic-analyzer
diff --git a/Documentation/dev-tools/kfuzztest.rst b/Documentation/dev-tools/kfuzztest.rst
new file mode 100644
index 000000000000..f5ccf545d45d
--- /dev/null
+++ b/Documentation/dev-tools/kfuzztest.rst
@@ -0,0 +1,152 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright 2025 Google LLC
+
+=========================================
+Kernel Fuzz Testing Framework (KFuzzTest)
+=========================================
+
+Overview
+========
+
+The Kernel Fuzz Testing Framework (KFuzzTest) is a framework designed to expose
+internal kernel functions to a userspace fuzzing engine.
+
+It is intended for testing stateless or low-state functions that are difficult
+to reach from the system call interface, such as routines involved in file
+format parsing or complex data transformations. This provides a method for
+in-situ fuzzing of kernel code without requiring that it be built as a separate
+userspace library or that its dependencies be stubbed out.
+
+The framework consists of two main components:
+
+1.  An API, based on the ``FUZZ_TEST_SIMPLE`` macro, for defining test targets
+    directly in the kernel tree.
+2.  A ``debugfs`` interface through which a userspace fuzzer submits raw
+    binary test inputs.
+
+.. warning::
+   KFuzzTest is a debugging and testing tool. It exposes internal kernel
+   functions to userspace with minimal sanitization and is designed for
+   use in controlled test environments only. It must **NEVER** be enabled
+   in production kernels.
+
+Supported Architectures
+=======================
+
+KFuzzTest is designed for generic architecture support. It has only been
+explicitly tested on x86_64.
+
+Usage
+=====
+
+To enable KFuzzTest, configure the kernel with::
+
+	CONFIG_KFUZZTEST=y
+
+which depends on ``CONFIG_DEBUGFS`` for receiving userspace inputs, and
+``CONFIG_DEBUG_KERNEL`` as an additional guardrail for preventing KFuzzTest
+from finding its way into a production build accidentally.
+
+The KFuzzTest sample fuzz targets can be built in with
+``CONFIG_SAMPLE_KFUZZTEST``.
+
+KFuzzTest currently only supports targets that are built into the kernel, as the
+core module's startup process discovers fuzz targets from a dedicated ELF
+section during startup.
+
+Defining a KFuzzTest target
+---------------------------
+
+A fuzz target should be defined in a .c file. The recommended place to define
+this is under the subsystem's ``/tests`` directory in a ``<file-name>_kfuzz.c``
+file, following the convention used by KUnit. The only strict requirement is
+that the function being fuzzed is visible to the fuzz target.
+
+Use the ``FUZZ_TEST_SIMPLE`` macro to define a fuzz target. This macro is
+designed for functions that accept a buffer and its length (e.g.,
+``(const char *data, size_t datalen)``).
+
+This macro provides ``data`` and ``datalen`` variables implicitly to the test
+body.
+
+.. code-block:: c
+
+	/* 1. The kernel function that we want to fuzz. */
+	int process_data(const char *data, size_t len);
+
+	/* 2. Define the fuzz target with the FUZZ_TEST_SIMPLE macro. */
+	FUZZ_TEST_SIMPLE(test_process_data)
+	{
+		/* 3. Call the kernel function with the provided input. */
+		process_data(data, datalen);
+	}
+
+A ``FUZZ_TEST_SIMPLE`` target creates a debugfs directory
+(``/sys/kernel/debug/kfuzztest/<test-name>``) containing a single write-only
+file ``input_simple``: writing a raw blob to this file will invoke the fuzz
+target, passing the blob as ``(data, datalen)``.
+
+Basic Usage
+^^^^^^^^^^^
+
+Because the interface accepts raw binary data, targets can be smoke-tested or
+fuzzed naively using standard command-line tools without any external
+dependencies.
+
+For example, to feed 128 bytes of random data to the target defined above:
+
+.. code-block:: sh
+
+   head -c 128 /dev/urandom > \
+       /sys/kernel/debug/kfuzztest/test_process_data/input_simple
+
+Integration with Fuzzers
+^^^^^^^^^^^^^^^^^^^^^^^^
+
+The simple interface makes it easy to integrate with userspace fuzzers (e.g.,
+LibFuzzer, AFL++, honggfuzz). A LibFuzzer, for example, harness may look like
+so:
+
+.. code-block:: c
+
+    /* Path to the simple target's input file */
+    const char *filepath = "/sys/kernel/debug/kfuzztest/test_process_data/input_simple";
+
+    extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
+        FILE *f = fopen(filepath, "w");
+        if (!f) {
+            return 0; /* Fuzzer should not stop. */
+        }
+        /* Write the raw fuzzer input directly. */
+        fwrite(Data, 1, Size, f);
+        fclose(f);
+        return 0;
+    }
+
+Note that while it is simple to feed inputs to KFuzzTest targets, kernel
+coverage collection is key for the effectiveness of a coverage-guided fuzzer;
+setup of KCOV or other coverage mechanisms is outside of KFuzzTest's scope.
+
+Metadata
+--------
+
+The ``FUZZ_TEST_SIMPLE`` macro embeds metadata into a dedicated section within
+the main ``.data`` section of the final ``vmlinux`` binary:
+``.kfuzztest_simple_target``, delimited by ``__kfuzztest_simple_targets_start``
+and ``__kfuzztest_simple_targets_end``.
+
+The metadata serves two purposes:
+
+1. The core module uses the ``.kfuzztest_simple_target`` section at boot to
+   discover every test instance and create its ``debugfs`` directory and
+   ``input_simple`` file.
+2. Tooling can use this section for offline discovery. While available fuzz
+   targets can be trivially enumerated at runtime by listing the directories
+   under ``/sys/kernel/debug/kfuzztest``, the metadata allows fuzzing
+   orchestrators to index available fuzz targets directly from the ``vmlinux``
+   binary without needing to boot the kernel.
+
+This metadata consists of an array of ``struct kfuzztest_simple_target``. The
+``name`` field within this struct references data in other locations of the
+``vmlinux`` binary, and therefore a userspace tool that parses the ELF must
+resolve these pointers to read the underlying data.
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
index 62fce9267761..4f210c5ec919 100644
--- a/include/linux/kfuzztest.h
+++ b/include/linux/kfuzztest.h
@@ -3,6 +3,8 @@
  * The Kernel Fuzz Testing Framework (KFuzzTest) API for defining fuzz targets
  * for internal kernel functions.
  *
+ * For more information please see Documentation/dev-tools/kfuzztest.rst.
+ *
  * Copyright 2025 Google LLC
  */
 #ifndef KFUZZTEST_H
-- 
2.51.0

