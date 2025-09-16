Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B7C274FDE
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013284; cv=none; b=ZcRRfsyskcgtjA8eR+7gZ1qacIPoEE0Tc1glxgaST0jZBa2tXlQFNiQST431NqpD6a2M/onJeSlNLwx98D612FJVksdrSwpMy5UTWUQWDFajiq/ZEXlR7bfHnE6qmhpszXfMfeA0xHV4ePCEEN24vRd6A411VHlrAybbZlWfwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013284; c=relaxed/simple;
	bh=qJDnwsi8rYP5Wp+H8LxkPOvT+aBCJa1jnIBCRmNCEj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZkWK2v8QKSDkT9xJ3a1JGSNKsLMXTC41Jpx3gpowo1rT1xsVSoGXwo/GJA6Bj+kEZSR6A04LQ/0tvW6gypvixE5G36MlvxW+1hlNQrfL6BF2jC0DUYLqhTmNHxPBOfSYFFAFDhxpQoxd2N0reC4kUsVAopqwqtpFf2oCUDKerE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbjscKHF; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbjscKHF"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3e8ef75b146so1895493f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013280; x=1758618080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yrCmffzlGuEExOPu+2JuPwFc40pU2sHK0rUuIT3g74=;
        b=AbjscKHFL8ivpiE4yWO+py7ajRN2ClTsfiDFIRjyAWoo9kIt4V+jaLQmEtXoTMVOoU
         rrt8EjbnVxENPm5Fi2UHy3/PUzGC3BUeNun/bglZzVRhHIOPWHgmgBIaHl06VqL4S4Rm
         aPtBklFN924h2JgG7ULc8v5G4BNM+BPurRoQ2azY6NBh+CFMD0rbNoa+FPXInbSZPRZe
         T+DxzhyzxzX9y4nlWTB4nH/tfnphWTV+1VhiJs5kI3szySOS+f3870jwMy/DKI4YCWb3
         9QL2EzjFAb2cQc8SIMZ6rKixzpInrUj/aNN+Hh5csqoziUUtZeLgijcFRrKXSeS8KGmc
         dtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013280; x=1758618080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yrCmffzlGuEExOPu+2JuPwFc40pU2sHK0rUuIT3g74=;
        b=p9pRXO5tZA9rMtmZUQOwrg+k4kEy53IIidrucb23iWGQRV9ToY16VWg+9i2huyfkHu
         tq29Ls1O6Q183jLW9mI9sX2ANh+dOMDCTjyWFIq/mq1NHBO+xrjDiwIl7cykN2T7be1H
         BzprBDdy+fru4pUxLthmmyI7P/7kM301xylkIF8l9tT2TY1ekU+x8divunjiRNnhoX6O
         DfIFNNbeDaFb7e+ouscFaWqKWqOLrL6koaatzVXG4P+5Izk0Q0r5CyaaPiiMt95v8x0g
         JC9wDIx5O9rTw38ZOhrVZoY3be3ryP1baJJ/F2x5fcBnHDRlD6LeCDmXopJUhZBOjiwL
         EsiA==
X-Forwarded-Encrypted: i=1; AJvYcCUVav8MEcFsvrSoZwUDuUvtoHkT2Gz94BLko9lE3wpUfR74OLdKLILCYq+1izvTdN6Pzjl5ih6qEntyqQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmIDyIEk8HUo7vHLFxma8n1rXlt9L5H1unt+E7TOJvG+iySuw5
	A6ZVTtjxTqFqB/cBeJUucfM6UQ9gW0czqwD9OmF44hwCrsf+Pt98b4Pz
X-Gm-Gg: ASbGnctlXcRUA6EAfUv8WuSyKmJPNoRVQ9mg+wnhfBa3GRjHoKgUktv1zMpDo51vt5R
	knlBxr+Z4avxjBjNAsl3istiDht3nNuVv67y9xFxxF4HZxp3vnLDGL5LCF1UHIbmZsueKeKaDtG
	B61l3ejnjoW6OKsRqnqMAGu3L9gcG0NMaw5hjdqh0zlCCCI9K40DvlTjn7tvxP2cowg97fIbK/7
	QKbCJCANAMrW6v5ir9voCx3B2vh6FFouambfSEam+pCZZpV6mRT1G4zrfC0NfVEoTE090s23srp
	ap2dzmYjZl7xK2lqQ7qZJsJq7jH1eZvwlpgJscybikJlZiAmOP3D+Tb08CQCt/IfSdBqCin5ELi
	lHBpWSkPi05yx6V+k0OFAtptCKUS9q+w1c9P2i7Ti7/Eew3OymJKCpHVjMkavv7kGF6O4QFkUUu
	cRshp4KWbqZ2xryzRYjJwtF4I=
X-Google-Smtp-Source: AGHT+IG5iZ2HWUjjmWFwCC/GHnLa6bpp4pAlSd7iyIhSqBHOTc39tKRs7gflZ9w5k6y0UE7LS5O+zA==
X-Received: by 2002:a05:6000:250e:b0:3ec:d789:b35e with SMTP id ffacd0b85a97d-3ecd789b5b1mr817634f8f.8.1758013279529;
        Tue, 16 Sep 2025 02:01:19 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:18 -0700 (PDT)
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
	tarasmadan@google.com
Subject: [PATCH v1 01/10] mm/kasan: implement kasan_poison_range
Date: Tue, 16 Sep 2025 09:01:00 +0000
Message-ID: <20250916090109.91132-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
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

---
v3:
- Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
  kasan_poison_range(), and return -EINVAL when this isn't respected.
---

Signed-off-by: Ethan Graham <ethangraham@google.com>
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
2.51.0.384.g4c02a37b29-goog

