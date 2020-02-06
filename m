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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FAEC2D0B1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 491BF20661
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQuMdB3A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBFLlZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:41:25 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33520 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFLlZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 06:41:25 -0500
Received: by mail-qk1-f195.google.com with SMTP id h4so5210489qkm.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 03:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oFkkNUdzzqqQ4BTE/G04D5Na0zNjD/ys0WvHWqp3S+E=;
        b=bQuMdB3AMwmlKGJ8GH4U+CPk8GDrQVlbZR9ZLDfITsUrqK44sJpR9W/0BTDZcJxQP1
         L34iaJPxIy5zbKKxD32koYp5AC/vYspTOSByxZOSd5tCXWCnPmBdy82DwRQfY41Zv1nh
         dyMU3noTM4DaVs9Bd8RmcTjaE/g1eLEQVdju/0gQ3DX8xCQuw4wwqBwki57oxSjua1QJ
         Mwd7cFso4HGr4Caz2pO/0aKfk4c0DmBYax51sm/AOUjRaBnMPUzBhA2dmSuHVzJaYRae
         91krbhk3/vyhWam9/REdF/aLWrIih+bXLVtTz9icB92YbDGgs+zSjJrOO4BVXlhSdmN1
         a8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oFkkNUdzzqqQ4BTE/G04D5Na0zNjD/ys0WvHWqp3S+E=;
        b=hCOnhaaN3WxV0DTMtbDfeEUkERJYx25B9Ahi0NV7TEYD7gXWoAm5c902V4RLcfdxTM
         LtjFnJMBm7KIErYHQLsj94OJGYzpyQ5l8x/DLhSLLl0D7ejn2exC5TUSoFuEyTJDsfVp
         BiYACjgTKoAeCIKYI6SfhFpI16xiAV1Lsj7XfFR2zCn/4l2/4YMB7wSOU/rojs21eulK
         VkYXoVmDwRYSitKBc8PopqyHgXU/UiXi63h97KfBDS4opTtyvkMctHhRnCml9Ig6ba0C
         CHKtbCLSi6w+ptzeaif3qNcJa319TW6YkHNWh5O3L5XAFd6iof4RWYNORKeiOeOFzOA8
         b1FA==
X-Gm-Message-State: APjAAAUPclMpe9tY8mgL9rAlx3DptV5p/KskZY11A0iBUVZrDUMqWdj/
        jH0Uuz3qV6q2SzHEkTPBSTaUC/CW
X-Google-Smtp-Source: APXvYqx2K2bY8moBMw9N2UABieFCnoIv+Fu3pmiIZqJk8opRfjiGNiazsK3N1DeYDltm/VnVMtEkNw==
X-Received: by 2002:a37:f518:: with SMTP id l24mr1917808qkk.441.1580989284281;
        Thu, 06 Feb 2020 03:41:24 -0800 (PST)
Received: from gateway.troianet.com.br ([2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id g37sm1507283qte.60.2020.02.06.03.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:41:23 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v3 1/3] crypto: qce - use cryptlen when adding extra sgl
Date:   Thu,  6 Feb 2020 08:39:45 -0300
Message-Id: <20200206113947.31396-2-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206012036.25614-1-cotequeiroz@gmail.com>
References: <20200206012036.25614-1-cotequeiroz@gmail.com>
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
