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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C43C35247
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA0420730
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNbHC8rb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgBFBVO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 20:21:14 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43743 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFBVO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 20:21:14 -0500
Received: by mail-qv1-f68.google.com with SMTP id p2so2092697qvo.10
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2020 17:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oFkkNUdzzqqQ4BTE/G04D5Na0zNjD/ys0WvHWqp3S+E=;
        b=nNbHC8rbkXPC7vISXtiMpMF84W43tHt1qrovbjw0GGckFfu0BURiHuP7jVAQkqRKnT
         HEQ+uYgS1XqpD2ybyX6Y8G8/nskG0yHbw41iOQtTPCZ8gId+ZF8x1c31+TQOZ783ays4
         jiiAHlCKUcZMIEh4F5lsHrPfdllX8ZTYNWdXHXLctoCR/tbmVgk/0SNJ//3CFGQYwm6l
         KE1rtZcgdCOE2lOxlejk4NjIm7ksy/3zv6ybGmt4LZ+eJcoJOxKamBfTOayXrAqgLnnf
         kFJXBtarlP7FUZtmwBU2KxSMURRHJoowBJEgUtDP8ZbtWYjS1sb2/1w9tbn6FA2zRMyr
         yGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oFkkNUdzzqqQ4BTE/G04D5Na0zNjD/ys0WvHWqp3S+E=;
        b=Q/HuNM58mvG1CFjV68hqBV2eIHenMX0C77mMwkK7diW1oxptxm8lkNWaX10+27uHMi
         iz2m0jNe/HhBkWHV+T0i7+3BKFQwiMBGhc2ce7/3mMy2M0lkqcLamY57tBJ1mPBfCevD
         kIP73fQcYcW+9pYi6Ed3dcHA4AdcZyJ0PwsSbVmL8x3CD/oYcVNTuw5kGCI1FICDdWM1
         jCMKEOefiVdESR32/4K3BFRc+ArK3K6q5Jzn3SdP5evLXtAWNYwmAbpbsSxtkHNSg/Pg
         c6QjbbdftZ80viwwKrmEpCRVIClcsQwslH6ISJ3TEF+GkayRAxdf99bOeCJZ9707JeS5
         dBTw==
X-Gm-Message-State: APjAAAXi4fpd7rGH2Hbx5D1QNGYFxx0ZfFH5RglQbxHAPR/zi0emMHy4
        0nNCqUe0uM7oBTpqNSokVcIGGgbB
X-Google-Smtp-Source: APXvYqzilE6Ptxx9uZJJxzYQDb6Uw+R1zGmum/bzC3zx64XdIR8XkLSY0UnWc8rc70zK+h08sNOQXg==
X-Received: by 2002:a05:6214:17cd:: with SMTP id cu13mr407550qvb.192.1580952072740;
        Wed, 05 Feb 2020 17:21:12 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c18sm719729qkk.5.2020.02.05.17.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 17:21:12 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v2 1/3] crypto: qce - use cryptlen when adding extra sgl
Date:   Wed,  5 Feb 2020 22:20:34 -0300
Message-Id: <20200206012036.25614-2-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206012036.25614-1-cotequeiroz@gmail.com>
References: <20200203165334.6185-1-cotequeiroz@gmail.com>
 <20200206012036.25614-1-cotequeiroz@gmail.com>
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
