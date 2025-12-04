Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2935834250D
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857603; cv=none; b=NY+ArThiAMYMKtU7yL2YWH37TdTd/XBZEMXmg0pQsxRMNOvYHYEP2vzVi1lWtlP93ItX33dGU3jmBu++HxZOKGqfa9aA74mVIy1hjiPLSmfFVai0jByYp805yVniens8AyGUk5y7mNn7er9edL1blDdhHMuodLBaWQXkyF1AgIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857603; c=relaxed/simple;
	bh=SLr8BO4ZGW22sZ7mEfPrF/suWJfHfY2rN3bWKeuDZ8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAla2Ype2tkNsirkWwH8o/Lg+jBmpTrM9iH8wixwropy5RcLKKCvV5NgOeI85v1m6q9ZgnuetB7dlI3zmvXwlxwm+VbTIgb5RGfUI038NOGz0f75pgOT4+RZzb+4ig5uFs+dv6nf9uNb4rHoVDLQBL5jMJQtWIuEXz9NIbESw34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGzW71Bo; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGzW71Bo"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42e2e40582eso614468f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857597; x=1765462397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ekn2DBIpCkQXanmNkedEYdcryjYDg+bStsY06P8Miig=;
        b=bGzW71BoNXtNjjbz1PyhU+5UP6+NttYR8U1PNX0svQjpXNwi/LqJPiQlqcT+JwX1af
         pa6mFPWQ7aIwqC0W5J98rdB8CktaRgqmLi/9a7mKOP7bIG8K/UPsC7Zx6Jr6BFcI8Ff8
         QdVQ6vc74tVQhL7wQNoit7dR+DgQ4T4Wc2wCrw6O9Wo7zzCjOWRmPbA+54LI3lkiSDog
         TXuKmPaIe7UJ1ilcEGAQQKnoG4ykjs2r/gMDvrd2s2MBbNP2ImqS9NlW/CGo3+6H2UCp
         DhRpUSJEV3dVxubijbBPAHC5L8IGBMvMu40JwFMd9N5BR0wGOBAS5dpnuL45eVDQ7xZ5
         HeHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857597; x=1765462397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ekn2DBIpCkQXanmNkedEYdcryjYDg+bStsY06P8Miig=;
        b=NL/V83Wct7jS9oxgXkPFUfOZatFDByyBP5Tb5/HAHSwcDCbwtmnCUb0K5/weZ30Tuq
         xsdFDpJ4+ai8+Rz1ezP+C3jGunxKojVfk2UJzA2Wu4dCrT/GmnOzuvvM+T4sI3aOH8lH
         EmPXWJKVk6wO65v/E2tnFJaF95AFQ6BqYj6jS0gNJdnU0SbuLrjvYuNntCgb7FYkC/xn
         47rdU0FXnNG0q8Lv915mnFOUeUMftb63fzEDJ/54bft/NpzMWXdeWz8TDBx3LyYl8Q+5
         EOx9J7cmRkzbh6nUaW4xwKIgfznoZVvKOS++nlak5Z9x8RiM5yT5/KUrLwu5UUa7I/TT
         qtug==
X-Forwarded-Encrypted: i=1; AJvYcCWpGifseXQOSg+bvrvyVjCVccenECRQC5ZRuK4ej6z+Jz2qMAplqYDBPbOgehgwnXkpOJpcf/du57YOXYw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1JhrqYHzDBP/ewzB43i6CVYvahVpPqMvPn/7/ONrBdTOJxMKl
	uLhBIE+CfQLuTqN8+uku3zcCyT6h84HS6Sl07Xj5Yn6T8yxPEEFaE3AA
X-Gm-Gg: ASbGncvXT1rK4PeujH8gBFOGjPcXT8GgjNDMnVK9tYUpBo1GHoEA7s5PyeDNr7un6xe
	+n+/oJXo9I9kPpKiLolvwLDrOlXqk4LLEyKUBqwrIr/t4OgfKL+zswTADFNHw4yT0Sv/kmxmNMJ
	tHev1JwTlD+CD3ATgjMIJeGl9oKsB6MG/fix4+oac2o6VBsNy9gBlWFutjHeVf87QyiAz4kLTeP
	xKH9Nzfms95WgGhczrfL29coGdXM6OU6K6tPeu63yEjosJRWxqkVYXIJE0HA/2zED9bOYzAndoY
	lO6/r1tbRYg5EPNN7DqSALUe7UqNShisnYYrC0la0QEOFwFNHSO02CcIVbSZVZu6uUQR/MI6Tkq
	1Tj3ai9CiFGYdXj4/zAXvBfMnSFDAxK9XZqgJMo+bKbKF2JzmXqQG6QA1Fz/I9pxmbjaTaXvDEX
	+xN5FFoYzClFDWdKO4ENiP+WZHrijD5gGAzAtP/4E+reWfjYgoR8zFi7WHwVCHFHNy/Q==
X-Google-Smtp-Source: AGHT+IF0jf9L5DYl+1CaWZ41zHsxhPYhONOE+2bdn2S71mNR6t6KEufMrADSOSJwyHdeDKC7Wy8upA==
X-Received: by 2002:a05:6000:144c:b0:3e8:b4cb:c3dc with SMTP id ffacd0b85a97d-42f79514872mr3363210f8f.3.1764857597333;
        Thu, 04 Dec 2025 06:13:17 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:16 -0800 (PST)
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
Subject: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Date: Thu,  4 Dec 2025 15:12:48 +0100
Message-ID: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
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

Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
file under /drivers/auxdisplay/tests.

To validate the correctness and effectiveness of this KFuzzTest target,
a bug was injected into parse_xy() like so:

drivers/auxdisplay/charlcd.c:179
- s = p;
+ s = p + 1;

Although a simple off-by-one bug, it requires a specific input sequence
in order to trigger it, thus demonstrating the power of pairing
KFuzzTest with a coverage-guided fuzzer like syzkaller.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Remove conditional inclusion of charlcd_kfuzz.c from charlcd.c, as
  requested by Andy Shevchenko.
- Update auxdisplay Makefile to conditionally build charlcd_kfuzz.c when
  CONFIG_KFUZZTEST=y, as suggested by Lukas Wunner and Andy Shevchenko.
- Foward declare parse_xy in charlcd_kfuzz.c.
---
---
 drivers/auxdisplay/Makefile              |  3 +++
 drivers/auxdisplay/tests/charlcd_kfuzz.c | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c

diff --git a/drivers/auxdisplay/Makefile b/drivers/auxdisplay/Makefile
index f5c13ed1cd4f..af00b0a173de 100644
--- a/drivers/auxdisplay/Makefile
+++ b/drivers/auxdisplay/Makefile
@@ -6,6 +6,9 @@
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_CFAG12864B)	+= cfag12864b.o cfag12864bfb.o
 obj-$(CONFIG_CHARLCD)		+= charlcd.o
+ifeq ($(CONFIG_KFUZZTEST),y)
+CFLAGS_charlcd.o += -include $(src)/tests/charlcd_kfuzz.c
+endif
 obj-$(CONFIG_HD44780_COMMON)	+= hd44780_common.o
 obj-$(CONFIG_HD44780)		+= hd44780.o
 obj-$(CONFIG_HT16K33)		+= ht16k33.o
diff --git a/drivers/auxdisplay/tests/charlcd_kfuzz.c b/drivers/auxdisplay/tests/charlcd_kfuzz.c
new file mode 100644
index 000000000000..3adf510f4356
--- /dev/null
+++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * charlcd KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+struct parse_xy_arg {
+	const char *s;
+};
+
+static bool parse_xy(const char *s, unsigned long *x, unsigned long *y);
+
+FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
+{
+	unsigned long x, y;
+
+	KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
+	KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
+	parse_xy(arg->s, &x, &y);
+}
-- 
2.51.0

