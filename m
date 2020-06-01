Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9339C433E1
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA0E2076B
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgFAQMv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:12:51 -0400
Received: from smtp02.tmcz.cz ([93.153.104.113]:36068 "EHLO smtp02.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgFAQMv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 12:12:51 -0400
Received: from smtp02.tmcz.cz (localhost [127.0.0.1])
        by sagator.hkvnode045 (Postfix) with ESMTP id 8F23D94DD3B;
        Mon,  1 Jun 2020 18:04:20 +0200 (CEST)
X-Sagator-Scanner: 1.3.1-1 at hkvnode046;
        log(status(custom_action(quarantine(clamd()))),
        status(custom_action(quarantine(SpamAssassinD()))))
X-Sagator-ID: 20200601-180420-0001-83134-Tkfubv@hkvnode046
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp02.tmcz.cz (Postfix) with ESMTPS;
        Mon,  1 Jun 2020 18:04:20 +0200 (CEST)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1jfmvD-0001Vo-0i; Mon, 01 Jun 2020 18:04:20 +0200
Received: by debian-a64.vm (sSMTP sendmail emulation); Mon, 01 Jun 2020 18:04:18 +0200
Message-Id: <20200601160418.171851200@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Mon, 01 Jun 2020 18:03:33 +0200
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Mike Snitzer <msnitzer@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc:     dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=qat-fix-4.patch
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using dm-crypt with QAT result in deadlocks.

If a crypto routine returns -EBUSY, it is expected that the crypto driver
have already queued the request and the crypto API user should assume that
this request was processed, but it should stop sending more requests. When
an -EBUSY request is processed, the crypto driver calls the callback with
the error code -EINPROGRESS - this means that the request is still being
processed (i.e. the user should wait for another callback), but the user
can start sending more requests now.

The QAT driver misunderstood this logic, it return -EBUSY when the queue
was full and didn't queue the request - the request was lost and it
resulted in a deadlock.

This patch fixes busy state handling - if the queue is at least 15/16
full, we return -EBUSY to signal to the user that no more requests should
be sent. We remember that we returned -EBUSY (the variable backed_off) and
if we finish the request, we return -EINPROGRESS to indicate that the user
can send more requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_algs.c
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
@@ -826,6 +826,9 @@ static void qat_aead_alg_callback(struct
 	qat_alg_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
+
+	if (qat_req->backed_off)
+		areq->base.complete(&areq->base, -EINPROGRESS);
 	areq->base.complete(&areq->base, res);
 }
 
@@ -847,6 +850,8 @@ static void qat_skcipher_alg_callback(st
 	dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
 			  qat_req->iv_paddr);
 
+	if (qat_req->backed_off)
+		sreq->base.complete(&sreq->base, -EINPROGRESS);
 	sreq->base.complete(&sreq->base, res);
 }
 
@@ -869,7 +874,7 @@ static int qat_alg_aead_dec(struct aead_
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
@@ -890,15 +895,16 @@ static int qat_alg_aead_dec(struct aead_
 	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_aead_enc(struct aead_request *areq)
@@ -911,7 +917,7 @@ static int qat_alg_aead_enc(struct aead_
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	uint8_t *iv = areq->iv;
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
@@ -935,15 +941,15 @@ static int qat_alg_aead_enc(struct aead_
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_skcipher_rekey(struct qat_alg_skcipher_ctx *ctx,
@@ -1051,7 +1057,7 @@ static int qat_alg_skcipher_encrypt(stru
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1081,17 +1087,16 @@ static int qat_alg_skcipher_encrypt(stru
 	cipher_param->cipher_offset = 0;
 	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
 	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
@@ -1111,7 +1116,7 @@ static int qat_alg_skcipher_decrypt(stru
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1141,17 +1146,16 @@ static int qat_alg_skcipher_decrypt(stru
 	cipher_param->cipher_offset = 0;
 	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
 	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.c
+++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
@@ -114,10 +114,19 @@ static void adf_disable_ring_irq(struct
 	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
 }
 
+bool adf_should_back_off(struct adf_etr_ring_data *ring)
+{
+	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
+}
+
 int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
 {
-	if (atomic_add_return(1, ring->inflights) >
-	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
+	int limit = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
+
+	if (atomic_read(ring->inflights) >= limit)
+		return -EAGAIN;
+
+	if (atomic_add_return(1, ring->inflights) > limit) {
 		atomic_dec(ring->inflights);
 		return -EAGAIN;
 	}
Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.h
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.h
+++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.h
@@ -58,6 +58,7 @@ int adf_create_ring(struct adf_accel_dev
 		    const char *ring_name, adf_callback_fn callback,
 		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
 
+bool adf_should_back_off(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
Index: linux-2.6/drivers/crypto/qat/qat_common/qat_crypto.h
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_crypto.h
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -90,6 +90,7 @@ struct qat_crypto_request {
 		   struct qat_crypto_request *req);
 	void *iv;
 	dma_addr_t iv_paddr;
+	int backed_off;
 };
 
 #endif

