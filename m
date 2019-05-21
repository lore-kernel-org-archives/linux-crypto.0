Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2DBC04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8AA6217D7
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="SHkASnCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfEUNfB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:35:01 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:20820 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfEUNeR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:34:17 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457cDk1nRGz9v2XX;
        Tue, 21 May 2019 15:34:14 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=SHkASnCL; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Ow7LbR6u9jAk; Tue, 21 May 2019 15:34:14 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457cDk0by2z9v2XY;
        Tue, 21 May 2019 15:34:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558445654; bh=QfMrYopbcDjTc9zMQZiJ8VBQsK2upXn33+elOKQwC2c=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=SHkASnCLeYBiqbWwYpxszm0Tyx0UL/qrNjft6OzYswK1o4QiqQKf1el5jkW+HoCLT
         ISmO/OFyo4IPmc01kqUPleXHioQxQq8ln9EGYbGxB+OxFHIdEP0mL+aavxzbtFT/m5
         O7EAR9TrPIx72Ll7mDNlSiacbU8gmG/QG7ej2CQk=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 750BC8B80C;
        Tue, 21 May 2019 15:34:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id vp5_7FeBL8Hg; Tue, 21 May 2019 15:34:15 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 337BA8B803;
        Tue, 21 May 2019 15:34:15 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id EB4FD68479; Tue, 21 May 2019 13:34:14 +0000 (UTC)
Message-Id: <1ad8020c8140da1b4f818220e130ed0074c37fe1.1558445259.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1558445259.git.christophe.leroy@c-s.fr>
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v1 08/15] crypto: talitos - Do not modify req->cryptlen on
 decryption.
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Tue, 21 May 2019 13:34:14 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For decrypt, req->cryptlen includes the size of the authentication
part while all functions of the driver expect cryptlen to be
the size of the encrypted data.

As it is not expected to change req->cryptlen, this patch
implements local calculation of cryptlen.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 9c4a79653b35 ("crypto: talitos - Freescale integrated security engine (SEC) driver")
---
 drivers/crypto/talitos.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6f6f34754ad8..a15aa6d6ec33 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1025,11 +1025,13 @@ static void talitos_sg_unmap(struct device *dev,
 
 static void ipsec_esp_unmap(struct device *dev,
 			    struct talitos_edesc *edesc,
-			    struct aead_request *areq)
+			    struct aead_request *areq, bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
 	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
 
@@ -1038,7 +1040,7 @@ static void ipsec_esp_unmap(struct device *dev,
 					 DMA_FROM_DEVICE);
 	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
 
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen,
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, cryptlen,
 			 areq->assoclen);
 
 	if (edesc->dma_len)
@@ -1049,7 +1051,7 @@ static void ipsec_esp_unmap(struct device *dev,
 		unsigned int dst_nents = edesc->dst_nents ? : 1;
 
 		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
-				   areq->assoclen + areq->cryptlen - ivsize);
+				   areq->assoclen + cryptlen - ivsize);
 	}
 }
 
@@ -1072,7 +1074,7 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, areq);
+	ipsec_esp_unmap(dev, edesc, areq, true);
 
 	/* copy the generated ICV to dst */
 	if (edesc->icv_ool) {
@@ -1108,7 +1110,7 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, req);
+	ipsec_esp_unmap(dev, edesc, req, false);
 
 	if (!err) {
 		/* auth check */
@@ -1145,7 +1147,7 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
-	ipsec_esp_unmap(dev, edesc, req);
+	ipsec_esp_unmap(dev, edesc, req, false);
 
 	/* check ICV auth status */
 	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
@@ -1248,6 +1250,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
  * fill in and submit ipsec_esp descriptor
  */
 static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
+		     bool encrypt,
 		     void (*callback)(struct device *dev,
 				      struct talitos_desc *desc,
 				      void *context, int error))
@@ -1257,7 +1260,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
-	unsigned int cryptlen = areq->cryptlen;
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	int tbl_off = 0;
 	int sg_count, ret;
@@ -1384,7 +1387,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
-		ipsec_esp_unmap(dev, edesc, areq);
+		ipsec_esp_unmap(dev, edesc, areq, encrypt);
 		kfree(edesc);
 	}
 	return ret;
@@ -1502,9 +1505,10 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
 
 	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
-				   iv, areq->assoclen, areq->cryptlen,
+				   iv, areq->assoclen, cryptlen,
 				   authsize, ivsize, icv_stashing,
 				   areq->base.flags, encrypt);
 }
@@ -1523,7 +1527,7 @@ static int aead_encrypt(struct aead_request *req)
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
-	return ipsec_esp(edesc, req, ipsec_esp_encrypt_done);
+	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
 }
 
 static int aead_decrypt(struct aead_request *req)
@@ -1536,8 +1540,6 @@ static int aead_decrypt(struct aead_request *req)
 	struct scatterlist *sg;
 	void *icvdata;
 
-	req->cryptlen -= authsize;
-
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, req->iv, 1, false);
 	if (IS_ERR(edesc))
@@ -1554,7 +1556,8 @@ static int aead_decrypt(struct aead_request *req)
 
 		/* reset integrity check result bits */
 
-		return ipsec_esp(edesc, req, ipsec_esp_decrypt_hwauth_done);
+		return ipsec_esp(edesc, req, false,
+				 ipsec_esp_decrypt_hwauth_done);
 	}
 
 	/* Have to check the ICV with software */
@@ -1571,7 +1574,7 @@ static int aead_decrypt(struct aead_request *req)
 
 	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - authsize, authsize);
 
-	return ipsec_esp(edesc, req, ipsec_esp_decrypt_swauth_done);
+	return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
 }
 
 static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
-- 
2.13.3

