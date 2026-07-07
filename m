Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588A43C7B1
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 17:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444567; cv=none; b=HfxAYpuNnr06MrD6H1wZQCq8bn6gxtY1lZfUrKKhzs1nFlxpo62DDaGRAfxeYt+ble+AyPO8aqscy3NxsPFvCiyo8pslQ8TqDPMB4VWQk0W68pzXj/PcTWNswTlYc2siiqmRrqiqFiOCccNORwJoTG4Fjvlo1jRz8wbsmj6J1iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444567; c=relaxed/simple;
	bh=h2bNyzFdRhty2nZBrRF7qZ99bpFdoiEGoomTOEdSM/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yafpb0Jx/WjsW0FfHyqrXmee4PlGIFYTMLHe0S9s4AV6yUoA7SdzUgPhJMUw8bIKe/j/0JCW7nPE4R/DD/nNpe/Guk7kuMWtNY7BR9luwu7irQvks3LCH3QDwi+EjRPMIFwNbhV2ddToKpNHjGSzqCsE5rcC9hZ9qhIK15PTkX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOtGZPSp; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOtGZPSp"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-845ea8924fdso5058155b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 10:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444565; x=1784049365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpsRsu/Sc6+h9vss+51m0IGJ1DAMRL92j7czA/gNDuY=;
        b=aOtGZPSp7ZL4jC+wEpLyfCdqAVmCJnZiOahUMswXL7b0sCVZm64rOLYSAw3qZCwPZe
         adCzIp11zReUN4Y+NB8WDWbSV/ekVoANCD4rLggVWrnOinKxKjB814MpS9JlPHMTzG95
         PBKjMmRsC5IKxGfF6H2GcwtuiyCxilOjr2+8ve2MxtdmPuBH3I8VafZUTJlggeoXiBQp
         rhx01adhQAZm5+UFGzL9xTxGj/aNuZQDa1NX4dXjuJVCymljKzfQsqusmN+UeoQerKZa
         QilSMXHpSt91tonTziFaMI8eo595BieB8fBQhjlvwxf7WqnDk028INRCTc32AjUh7dVj
         6HmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444565; x=1784049365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KpsRsu/Sc6+h9vss+51m0IGJ1DAMRL92j7czA/gNDuY=;
        b=Y1wjUVppOoV8HHg2ZFSbatzWRgzamO+pwYxsBfg5HwlFggkw6V0ywg/b8L/uVxHSLr
         aXHjoHVS7y7wOmgOF2d7yApdSvEaLb2O8jm1rGpb+a3KVLFWj06pDEuNehH7XqvBTGHn
         mOjEC++qG4+okZY+xQhao7EOhgm5Nqwhsg5614HzpUtG7CtHGVMLXHHhz9vDmeKU+dfE
         l6hIdfeNJDKF3RZw/FwBtXDP9Lct9RQRbz3jBzFrTzqGVVUGHkqA5r1bV52Ez5TEFSbS
         b/z/vlrh8gbmT+qXlS1Iuc9oX/oMKrK2SZoaXIp970AqBpYH7DmvNyCJAcrVvkwPZCbJ
         la+w==
X-Gm-Message-State: AOJu0Ywc6jJ1CSgcKKqvO2OGoee33H0GTaMjSyUPlEmMnP9Mw5nrmTWZ
	UA/fO1JEbz+F9PIKCkD/Z88cTnIlE63jtpFB/LLyT7ywiSYwGo8bIDeO
X-Gm-Gg: AfdE7cnmAhONoOAXYFjf76T0cZxMqINs4sOW2yDeBjghON4X8bb8L4RQHRpbwgnjDnB
	8rNV3vl17PpJwi3hevpUGZi6Rwhp8wBpk4S6bbqyQ09IWeWws6oWpVnQL9H5Rtn5yUc+pQguDsZ
	qjBd898l1LDrT4gRzRAZib4xyOEPgeQqnwKlRNX5J/tUYzLQuTBRJxfHz2/dHdVgsCmf/737Ek1
	SznruaXKF8alzuw7FixwW0JFOJnjDQjRRKah0Ge02PtYL20tgzEtTTe47ZRA4TtexzKOTCusUnM
	mefnZXrIDGUDJCOzkPSTe0b2paMMT+rVMDCguQIb82AZhgLfQJl4LdVEGMb4gohzjdyin841IV+
	WqlA7QGyzO6MH/ANZDl1ySmibDYSHidlKRfReusxQ2wixkGzflnJBllKirGCBcUwIFett1CDlU8
	S9j3eZfnecD9n3
X-Received: by 2002:a05:6a00:2451:b0:845:ea88:f8d8 with SMTP id d2e1a72fcca58-84826d85a8dmr5467607b3a.48.1783444564949;
        Tue, 07 Jul 2026 10:16:04 -0700 (PDT)
Received: from mincom1 ([175.235.236.90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5784602b3a.3.2026.07.07.10.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 10:16:04 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH v2 3/5] crypto: eip93: use request-local SA records for cipher requests
Date: Wed,  8 Jul 2026 02:15:35 +0900
Message-ID: <20260707171537.467608-4-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707171537.467608-1-hurryman2212@gmail.com>
References: <20260707171537.467608-1-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cipher and AEAD requests keep mutable direction and copy flags in the SA
record. Updating the tfm-level SA record for decrypt requests can leak
those settings into concurrent requests using the same transform.

Copy the prepared SA record into the request context and apply the
request-specific flags there. Map that request-local record for DMA, then
unmap it on normal completion and validation failures.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-aead.c   | 34 +++++++++++++------
 .../crypto/inside-secure/eip93/eip93-cipher.c | 34 ++++++++++++-------
 .../crypto/inside-secure/eip93/eip93-cipher.h |  3 +-
 .../crypto/inside-secure/eip93/eip93-common.c |  9 +++++
 4 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 2bbd0af7b0e0..3b2edb012048 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -42,12 +42,18 @@ void eip93_aead_handle_result(struct crypto_async_request *async, int err)
 
 static int eip93_aead_send_req(struct crypto_async_request *async)
 {
+	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(async->tfm);
 	struct aead_request *req = aead_request_cast(async);
 	struct eip93_cipher_reqctx *rctx = aead_request_ctx(req);
 	int err;
 
 	err = check_valid_request(rctx);
 	if (err) {
+		if (rctx->sa_record_base) {
+			dma_unmap_single(ctx->eip93->dev, rctx->sa_record_base,
+					 sizeof(rctx->sa_record), DMA_TO_DEVICE);
+			rctx->sa_record_base = 0;
+		}
 		aead_request_complete(req, err);
 		return err;
 	}
@@ -81,8 +87,6 @@ static void eip93_aead_cra_exit(struct crypto_tfm *tfm)
 {
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	dma_unmap_single(ctx->eip93->dev, ctx->sa_record_base,
-			 sizeof(*ctx->sa_record), DMA_TO_DEVICE);
 	kfree(ctx->sa_record);
 }
 
@@ -191,11 +195,24 @@ static int eip93_aead_crypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	int ret;
 
-	ctx->sa_record_base = dma_map_single(ctx->eip93->dev, ctx->sa_record,
-					     sizeof(*ctx->sa_record), DMA_TO_DEVICE);
-	ret = dma_mapping_error(ctx->eip93->dev, ctx->sa_record_base);
-	if (ret)
+	memcpy(&rctx->sa_record, ctx->sa_record, sizeof(rctx->sa_record));
+	if (IS_DECRYPT(rctx->flags)) {
+		rctx->sa_record.sa_cmd0_word |= EIP93_SA_CMD_DIRECTION_IN;
+		rctx->sa_record.sa_cmd1_word &= ~(EIP93_SA_CMD_COPY_PAD |
+						   EIP93_SA_CMD_COPY_DIGEST);
+	} else {
+		rctx->sa_record.sa_cmd0_word &= ~EIP93_SA_CMD_DIRECTION_IN;
+		rctx->sa_record.sa_cmd1_word |= EIP93_SA_CMD_COPY_PAD |
+						 EIP93_SA_CMD_COPY_DIGEST;
+	}
+
+	rctx->sa_record_base = dma_map_single(ctx->eip93->dev, &rctx->sa_record,
+					      sizeof(rctx->sa_record), DMA_TO_DEVICE);
+	ret = dma_mapping_error(ctx->eip93->dev, rctx->sa_record_base);
+	if (ret) {
+		rctx->sa_record_base = 0;
 		return ret;
+	}
 
 	rctx->textsize = req->cryptlen;
 	rctx->blksize = ctx->blksize;
@@ -205,7 +222,6 @@ static int eip93_aead_crypt(struct aead_request *req)
 	rctx->sg_dst = req->dst;
 	rctx->ivsize = crypto_aead_ivsize(aead);
 	rctx->desc_flags = EIP93_DESC_AEAD;
-	rctx->sa_record_base = ctx->sa_record_base;
 
 	if (IS_DECRYPT(rctx->flags))
 		rctx->textsize -= rctx->authsize;
@@ -238,10 +254,6 @@ static int eip93_aead_decrypt(struct aead_request *req)
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct eip93_cipher_reqctx *rctx = aead_request_ctx(req);
 
-	ctx->sa_record->sa_cmd0_word |= EIP93_SA_CMD_DIRECTION_IN;
-	ctx->sa_record->sa_cmd1_word &= ~(EIP93_SA_CMD_COPY_PAD |
-					  EIP93_SA_CMD_COPY_DIGEST);
-
 	rctx->flags = ctx->flags;
 	rctx->flags |= EIP93_DECRYPT;
 	if (ctx->set_assoc) {
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 4dd7ab7503e8..66b85781ef93 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -32,6 +32,7 @@ void eip93_skcipher_handle_result(struct crypto_async_request *async, int err)
 
 static int eip93_skcipher_send_req(struct crypto_async_request *async)
 {
+	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(async->tfm);
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct eip93_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	int err;
@@ -39,6 +40,11 @@ static int eip93_skcipher_send_req(struct crypto_async_request *async)
 	err = check_valid_request(rctx);
 
 	if (err) {
+		if (rctx->sa_record_base) {
+			dma_unmap_single(ctx->eip93->dev, rctx->sa_record_base,
+					 sizeof(rctx->sa_record), DMA_TO_DEVICE);
+			rctx->sa_record_base = 0;
+		}
 		skcipher_request_complete(req, err);
 		return err;
 	}
@@ -72,8 +78,6 @@ static void eip93_skcipher_cra_exit(struct crypto_tfm *tfm)
 {
 	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	dma_unmap_single(ctx->eip93->dev, ctx->sa_record_base,
-			 sizeof(*ctx->sa_record), DMA_TO_DEVICE);
 	kfree(ctx->sa_record);
 }
 
@@ -133,7 +137,7 @@ static int eip93_skcipher_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 	return 0;
 }
 
-static int eip93_skcipher_crypt(struct skcipher_request *req)
+static int eip93_skcipher_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct eip93_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct crypto_async_request *async = &req->base;
@@ -153,11 +157,19 @@ static int eip93_skcipher_crypt(struct skcipher_request *req)
 				crypto_skcipher_blocksize(skcipher)))
 			return -EINVAL;
 
-	ctx->sa_record_base = dma_map_single(ctx->eip93->dev, ctx->sa_record,
-					     sizeof(*ctx->sa_record), DMA_TO_DEVICE);
-	ret = dma_mapping_error(ctx->eip93->dev, ctx->sa_record_base);
-	if (ret)
+	memcpy(&rctx->sa_record, ctx->sa_record, sizeof(rctx->sa_record));
+	if (encrypt)
+		rctx->sa_record.sa_cmd0_word &= ~EIP93_SA_CMD_DIRECTION_IN;
+	else
+		rctx->sa_record.sa_cmd0_word |= EIP93_SA_CMD_DIRECTION_IN;
+
+	rctx->sa_record_base = dma_map_single(ctx->eip93->dev, &rctx->sa_record,
+					      sizeof(rctx->sa_record), DMA_TO_DEVICE);
+	ret = dma_mapping_error(ctx->eip93->dev, rctx->sa_record_base);
+	if (ret) {
+		rctx->sa_record_base = 0;
 		return ret;
+	}
 
 	rctx->assoclen = 0;
 	rctx->textsize = req->cryptlen;
@@ -167,7 +179,6 @@ static int eip93_skcipher_crypt(struct skcipher_request *req)
 	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
 	rctx->blksize = ctx->blksize;
 	rctx->desc_flags = EIP93_DESC_SKCIPHER;
-	rctx->sa_record_base = ctx->sa_record_base;
 
 	return eip93_skcipher_send_req(async);
 }
@@ -181,22 +192,19 @@ static int eip93_skcipher_encrypt(struct skcipher_request *req)
 	rctx->flags = tmpl->flags;
 	rctx->flags |= EIP93_ENCRYPT;
 
-	return eip93_skcipher_crypt(req);
+	return eip93_skcipher_crypt(req, true);
 }
 
 static int eip93_skcipher_decrypt(struct skcipher_request *req)
 {
-	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct eip93_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct eip93_alg_template *tmpl = container_of(req->base.tfm->__crt_alg,
 				struct eip93_alg_template, alg.skcipher.base);
 
-	ctx->sa_record->sa_cmd0_word |= EIP93_SA_CMD_DIRECTION_IN;
-
 	rctx->flags = tmpl->flags;
 	rctx->flags |= EIP93_DECRYPT;
 
-	return eip93_skcipher_crypt(req);
+	return eip93_skcipher_crypt(req, false);
 }
 
 /* Available algorithms in this module */
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.h b/drivers/crypto/inside-secure/eip93/eip93-cipher.h
index 47e4e84ff14e..e9612696c388 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.h
@@ -9,6 +9,7 @@
 #define _EIP93_CIPHER_H_
 
 #include "eip93-main.h"
+#include "eip93-regs.h"
 
 struct eip93_crypto_ctx {
 	struct eip93_device		*eip93;
@@ -16,7 +17,6 @@ struct eip93_crypto_ctx {
 	struct sa_record		*sa_record;
 	u32				sa_nonce;
 	int				blksize;
-	dma_addr_t			sa_record_base;
 	/* AEAD specific */
 	unsigned int			authsize;
 	unsigned int			assoclen;
@@ -32,6 +32,7 @@ struct eip93_cipher_reqctx {
 	unsigned int			textsize;
 	unsigned int			assoclen;
 	unsigned int			authsize;
+	struct sa_record		sa_record __aligned(CRYPTO_DMA_ALIGN);
 	dma_addr_t			sa_record_base;
 	struct sa_state			*sa_state;
 	dma_addr_t			sa_state_base;
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index ed46730c36bc..f422c93748c9 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -637,6 +637,10 @@ int eip93_send_req(struct crypto_async_request *async,
 				 DMA_TO_DEVICE);
 free_sa_state:
 	kfree(rctx->sa_state);
+	if (rctx->sa_record_base)
+		dma_unmap_single(eip93->dev, rctx->sa_record_base,
+				 sizeof(rctx->sa_record), DMA_TO_DEVICE);
+	rctx->sa_record_base = 0;
 
 	return err;
 }
@@ -693,6 +697,11 @@ void eip93_handle_result(struct eip93_device *eip93, struct eip93_cipher_reqctx
 				 sizeof(*rctx->sa_state_ctr),
 				 DMA_FROM_DEVICE);
 
+	if (rctx->sa_record_base)
+		dma_unmap_single(eip93->dev, rctx->sa_record_base,
+				 sizeof(rctx->sa_record), DMA_TO_DEVICE);
+	rctx->sa_record_base = 0;
+
 	if (rctx->sa_state)
 		dma_unmap_single(eip93->dev, rctx->sa_state_base,
 				 sizeof(*rctx->sa_state),
-- 
2.53.0

