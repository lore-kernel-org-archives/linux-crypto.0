Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9949E2857C1
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774862367; cv=none; b=sAZC0WWHQUSRXylABZ5lZdwwrTUHzX2OmsMw0cS572/YY34272/puhHskorO9ie6ii/j0Xkeo4txR449VgdQe4UgHVyrMrme2GKQ3A0U4GuGE43ZyLJUMt726nlwyE0UEZmmqYw44cJskbwnXHMUbLhG0mVg5wlKnZv6YRyIXqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774862367; c=relaxed/simple;
	bh=v2wJm5OxMhFirUpbsSseKePV0XDwNFTZ0HeYn749ALw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q4ySDVqr23NJx9cgJTqoNRCf/y040Lfr4x4HOIBq7kMX3Fgv32Kpyd7fBTSjvHo4yx49Vcv2szrmIS7HO6eLn+5J4g8Ajn6Xof6Ql+f4z2kXELi/0h15uR2FOK+mM0M45YgzRmgccd8QX7BexryoTO/zQZDuz3QRdSyWGc0CKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dSbHaYzF; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSbHaYzF"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48371104ffdso6551865e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 02:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774862364; x=1775467164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5jy4tutbo6n4MCIxyRYqtKSRHX+kUl57MnIxgCmBAFA=;
        b=dSbHaYzF+LR3DQUxQV7NjAh+UO7BEBjxiNKYgum10Q06KjKvnBebNap1yVBTWbGCq5
         c1CGp/6sGmVmtJgP3FiQlmGp1CtBGzaNUMq/a2fJn8ZeA3TDkbejeZJTQDc1TBpVe+3o
         zLFZ6t4XvHKfJF+63Pb+dyZu7xtM9NGHVsNEg2Al9gVWQvUXhSC9Eo5+AiqEbKTsRJgN
         dgKoGXyLD2qIk8X7d8hKUbTpn1fSXI5MWjmuFWwmxJpKc6XT8/Dvi2cf9KWvnowbVOfI
         QRe02ix2rQD6iWn7J/QSCYhdpvhN1bxNz0eV1a5Pdkh/dIYigeKDaz1S/Z7xhXYfaNDd
         VmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774862364; x=1775467164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jy4tutbo6n4MCIxyRYqtKSRHX+kUl57MnIxgCmBAFA=;
        b=KIT8/GSdP2QZmaByKeOrff0BRM74QQDDtLxjnrOfB9Hzymq0+j8ZZv0iNrzKpAvOyG
         Dwxkbz9ojNM4xJraRNj3udH/RzgJr4j5OHIgNk4YBICGzWnhiocY1vcfY4JVDCjMdhNT
         2dFK60tFsKRzJ/fO+vc6k0biHL6+unO1qAbtw+xvhvEKgkHafw7mJ6C1SDUoiBzbOnck
         3fd81KhSWWGw5Gj/fMi2dPGHwPXy7+qZLUUPxL2CE77cSt0DL6TrdIVXVRiUTOy6Te08
         IoCd+VwfuwKN01/5kjjchCQcBfmxNjMcQ48wBA2nQJayomMRnUWegZBBpZJ6WVJEucHe
         RI/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXn54BI+8i7vsNkisyPAx2s6bu4OUa6PMZO5sbYkmLfa8ZAmfEjnLL2vpPWi1LH2DesjM+m6bKMiR//D6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsNFuF6GJGqVevAONBlwF8X9xJa4DoLAdw1b2dyVucLcMNxr7I
	P661tUXh5jKVxcFn7vr7/rbrez/GA1juzAPFhvmn03muMX/nbd234/Zn
X-Gm-Gg: ATEYQzyiVV1p/e+eoTlerQWwtkuUuVHPNs6Y9ScgQFnpqCTxsfLbu7pzCo0QUDy9em/
	WZrrSREvh3yTMxLfdCug8uLRH29B+EeCaAKb4UoBGLzwJplE8Br4t+pg88mOkXL2hC7TA5qCxVh
	D4p4OGLg90sxPd8EePGyLws2vqCwHoMiS1uqi5L9LerU8/rroxGDMvQ7N/SnBl6ot3dscdm/1JC
	7gbI3shBqucD6vnVU9T26zda5IaYvxLkNrzWM3202OZip1HU7vmsGu0dfOmmo1HrGT6BpYSUxr6
	Y5CiJnq8ETVNNbRnRLh+c0hGoqrznuT4j/WQzZ6ja8NdAiZBcdXJJozggu7YrBbkp+cjHWw/p6r
	FQNr4TyC0Xx8PCa8TASw8P2Wiqb6Z6vOu5DuISaphh0VGxJhVFYUsf9pVk19wPzBwNtUWL3xl2j
	9JDN/R4ie/k26Sy3W/BnTKKmzkc/t0pEAlxWNXeT6noQu/c5YrC9N+nhzwcmSnfW1NB5lUM1Zni
	1Tr3GZvGyu+HsZZHkWI
X-Received: by 2002:a05:600c:5249:b0:485:f1d6:2b1d with SMTP id 5b1f17b1804b1-48727c8680fmr118714665e9.0.1774862363788;
        Mon, 30 Mar 2026 02:19:23 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-82-131.paris.inria.fr. [128.93.82.131])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-487270af027sm123355925e9.3.2026.03.30.02.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 02:19:23 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: eip93 - Fix dma_unmap_single() direction in eip93_hash_handle_result()
Date: Mon, 30 Mar 2026 11:18:14 +0200
Message-ID: <20260330091817.25797-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The buffer rctx->sa_record_base was mapped in eip93_hash_update();
rctx->sa_state_ctr_base and rctx->sa_state_base in eip93_send_req()
with direction DMA_TO_DEVICE but unmap with DMA_FROM_DEVICE in
eip93_hash_handle_result() and eip93_handle_result().

Change the unmap to match the mapping.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-common.c | 4 ++--
 drivers/crypto/inside-secure/eip93/eip93-hash.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index f4ad6beff15e..75659a45ea5a 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -687,12 +687,12 @@ void eip93_handle_result(struct eip93_device *eip93, struct eip93_cipher_reqctx
 	if (rctx->sa_state_ctr)
 		dma_unmap_single(eip93->dev, rctx->sa_state_ctr_base,
 				 sizeof(*rctx->sa_state_ctr),
-				 DMA_FROM_DEVICE);
+				 DMA_TO_DEVICE);
 
 	if (rctx->sa_state)
 		dma_unmap_single(eip93->dev, rctx->sa_state_base,
 				 sizeof(*rctx->sa_state),
-				 DMA_FROM_DEVICE);
+				 DMA_TO_DEVICE);
 
 	if (!IS_ECB(rctx->flags))
 		memcpy(reqiv, rctx->sa_state->state_iv, rctx->ivsize);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 2705855475b2..19a41a0db667 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -67,7 +67,7 @@ void eip93_hash_handle_result(struct crypto_async_request *async, int err)
 	int i;
 
 	dma_unmap_single(eip93->dev, rctx->sa_state_base,
-			 sizeof(*sa_state), DMA_FROM_DEVICE);
+			 sizeof(*sa_state), DMA_TO_DEVICE);
 
 	/*
 	 * With partial_hash assume SHA256_DIGEST_SIZE buffer is passed.
-- 
2.43.0

