Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A9931986C
	for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786813761; cv=none; b=kL+TsoIH9/Z28qeUr0e01JqtOcS/YqBCIQP1MvU/rx757UUURG+nwZN9WrRhZXESt+23XheTiHsLm/xh2C9X4G50wkyzdZ77QEGE4tyOpqBVCUv4O8SEiUIiN5IHm8aT3wGhsr3Kwr78PrEg/9GsaT4eSmB65jlBOm1Enh1FszE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786813761; c=relaxed/simple;
	bh=EMOpJ1B+eGp9GhFVzPZ9FXXobnrl//5Du0SDBSY14Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hcsUUAN2zKG0Ms4w2oi0qQLWF98K5Oafu5bVQDv2ffDVj/ghyjyGEz5ONSEhnqq8LRyIK66Sd2MZwMZAPlkhJhAt+tx5k2Mk3u0Mlp8EkuAdxfhG5CmRD+ZhlLsISiGjG8zg4x3ItQMglNGvWixRScOyWJb0R1F2PXRfGR2I1lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=f+t6STbq; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="f+t6STbq"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a38098734bso3079178a12.1
        for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 10:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786813758; x=1787418558; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uJ8iLpdEmJENtbZVZxGqhSaVmBWwKh+XpuL1dopqPE=;
        b=f+t6STbqHKcS5bO0G0r6QnqdA35pGgu6fs69WYPVPC/UAxRw6FOHMq5oAeoHTuJf2i
         RVtQVRupe6P9nHDooELRYVXftgOHAXVHOSSIQE/wGw3cTaJU5nGryaXjhoBIWjbfd7oJ
         QEhOt9eeFSnRaUlWW6GbWkkR+f9xVmOqCRYC53hSysnSvst7qR7h+fP1ooTDYAVfLnGt
         +lU45ICETcMzXTYnxhwSNEgtlD2ANfYwmhmKFpUQJUfakCaVJvjnKAOZ1YNWAbuQrLKY
         zKgWJxJeFq06l/8QRo+hcA2q1mm8JXmFAByJZfBxdhQgvsBjI3wvc6oEUaof/nu12dc6
         rmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786813758; x=1787418558;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1uJ8iLpdEmJENtbZVZxGqhSaVmBWwKh+XpuL1dopqPE=;
        b=Uhv8WWsSwyALoczlHkvkyNGZS0K/MBIVm7T50f5ukxWo90iw159gmLDNlbwM4Eod8h
         1K073XOuc82prGi5RLf72Rz6VvAg3teWOL+jdyjqd/WCpRaNpzj9MEAzZjjf1bCiaIBZ
         desfNY4gIVP39598JIsfVt6q3QWjq97w0ZFmEmZwkn06EHZxNBlNytyktwjT1LdHsmBP
         9v5HocQ+fKKTZRB9IlDLOCdAf0EdKdaJ1V0s3x+XcyVRGx9o9PPr4Jj3wUSM5fLuOqbX
         LrMYTjUuCxnmanA0X5jAzi7NxTUAMt32+1G47VxpJRP//0wG1lpeUShR+wybM9lVyVyq
         +AnQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnQ0euDVb/W7zEgGrM9keLs+aeUfYuVjyIyvAKxyW+ZHTlG9yZcZ6lrHSOZ+qCiHYqHPEe1XNk1PrQAto=@vger.kernel.org
X-Gm-Message-State: AOJu0YxErdLjEO+4SM8AeE7CFOBIstqwBTdv5tOTf/ugkjSgbXXRPkcN
	FLYOyeTleKl9xdBNHuj73OMLmNxYJu44smogI8hb4RSUCCv9U/wkcIYr
X-Gm-Gg: AR+sD10mytt38GXxf4TZd5zO/zFEoQAFlhVwo11k04daCT5No1Aa+p+glBU4vFcsQOl
	2sxhdmsi+ugklIkMs14EXFOR/6nF/Xv7161XX4KD20+rn1TFCNdbes6L2M5RVXVe0nPDaXTy8+Z
	AtVmu+OwU8Uu7X6t2yt9Ep0M0Lk7wDPvlrPkjmZbZEkz8C1O4GwI/w3+wu0DAwlhF80XpW1mCgo
	Z06lcmj4pGjorTlmfZvooWKnzbhBbpdbOmvBnSDijsJ1mUfJWgqoYrdirO42gb3pPXU1YtiQfk3
	e15ecawZao/VDls5INhYHIntBIaj7ShzgkkYPa/LsttKf9AezflOYpcxvbDsTPly6VrCiZapGxL
	uiv1+/eBBdGTlP4N9SZLLotzPna9b6IRNalS7/XpA6y48Ve9Zov0FLsGpsCQXlioAZMeJfP9q12
	gFkRCx2Jocma2b3GGyRK0TvFyEuG2N6XYej0f6vDPqU9zO5T6l7j+ZAcd4pFeMbCONt5I963yNz
	Cro6y80xef29ksy1eE=
X-Received: by 2002:a17:907:a687:b0:c1f:983f:d8a with SMTP id a640c23a62f3a-c212aa5fbedmr689896466b.24.1786813758191;
        Sat, 15 Aug 2026 10:09:18 -0700 (PDT)
Received: from david.gall (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c21234c4893sm243662466b.20.2026.08.15.10.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 10:09:17 -0700 (PDT)
Date: Sat, 15 Aug 2026 19:09:14 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH] crypto: octeontx - use crypto_memneq() to check HMAC
Message-ID: <aoCdOiyhQZZsFm5S@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

validate_hmac_cipher_null() compares the computed and received HMAC
with memcmp(), which short-circuits on the first differing byte and
leaks tag-match length via timing. Use crypto_memneq() instead.

Because for cipher_null the validated payload is un-encrypted, this
valid prefix leak allows for authenticated message forgery.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 096be42e9d03..70befbdd442b 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -16,6 +16,7 @@
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 #include <crypto/xts.h>
+#include <crypto/utils.h>
 #include <crypto/scatterwalk.h>
 #include <linux/sort.h>
 #include <linux/module.h>
@@ -105,9 +106,9 @@ static inline int validate_hmac_cipher_null(struct otx_cpt_req_info *cpt_req)
 	req = container_of(cpt_req->areq, struct aead_request, base);
 	tfm = crypto_aead_reqtfm(req);
 	rctx = aead_request_ctx_dma(req);
-	if (memcmp(rctx->fctx.hmac.s.hmac_calc,
-		   rctx->fctx.hmac.s.hmac_recv,
-		   crypto_aead_authsize(tfm)) != 0)
+	if (crypto_memneq(rctx->fctx.hmac.s.hmac_calc,
+			  rctx->fctx.hmac.s.hmac_recv,
+			  crypto_aead_authsize(tfm)))
 		return -EBADMSG;
 
 	return 0;
-- 
2.43.0

