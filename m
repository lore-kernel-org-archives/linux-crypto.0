Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C941C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6179A20C01
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfBTKB2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:01:28 -0500
Received: from mout.gmx.net ([212.227.15.15]:33383 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfBTKB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 05:01:28 -0500
Received: from localhost.localdomain ([218.18.229.179]) by mail.gmx.com
 (mrgmx003 [212.227.17.184]) with ESMTPSA (Nemesis) id
 0M0PdN-1hAdBV3Vl7-00ubrE; Wed, 20 Feb 2019 11:01:13 +0100
From:   Chengguang Xu <cgxu519@gmx.com>
To:     horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] crypo: caam: remove redundant likely/unlikely annotation
Date:   Wed, 20 Feb 2019 18:00:32 +0800
Message-Id: <20190220100032.32098-1-cgxu519@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:pQqQYj/CPUysj9e+CQwlM9Pj8/0UtgbK9SOXblzEnl+57dt19yi
 dDPJ9jP24ITJ5bK/HEmq0sQ6YrKJkhd1jir2A+axjpyfSeiNsEBAxPq4zmRER8HWBgcc0TJ
 VUyCGb7e5eNnMoL5V29on1ScZ1kMn0+vQ5uAF+pxIYw1yjiq745sr5vMl5Qm51tZm7Vn9N6
 19Sh/Swd+Q3S1WHeo1V9g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lcgW4RtAbSE=:ebYu3YMZ59FJFhb6a5W2H4
 Xo+w4PU69kfP2ew8YtszklRVmFjGKcHin7qOCnh18uf1lXsPy42guzUDy99qFyDTPpKC1fhCM
 tIE0wSJVyBG/e2I/ygY2OWS2rsTskxx94aMoSkw2kO08VnMYJwwncaLRD78xOspAhb5PKNl3l
 YTJJL+7vVP8jShu8BG2Y9UZrcO0ZhMpVnjtH694TdncrvgF3kTtFrZQUrCymVdETavCSjXivK
 K8hzLxMBFeiSn9hTf7G7iUM85XCn+aoa/1sGlYBfHc0epvoW/Ees8rIk/Fo35+2eI9cZiHHAX
 Xyx0/G0GnnZ7Ebkq2Yr7fZXrD4dj3wq76r0jfOD0NN/Q1lPqT+z9Lxngmz1LOyyjy4XRQuux+
 lKy3wTvxH19Q8FGjJjInlCtgy8R9rUttGN0runmbTbhWgVrC9mKuuYQwNLWTAx9BamoY6oFEp
 xRy70fMA/0H3akpizcwjHUNk23K4pXMeJn7Zd3J5VthQd5y3QuOLswJa6Ps8Iplhtuo6sDnLD
 vWzoMP6tH30ReAFh8jMj+FhYtQZHlsdI0Z/Jq9Ysvpkrhp4SptrmxTstZDyoKo4BHqtWD7v1x
 iOaksNIKui3utkpe70YhiP8VdZlME0MNxGIlqrGFer+umUnIvkxCxZMtU+lpQ51J63HpPY5kq
 VZht57Tr86TY7w1hUjm1QPZNWQw5s2qTqRLyhwxkpxdnB2j+eZ5uPCBSCtdGRKQu5IIwbGZX+
 83xP09Qz4KtYMwXTZu0AbCjg1RDUgNMDlzRlzDOFZKd4o5bmWk52N/3Wco0q3tefCDhs2wm5N
 JRGaR+3EDTuFc7netT/ziqiSIQoJr5G4AcRJeSwZKSL44ZeLy+ddBPTPVdZ2cK06oZvRibiHE
 yfuj4xyGqhdvanxe+rJai2YtSb0rbahLcSg6/Du3MBRMYRIoCBOra5m0w7Tq7H
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

unlikely has already included in IS_ERR(), so just
remove redundant likely/unlikely annotation.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 drivers/crypto/caam/caamalg_qi.c | 6 +++---
 drivers/crypto/caam/qi.c         | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index c0d55310aade..7d5f47203074 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -782,7 +782,7 @@ static struct caam_drv_ctx *get_drv_ctx(struct caam_ctx *ctx,
 
 			cpu = smp_processor_id();
 			drv_ctx = caam_drv_ctx_init(ctx->qidev, &cpu, desc);
-			if (likely(!IS_ERR_OR_NULL(drv_ctx)))
+			if (!IS_ERR_OR_NULL(drv_ctx))
 				drv_ctx->op_type = type;
 
 			ctx->drv_ctx[type] = drv_ctx;
@@ -892,7 +892,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct caam_drv_ctx *drv_ctx;
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
-	if (unlikely(IS_ERR_OR_NULL(drv_ctx)))
+	if (IS_ERR_OR_NULL(drv_ctx))
 		return (struct aead_edesc *)drv_ctx;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
@@ -1184,7 +1184,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	struct caam_drv_ctx *drv_ctx;
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
-	if (unlikely(IS_ERR_OR_NULL(drv_ctx)))
+	if (IS_ERR_OR_NULL(drv_ctx))
 		return (struct skcipher_edesc *)drv_ctx;
 
 	src_nents = sg_nents_for_len(req->src, req->cryptlen);
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index b84e6c8b1e13..7cb8b1755e57 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -318,7 +318,7 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc)
 	/* Create a new req FQ in parked state */
 	new_fq = create_caam_req_fq(drv_ctx->qidev, drv_ctx->rsp_fq,
 				    drv_ctx->context_a, 0);
-	if (unlikely(IS_ERR_OR_NULL(new_fq))) {
+	if (IS_ERR_OR_NULL(new_fq)) {
 		dev_err(qidev, "FQ allocation for shdesc update failed\n");
 		return PTR_ERR(new_fq);
 	}
@@ -431,7 +431,7 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *qidev,
 	/* Attach request FQ */
 	drv_ctx->req_fq = create_caam_req_fq(qidev, drv_ctx->rsp_fq, hwdesc,
 					     QMAN_INITFQ_FLAG_SCHED);
-	if (unlikely(IS_ERR_OR_NULL(drv_ctx->req_fq))) {
+	if (IS_ERR_OR_NULL(drv_ctx->req_fq)) {
 		dev_err(qidev, "create_caam_req_fq failed\n");
 		dma_unmap_single(qidev, hwdesc, size, DMA_BIDIRECTIONAL);
 		kfree(drv_ctx);
-- 
2.20.1

