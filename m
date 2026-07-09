Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF723BF660
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 19:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625407; cv=none; b=apzur5QQKCFreBmiGEf9sly3U6ONZc6eyVlfCiB0zv4VrR/2Q+jXOncVZdazR5CUykHHm/mBsP5b+49WXfE7etqPWzyiyYljdGw/EuMJ+3Uln4KGygjb+okaJYKxJ33Pjb0YWeq+Yh4u29upOfXyULqIQkhdT3C1xUIKumMLYeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625407; c=relaxed/simple;
	bh=mhZ5EgYm1uEO8wYkbnknTvEBKv+Yz2a/FMmsfjr4Qfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgB0vS8Xi/ruGTHjQSfI+kHdtx3FnlTUsDjVsgYSt/aRLIMPDLRrYG/12yq8HvVi+dVRLBGM5f6nwaPIDFggHMWbqWxF8FskZpKXHlTjO6+uz5SCDTzZo58O2rwpKH3ua04CXpzl2OnUL3UNp45dThRX3RJLbXzHFNQmXRBLBmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOI0F6m3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOI0F6m3"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-472326ca506so168241f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 12:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783625404; x=1784230204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cw7XVcaORy+d/dFYODK+UOJC8GePay1GtMpoNR5qLgs=;
        b=AOI0F6m3TwA7VNWoQHqF7dKMlNULN7mABTHBGQme4m0jCw9Iz8QATmSMKGlBh9aTga
         bpVzCprIuwgxdtrZCjgCmFdYvbiK6rxVwTSmNZAukaASUuuWgnpLw8iy3MdPsg1yH7qA
         Jim/+WCj+Jo2T0AFeDqNpsDZRPagATWxbxdOwHDw3q0D2+9hgkmuRJd1key36/aU+r/U
         jrO/eRGuOY5pB/3OBg6BMGb5Kn3EPX3mO81/z8RDAFcSH3Apki7mOUHYMl5fq0ZrMJgb
         DZGXW1sUh8VMS8ZDgY03X49vBYrE/iVVJ1CsviQnqlhjp2kpnDYjl5Y9ghxCY4iEjAA6
         3NlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783625404; x=1784230204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cw7XVcaORy+d/dFYODK+UOJC8GePay1GtMpoNR5qLgs=;
        b=MngHjk357vl0aYZQdpVhn8wHbYcfZyoJ0Sd/eadE5K+kcucQW7pvFixRYrGTYoRIn6
         Vfp2WWrot6svVgzpUMFDbV3EUQzw1AGRJCOe890hwDOSPnNZjLp8oNn4nEZ72iwvVI+I
         9uaojgVbQlMMgK/bnyqXC34oQTcBvjt15KVFb8zFAfpJsX+8W3akHMAEiJvlnveYC4YH
         wTDZ8nP8ANSpJtLcwojxCP2QbhPBJDqgMZ2JLEN/StzQCpD3qkJytEZx2p+h57YH++3Y
         qt5h6b7LNkCEiYSF/kQRzzHMpWbNM7fg40KSyN5cxRSWAu/0gvrk+KarMtqwRIZMt/Pm
         fZAw==
X-Forwarded-Encrypted: i=1; AHgh+RorxsFZfwwP+Voy7bMdIKNaAMNV6wgsGv4WaiLtRN1YoGuTUvduCpc161JEMrUmGEH5ZDJ/3pKuwAzaYrM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRTjKqDewsF65eAH469U2yyJQwApTy0INTu00RdxTzv8BrD2J7
	TEIP3lTEHTyZHhplTfC86zV9VJnFecC9J0mjszcMSSAYVSm/A8s2d3qZ
X-Gm-Gg: AfdE7cnY5nx86T2+S0hFSGbURNb24QxrCNpxR8Ys1yZcC+o64+2QBPdng5v1CMdBAvP
	O+HuJFBxrXxQ1Pa8XQtlk1Px9Un3K5BdhiAAWu5vUDWElPyR1mvsTqioSPerpv63kfleL3heqXj
	kBfmJ3CNvxET5NcYcrgRwjQvwnCBuNzdhAlUj86MYHN3OOyiu87gcVVG9XDZM/rEhmZPLICRw0b
	biTg4ovbJ3X4D8qqCj9z4yjvkQDlu70xYGReTI0EjQxFuHQ7hWMmr9gZUJ/D548/Ko5vRBge86N
	/MU8YK2cDYpVpX4M8gF2mkIPR95iTLhSg9IQ58NW313TxXdENiT0jd1Gk4VsKBjLZz38FaPsL8h
	dBFhCVzfDFdtJfuLibIkFZCE/jCH1cJM7L+X40N5WEbfU6a2UQOWI4dkA7cVe6ocmsX6fjKcxXn
	h/kxWPduPnmEznOyyhTWsm1A8pRJr0FjCkvmI=
X-Received: by 2002:a05:6000:2dca:b0:47d:e01c:c28 with SMTP id ffacd0b85a97d-47df076a672mr8933759f8f.36.1783625403791;
        Thu, 09 Jul 2026 12:30:03 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:d9f3:ab2b:ac6e:fc84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e6ccsm53873509f8f.5.2026.07.09.12.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:30:03 -0700 (PDT)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/5] crypto: talitos - stop using crypto_ahash::init
Date: Thu,  9 Jul 2026 21:28:24 +0200
Message-ID: <20260709192826.12699-4-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709192826.12699-1-ggoerisch@gmail.com>
References: <2026070912-pluck-bagful-2a71@gregkh>
 <20260709192826.12699-1-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 9826d1d6ed5f86cb3d61610b3b1fe31e96a40418 upstream.

The function pointer crypto_ahash::init is an internal implementation
detail of the ahash API that exists to help it support both ahash and
shash algorithms.  With an upcoming refactoring of how the ahash API
supports shash algorithms, this field will be removed.

Some drivers are invoking crypto_ahash::init to call into their own
code, which is unnecessary and inefficient.  The talitos driver is one
of those drivers.  Make it just call its own code directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/talitos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ca4fbd227bc..a941ec08817e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2119,13 +2119,14 @@ static int ahash_finup(struct ahash_request *areq)
 
 static int ahash_digest(struct ahash_request *areq)
 {
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
-
-	ahash->init(areq);
-	req_ctx->last = 1;
+	ahash_init(areq);
+	return ahash_finup(areq);
+}
 
-	return ahash_process_req(areq, areq->nbytes);
+static int ahash_digest_sha224_swinit(struct ahash_request *areq)
+{
+	ahash_init_sha224_swinit(areq);
+	return ahash_finup(areq);
 }
 
 static int ahash_export(struct ahash_request *areq, void *out)
@@ -3242,6 +3243,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		    (!strcmp(alg->cra_name, "sha224") ||
 		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
 			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
+			t_alg->algt.alg.hash.digest =
+				ahash_digest_sha224_swinit;
 			t_alg->algt.desc_hdr_template =
 					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
 					DESC_HDR_SEL0_MDEUA |
-- 
2.54.0

