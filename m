Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3314CC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 22:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AB9206E2
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFBWF2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:05:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:43747 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBWF2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 18:05:28 -0400
IronPort-SDR: +9Loevk66SVoFX7aswNYhHDFJQbYMs+FPQbWcSPLmAO87R4yFYVG5T1wdXKO+oLGIq/PEoulEH
 EGGFsDhpjksg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 15:05:26 -0700
IronPort-SDR: NqmMFRa8ZSSO8O9xNeDZJ5yE5ZCB0s79dca5YjmIRxoG37KxtWK1lphiKUxqkdhiRrZN+5uVjg
 fBHhsA03inXA==
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="470824556"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 15:05:23 -0700
Date:   Tue, 2 Jun 2020 23:05:16 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com,
        dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
Message-ID: <20200602220516.GA20880@silpixa00400314>
References: <20200601160418.171851200@debian-a64.vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601160418.171851200@debian-a64.vm>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mikulas,

thanks for your patch. See below.

On Mon, Jun 01, 2020 at 06:03:33PM +0200, Mikulas Patocka wrote:
> Using dm-crypt with QAT result in deadlocks.
> 
> If a crypto routine returns -EBUSY, it is expected that the crypto driver
> have already queued the request and the crypto API user should assume that
> this request was processed, but it should stop sending more requests. When
> an -EBUSY request is processed, the crypto driver calls the callback with
> the error code -EINPROGRESS - this means that the request is still being
> processed (i.e. the user should wait for another callback), but the user
> can start sending more requests now.
> 
> The QAT driver misunderstood this logic, it return -EBUSY when the queue
> was full and didn't queue the request - the request was lost and it
> resulted in a deadlock.
> 
> This patch fixes busy state handling - if the queue is at least 15/16
> full, we return -EBUSY to signal to the user that no more requests should
> be sent. We remember that we returned -EBUSY (the variable backed_off) and
> if we finish the request, we return -EINPROGRESS to indicate that the user
> can send more requests.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> Index: linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
> ===================================================================
> --- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_algs.c
> +++ linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -826,6 +826,9 @@ static void qat_aead_alg_callback(struct
>  	qat_alg_free_bufl(inst, qat_req);
>  	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
>  		res = -EBADMSG;
> +
> +	if (qat_req->backed_off)
> +		areq->base.complete(&areq->base, -EINPROGRESS);
>  	areq->base.complete(&areq->base, res);
>  }
>  
> @@ -847,6 +850,8 @@ static void qat_skcipher_alg_callback(st
>  	dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
>  			  qat_req->iv_paddr);
>  
> +	if (qat_req->backed_off)
> +		sreq->base.complete(&sreq->base, -EINPROGRESS);
>  	sreq->base.complete(&sreq->base, res);
>  }
>  
> @@ -869,7 +874,7 @@ static int qat_alg_aead_dec(struct aead_
>  	struct icp_qat_fw_la_auth_req_params *auth_param;
>  	struct icp_qat_fw_la_bulk_req *msg;
>  	int digst_size = crypto_aead_authsize(aead_tfm);
> -	int ret, ctr = 0;
> +	int ret, backed_off;
>  
>  	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
>  	if (unlikely(ret))
> @@ -890,15 +895,16 @@ static int qat_alg_aead_dec(struct aead_
>  	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
>  	auth_param->auth_off = 0;
>  	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
> -	do {
> -		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> -	} while (ret == -EAGAIN && ctr++ < 10);
>  
> +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> +again:
> +	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
>  	if (ret == -EAGAIN) {
> -		qat_alg_free_bufl(ctx->inst, qat_req);
> -		return -EBUSY;
> +		qat_req->backed_off = backed_off = 1;
> +		cpu_relax();
> +		goto again;
>  	}
I am a bit concerned about this potential infinite loop.
If an error occurred on the device and the queue is full, we will be
stuck here forever.
Should we just retry a number of times and then fail?
Or, should we just move to the crypto-engine?

> -	return -EINPROGRESS;
> +	return backed_off ? -EBUSY : -EINPROGRESS;
>  }
>  
>  static int qat_alg_aead_enc(struct aead_request *areq)
> @@ -911,7 +917,7 @@ static int qat_alg_aead_enc(struct aead_
>  	struct icp_qat_fw_la_auth_req_params *auth_param;
>  	struct icp_qat_fw_la_bulk_req *msg;
>  	uint8_t *iv = areq->iv;
> -	int ret, ctr = 0;
> +	int ret, backed_off;
>  
>  	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
>  	if (unlikely(ret))
> @@ -935,15 +941,15 @@ static int qat_alg_aead_enc(struct aead_
>  	auth_param->auth_off = 0;
>  	auth_param->auth_len = areq->assoclen + areq->cryptlen;
>  
> -	do {
> -		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> -	} while (ret == -EAGAIN && ctr++ < 10);
> -
> +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
checkpatch: line over 80 characters - same in every place
adf_should_back_off is used.

> +again:
> +	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
>  	if (ret == -EAGAIN) {
> -		qat_alg_free_bufl(ctx->inst, qat_req);
> -		return -EBUSY;
> +		qat_req->backed_off = backed_off = 1;
> +		cpu_relax();
> +		goto again;
>  	}
> -	return -EINPROGRESS;
> +	return backed_off ? -EBUSY : -EINPROGRESS;
>  }
>  
>  static int qat_alg_skcipher_rekey(struct qat_alg_skcipher_ctx *ctx,
> @@ -1051,7 +1057,7 @@ static int qat_alg_skcipher_encrypt(stru
>  	struct icp_qat_fw_la_cipher_req_params *cipher_param;
>  	struct icp_qat_fw_la_bulk_req *msg;
>  	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
> -	int ret, ctr = 0;
> +	int ret, backed_off;
>  
>  	if (req->cryptlen == 0)
>  		return 0;
> @@ -1081,17 +1087,16 @@ static int qat_alg_skcipher_encrypt(stru
>  	cipher_param->cipher_offset = 0;
>  	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
>  	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
> -	do {
> -		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> -	} while (ret == -EAGAIN && ctr++ < 10);
>  
> +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> +again:
> +	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
>  	if (ret == -EAGAIN) {
> -		qat_alg_free_bufl(ctx->inst, qat_req);
> -		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
> -				  qat_req->iv_paddr);
> -		return -EBUSY;
> +		qat_req->backed_off = backed_off = 1;
> +		cpu_relax();
> +		goto again;
>  	}
> -	return -EINPROGRESS;
> +	return backed_off ? -EBUSY : -EINPROGRESS;
>  }
>  
>  static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
> @@ -1111,7 +1116,7 @@ static int qat_alg_skcipher_decrypt(stru
>  	struct icp_qat_fw_la_cipher_req_params *cipher_param;
>  	struct icp_qat_fw_la_bulk_req *msg;
>  	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
> -	int ret, ctr = 0;
> +	int ret, backed_off;
>  
>  	if (req->cryptlen == 0)
>  		return 0;
> @@ -1141,17 +1146,16 @@ static int qat_alg_skcipher_decrypt(stru
>  	cipher_param->cipher_offset = 0;
>  	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
>  	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
> -	do {
> -		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> -	} while (ret == -EAGAIN && ctr++ < 10);
>  
> +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> +again:
> +	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
>  	if (ret == -EAGAIN) {
> -		qat_alg_free_bufl(ctx->inst, qat_req);
> -		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
> -				  qat_req->iv_paddr);
> -		return -EBUSY;
> +		qat_req->backed_off = backed_off = 1;
> +		cpu_relax();
> +		goto again;
>  	}
> -	return -EINPROGRESS;
> +	return backed_off ? -EBUSY : -EINPROGRESS;
>  }
>  
>  static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
> Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
> ===================================================================
> --- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.c
> +++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
> @@ -114,10 +114,19 @@ static void adf_disable_ring_irq(struct
>  	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
>  }
>  
> +bool adf_should_back_off(struct adf_etr_ring_data *ring)
> +{
> +	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
How did you came up with 15/16?
checkpatch: WARNING: line over 80 characters

> +}
> +
>  int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
>  {
> -	if (atomic_add_return(1, ring->inflights) >
> -	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
> +	int limit = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
> +
> +	if (atomic_read(ring->inflights) >= limit)
> +		return -EAGAIN;
Can this be removed and leave only the condition below?
Am I missing something here?
> +
> +	if (atomic_add_return(1, ring->inflights) > limit) {
>  		atomic_dec(ring->inflights);
>  		return -EAGAIN;
>  	}
> Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.h
> ===================================================================
> --- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.h
> +++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.h
> @@ -58,6 +58,7 @@ int adf_create_ring(struct adf_accel_dev
>  		    const char *ring_name, adf_callback_fn callback,
>  		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
>  
> +bool adf_should_back_off(struct adf_etr_ring_data *ring);
>  int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg);
>  void adf_remove_ring(struct adf_etr_ring_data *ring);
>  #endif
> Index: linux-2.6/drivers/crypto/qat/qat_common/qat_crypto.h
> ===================================================================
> --- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_crypto.h
> +++ linux-2.6/drivers/crypto/qat/qat_common/qat_crypto.h
> @@ -90,6 +90,7 @@ struct qat_crypto_request {
>  		   struct qat_crypto_request *req);
>  	void *iv;
>  	dma_addr_t iv_paddr;
> +	int backed_off;
>  };
>  
>  #endif
> 
Regards,

-- 
Giovanni
