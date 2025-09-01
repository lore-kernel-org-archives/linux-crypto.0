Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125D830648E;
	Mon,  1 Sep 2025 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756744992; cv=none; b=bqNT54IlEIp4uurfB9LV2bZuaKntcFNxXHX1Bit44kzbmMeAUwxlbpKm5VgkIlwwhVDbYnUlRXPrfV8AF/mmFYj8nqr8lJPXefdvXEZM63Af0UGriVfIdK7QeWygDnI5TlE4yGMHZ1hy6WVRErmyQQXPcgIHM8MORDGxI5AGTa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756744992; c=relaxed/simple;
	bh=ycip1TAxLiNDPAGKEgXLYzfxp76jFeTeK/teHCQFpWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xslu8yfH46Z1pu+Y8Ede2K08rmjTwplTK6OzLbP9lLETN6CaVuQooE89KmhclXwqraQNkUVNFQSLet7I9LT23UYICE7v98vLd3+tRXPy1y5vu7aRiIL/4xxJZdNeCxRcdjH6SIz4ZXSXcnRF7Wv3g2BOrfjP9LubYQZvr1n/KJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YdN6b9gO; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YdN6b9gO"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ce772ce0dbso2995298f8f.0;
        Mon, 01 Sep 2025 09:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744989; x=1757349789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtywjNgEiCtG5qk+Og9zZlkfm9Zwe/MrSwR0wbY7quk=;
        b=YdN6b9gORyUV6jplretqUyXCa0pFj0ygNh9nWOEUxCyuUgA7GCvuiuE4HimA0QhnVL
         FxUEac6kdyGFVuaUOXcY+9lSvrn5TODUNpRe5MrRmEn3IsX1fSd/Ib9bptd4giMyn5Dq
         I8C/TXfjTRP+XOp4IzZgP7NMpf1n7Skkz/EowO9lyzxftoYPtqgunr+wRCN6sZpw6mWk
         /Pc4klVr3v43UXSxSTCoD4pbtf6Ihdhn8KElSvFokHOYyIoYun1hq7dqyokf+UtZQjNX
         ulCs5ITU9NUTxsR4m8iU1M+yivWyR2THtGC/JzcZUnzVapqdw3C4VEDNcPpWHaRLa5CT
         d80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744989; x=1757349789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtywjNgEiCtG5qk+Og9zZlkfm9Zwe/MrSwR0wbY7quk=;
        b=m5oxSo3S9SZg+Duqea365F4TMbQtymWwU53AoEnFOiwlzbSTK4Q3cte7RgQwkf7ZmM
         OJXejG8GOjxmr1zSKBeQUCpZa43f/hbyhD4kxE7j5zJBKUJOCOBl/A/42eTFrG0jJTOk
         qSU+LX8dv6ymE35VYj+X678R95hLsiCLbyn8J/qgj/VEgfIYOKXEezUvKGWMKAyTd36N
         ss7a4qMc2RueoubxDFxyjBOK+3b0ERAeYOIE3oTLPi67SnTiq/9GRkEdt+/tB7k2gWGG
         7TAbHkuekgkuImbpQ5PykHvYPQ1SGSmjgqekWhcXBFy4R+zEpaTaWPLvM+2WEL3PrI4i
         E8HA==
X-Forwarded-Encrypted: i=1; AJvYcCWp2LV2V0Rjxg1T50GXRBQfBEjjzV92i9Lzp7qYmb0JC3n8VatdIYraaNk/WZD4/YIMD6L30D4bpuda3Q2U@vger.kernel.org, AJvYcCX9D1aaX8WVb+A8us3EaliVCkeCjA/l4yExofe5g5Zr+WlMKQMzzulCd982oux+Z7D7175/5GYYb3e8WwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAXa5cQ4zjDqvjAYyyBwSUHVn2Kj/Ny7PbZ6q8iLSPqg1VABaz
	UW+3TEwFbqMud9Wr7fKHiLWylHa9JCbLxMn36thaBxJZOIkhLIz2gHGA
X-Gm-Gg: ASbGncs5cZGw1iVoZO4MB/WoGHvxA4RP/SoIwS8tZ5qBn5Gr5ZHzwera350ePacq40y
	BtOxYYx6EFBSViWGF3mPnvkeK/tglodUtVUEVEdI5fBMHo5W9A37Kg4Xn6G3IiOiz6ZBha/tETN
	kWJvjpC/i1Lqcewp+f64wilKe+l4+2z8OWrM4NtyVUMRJzpl/GSuQvzd9ojd6XTa87ZlFIX9V7+
	clJB8NhimmxwqI479kw1x6RoR9SF3KRq3yy9fX0QPDafKX5mmm5h0xBjrPyW+G6xFSmuTfphWN/
	RuwQQoCjKnh3jbdQazowZvNB05lYoLfx4E2fiLcLGDG9CxvDC13I5A0Z9ZI+QwHoX7U0jGMRMZD
	t8+/bSYMYA5omrD4vb8+c8VQxrEFpyV8ZgFF+CjR/G2zjWzp059UmE4VOXgYi90z6UsEgsnEVIE
	sHVbNHiDICwe+dhnsQaqMXk8DWCgrS
X-Google-Smtp-Source: AGHT+IEnOODGXodj9uSDYZuNbZRTIWZR+Tmr4mQZlPwEBrGOm1FTa8AUzy4RHJ1nyi0T/epc72WPkQ==
X-Received: by 2002:a5d:5f50:0:b0:3ce:8632:9fed with SMTP id ffacd0b85a97d-3d1def6a9ecmr7320649f8f.45.1756744989103;
        Mon, 01 Sep 2025 09:43:09 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:08 -0700 (PDT)
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
Subject: [PATCH v2 RFC 1/7] mm/kasan: implement kasan_poison_range
Date: Mon,  1 Sep 2025 16:42:06 +0000
Message-ID: <20250901164212.460229-2-ethan.w.s.graham@gmail.com>
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

Introduce a new helper function, kasan_poison_range(), to encapsulate
the logic for poisoning an arbitrary memory range of a given size, and
expose it publically in <include/linux/kasan.h>.

This is a preparatory change for the upcoming KFuzzTest patches, which
requires the ability to poison the inter-region padding in its input
buffers.

No functional change to any other subsystem is intended by this commit.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 include/linux/kasan.h | 16 ++++++++++++++++
 mm/kasan/shadow.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..09baeb6c9f4d 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,21 @@ static inline bool kasan_has_integrated_init(void)
 }
 
 #ifdef CONFIG_KASAN
+
+/**
+ * kasan_poison_range - poison the memory range [start, start + size)
+ *
+ * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, defined
+ * in <mm/kasan/kasan.h>.
+ *
+ * - If @start is unaligned, the initial partial granule at the beginning
+ *	of the range is only poisoned if CONFIG_KASAN_GENERIC is enabled.
+ * - The poisoning of the range only extends up to the last full granule before
+ *	the end of the range. Any remaining bytes in a final partial granule are
+ *	ignored.
+ */
+void kasan_poison_range(const void *start, size_t size);
+
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -402,6 +417,7 @@ static __always_inline bool kasan_check_byte(const void *addr)
 
 #else /* CONFIG_KASAN */
 
+static inline void kasan_poison_range(const void *start, size_t size) {}
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..a1b6bfb35f07 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -147,6 +147,37 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 }
 EXPORT_SYMBOL_GPL(kasan_poison);
 
+void kasan_poison_range(const void *start, size_t size)
+{
+	void *end = (char *)start + size;
+	uintptr_t start_addr = (uintptr_t)start;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	end_addr = ALIGN_DOWN((uintptr_t)end, KASAN_GRANULE_SIZE);
+	if (start_addr >= end_addr)
+		return;
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
+}
+EXPORT_SYMBOL(kasan_poison_range);
+
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
-- 
2.51.0.318.gd7df087d1a-goog

