Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D7EC43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A54520866
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EA63CUhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfLTTDG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:03:06 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39931 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTDG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:03:06 -0500
Received: by mail-pj1-f67.google.com with SMTP id t101so4528779pjb.4
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eN0GkTu09upu/xisGXDpo1R5jjFIfIXvHq6ACDD9fTw=;
        b=EA63CUhXF6tuqkDOKFS3HZPm53hh9kRUdGel9V8jPwn3vvJPWn0Js6CKU8eZeVFNxR
         EBIQ0vzqYGMxY/Xy55Zedc0qmvhFzQr8cdPlcIiWD0BiAcekVdsjWNwfMf7bSdNQA6Sf
         PW5LyNmJLgz8P0nuvNqgL7ZmL4/AnXpRcUQdXOKI9vZz5gUVMEsV5uIfQu9sDv2M4RVt
         iLGXyr1TYubEQdY/eLW/ax4y+QSUojjg7GprxgjMIy8HwKCaiNQu21bi3pMRhQxYSs1Q
         k427J1TyKA8Bo/aiJsTpSPqtVSmjmaAZ+hkBEdjG54Ez2aNNnlak1z0KhWofG/bjJ5oR
         u1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eN0GkTu09upu/xisGXDpo1R5jjFIfIXvHq6ACDD9fTw=;
        b=eWUeDXbbfvc1WkCEiXJRAjnhhXDViWAm0VdWIQr3yIQtV0g1ltPDJvWzKAJU/ghuaX
         WksX6UgNz6aPCTHTUlQRPoCq+XazgfTyt04mTg4TDs3K+ZC/4D9r8rPYfznWkm14tnKr
         JQOEpTUkKim+DFSZxnQx6iWfw4Qye7FwZCmHgD94Zx7njqJYOj8nZlQoheC0nBJYN0eH
         LJeiElYnFUe263EseKkUofYdydBOuBhG2qx0EAf/UpobOMsRF0Pyrtnq7gRNnIacEvtm
         9Y08bD7M4XCM3n4DnXgGxmxea8t33FaxeZZLx4yFKl4LbKO/XmwQPGqkSEyScgZ6N9WA
         X+nA==
X-Gm-Message-State: APjAAAU8IEX9Wp/iWywknRT1gMiILswoSbWXGY+1+WqNQeaSb4L8gQnh
        xQ3qDD2wxFBrmvdzqjB3EQ8=
X-Google-Smtp-Source: APXvYqwc0rOZfR5z7Vk7OUXs8TyP7KVcK/toUxT8ovxNm09CqNIKAe0YwjPeS2Mq/6uVFP9X2KrJNw==
X-Received: by 2002:a17:90a:ec0f:: with SMTP id l15mr17202255pjy.39.1576868585719;
        Fri, 20 Dec 2019 11:03:05 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:03:05 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH 3/6] crypto: qce - save a sg table slot for result buf
Date:   Fri, 20 Dec 2019 16:02:15 -0300
Message-Id: <20191220190218.28884-4-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When ctr-aes-qce is used for gcm-mode, an extra sg entry for the
authentication tag is present, causing trouble when the qce driver
prepares the dst-results sg table for dma.

It computes the number of entries needed with sg_nents_for_len, leaving
out the tag entry.  Then it creates a sg table with that number plus
one, used to store a result buffer.

When copying the sg table, there's no limit to the number of entries
copied, so the extra slot is filled with the authentication tag sg.
When the driver tries to add the result sg, the list is full, and it
returns EINVAL.

By limiting the number of sg entries copied to the dest table, the slot
for the result buffer is guaranteed to be unused.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
---
 drivers/crypto/qce/dma.c      | 6 ++++--
 drivers/crypto/qce/dma.h      | 3 ++-
 drivers/crypto/qce/skcipher.c | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 40a59214d2e1..7da893dc00e7 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -47,7 +47,8 @@ void qce_dma_release(struct qce_dma_data *dma)
 }
 
 struct scatterlist *
-qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl)
+qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl,
+		int max_ents)
 {
 	struct scatterlist *sg = sgt->sgl, *sg_last = NULL;
 
@@ -60,12 +61,13 @@ qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl)
 	if (!sg)
 		return ERR_PTR(-EINVAL);
 
-	while (new_sgl && sg) {
+	while (new_sgl && sg && max_ents) {
 		sg_set_page(sg, sg_page(new_sgl), new_sgl->length,
 			    new_sgl->offset);
 		sg_last = sg;
 		sg = sg_next(sg);
 		new_sgl = sg_next(new_sgl);
+		max_ents--;
 	}
 
 	return sg_last;
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index 1e25a9e0e6f8..ed25a0d9829e 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -42,6 +42,7 @@ int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
 void qce_dma_issue_pending(struct qce_dma_data *dma);
 int qce_dma_terminate_all(struct qce_dma_data *dma);
 struct scatterlist *
-qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add);
+qce_sgtable_add(struct sg_table *sgt, struct scatterlist *sg_add,
+		int max_ents);
 
 #endif /* _DMA_H_ */
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index e4f6d87ba51d..a9ae356bc2a7 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -95,13 +95,13 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 
 	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
 
-	sg = qce_sgtable_add(&rctx->dst_tbl, req->dst);
+	sg = qce_sgtable_add(&rctx->dst_tbl, req->dst, rctx->dst_nents - 1);
 	if (IS_ERR(sg)) {
 		ret = PTR_ERR(sg);
 		goto error_free;
 	}
 
-	sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->result_sg);
+	sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->result_sg, 1);
 	if (IS_ERR(sg)) {
 		ret = PTR_ERR(sg);
 		goto error_free;
