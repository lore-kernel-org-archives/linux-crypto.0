Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92429C04EB5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 15:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6828121775
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 15:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4uisUdN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBGPDB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 10:03:01 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36683 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbgBGPDA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 10:03:00 -0500
Received: by mail-qt1-f194.google.com with SMTP id t13so2056373qto.3
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2020 07:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dy9o98hzu1MS+RljWNRsefU29lbZAdlv1mMfEvRfL38=;
        b=c4uisUdNLTzpymbPFXvGawpmXIi9FZWG3/LhMHqCU0TSVujhM2pkLyJNIXZqfpUBi5
         6un4dAGQQPlGxY/fL87oCA+krbjeXB3O6cObO1hNFYQ77QTzZSKn009Z6cHCRB2+/g4Q
         L+1GuFiL7TI69lzrqsHwn3QhAl2u+r9NRbeUvLme6SvlAdddKMnjZ9Z05yTkN5jt5NeG
         TcpCnWKv+J+am625vuXmg/rLtIv0Kyv1m/nsdZF59wg0L1ZyQOKnfMx/B1qyhfB9jlFZ
         +NkqKT+mpps19AmT9GFEeAOVAZaNSRoSgV+CaQm0Dt9C9Sz0BgnZ57/dOmZ0oD8merE4
         dXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dy9o98hzu1MS+RljWNRsefU29lbZAdlv1mMfEvRfL38=;
        b=bjEd4V4rb/wh0X0nTKMXxxM4E//vCrlhAgFnTbld14y6Z90XdTIOYhpb/dzSEKL6X0
         u6Z4UTJgU5m0SbKSaBrvJVJD2ldzSriqj0WhBdHRn/Clm/lSHX9eSKcFh4+CeGWb7zS+
         J4Gta5ZrxQ3ycK57TEGxeSeVFFD3dO5Q0vBLzVIuK7tI0DXyLx6UnuSjfHbfWgo8XPa2
         cUPNc7B0NpBHtUNa7/Sw3SSwxCw6rwK9hNHZQUnfDgiEKDhgno8tNf4Q3nOzZYS3Lm5Y
         iY79UBwAfLxT/7YfrjvKhihEGPaqUXxtqTa8abOvUnDmLyqTOZ+Ssm6yA2TIbZjylPrK
         cwKQ==
X-Gm-Message-State: APjAAAXjItRLFBpiinhtfXw7hbnBWl7O03SvaDr5NY3xKEC+W1H+/Avo
        cHYJ4y8zwPZmW7+1leX9ROvA30Qc
X-Google-Smtp-Source: APXvYqyZkrye44WvXCmhyvOgtzxDzh9c+Hki0/k0tOhBqqEcxsmpj0YilESM2n3cY6Yi2hYdGKRErA==
X-Received: by 2002:ac8:7caf:: with SMTP id z15mr7808295qtv.68.1581087778660;
        Fri, 07 Feb 2020 07:02:58 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c10sm420740qkm.56.2020.02.07.07.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:02:58 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v5 1/3] crypto: qce - use cryptlen when adding extra sgl
Date:   Fri,  7 Feb 2020 12:02:25 -0300
Message-Id: <20200207150227.31014-2-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200207150227.31014-1-cotequeiroz@gmail.com>
References: <20200207150227.31014-1-cotequeiroz@gmail.com>
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
v1 -> v5: no change

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
