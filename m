Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D1BC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33232147C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfBTKuO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:50:14 -0500
Received: from mout.gmx.net ([212.227.17.20]:37195 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfBTKuN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 05:50:13 -0500
Received: from localhost.localdomain ([218.18.229.179]) by mail.gmx.com
 (mrgmx102 [212.227.17.174]) with ESMTPSA (Nemesis) id
 0MZOan-1gbJnP0LrZ-00LBTU; Wed, 20 Feb 2019 11:49:59 +0100
From:   Chengguang Xu <cgxu519@gmx.com>
To:     horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2] crypto: caam - remove redundant likely/unlikely annotation
Date:   Wed, 20 Feb 2019 18:49:18 +0800
Message-Id: <20190220104918.32637-1-cgxu519@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:EXsswomEW9rVBGEH5Hod2JprrhgywWSO2Mwzkg0GS53LiFRDXP+
 BMF4f1dVhSgjeIgOFFPiLQ9rW0PEcJcyUrYh4pbmkMubGueZ4NflJ35hIm5T5EvtKyHVMxf
 fliSVyx28Z3Aj8QA42p2qdVaYGAq19xpRNysOucDjVRJhMriZ20LMYY8S7aaBfvc1U9otqN
 BbXnES9HzfzsfZ1APSpXw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xGAJQYSx7KI=:7LCEmBtVWCuGgsn0u24r1O
 cM8plOSIiO1185oIMwbgR2usA5YH1g8ivDcyKlyiN3yQA82F2Mvmw/wawZTgLGCR2sGwMGsco
 TaPA6sIKuTsuQ3WMC3iWfqtsrlcV4VDvWDP0wJkUdy4juYSwdi5NNa2maDkaBiqnKQOkzCzTv
 BQR3PxAwgmBVLVm/ijbAYpl+esZwu9R1g27EjJvz2DTmjlrdj/ts07GtEVr+Q1jwHUt2p0qiL
 byp8tpSXjIXpJId+fg3Q1nD34s3jqN2lJsj1EtdgFYlLPLiuKo4YMb3oCLhsg02ZyMWI+7Boq
 JGFDXTw8PoE7USCT7umX+hPBogUG1UsQO/SiHc7z9jahGhAwMWhG94psLM/m1N91PkqBrfICi
 KB1Y1UQMAAgypt6Fe42OfclhpQ4HOz/Y/iGJpXajM62LVC7QDZFkUasSzQbdTfO7Tv/GF2WKK
 0ZHObfmzFZCND6fV/iqpGMdYDR2eoKjePK11VO3l+FsLdSkOQqP2T9EXmOSPuCbAbAHhbKzEj
 FAek4jKR8OihwBoO0ujIZmoGj9V+mG8wPGtBYdPtbQrU1rt61RKDvjFeosU5Snan0/Qe7PCMA
 ON8CvlqlnsM+pB1rU9rOhSKp1ctoDPJ/9dLHvTgq2/pzh/p1Q147Zmm8UO8Dmxjd3ZhlAMU/K
 bJCs2A0pzEG35gELdNF+njEjew+KQROKhRO84YuFL1Ctp4J/sY2EAIT5v2XeQ5rWTPjAFYR+V
 rd0XRytvaKE1/WcHrY4QiqFGj4gGRkb4Yr78+7nuM6/UtbbKxsQzQoRn2op5cVBGXP1oUwBHe
 ti7s3ic3nV+0vYxl10Wm/HnJqk8TENxnNXGie0R0dML0NXZ+gFwksu1WgeTyjhgv+LkEkW8Xy
 CWGxUeq6Tj9xInAo8q32paN1EEesQ79uy7IOLX2NPN4aS4860fVyAp9Vum8JrE
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

unlikely has already included in IS_ERR(), so just
remove redundant likely/unlikely annotation.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
v1->v2:
- Fix subject typo and format.

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

