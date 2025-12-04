Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF0E344026
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857599; cv=none; b=atmUVUNBtv90XEWIYSYUckDn6Y0mQxmB8M3znxRxbmz3UY7+LY6pxwQiGux16YKoykC5DRf0JJdTT1D7YXV969dYQuuYBm9uTcR6RH9ytOFgwE7gxy/cY0hhy6n833Ao1AZfh6GwEWcbgU1745Jc/jsPtah4N3V5D94XlYEdnUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857599; c=relaxed/simple;
	bh=WuvuYrKJlC5+EVDn+2jK6a/jc6Brt3r9WFpW4nuOaLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdoU2k/lSj9hFoZnSHLuyIdIBvlhaE5jkWm24449BVqx46K9hi5xrqGfLMEMsXBQhYmRn1GcW1pDz5HbUcP1kq9L5BXcBVS5SevrwYK9a6u306kAiBEX63jJdB8umQkSlY3KKjdNTa78ev/qQA8KCJnc9I6qmrBWiPPx6R41jEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTpV/1gG; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTpV/1gG"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42e2ba54a6fso424093f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857595; x=1765462395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYb/yPra/VQ92UPtHr69bchv45pj9r5YmHZ7p3XU5gk=;
        b=ZTpV/1gG26JSBGGdXZZKPLubqM7wG0Fb8nawW46f9jIZyqu+tUJPMwVnv3zKCuvLhD
         WeZG54HWTBCpIZdOpN1ItgPkwW3fQGolizplG8K/QLnuKc3fO0NgBxSTGrVW5nD0F6G5
         eliZH0REpPiaQFkxs6XC+xzUHlCefFZ1jY3AWtPAdtGWSzkhMPVeT5zFVkXeGAcUEGCh
         dSaDcdPtQTCj8+gpVaOcBUGpTU2Zb8eD8iZ9Q+PgnTwLgoY00tHS7S5zTXlgk5Z/KFd3
         rOsKAPNjwDnC1k4COOZXFIIOZH6DQEnElGVBiSdQBCROd1kwpzOioG7KLafNGxGmxkPK
         2uPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857595; x=1765462395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JYb/yPra/VQ92UPtHr69bchv45pj9r5YmHZ7p3XU5gk=;
        b=uhSjek7f0dZ/G3tZejzJoyq/5LBcw8rqzXclTdo98D6I7khgy5T8zAY86HLIfcOv9s
         pb34vDlAkDlG3tN7egr+ilNqtGp0E4StUDpw3aerPwbo/SuFTAa7zAU9q9lWtPld/HlS
         Nl1Y42mLLKZ4umJ1bQIBb1NgRyYpsMLtMxWv+7OAJ9Upm1YId5p39np9jI3bQ3owZTng
         KG1f97YSIqXFw7/xhgu4iJ57jiURgYOMaGhHN5AFP1lwkXZgWWMz3JBj8U/aXb3KCJYc
         dpPsSzBvOf90/GziCxwcC84Ub5Em9nxaGKAySC4qR5Elr0Q7chixQavp4zjXvlm5QJix
         cAaw==
X-Forwarded-Encrypted: i=1; AJvYcCWg9F+iQkD5NbQYsp2fNxtcJFnrWCwQoypXUhrvcQEN/QRMTFpP7DidQ8p5RweCA3I2UZbOBLWzIzmz96k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdyAIYyxehbiO9wa2O8pFNLnPFZQjB6/W0mKm078fty14cI72U
	VmDQHUTHPkrm4K8SNIGjv1hdch5dC2ninjO8th7tu3LgNY/wR2+y1MxS
X-Gm-Gg: ASbGncsjM89qMfcEJl7jbbmtt4TzRGLnKT66QWe2bv3IId+BhvWWhd0VnIlsX5rf4mB
	t8GdsvWzh8QztI4kOVqFeAocSRsmtvgOEWRmV+rXEhpUX4u3oN5pErY/JueatBh7h7wL+hv6npT
	Y9qpvh2axZ2XSlXFpRfc3xIr03ohvmk2a0OB9hoEZhKuygjPvUE+f2ngYkfIq6yXX9GGg9ZQjgj
	5PTHD8LsgFABMZKT9Rygu2eeGVcgiqdQ7hhed+dBL7DLZMqVwC9JVEkKx+yl34N1O8bjzmhJzBP
	GgoJX5aErhCvZqcxZM2v1FSKdjUFjbj1/hj7wfv/AUP0v17/0ObUVLIRHBg86YRgwMesW5IKpqf
	U7ymGj/3DCKoClOXZx6mZkPPGeU9pHaIfBnJaD9gNz3ONdSHfDmeeJw1pB9wXDe35NwBcqFsfBO
	zcDlkTIrXb4vVHfP7qDVLGvVG9NnzWI6VZlN5K4o5G3XSMsJ4qptNIDrtLzXDrjZgwFiyot1SwO
	t8b
X-Google-Smtp-Source: AGHT+IFaN2iuHh8JgUwoVZzKMyn/tcQMjt8qJkVwY5tRzh0K3jG6s9pjH/nYgcBl1jHrMCivejQ75w==
X-Received: by 2002:a05:6000:290e:b0:42b:411b:e487 with SMTP id ffacd0b85a97d-42f73174091mr6010345f8f.2.1764857594380;
        Thu, 04 Dec 2025 06:13:14 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:13 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
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
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Ethan Graham <ethangraham@google.com>
Subject: [PATCH 07/10] kfuzztest: add KFuzzTest sample fuzz targets
Date: Thu,  4 Dec 2025 15:12:46 +0100
Message-ID: <20251204141250.21114-8-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Add two simple fuzz target samples to demonstrate the KFuzzTest API and
provide basic self-tests for the framework.

These examples showcase how a developer can define a fuzz target using
the FUZZ_TEST(), constraint, and annotation macros, and serve as runtime
sanity checks for the core logic. For example, they test that
out-of-bounds memory accesses into poisoned padding regions are
correctly detected in a KASAN build.

These have been tested by writing syzkaller-generated inputs into their
debugfs 'input' files and verifying that the correct KASAN reports were
triggered.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Use the FUZZ_TEST_SIMPLE macro in the `underflow_on_buffer` sample
  fuzz target instead of FUZZ_TEST.
PR v2:
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
---
---
 samples/Kconfig                               |  7 ++
 samples/Makefile                              |  1 +
 samples/kfuzztest/Makefile                    |  3 +
 samples/kfuzztest/overflow_on_nested_buffer.c | 71 +++++++++++++++++++
 samples/kfuzztest/underflow_on_buffer.c       | 51 +++++++++++++
 5 files changed, 133 insertions(+)
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 6e072a5f1ed8..5209dd9d7a5c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -320,6 +320,13 @@ config SAMPLE_HUNG_TASK
 	  Reading these files with multiple processes triggers hung task
 	  detection by holding locks for a long time (256 seconds).
 
+config SAMPLE_KFUZZTEST
+	bool "Build KFuzzTest sample targets"
+	depends on KFUZZTEST
+	help
+	  Build KFuzzTest sample targets that serve as selftests for input
+	  deserialization and inter-region redzone poisoning logic.
+
 source "samples/rust/Kconfig"
 
 source "samples/damon/Kconfig"
diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8..3a0e7f744f44 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -44,4 +44,5 @@ obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_MTIER)	+= damon/
 obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
+obj-$(CONFIG_SAMPLE_KFUZZTEST)		+= kfuzztest/
 obj-$(CONFIG_SAMPLE_TSM_MR)		+= tsm-mr/
diff --git a/samples/kfuzztest/Makefile b/samples/kfuzztest/Makefile
new file mode 100644
index 000000000000..4f8709876c9e
--- /dev/null
+++ b/samples/kfuzztest/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_SAMPLE_KFUZZTEST) += overflow_on_nested_buffer.o underflow_on_buffer.o
diff --git a/samples/kfuzztest/overflow_on_nested_buffer.c b/samples/kfuzztest/overflow_on_nested_buffer.c
new file mode 100644
index 000000000000..2f1c3ff9f750
--- /dev/null
+++ b/samples/kfuzztest/overflow_on_nested_buffer.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * overflow on a nested region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+
+/**
+ * DOC: test_overflow_on_nested_buffer
+ *
+ * This test uses a struct with two distinct dynamically allocated buffers.
+ * It checks that KFuzzTest's memory layout correctly poisons the memory
+ * regions and that KASAN can detect an overflow when reading one byte past the
+ * end of the first buffer (`a`).
+ *
+ * It can be invoked with kfuzztest-bridge using the following command:
+ *
+ * ./kfuzztest-bridge \
+ *   "nested_buffers { ptr[a] len[a, u64] ptr[b] len[b, u64] }; \
+ *   a { arr[u8, 64] }; b { arr[u8, 64] };" \
+ *   "test_overflow_on_nested_buffer" /dev/urandom
+ *
+ * The first argument describes the C struct `nested_buffers` and specifies that
+ * both `a` and `b` are pointers to arrays of 64 bytes.
+ */
+#include <linux/kfuzztest.h>
+
+static void overflow_on_nested_buffer(const char *a, size_t a_len, const char *b, size_t b_len)
+{
+	size_t i;
+	pr_info("a = [%px, %px)", a, a + a_len);
+	pr_info("b = [%px, %px)", b, b + b_len);
+
+	/* Ensure that all bytes in arg->b are accessible. */
+	for (i = 0; i < b_len; i++)
+		READ_ONCE(b[i]);
+	/*
+	 * Check that all bytes in arg->a are accessible, and provoke an OOB on
+	 * the first byte to the right of the buffer which will trigger a KASAN
+	 * report.
+	 */
+	for (i = 0; i <= a_len; i++)
+		READ_ONCE(a[i]);
+}
+
+struct nested_buffers {
+	const char *a;
+	size_t a_len;
+	const char *b;
+	size_t b_len;
+};
+
+/**
+ * The KFuzzTest input format specifies that struct nested buffers should
+ * be expanded as:
+ *
+ * | a | b | pad[8] | *a | pad[8] | *b |
+ *
+ * where the padded regions are poisoned. We expect to trigger a KASAN report by
+ * overflowing one byte into the `a` buffer.
+ */
+FUZZ_TEST(test_overflow_on_nested_buffer, struct nested_buffers)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(nested_buffers, a);
+	KFUZZTEST_EXPECT_NOT_NULL(nested_buffers, b);
+	KFUZZTEST_ANNOTATE_LEN(nested_buffers, a_len, a);
+	KFUZZTEST_ANNOTATE_LEN(nested_buffers, b_len, b);
+
+	overflow_on_nested_buffer(arg->a, arg->a_len, arg->b, arg->b_len);
+}
diff --git a/samples/kfuzztest/underflow_on_buffer.c b/samples/kfuzztest/underflow_on_buffer.c
new file mode 100644
index 000000000000..b2f5ff467334
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * underflow on a region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+
+/**
+ * DOC: test_underflow_on_buffer
+ *
+ * This test ensures that the region between the metadata struct and the
+ * dynamically allocated buffer is poisoned. It provokes a one-byte underflow
+ * on the buffer, which should be caught by KASAN.
+ *
+ * It can be invoked with kfuzztest-bridge using the following command:
+ *
+ * ./kfuzztest-bridge \
+ *   "some_buffer { ptr[buf] len[buf, u64]}; buf { arr[u8, 128] };" \
+ *   "test_underflow_on_buffer" /dev/urandom
+ *
+ * The first argument describes the C struct `some_buffer` and specifies that
+ * `buf` is a pointer to an array of 128 bytes. The second argument is the test
+ * name, and the third is a seed file.
+ */
+#include <linux/kfuzztest.h>
+
+static void underflow_on_buffer(char *buf, size_t buflen)
+{
+	size_t i;
+
+	pr_info("buf = [%px, %px)", buf, buf + buflen);
+
+	/* First ensure that all bytes in arg->b are accessible. */
+	for (i = 0; i < buflen; i++)
+		READ_ONCE(buf[i]);
+	/*
+	 * Provoke a buffer overflow on the first byte preceding b, triggering
+	 * a KASAN report.
+	 */
+	READ_ONCE(*((char *)buf - 1));
+}
+
+/**
+ * Tests that the region between struct some_buffer and the expanded *buf field
+ * is correctly poisoned by accessing the first byte before *buf.
+ */
+FUZZ_TEST_SIMPLE(test_underflow_on_buffer)
+{
+	underflow_on_buffer(data, datalen);
+}
-- 
2.51.0

