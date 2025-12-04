Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5541340A7A
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857588; cv=none; b=gu96WTLQspkdAX6o9+DK+5UshYymwlssvqrwNTnpemXpTj2bHCQTx8hgWuxKItvxOj0aZqmZp/uA5dZAx3gdVj9PYKcw/8/Zo4JuW3zr1nhU1XcPqLCS7hSeeBRk05Wi4A/3kU4yexUiEVuORxDcRtLzoQEh+AklIhzLQ0QRcog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857588; c=relaxed/simple;
	bh=sPmkDEwwPWrQdJRXFfdzLMoaCivv4pvJuP/ZwzlRc98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRgqpqY85+O3rOF+lieZtO+sF2AVmYiWN/SHqozHfqp9saTunkRor+kAokktJeQSJfEWqHDpd3LlrlNBM2OAGTldAjkrreiRWQSeuigrbIBi5qTX9z2t/Oj9H/WT4Hf5W17KdiasHf80PV98UTz686IjyYTLyQnzt54+A0t+qFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JuDUMbTz; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JuDUMbTz"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so9046675e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857584; x=1765462384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvLRPmFVeFXL/FXUoH0yHVRGEwWvQKNGaG9SkVtG73M=;
        b=JuDUMbTzRHg7EtYfYyfkGNC26E1gxHm3E+RnhS1qsH67E4NPZKcNIx4NJXsUJNnzO5
         Z2AjIbuR5Gdf7Mh7d/gRhHwtglZCd3KgJ5dK9cjnWX5nuA0FaxkwDeF0Y+9KGSIPmQ03
         Opt5PyrRpDji3+3ynvgaRG04Po2LHlmCJSb1YJ57ua4lSwBUUX1Lv6Ovxk+VRNMTJyjP
         ze5X0L6KMgFOcj44j8QgAtik7whmf/8IpK2lH5Y9Rz/R2+YXAsmy8klt7roE2EOW9axH
         cY87Brt8LYuOHYukS3yy/QdBZsOnzHc7U9at16L86H+TVCZd78tbzcsEQGIi5KAM+Mw2
         YnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857584; x=1765462384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vvLRPmFVeFXL/FXUoH0yHVRGEwWvQKNGaG9SkVtG73M=;
        b=OrQBiTpcqETwcvihSetepjcB5bVS/9gSvfHxSERiHuIG/1+9ifreHM3oGWHRBlHw7h
         9CHIjCoFCR5ViDkT55dUPd0/EpY6z0ZywWE9AZ3oChQJDSvVRXtd3krV5nj3W3GQ73vn
         4GpQ8tcHdfEHi/dwhP+plXe92w43aUg/2QK96b8kWVfzIP71HYMM0F7m6IBMoLqmAw8V
         ziitrViezad7pt2MNLUvAgeo0/8WQGTsAYcYGqfs001R4x7Sns5sG8Z1ATidj1M8ttDE
         sdCf+yamEqHOGnJHe/LQYkWyX1F+vdJUOXoGWEVjQB20vNi0LhOo/LxWnkUQk5inlPqm
         j6rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhY720EWhuGIBEiHRlKL9Sr4FXdw0C8ujt0WltiCbgfaq2q9Se41apJlxk6Z/i9J1DIpECjwVb2oytb4s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybg5CqD6a+4xdA8oVqng7s2DA2wVkkUUIT51CziWZYI0LxkhBT
	qin2LUjyDxErsFpT++1MOYz83RlapYvscUENZ+2dREoYBGtyZ/M29Sqn
X-Gm-Gg: ASbGncuNvTexjtGExtd50CqZMBdWrjSnWu/u5hnVOx+9hNDKAdAome40Gtgc+LZ51XJ
	/EbqByf3tQ2bK5i3R2OxG+0VLPuA8VFCy5uc8mnwGDIDDKJ+VazONGGNBLQmqt1uls/ssxsbR7o
	HmvfLQFoBsWMMf6+M71QHR2Y4B3CftokAphILRZtDMvlrryXKK9+pgXHs1YKBKQDslucy9qGUZ5
	nAJXBbTeHTq50+/ly2oxjDqrFLjMaMh/oylQtqognaNJ56yBe6EvonFslKGwNJpJaLKPIYCeFkk
	R3A62CnjKLg5A85zoDAGkFP3TVjVFSFNTvfx2aFqhF/2RarWfSUxRyLp80EjOgjfOQ/BoWy54tt
	3RpbXu0pkIwsHdQjCckseDJre6+Tj7mRAgsavHbqnOSel+t3BdBcQyzdvYZRLfTSP91zOtWP5qG
	8HcRMERhjGuyG+6hBW74z5GKAXWktwMJpKCu1lK72FDVudIRMjb3O7RUcmYVWp4OY+RA==
X-Google-Smtp-Source: AGHT+IHVRlhcJRejGEsgP4K4cLss0ObE1mVBCmN6UHr1S399d5qS3NN/eNqDmcGxbLusiL5cPl9foQ==
X-Received: by 2002:a05:600c:3545:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-4792f3860e4mr28572475e9.17.1764857583596;
        Thu, 04 Dec 2025 06:13:03 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:03 -0800 (PST)
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
Subject: [PATCH 01/10] mm/kasan: implement kasan_poison_range
Date: Thu,  4 Dec 2025 15:12:40 +0100
Message-ID: <20251204141250.21114-2-ethan.w.s.graham@gmail.com>
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

Introduce a new helper function, kasan_poison_range(), to encapsulate
the logic for poisoning an arbitrary memory range of a given size, and
expose it publically in <include/linux/kasan.h>.

This is a preparatory change for the upcoming KFuzzTest patches, which
requires the ability to poison the inter-region padding in its input
buffers.

No functional change to any other subsystem is intended by this commit.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Move kasan_poison_range into mm/kasan/common.c so that it is built
  with HW_TAGS mode enabled.
- Add a runtime check for kasan_enabled() in kasan_poison_range.
- Add two WARN_ON()s in kasan_poison_range when the input is invalid.
PR v1:
- Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
  kasan_poison_range(), and return -EINVAL when this isn't respected.
---
---
 include/linux/kasan.h | 11 +++++++++++
 mm/kasan/common.c     | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

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
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 9142964ab9c9..c83579ef37c6 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -570,3 +570,40 @@ bool __kasan_check_byte(const void *address, unsigned long ip)
 	}
 	return true;
 }
+
+int kasan_poison_range(const void *addr, size_t size)
+{
+	uintptr_t start_addr = (uintptr_t)addr;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	if (!kasan_enabled())
+		return 0;
+
+	end_addr = start_addr + size;
+	if (WARN_ON(end_addr % KASAN_GRANULE_SIZE))
+		return -EINVAL;
+
+	if (WARN_ON(start_addr >= end_addr))
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
+	poison_body_end = end_addr;
+
+	if (poison_body_start < poison_body_end)
+		kasan_poison((void *)poison_body_start,
+			     poison_body_end - poison_body_start,
+			     KASAN_SLAB_REDZONE, false);
+	return 0;
+}
+EXPORT_SYMBOL(kasan_poison_range);
-- 
2.51.0

