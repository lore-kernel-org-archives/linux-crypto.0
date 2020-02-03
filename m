Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8098C35247
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 19:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BCC12051A
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 19:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IuEZlmCh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgBCTFQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 14:05:16 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:33692 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgBCTFP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 14:05:15 -0500
Received: by mail-qv1-f66.google.com with SMTP id z3so7360559qvn.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Feb 2020 11:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oFkkNUdzzqqQ4BTE/G04D5Na0zNjD/ys0WvHWqp3S+E=;
        b=IuEZlmChQd+iOSOa4PRywGGyo+QZD/WuKT6UZ+AFAslKvY1QiWX7inGAaG3RatFuGp
         S8A4vF+4AdutspNgsJagzx8G2igvBdfwwZXi3b96d7vzSYDS2D8HTn7OWWs5f7imJD6h
         6Nw8liNXI4OliBO2os28dVFoaL8fU6n4v7O8jQ/axFVg5Q2LG11gl2Muj4klWlVTYEpl
         +T56QXGBn4uVQ4EiAb+R4YFko7hO2z7R08qcgxR1Chs3UuT7jPp2uZcD9sVSw8tMhcRR
         r+nsmH6y/IiK6skHLsXW8eHImpXOn12fiFPTHToLEat9hY442QBMfAxEb0Qpkl5RJKPw
         FbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oFkkNUdzzqqQ4BTE/G04D5Na0zNjD/ys0WvHWqp3S+E=;
        b=CDDZ7q6BMo4Pl9Wt9vXcfBFCKf+hGHlIHbVL6p6JCzZ+KshrgeERx/6UJJonsP2bbz
         s5Xg1YS6CHtQZmUXSM1KactQ908aHL6cVaA8O7dtQCYB7HuevK3XahZlXuhigyC6cuK+
         ebN570wQNr5HSDdQGPZCt9DGM6tqpZDKCzSKuUJ/5d7bT11/dSWigyhPKWtS+3vHKC0j
         8IG32a1KqjYqb5h82LIixgCekm5YaKaxHm1+GD7Wyp9+jgtuu7Sj3/EgXbLBXV+eeDaz
         psWCepXKUMeApWgDwI8yLc628caewy2v2k3bH/aH8fLEWs0vTR++zh9yLQjeYUDDT7yl
         BR3w==
X-Gm-Message-State: APjAAAVMP/ROH6F7GfyvO8dvgIowTeZd27Dvldo3YY92v5Dpvp5kjfve
        J3ktva5DH5i7fkFxvflWyz2GZl0t
X-Google-Smtp-Source: APXvYqwaTZTyLnegJdgnPDshGwFepUdR0Cl6ce+3f5fnlk8BnrVBwtdglT0OKN1k98eklzALj/rNXQ==
X-Received: by 2002:a05:6214:176e:: with SMTP id et14mr23461565qvb.133.1580756713422;
        Mon, 03 Feb 2020 11:05:13 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id b30sm9680001qka.48.2020.02.03.11.05.12
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 11:05:13 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: qce - use cryptlen when adding extra sgl
Date:   Mon,  3 Feb 2020 16:04:54 -0300
Message-Id: <20200203165334.6185-2-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200203165334.6185-1-cotequeiroz@gmail.com>
References: <20200203165334.6185-1-cotequeiroz@gmail.com>
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
