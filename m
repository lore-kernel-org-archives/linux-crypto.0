Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA9727511E
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 14:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293884; cv=none; b=AkDlOnSykHdWqnzcHFbLEpmuLbKJ2OdLHwKC8QDBgy9u5wm9+bf4LCB0I9TO7fxInZM6EafYFYXEC0FNTfA2kII88cbQKeEiq3NYZ96KgjdxGlY8uVwr/nasRiUxuW25LAXw3jOZ1KbtzLDTlQ1JvKdOrPni2cHpVTTKxOIsyAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293884; c=relaxed/simple;
	bh=egRlU8I8cap/vMG/cP8j3cYqgKLkvNE8Tghmz+aDQ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACUZzq1Ecnh3QPbTvA6ARJ6J+TKZBDK/m0F6ZeuwDlQ9Yo4oXX/1lo36NqRHxtO4YO5l/S5PKohibaFVrYroOaWlzECb50jxeRMTMmwZ+s3dN5cEd7Laf7RjBdn/2UgYtJAtVWoAEegbbuoeqeJqpvdzPch4YMyBA2aSudcUGkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JdRqnUvr; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JdRqnUvr"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45f2c4c3853so8049735e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 07:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293880; x=1758898680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iux7tJA7Iu45JzwDlqqn3NczB+xQmLnfn/+UUn4bsic=;
        b=JdRqnUvryAa6smB7nKg6KARTl+190Tbrk5xt77sgdnc30u1kPjHdigY4wD/JwYzoDb
         5z3IIcR7ZkVks8kC5AAG1Iqn4hAbuaECNrauHnQpuOD4+1dV/raCWWK5lkli53zbg5GR
         CqmAZUSs6sl3IrGkbWAfn62HYiOkDFVE1gAcssm0LqymrHOv30FeVMHYQuODs9IptO6v
         4/dnn7Zew7lTMqZId4aqOpiKMTswQ3IdU6zQAO8OKCqug/XcIY/bDooDA9qmfUltiIRJ
         e6hLXCKbYgNHrEtORzEekJ+HMok1ATD03jsh57QBxePhlNmhfGK+6vOdf54OIzDSFqGa
         FlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293880; x=1758898680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iux7tJA7Iu45JzwDlqqn3NczB+xQmLnfn/+UUn4bsic=;
        b=R/iM4Ku9ktG3eRklqxkliX2UKdjT8cZRJJMTxGq7kLZi6zTaQIzzSR4gtvGxNgDAnb
         euYrSz3Xso3Uiuur+u58WysEzsAfOagO4vNL17c6aYyox4ckuX8Qt5Oo5Klf9Uu7863K
         BvX07fAgHjtB6xC1MYtTVly5m5C+MvCUJbEinjsvcHiA7qr8lIoMr9fZuJLKYYwPmteO
         86poQWbjd9aPpIom9QhnZ0heYuGdkCDsKYuNu9mh4SqipJMwp972nL1i5L7vUCVR7XUb
         WpusBw31ZlrDhbF4l1p842dVO50htQ9uwCqR3g8Ezsgxps8IaSfDp5c57do9T4Cwlvou
         a3xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbEcV/QMr7O5cHr4TmIl3w6x+a/k9b6UDPf7RbS+RJhKs3YZH4r2L8KldNKuAy/hnDCqELv5JfWjsw9kQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJEH1GLdQJd3KaWUmDKqWj3NRyBgcfwn7f/vgAJdu9vpyR0nZu
	mE6rfcwZmRjNWjUEDRSjQMmWiIwFmuU8Hi3Pc00lEvz7fmqX7jzF91zP
X-Gm-Gg: ASbGncsVyiBWkShxXywqFPTwyELunfmbfP6Ic0etp55gpZaNEj6QR5QkM+RtXk1MFzc
	FsnH47qRO8D7bqqr/joyC5ZQ1vXF6gT4lwuwbX3NFb1JO98Ki+MoahQjNfGQXwNibChVWM/GbJd
	v2LOTZCPvN1C83rseYdvg6n5mmcsQ6Zf+Jx1m1X6e+Q29Ic8Bppx0kxangvSXpBolV2DHdiV2xu
	2n0iJsWrqjQWfsHRFWwPWPDkNbjWz960n7nv0JFhQQeYG0ZAuTzWQzFoQR31Lflg9ndkarKvXQq
	M5n1PakeJ2b8RsoPn6y/T0RV+UfDcvo3rVInVPR1Ltm7bqLy/flpJlUojzi5KgRXHBa8RGcTkpc
	aYSc6f3/YTZ1vO2SZEJgHhkuHjwLZkCVvOWLCmOCmEhNxbswpLtBLOUw/J+iPkCofkEr6vigZ5c
	OxUy/YTtmRSMXKXdI=
X-Google-Smtp-Source: AGHT+IE+XK5nD+9hANJoxYPRSlTs9xbOKfixXYZia7lhztTHnoAksXT/1nQcAsPiiouWjOFFkGLQJg==
X-Received: by 2002:a05:600c:b8d:b0:45d:e326:96fb with SMTP id 5b1f17b1804b1-467ef72d771mr33033965e9.30.1758293879733;
        Fri, 19 Sep 2025 07:57:59 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:57:59 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
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
	tarasmadan@google.com
Subject: [PATCH v2 01/10] mm/kasan: implement kasan_poison_range
Date: Fri, 19 Sep 2025 14:57:41 +0000
Message-ID: <20250919145750.3448393-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Introduce a new helper function, kasan_poison_range(), to encapsulate
the logic for poisoning an arbitrary memory range of a given size, and
expose it publically in <include/linux/kasan.h>.

This is a preparatory change for the upcoming KFuzzTest patches, which
requires the ability to poison the inter-region padding in its input
buffers.

No functional change to any other subsystem is intended by this commit.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

---
PR v1:
- Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
  kasan_poison_range(), and return -EINVAL when this isn't respected.
---
---
 include/linux/kasan.h | 11 +++++++++++
 mm/kasan/shadow.c     | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..cd6cdf732378 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,16 @@ static inline bool kasan_has_integrated_init(void)
 }
 
 #ifdef CONFIG_KASAN
+
+/**
+ * kasan_poison_range - poison the memory range [@addr, @addr + @size)
+ *
+ * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, defined
+ * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial granule
+ * at the beginning of the range is only poisoned if CONFIG_KASAN_GENERIC=y.
+ */
+int kasan_poison_range(const void *addr, size_t size);
+
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -402,6 +412,7 @@ static __always_inline bool kasan_check_byte(const void *addr)
 
 #else /* CONFIG_KASAN */
 
+static inline int kasan_poison_range(const void *start, size_t size) { return 0; }
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..7faed02264f2 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -147,6 +147,40 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 }
 EXPORT_SYMBOL_GPL(kasan_poison);
 
+int kasan_poison_range(const void *addr, size_t size)
+{
+	uintptr_t start_addr = (uintptr_t)addr;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	if ((start_addr + size) % KASAN_GRANULE_SIZE)
+		return -EINVAL;
+
+	end_addr = ALIGN_DOWN(start_addr + size, KASAN_GRANULE_SIZE);
+	if (start_addr >= end_addr)
+		return -EINVAL;
+
+	head_granule_start = ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE);
+	head_prefix_size = start_addr - head_granule_start;
+
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
+		kasan_poison_last_granule((void *)head_granule_start,
+					  head_prefix_size);
+
+	poison_body_start = ALIGN(start_addr, KASAN_GRANULE_SIZE);
+	poison_body_end = ALIGN_DOWN(end_addr, KASAN_GRANULE_SIZE);
+
+	if (poison_body_start < poison_body_end)
+		kasan_poison((void *)poison_body_start,
+			     poison_body_end - poison_body_start,
+			     KASAN_SLAB_REDZONE, false);
+	return 0;
+}
+EXPORT_SYMBOL(kasan_poison_range);
+
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
-- 
2.51.0.470.ga7dc726c21-goog

