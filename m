Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31857C35247
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 21:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1F3A20720
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 21:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyFXP1xH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBFVCo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 16:02:44 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34254 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBFVCo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 16:02:44 -0500
Received: by mail-qk1-f194.google.com with SMTP id a23so99670qka.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 13:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zI3TjwN7LJ7pqIcCXM6aXOKYuQCzr3fiuSGdPGq37e8=;
        b=TyFXP1xHv3jLYqPV4bO1WT99KLgwjPOlYgo5Z9fqjFpRTA5bRpWniPpvuYBHlVaUGv
         8nw9g/Kn4qrpL+gSh1JpiZ2UL0XgRnoLbT7rmeUzgYBAwoZvu3E14j3hO3XUVxSh+3um
         CqUv9wnhi5XnayQyNX0QEiybTAqUdkU1C82Du+RkaJpER5iXS/ttNvLJrxXMs0p/asum
         rIlodokl+Y6kwfSIaVMVn3KhZ36FpVByugbvMXeKbnINdMCRNnF8eMYuss5ssGoUK6Lg
         ubtXBTtxVQvEjfv/KwwslS7FoMpmBLnpzGEPUYo+St7sS53lJt1Xj8Z11UtfubozjLDr
         Lmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zI3TjwN7LJ7pqIcCXM6aXOKYuQCzr3fiuSGdPGq37e8=;
        b=r0kIZ7vRMGzRUYEOLs+7hOabAtNehf9boY6nHii4YgNNJECrUvcJMmTOCDZpz0vV1m
         JtJXCOnjNyGu1dRLVFbpMiwcXYz75FOiiu/TAVQcB2fnp5Rmv8zXOcNw2oXlXKVb649I
         UIUf0XkHvfw0YQANA3jJEixhOw6qlWth6UVX2YPEFolqwNrgRsZAtSDxOBaMaMft5QZH
         cHYYIaPAMla8CDEWRJ6TJ6gtSMjn59m+FWNCuxsHNDDRi9iJyvGnyq67iYrp36BRjpcQ
         Sv9rp696qaVHl+dUYf19q5nnnCLxJnROcd5fI64MI5jVdquc8ezD/srp5JrQ2HMdUw3g
         tkeg==
X-Gm-Message-State: APjAAAWj/WxqYg7759eFP8kkUZ0tw/6LM986SUn0CSHmLcZGM22NxBMN
        PPZhIlJ7SGMB/6j8nRmHUmFMFcdk
X-Google-Smtp-Source: APXvYqwulHmnvP4His6SRhmkvlpxOrzSISTEtDyxEnDwBqEj1+Lg4fgoZzMqE7jXlsDgwtt8I3mZFQ==
X-Received: by 2002:a37:7cc7:: with SMTP id x190mr4293971qkc.10.1581022962903;
        Thu, 06 Feb 2020 13:02:42 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id o12sm252869qke.79.2020.02.06.13.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 13:02:42 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v4 1/3] crypto: qce - use cryptlen when adding extra sgl
Date:   Thu,  6 Feb 2020 18:02:05 -0300
Message-Id: <20200206210207.21849-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The qce crypto driver appends an extra entry to the dst sgl, to maintain
private state information.

When the gcm driver sends requests to the ctr skcipher, it passes the
authentication tag after the actual crypto payload, but it must not be
touched.

Commit 1336c2221bee ("crypto: qce - save a sg table slot for result
buf") limited the destination sgl to avoid overwriting the
authentication tag but it assumed the tag would be in a separate sgl
entry.

This is not always the case, so it is better to limit the length of the
destination buffer to req->cryptlen before appending the result buf.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
--
v1 -> v4: no change

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 7da893dc00e7..46db5bf366b4 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -48,9 +48,10 @@ void qce_dma_release(struct qce_dma_data *dma)
 
 struct scatterlist *
 qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl,
-		int max_ents)
+		unsigned int max_len)
 {
 	struct scatterlist *sg = sgt->sgl, *sg_last = NULL;
+	unsigned int new_len;
 
 	while (sg) {
 		if (!sg_page(sg))
@@ -61,13 +62,13 @@ qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl,
 	if (!sg)
 		return ERR_PTR(-EINVAL);
 
-	while (new_sgl && sg && max_ents) {
-		sg_set_page(sg, sg_page(new_sgl), new_sgl->length,
-			    new_sgl->offset);
+	while (new_sgl && sg && max_len) {
+		new_len = new_sgl->length > max_len ? max_len : new_sgl->length;
+		sg_set_page(sg, sg_page(new_sgl), new_len, new_sgl->offset);
 		sg_last = sg;
 		sg = sg_next(sg);
 		new_sgl = sg_next(new_sgl);
-		max_ents--;
+		max_len -= new_len;
 	}
 
 	return sg_last;
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index ed25a0d9829e..786402169360 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -43,6 +43,6 @@ void qce_dma_issue_pending(struct qce_dma_data *dma);
 int qce_dma_terminate_all(struct qce_dma_data *dma);
 struct scatterlist *
 qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add,
-		int max_ents);
+		unsigned int max_len);
 
 #endif /* _DMA_H_ */
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 4217b745f124..63ae75809cb7 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -97,13 +97,14 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 
 	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
 
-	sg = qce_sgtable_add(&rctx->dst_tbl, req->dst, rctx->dst_nents - 1);
+	sg = qce_sgtable_add(&rctx->dst_tbl, req->dst, req->cryptlen);
 	if (IS_ERR(sg)) {
 		ret = PTR_ERR(sg);
 		goto error_free;
 	}
 
-	sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->result_sg, 1);
+	sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->result_sg,
+			     QCE_RESULT_BUF_SZ);
 	if (IS_ERR(sg)) {
 		ret = PTR_ERR(sg);
 		goto error_free;
