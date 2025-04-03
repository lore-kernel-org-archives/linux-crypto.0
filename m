Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0877C24061B
	for <linux-crypto@vger.kernel.org>; Thu,  3 Apr 2025 07:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743664815; cv=none; b=tj3P+ddES2/6sENGFStUM5jHsk1kLVLKKuSM1CEoXYaE2st3Orkxt0932TGzW7GaZUDGbwjFeRhkhWmq5iClHnExN3t/4VxffsxKD++DxWpPddP/cVANak40NauJl4ONIb+L+SwmaZHId2kkxOL5y+V4qKaurwrwh1fVN+yIwrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743664815; c=relaxed/simple;
	bh=gPgLHWdwggi9HajjGjzwjlJ3I72lmM3bOriec5GPE6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m2sBZboLs3MS3O6jxOkBXrNOKlghIk7YK2KUqWIwevEgIutiWpMusoHSS5qmJmVU/5+raaANDr1+HKVUGDVvy2nmSY84dYgHEVbLttuUFW59BtlKx66rIgQzOQxTmc3Ofl8GVNC5Jg1iOfJ67W6MF18Iru8dyrnJvBNY9Bsp3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylJ++cM5; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylJ++cM5"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3912fc9861cso241636f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 03 Apr 2025 00:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743664812; x=1744269612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RUzKvb5TvRx6Fh/lfVibG4+MdYfgWiVJxFmOU7Qv3Gc=;
        b=ylJ++cM5P5Kkyqw09k63im6V3EYSfQPRfd6wbe10sBBszaoldasfeWWTwbLzkQmEL5
         3Ehp+Z+guZzJ5a8rNojFFSzAHoE8YsMfO9KlUZRC58H/OnKo/y739boUXHwuYxYEB9FJ
         EtiJhMNskzZE98wK93Lr52P42B0uX/wWI21Jat07ZUaJk0g1t6Cdpw3XWUjmp2lCCWO3
         EYjCdJ9QMRkp6JxjKCwjB+R7cXV7V7am/yLY5vCEA6vaXOKFYg21RQhgeJ+aTvD2t/Hy
         7cxXenojZhiKn1Hwsch0ARKKN4tzICdnV5BSfG9MEW1n/xx2jUIEB7aPZZE9kVduKvRq
         PMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743664812; x=1744269612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUzKvb5TvRx6Fh/lfVibG4+MdYfgWiVJxFmOU7Qv3Gc=;
        b=gdOLVh2hDPsTutOnmOx2MfzOteOnGKKCfQl46hMrPuFy7MEg8/LheyjTz1fQ0TnzEa
         8Mk74PhvUYxVftWsez3sNj2QNUeXjYGrlVRdimGJwVmW5H//GimEduNCY6+DOQlsMcMG
         jp9vHUft7RHqSSy8xlVeB5ts2iY6QmxMJ9ez5aHPskyfs7EImeX8HtXegzJD9VsPvIZr
         Xg1oE3RHDJGpquPLXgjWwCRaF82kH73img4o58yTY0RLVVLlHHnrXLtsJ1PUx7mRZsVl
         WoVXg3pHZZ3c7VFX2K8B13pOpqgidujeS/rtElo+aAwLpvjfbw18/+3LA/X23RKx1s+H
         lPLA==
X-Gm-Message-State: AOJu0YxgyqgSrrtQQRtFSnmfTaZNEvvQeP5XTUQvJNLfbuV3A4rpI7Sz
	99cOcku1pOVycT+EL8bNp326R5Eso5bi9SCCH+pz+dihksq+zT9Ncrl4JoQF55OiHKHlu0UOYEQ
	hki1Z6X916XekQs/BoiXxBYa2THi0CR2j4k03GzVzMvpPkIQe/Li2IZAMgzRNpj/GA55XHrwkE2
	hiujvTTUFvz272TaWuQT94EXDqAxaKgA==
X-Google-Smtp-Source: AGHT+IHCRTzzAmaHj71ujYKp+6dY6zspnecNvz85zvBYMg2Wpc0MY3Se5dOynzqdS7ZkhAERQdC4iVFF
X-Received: from wrtx7.prod.google.com ([2002:a5d:60c7:0:b0:39a:bcee:e7a1])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f8c:0:b0:390:eebc:6f32
 with SMTP id ffacd0b85a97d-39c1211c6cemr17627581f8f.48.1743664812405; Thu, 03
 Apr 2025 00:20:12 -0700 (PDT)
Date: Thu,  3 Apr 2025 09:19:57 +0200
In-Reply-To: <20250403071953.2296514-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250403071953.2296514-5-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1940; i=ardb@kernel.org;
 h=from:subject; bh=sXgJMqJU5B13l3xARHILiOCuMf8ZrNcROv+DWkjDfzw=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIf2d2QLJt3K/10yX3hczIffyuq1TXUovy1Vf6Pow9W2VZ
 4XZzVy9jlIWBjEOBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRe08YGU4vWvxzS1krC6/N
 yWkizSxe783bVmxyeFi5XyHywwnTuHBGhlfrOuYaX5Nwv526oul+Rdwrry07OQ1XL3th//3bt0b W1+wA
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250403071953.2296514-8-ardb+git@google.com>
Subject: [PATCH v2 3/3] crypto: ctr - remove unused crypto_ctr_encrypt_walk()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au, 
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

crypto_ctr_encrypt_walk() is no longer used so remove it.

Note that some existing drivers currently rely on the transitive
includes of some other crypto headers so retain those for the time
being.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/crypto/ctr.h | 47 --------------------
 1 file changed, 47 deletions(-)

diff --git a/include/crypto/ctr.h b/include/crypto/ctr.h
index da1ee73e9ce9..c41685874f00 100644
--- a/include/crypto/ctr.h
+++ b/include/crypto/ctr.h
@@ -10,56 +10,9 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
-#include <linux/string.h>
-#include <linux/types.h>
 
 #define CTR_RFC3686_NONCE_SIZE 4
 #define CTR_RFC3686_IV_SIZE 8
 #define CTR_RFC3686_BLOCK_SIZE 16
 
-static inline int crypto_ctr_encrypt_walk(struct skcipher_request *req,
-					  void (*fn)(struct crypto_skcipher *,
-						     const u8 *, u8 *))
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	int blocksize = crypto_skcipher_chunksize(tfm);
-	u8 buf[MAX_CIPHER_BLOCKSIZE];
-	struct skcipher_walk walk;
-	int err;
-
-	/* avoid integer division due to variable blocksize parameter */
-	if (WARN_ON_ONCE(!is_power_of_2(blocksize)))
-		return -EINVAL;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes > 0) {
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
-		int nbytes = walk.nbytes;
-		int tail = 0;
-
-		if (nbytes < walk.total) {
-			tail = walk.nbytes & (blocksize - 1);
-			nbytes -= tail;
-		}
-
-		do {
-			int bsize = min(nbytes, blocksize);
-
-			fn(tfm, walk.iv, buf);
-
-			crypto_xor_cpy(dst, src, buf, bsize);
-			crypto_inc(walk.iv, blocksize);
-
-			dst += bsize;
-			src += bsize;
-			nbytes -= bsize;
-		} while (nbytes > 0);
-
-		err = skcipher_walk_done(&walk, tail);
-	}
-	return err;
-}
-
 #endif  /* _CRYPTO_CTR_H */
-- 
2.49.0.472.ge94155a9ec-goog

