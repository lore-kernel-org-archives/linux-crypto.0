Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7324C432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 16:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747D620718
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 16:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNSDbdPH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfKQQHx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 11:07:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37146 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQQHx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 11:07:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id t1so16575595wrv.4;
        Sun, 17 Nov 2019 08:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ZfuFAz9i7eipM0Ww7pnmorkcOiDa7xzRC8FduXZgjg=;
        b=DNSDbdPHmy5xZPJPbG6wCk5AKQstG/YcSuLATZewIeg/wyV3o2TvqAHibr3blWGTAg
         yeFr+03gdbeArSnM2RFZrEbTZT7Qq1GYx6k0jme4TQzu75tY2tnxtRj7gwxXc26dPA7w
         FIG2QpsiJZGmtZ72FGzK/ZWkPuZvs3yq6vIgrN08z3SdZGfsrBwxC1NljL54euWxikt/
         G6KRGuGEZ4A7Ng4wa+Y2NVjv3ZLha3GIEU+hBlFjJ54S48jfzBC4mkZ46SP7sYXT62N3
         smT9ztlH1U+Bit8r0WjSXaai10kVroMj7CWx8xNRPp/GBbUmcywM/rAIqlith64d5ezr
         atew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3ZfuFAz9i7eipM0Ww7pnmorkcOiDa7xzRC8FduXZgjg=;
        b=OuHFav4JcwrwXd0V12SzB+7jTQvRAvIhpWBNH/gzsqS4DLwVywGP+vSF5ucTnrGiPJ
         DdzVRYZqr/ccF+0A6zTmKlnH56dzs0X7xBxR0PtP8bcKVsWDHjfAHOXcpuKaWSPGHClI
         bVMvTGZ0+jouyEdEVGw5aN68o+SILtsoEtlAgAv4URB5sxmSqW7KJ16DoHESx/xVz5f/
         kaWxR5wVNeEPUqqq+IWaOkuT4Ez2A2Q5neFmjIsz2YKkSixRyDD26gIGkabEf0XGghUG
         3r8J/VqyweaCrguKXJqVie264kQvnSpq3x8WDh4i7k7zi4ugQYnYnd0oSQcEEY/7/NYg
         NXVg==
X-Gm-Message-State: APjAAAX+v8IRlsU7vye22sMb0kU3PP2fDCtQyeOTQvWd/fwLKQbvubvL
        Ejzz5eZaGI2+kwDO4YCaInc=
X-Google-Smtp-Source: APXvYqxRoa5u/ttV4Rk72n7ofhq/PCWlE8ojnC2DDYLZCRCyx7oQ4nfIBiXuztaoLUJCHuNxPUt0ow==
X-Received: by 2002:a05:6000:354:: with SMTP id e20mr28087903wre.17.1574006869853;
        Sun, 17 Nov 2019 08:07:49 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a5sm19017916wrv.56.2019.11.17.08.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 08:07:49 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: allwinner: sun8i-ce: enable working on big endian
Date:   Sun, 17 Nov 2019 17:07:45 +0100
Message-Id: <20191117160745.32197-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On big endian kernel, the sun8i-ce crypto driver does not works.
This patch do the necessary modification to permit it to work on BE
kernel (setting descriptor entries as __le32 and adding some cpu_to_le32)

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 50 +++++++++++--------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 24 ++++-----
 2 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index b6e7c346c3ae..37d0b6c386a0 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -90,7 +90,9 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	struct ce_task *cet;
 	struct scatterlist *sg;
 	unsigned int todo, len, offset, ivsize;
+	dma_addr_t addr_iv = 0, addr_key = 0;
 	void *backup_iv = NULL;
+	u32 common, sym;
 	int flow, i;
 	int nr_sgs = 0;
 	int nr_sgd = 0;
@@ -115,28 +117,31 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	cet = chan->tl;
 	memset(cet, 0, sizeof(struct ce_task));
 
-	cet->t_id = flow;
-	cet->t_common_ctl = ce->variant->alg_cipher[algt->ce_algo_id];
-	cet->t_common_ctl |= rctx->op_dir | CE_COMM_INT;
-	cet->t_dlen = areq->cryptlen / 4;
+	cet->t_id = cpu_to_le32(flow);
+	common = ce->variant->alg_cipher[algt->ce_algo_id];
+	common |= rctx->op_dir | CE_COMM_INT;
+	cet->t_common_ctl = cpu_to_le32(common);
 	/* CTS and recent CE (H6) need length in bytes, in word otherwise */
 	if (ce->variant->has_t_dlen_in_bytes)
-		cet->t_dlen = areq->cryptlen;
+		cet->t_dlen = cpu_to_le32(areq->cryptlen);
+	else
+		cet->t_dlen = cpu_to_le32(areq->cryptlen / 4);
 
-	cet->t_sym_ctl = ce->variant->op_mode[algt->ce_blockmode];
+	sym = ce->variant->op_mode[algt->ce_blockmode];
 	len = op->keylen;
 	switch (len) {
 	case 128 / 8:
-		cet->t_sym_ctl |= CE_AES_128BITS;
+		sym |= CE_AES_128BITS;
 		break;
 	case 192 / 8:
-		cet->t_sym_ctl |= CE_AES_192BITS;
+		sym |= CE_AES_192BITS;
 		break;
 	case 256 / 8:
-		cet->t_sym_ctl |= CE_AES_256BITS;
+		sym |= CE_AES_256BITS;
 		break;
 	}
 
+	cet->t_sym_ctl = cpu_to_le32(sym);
 	cet->t_asym_ctl = 0;
 
 	chan->op_mode = ce->variant->op_mode[algt->ce_blockmode];
@@ -144,9 +149,9 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	chan->method = ce->variant->alg_cipher[algt->ce_algo_id];
 	chan->keylen = op->keylen;
 
-	cet->t_key = dma_map_single(ce->dev, op->key, op->keylen,
-				    DMA_TO_DEVICE);
-	if (dma_mapping_error(ce->dev, cet->t_key)) {
+	addr_key = dma_map_single(ce->dev, op->key, op->keylen, DMA_TO_DEVICE);
+	cet->t_key = cpu_to_le32(addr_key);
+	if (dma_mapping_error(ce->dev, addr_key)) {
 		dev_err(ce->dev, "Cannot DMA MAP KEY\n");
 		err = -EFAULT;
 		goto theend;
@@ -171,9 +176,10 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 						 ivsize, 0);
 		}
 		memcpy(chan->bounce_iv, areq->iv, ivsize);
-		cet->t_iv = dma_map_single(ce->dev, chan->bounce_iv,
-					   chan->ivlen, DMA_TO_DEVICE);
-		if (dma_mapping_error(ce->dev, cet->t_iv)) {
+		addr_iv = dma_map_single(ce->dev, chan->bounce_iv, chan->ivlen,
+					 DMA_TO_DEVICE);
+		cet->t_iv = cpu_to_le32(addr_iv);
+		if (dma_mapping_error(ce->dev, addr_iv)) {
 			dev_err(ce->dev, "Cannot DMA MAP IV\n");
 			err = -ENOMEM;
 			goto theend_iv;
@@ -208,9 +214,9 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 
 	len = areq->cryptlen;
 	for_each_sg(areq->src, sg, nr_sgs, i) {
-		cet->t_src[i].addr = sg_dma_address(sg);
+		cet->t_src[i].addr = cpu_to_le32(sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
-		cet->t_src[i].len = todo / 4;
+		cet->t_src[i].len = cpu_to_le32(todo / 4);
 		dev_dbg(ce->dev, "%s total=%u SG(%d %u off=%d) todo=%u\n", __func__,
 			areq->cryptlen, i, cet->t_src[i].len, sg->offset, todo);
 		len -= todo;
@@ -223,9 +229,9 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 
 	len = areq->cryptlen;
 	for_each_sg(areq->dst, sg, nr_sgd, i) {
-		cet->t_dst[i].addr = sg_dma_address(sg);
+		cet->t_dst[i].addr = cpu_to_le32(sg_dma_address(sg));
 		todo = min(len, sg_dma_len(sg));
-		cet->t_dst[i].len = todo / 4;
+		cet->t_dst[i].len = cpu_to_le32(todo / 4);
 		dev_dbg(ce->dev, "%s total=%u SG(%d %u off=%d) todo=%u\n", __func__,
 			areq->cryptlen, i, cet->t_dst[i].len, sg->offset, todo);
 		len -= todo;
@@ -250,8 +256,8 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 
 theend_iv:
 	if (areq->iv && ivsize > 0) {
-		if (cet->t_iv)
-			dma_unmap_single(ce->dev, cet->t_iv, chan->ivlen,
+		if (addr_iv)
+			dma_unmap_single(ce->dev, addr_iv, chan->ivlen,
 					 DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
@@ -265,7 +271,7 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	}
 
 theend_key:
-	dma_unmap_single(ce->dev, cet->t_key, op->keylen, DMA_TO_DEVICE);
+	dma_unmap_single(ce->dev, addr_key, op->keylen, DMA_TO_DEVICE);
 
 theend:
 	return err;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index c6ddad3393ed..43db49ceafe4 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -103,8 +103,8 @@ struct ce_variant {
 };
 
 struct sginfo {
-	u32 addr;
-	u32 len;
+	__le32 addr;
+	__le32 len;
 } __packed;
 
 /*
@@ -112,18 +112,18 @@ struct sginfo {
  * The structure of this descriptor could be found in the datasheet
  */
 struct ce_task {
-	u32 t_id;
-	u32 t_common_ctl;
-	u32 t_sym_ctl;
-	u32 t_asym_ctl;
-	u32 t_key;
-	u32 t_iv;
-	u32 t_ctr;
-	u32 t_dlen;
+	__le32 t_id;
+	__le32 t_common_ctl;
+	__le32 t_sym_ctl;
+	__le32 t_asym_ctl;
+	__le32 t_key;
+	__le32 t_iv;
+	__le32 t_ctr;
+	__le32 t_dlen;
 	struct sginfo t_src[MAX_SG];
 	struct sginfo t_dst[MAX_SG];
-	u32 next;
-	u32 reserved[3];
+	__le32 next;
+	__le32 reserved[3];
 } __packed __aligned(8);
 
 /*
-- 
2.23.0

