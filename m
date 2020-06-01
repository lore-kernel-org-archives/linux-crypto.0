Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616BBC433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E55E206C3
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgFAQMq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:12:46 -0400
Received: from smtp01.tmcz.cz ([93.153.104.112]:37678 "EHLO smtp01.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgFAQMq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 12:12:46 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2020 12:12:44 EDT
Received: from smtp01.tmcz.cz (localhost [127.0.0.1])
        by sagator.hkvnode045 (Postfix) with ESMTP id 918B5940597;
        Mon,  1 Jun 2020 18:04:21 +0200 (CEST)
X-Sagator-Scanner: 1.3.1-1 at hkvnode045;
        log(status(custom_action(quarantine(clamd()))),
        status(custom_action(quarantine(SpamAssassinD()))))
X-Sagator-ID: 20200601-180421-0001-94206-NFMkfP@hkvnode045
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp01.tmcz.cz (Postfix) with ESMTPS;
        Mon,  1 Jun 2020 18:04:21 +0200 (CEST)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1jfmvE-0001Vu-8c; Mon, 01 Jun 2020 18:04:21 +0200
Received: by debian-a64.vm (sSMTP sendmail emulation); Mon, 01 Jun 2020 18:04:19 +0200
Message-Id: <20200601160419.414457600@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Mon, 01 Jun 2020 18:03:34 +0200
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Mike Snitzer <msnitzer@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc:     dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] qat: fix misunderstood -EBUSY return code in asym algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=qat-fix-asym.patch
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a bug in QAT in async asymetric algorithm.

adf_send_message returns -EAGAIN when the queue is full. The caller
misunderstands it as -EBUSY - so the retry loop will never happen.

Furthermore, when the crypto driver return -EBUSY, it is expected that it
has queued the request and the caller should stop sending more requests.
When the request is returned with -EINPROGRESS, the caller can send more
requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/crypto/qat/qat_common/qat_asym_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -179,6 +179,7 @@ struct qat_asym_request {
 		struct kpp_request *dh;
 	} areq;
 	int err;
+	int backed_off;
 	void (*cb)(struct icp_qat_fw_pke_resp *resp);
 } __aligned(64);
 
@@ -219,6 +220,8 @@ static void qat_dh_cb(struct icp_qat_fw_
 			 sizeof(struct qat_dh_output_params),
 			 DMA_TO_DEVICE);
 
+	if (req->backed_off)
+		kpp_request_complete(areq, -EINPROGRESS);
 	kpp_request_complete(areq, err);
 }
 
@@ -263,7 +266,7 @@ static int qat_dh_compute_value(struct k
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(kpp_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret, backed_off;
 	int n_input_params = 0;
 
 	if (unlikely(!ctx->xa))
@@ -388,17 +391,17 @@ static int qat_dh_compute_value(struct k
 	msg->input_param_count = n_input_params;
 	msg->output_param_count = 1;
 
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
-
-	if (!ret)
-		return -EINPROGRESS;
-
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_dh_output_params),
-				 DMA_TO_DEVICE);
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->pke_tx);
+again:
+	ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	if (ret == -EAGAIN) {
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
+	}
+
+	return backed_off ? -EBUSY : -EINPROGRESS;
+
 unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
@@ -585,6 +588,8 @@ static void qat_rsa_cb(struct icp_qat_fw
 			 sizeof(struct qat_rsa_output_params),
 			 DMA_TO_DEVICE);
 
+	if (req->backed_off)
+		akcipher_request_complete(areq, -EINPROGRESS);
 	akcipher_request_complete(areq, err);
 }
 
@@ -692,7 +697,7 @@ static int qat_rsa_enc(struct akcipher_r
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (unlikely(!ctx->n || !ctx->e))
 		return -EINVAL;
@@ -782,17 +787,18 @@ static int qat_rsa_enc(struct akcipher_r
 	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
-
-	if (!ret)
-		return -EINPROGRESS;
-
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_rsa_output_params),
-				 DMA_TO_DEVICE);
+
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->pke_tx);
+again:
+	ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	if (ret == -EAGAIN) {
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
+	}
+
+	return backed_off ? -EBUSY : -EINPROGRESS;
+
 unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
@@ -826,7 +832,7 @@ static int qat_rsa_dec(struct akcipher_r
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (unlikely(!ctx->n || !ctx->d))
 		return -EINVAL;
@@ -934,17 +940,18 @@ static int qat_rsa_dec(struct akcipher_r
 		msg->input_param_count = 3;
 
 	msg->output_param_count = 1;
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
-
-	if (!ret)
-		return -EINPROGRESS;
-
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_rsa_output_params),
-				 DMA_TO_DEVICE);
+
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->pke_tx);
+again:
+	ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	if (ret == -EAGAIN) {
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
+	}
+
+	return backed_off ? -EBUSY : -EINPROGRESS;
+
 unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,

