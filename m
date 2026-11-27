Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752277;
	b=wsoRGi+Jkyatt25eGPok3G+c9Fja5lISzCyN8PZ6Xo4hQwBQc20wQiBEii/18HX5Umg/
	 2PPNq+kRSbh/PWoGjt9Mwi0J2YCPKfRqoXqQnYvoWPj7W1IqWtf8mK6lQpTRtd5FbLRbR
	 yY7B9wQz7E6yZV7P4Hx40u6rld5TfT1Pzyrr3Mn6MQq9FsBWmYwERh6WTkC27+5Q3ZSpd
	 06X3I1/VgGf9bTScIHUI8XUL9qmdTYo1kBQBonf8Xx4e1PKk6Tn2iaHFJ0eZ7zXVU4SIo
	 ifk6EbT3N3YAKLLPZGFAZdqLrkweke56i/a01IXgDGSjfn/4z4/NTf3ddFI8dBtT1Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752277;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1bcOHocv/o98CWUpRfKBjcBDZ8CYOLJcN1EzgcYFRaE=;
	b=IRl+MnPobbVUWh0B4cTxMKamp79ITkMYMbn/3s5V4TVvl3BfvRt1cJWx2LdYmhM/XeQH
	 BPUzoDPDXEcH1MjQuJJm688BAeAvgyCAGWt8tE8H4DLvN4V25zkV8zsISxUZD73+HC9IT
	 OhCmxcvKSrRtLVeSOS1sxBVK9jEWyvBS45P5ehaHYH31yIhTQuCQ531k7sP7OmYM2EMEO
	 expYjivlQgtY7LRrtg1e53zoI+HQqJpm7D5wFtPO4Nv183ITekqNOM3WP6nY9l5jcJmvS
	 iZ9ir5sWGaTM0OAbxRTQKYw+MAbZWAl0hhjbAbNCgwv4g70f31Mut1ac9x84RfBzYrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00i0nT1I;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64A606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD64A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00i0nT1I
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b487f44ee0so3129902a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752276; x=1796357076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1bcOHocv/o98CWUpRfKBjcBDZ8CYOLJcN1EzgcYFRaE=;
        b=00i0nT1IQrcLyk1YPSlvuV6uqu07807G13mqaMxHMzeZPikEQfOQ+KU50JQwrSVt1v
         H9AhYvaLT79afBM0mN13kL5Qx1Fk3vH6Xy5WSeyXy9xsDZ13oOjQg5SUwntX9qrLNUcF
         tDIMzsqOqilT/Ufz5ljrNLRWh2mj+PzEQX2dwzIlYjtaAv/Oz/67o0h6wKy9UBvSZlCN
         rsVMi0BJbZlqZw158HoVOeCCBwarbaj3BQzinyqpzK4PeOpTlUrl7QEC7EWY9rsEO+t2
         H3eYLd8FFBPKaqNEbIx776WUzPP101V6Vba906XgCn6rYyWXc3qeYBb6DJzEPDObwngG
         iGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752276; x=1796357076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1bcOHocv/o98CWUpRfKBjcBDZ8CYOLJcN1EzgcYFRaE=;
        b=OaX0ifE5ta9y5/SaeaH/wSSxav+BxBiAA1tLru/u7xGls6y/BqSGMWm78bco2QnCKq
         NjMFi5q12gKs7ZktERnVAbmQP5Ke1+bamjnqAzBYFqscTAnIRw/TvV+rVy+g0vZ3HcKP
         GqSJhk9elSksAXOSfbyGDGVd0e0Jl2YmZmoLO7vF2PAZ0iMaeFsrpatffROLrl0tOyLu
         NA1EtbPpR+SH9yEnl9QAo+ymNeiBLBRb7j9U/UH28gD+OsGV/YCQNDRsRAmIMfqU1fKb
         NBjnxpJx/E35gsfAgr8CkIDjDTJ78jwKeHFoAHBQwxWMMEOLs2QheGEsj5zT1ELmlO5c
         WLpw==
X-Gm-Message-State: APuU4Z9Y90b9lQsQ9OdWZ/f0x2ldqN2ZyEMgwv6foDc6f5tlWmGqPjb6
	wyJdZTgFDTu5MZvGtI4a+lBymjtO0vtwjnpSQ5AienN/UTkGnwBY8mEx1yjs1A==
X-Gm-Gg: AZFdTZdpoIIF5v7UAJXRcSkZxz6XiirVLGnmHbs5TgVRBso6HXjVztdZp3nVMArl7h6
	BxIxyqJ0iNjLx+/XgNMPxS9dcMgxhhuGGtE8lldObxQ6KPm9u9hAmjw5ivyKxdqW59HWqAk/3Xo
	nRApMIfknyfz+3Tfack0t2KiFiCZdCF9m2re57NYpY7nMW4A5IOMbmJZ0Ka9tttrF9kTsODrUNW
	yQa7GHJ6vgyZuye2pUWE1V4EoerU5FIwNAwuSz+Z+vcJOJVvNV4rr189o2KtZEtHVjdL3Pagywh
	3IoqS510RFXaQyeHhi2RJNXV8USGXZleFioUQnVJpDD8RvwzxDMcNT+ZdF6/lc7u50NeeIu+OYq
	1C0whTmgRqhOO9lmt1TdYq2Krx1qlpGcWjtLWNzp4A6Kgo6J5IGkDYDUZ1K2Oh64byYVzm4tNg0
	eshtbAjLQL/i2KNZIlvHDg8bSYnKJsfm7ghAU03vFPsj2arkrpyxCXbGBh1qqn00jrNHImt3vvH
	9rmhdNJWXbpJL/PHkOJaQjsBPQLFdiFrEJIiKh4JnmQ4ZBPGGadvgH4pbbJakvg5W5HZUQswBhF
	Djg0VXKty+IdPzL045Ly+7P4NPfFpaEzOYNN5vr+j6/cGVoqhUN3miaJKZSApObDwq8bJu3o/fP
	nl5cdoRYtOHA5KkM0h6+7lHQtas9qgPxVUBbCcSRW3FpT1zZEZ/tedqwGEzAqg8TesUCBqBaNIT
	GgnOAUmLWO1/nwjpUCwxzZE+Q=
X-Received: by 2002:a17:90b:1c08:b0:3b0:9deb:d990 with SMTP id 98e67ed59e1d1-3b41cafd549mr21751142a91.39.1795752276090;
        Thu, 26 Nov 2026 20:04:36 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:35 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 5/8] crypto: amcc - don't use memcpy() on the coherent SA and state record
Date: Thu, 26 Nov 2026 20:04:20 -0800
Message-ID: <20261127040423.1023233-6-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

crypto4xx_build_pd() copies the SA and the IV into the shadow SA and
state record pools with memcpy(). Those pools come from
dma_alloc_coherent(), which is cache-inhibited on the non-coherent 4xx
cores. The 32-bit powerpc memcpy() zeroes each whole destination cache
line with dcbz before filling it, and dcbz on cache-inhibited memory
raises an alignment exception. The kernel emulates it, so the copy
still works, but each such copy takes a trap, and the first one
warns:

  WARNING: CPU: 0 PID: 2434 at fix_alignment+0x184/0x1ac
  ...
  ---- interrupt: 600 at memcpy+0x88/0x10c
  LR [e4f9b88c] crypto4xx_build_pd+0x1c8/0x854 [crypto4xx]

Copy both with word stores instead. Every caller passes word-aligned
buffers whose lengths are multiples of 4.

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c |  5 +++--
 drivers/crypto/amcc/crypto4xx_core.h | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 0dc23d29845e..cb9b36d6f4fc 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -782,10 +782,11 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	pd_uinfo->async_req = req;
 
 	if (iv_len)
-		memcpy(pd_uinfo->sr_va->save_iv, iv, iv_len);
+		crypto4xx_memcpy_to_coherent(pd_uinfo->sr_va->save_iv, iv,
+					     iv_len);
 
 	sa = pd_uinfo->sa_va;
-	memcpy(sa, req_sa, sa_len * 4);
+	crypto4xx_memcpy_to_coherent(sa, req_sa, sa_len * 4);
 
 	sa->sa_command_1.bf.hash_crypto_offset = (assoclen >> 2);
 	offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(sa);
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 66a95733c86d..294a57b77733 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -209,6 +209,24 @@ static inline void crypto4xx_memcpy_swab32(u32 *dst, const void *buf,
 	}
 }
 
+/*
+ * The shadow SA and state record pools come from dma_alloc_coherent(),
+ * which is cache-inhibited on the non-coherent 4xx cores. memcpy() zeroes
+ * whole destination cache lines with dcbz, and dcbz on cache-inhibited
+ * memory takes an alignment exception, so copy word by word instead.
+ * WRITE_ONCE() keeps the compiler from turning the loop back into memcpy().
+ * Both pointers must be word aligned and len a multiple of 4.
+ */
+static inline void crypto4xx_memcpy_to_coherent(void *dst, const void *src,
+						size_t len)
+{
+	u32 *d = dst;
+	const u32 *s = src;
+
+	for (; len >= sizeof(u32); len -= sizeof(u32))
+		WRITE_ONCE(*d++, *s++);
+}
+
 static inline void crypto4xx_memcpy_from_le32(u32 *dst, const void *buf,
 					      size_t len)
 {
-- 
2.56.1

