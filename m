Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26F8320A31;
	Mon,  1 Sep 2025 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756744999; cv=none; b=aTIvt1jhI9AD9u4tjYzRvr4YfnGgylTG5Tm8XfZtK3G9dHZ1xzc3RiVFLu7/3y/ViTuUXsUa4FJR69O6vjHETVY+D4Xu7xrfkcf4N45AdN63tZdFSVDaJmnLRskXuBSWjSKG2RjjZurdJn1X5zZsYaTcfWQ3gSBeIwJw6vSXLG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756744999; c=relaxed/simple;
	bh=5G+472+LxBGUu9qceuoO7EbTjatKppK80VIx+iKXfLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWntlz6S3/NyDOnDIL/C+xEQIn4cIjoZbd4r5nYIGxDkpgAaWPxsKXDeUSSKeXpWOH6/4q5CJSUh2IrbIX4MtzTd4/5PqAgZ5koDeNcNA4H4hs7OwksUkewtVUfC55pnUAVtrVjSDz09FZjSJUijXglLt80KO8srkYbOCA6xXOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmskYteQ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmskYteQ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso2905584f8f.2;
        Mon, 01 Sep 2025 09:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744994; x=1757349794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApDGjF4qZlhoSmK2tdSzupo+2mRrDnKfGsOkf1zOwN4=;
        b=lmskYteQpwxvh+7VQdIzxKHxphQCnleZOGqEdYqSJbrxSu+W2gP2GY6qeRmOMYLZzt
         APYj7bi1QTkA7G5JFJDoLjGpHhZ+zbAQ0TXRYWOIKymzIZJ6AcMHvdEsmjZtCFhqxCXS
         qp+IKcEPDYdOSRbnpmn9hCy5bzACxEhFrl0pA3a/yg9GmX9fRi1kXSFNT+7QgoWe3Z/C
         R8I7BqtXLPwA+lOs22cQqb7GWGYA4e+CA2jLGcR56qYKq6w3xKnSOb9kWAVYq0Jg2GGx
         CekWnzMLWmuQm7iL962aZXn5XmeRBr49iZv5GcAOeDAPc+5moGDpxJoezOv2Cz5SSedh
         2qng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744994; x=1757349794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ApDGjF4qZlhoSmK2tdSzupo+2mRrDnKfGsOkf1zOwN4=;
        b=gZnanYkqyio48CXzbLW3yr89IzfAOdGzFh1KqiG8aTxhSKiRIqe6f0jVkyV30M5AVo
         Vbm2otkc69HiXqhn5NedQVujtW7ylCkmjaJ/mGy7bv8wSc6aObPUZTygJYNHANmSvE5D
         hF9KwS5TLwj4DcN/JbwQo0+pLYWr984cZWgutN1CK1rDx6IoajnHcXLFgNmAg+3nKAfn
         y3JOwHscJ6DfGPepD0KXm82H4cvZSDE+OJyih0f5lWYUi57A4/96xvhivJmkqVe0zvQt
         wdW69ejBDg0nOQQgViNOMwVYP8649THBaxz1AFva8ebpD61PaJSp8bFDuuT5Kf22WRq1
         1gxA==
X-Forwarded-Encrypted: i=1; AJvYcCWPeP/1GbdehokBtZUYgDqxaoTGsFrDyj4MR/pkd8L4xIFyKGaeIt602nfc7XDejiW34HyL07I5vkxKs/o7@vger.kernel.org, AJvYcCXWFaKfXYyz84pBKXEw6UupU3fJJ0C48GYzePXWJkdJz0oOcDYbqHzsxdqNDs/n/mD4OpHBWLxhX25oajU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWzsVPMF1dVT/VlPgi9ZDUtB5PrFTdrr+aOIS6A1j9PvQ16mG8
	Cd0kMhqQf0ABwylN0W32QQFu9NyTIE3FuvfweDuWvCvwXN3qMurnTBXXc9Jghd1l6kf8TQ==
X-Gm-Gg: ASbGnctrprO8wXOyJLvYU9qtqwsqAmDHuKaHClEfIMI7rflVd7vjzpcsOJL2YoJMpWf
	2Il7hQlhaDeAYZc8p+TqolATLjhiAC/EXX2hlHu2t5/AWdLiHOUBcDWQeQL287uaht2sq8vGVgO
	mvvHMd06/AyY8GfiO1RCg1y+shkuRUMr1Uzh3AKObO0eRJYNDzrXlv6G7BOKymOiYyMcCin1b0u
	cAuzClQxOH0s7LCCWCeLFo7rR9LhSIwXnduxkkNUE6ck4oOyCDD/VK9wmjRpy0XSKe8+wWMXkKr
	p+mo0wPE7+E2sWvcKG+aq2VAkXpE+lbZG/ERbviIYsaCoVlKtd2YNN3gLrWxusSVBLnkoCUnfqm
	lyca6SDloQRIKiXXr/TPiqE9CPGC5kPX6EAc3hqsAXIllD2Ciq57T7RwFP3ZmHXI4i/zvDnjF7Y
	5V4gNII6ZaqUPSCCDxPfO3/wn7G6io
X-Google-Smtp-Source: AGHT+IGObzEWmAWMvVVCO+qu5XzxIJd7dvBXszVP90qakpw859cAfnGGaYfjxJR6FILuoiBJKV7+Qg==
X-Received: by 2002:a05:6000:25ca:b0:3b7:9629:ac9e with SMTP id ffacd0b85a97d-3d1df34d63dmr5448037f8f.50.1756744993978;
        Mon, 01 Sep 2025 09:43:13 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:13 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 6/7] kfuzztest: add KFuzzTest sample fuzz targets
Date: Mon,  1 Sep 2025 16:42:11 +0000
Message-ID: <20250901164212.460229-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
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
sanity checks for the core logic. For example, they test that out-of-bounds
memory accesses into poisoned padding regions are correctly detected in a
KASAN build.

These have been tested by writing syzkaller-generated inputs into their
debugfs 'input' files and verifying that the correct KASAN reports were
triggered.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 samples/Kconfig                               |  7 +++
 samples/Makefile                              |  1 +
 samples/kfuzztest/Makefile                    |  3 ++
 samples/kfuzztest/overflow_on_nested_buffer.c | 52 +++++++++++++++++++
 samples/kfuzztest/underflow_on_buffer.c       | 41 +++++++++++++++
 5 files changed, 104 insertions(+)
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

diff --git a/samples/Kconfig b/samples/Kconfig
index ffef99950206..4be51a21d010 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -321,6 +321,13 @@ config SAMPLE_HUNG_TASK
 	  if 2 or more processes read the same file concurrently, it will
 	  be detected by the hung_task watchdog.
 
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
index 000000000000..8b4bab1d6d4a
--- /dev/null
+++ b/samples/kfuzztest/overflow_on_nested_buffer.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * overflow on a nested region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
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
index 000000000000..fbe214274037
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * underflow on a region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
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
+struct some_buffer {
+	char *buf;
+	size_t buflen;
+};
+
+/**
+ * Tests that the region between struct some_buffer and the expanded *buf field
+ * is correctly poisoned by accessing the first byte before *buf.
+ */
+FUZZ_TEST(test_underflow_on_buffer, struct some_buffer)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(some_buffer, buf);
+	KFUZZTEST_ANNOTATE_LEN(some_buffer, buflen, buf);
+
+	underflow_on_buffer(arg->buf, arg->buflen);
+}
-- 
2.51.0.318.gd7df087d1a-goog

