Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036011E525
	for <linux-crypto@vger.kernel.org>; Mon,  1 Apr 2024 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989251; cv=none; b=FPfwXZ5qj3LZk1RfWOQVOk2RxOq98QfZ2FY8tyCxC91kvybnupNCwPqSXdII4xwRV/ab3voqI5jZEeIZIibUj8MmWfsZQnOWkPvrcE6N/zs7KmsMvYiXG8fqFVctTLz4Q9haessud5+3e3pZgFELt5CBtFu4uV5JrNsOSjtYv+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989251; c=relaxed/simple;
	bh=2HR4hSPxoXiOT9ncvLIn94WohHa3F3zyMsRCFeKu9Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjZVp1zlUxnR4gh1Pm2ah2p+gMc9TkZ2JWTdCmsCJqlo7dP/RIKvt0kcAUda6iwSHD+djIVo9e+1mvWs+g3Cyc13L524xHSjz9/zP7+J9tKqp2kdAS/hQTIAaHVe2jb/dwmaXntEG/8RTqI9bM9aSvQquh0g6MV2dRMebXlzsUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=AoAnnVei; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="AoAnnVei"
Received: from [100.64.200.249] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 21244208B324;
	Mon,  1 Apr 2024 09:34:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 21244208B324
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1711989243;
	bh=39I0Y90dA9bIsxVXudHTnA9QLat04AGZ2eAVp1pKulQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AoAnnVeiCqP4xgpUdV0eY+BbG3IcSd8rX0ooGdxIiw2md1z/EmgQU05sRDeTtFzk/
	 UzUThpDqNS8BOmd93Qwa9x543sdriBz1MwtZPKa9Yjmz1LLylt5Yc59InT76A2rjzY
	 y+haT8+jxab56QAzLSmbCUpyI3JygjIfMGf5gpbg=
Message-ID: <0ca1f15a-f883-407f-8837-c2a9891637f4@linux.microsoft.com>
Date: Mon, 1 Apr 2024 09:34:03 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] Add SPAcc driver to Linux kernel
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
 <20240328182652.3587727-2-pavitrakumarm@vayavyalabs.com>
 <6e486947-54cb-4ff5-bcf3-97e6ae106412@linux.microsoft.com>
 <CALxtO0=tvJh+h9W+1eN4xLQtwOugteABpA0QUTrgJ=f_dgeVoA@mail.gmail.com>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <CALxtO0=tvJh+h9W+1eN4xLQtwOugteABpA0QUTrgJ=f_dgeVoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/2024 12:21 AM, Pavitrakumar Managutte wrote:
> Hi Easwar,
>   My comments are embedded below. Also should I wait for more comments
> from you or
> should I go ahead and push v2 with the below fixes ?
> 
> Warm regards,
> PK
> 

<snip>

Please see more comments below, and go ahead and push a v2. If possible, split 
the series into more patches. I leave it to you to group them by file or logical
 functionality, so long as each individual commit compiles neatly so as to not break
future git bisects.


On 3/28/2024 11:26 AM, Pavitrakumar M wrote:
> Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  drivers/crypto/dwc-spacc/spacc_aead.c      | 1382 ++++++++++
>  drivers/crypto/dwc-spacc/spacc_ahash.c     | 1183 ++++++++
>  drivers/crypto/dwc-spacc/spacc_core.c      | 2917 ++++++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h      |  839 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.c    |  324 +++
>  drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++
>  drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
>  drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
>  drivers/crypto/dwc-spacc/spacc_interrupt.c |  204 ++
>  drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
>  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  754 +++++
>  11 files changed, 8987 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dwc-spacc/spacc_ahash.c
> new file mode 100644
> index 000000000000..53c76ee16c53
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> @@ -0,0 +1,1183 @@
> +// SPDX-License-Identifier: GPL-2.0
> +

<snip>

> +
> +static int spacc_hash_init(struct ahash_request *req)
> +{
> +	int x = 0, rc = 0;
> +	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +	const struct spacc_alg *salg = spacc_tfm_ahash(&reqtfm->base);
> +	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
> +
> +
> +	ctx->digest_buf = NULL;
> +
> +	ctx->single_shot = 0;
> +	ctx->total_nents = 0;
> +	ctx->cur_part_pck = 0;
> +	ctx->final_part_pck = 0;
> +	ctx->rem_len = 0;
> +	ctx->rem_nents = 0;
> +	ctx->first_ppp_chunk = 1;
> +	ctx->small_pck = 1;
> +	tctx->ppp_sgl = NULL;
> +
> +	if (tctx->handle < 0 || !tctx->ctx_valid) {
> +		priv = NULL;
> +		dev_dbg(tctx->dev, "%s: open SPAcc context\n", __func__);
> +
> +		for (x = 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) {
> +			priv = dev_get_drvdata(salg->dev[x]);
> +			tctx->dev = get_device(salg->dev[x]);
> +			if (spacc_isenabled(&priv->spacc, salg->mode->id, 0)) {
> +				tctx->handle = spacc_open(&priv->spacc,
> +							  CRYPTO_MODE_NULL,
> +						salg->mode->id, -1, 0,
> +						spacc_digest_cb, reqtfm);
> +			}
> +
> +			if (tctx->handle >= 0)
> +				break;
> +
> +			put_device(salg->dev[x]);
> +		}
> +
> +		if (tctx->handle < 0) {
> +			dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
> +			goto fallback;
> +		}
> +
> +		rc = spacc_set_operation(&priv->spacc, tctx->handle,
> +					 OP_ENCRYPT, ICV_HASH, IP_ICV_OFFSET,
> +					 0, 0, 0);
> +		if (rc < 0) {
> +			spacc_close(&priv->spacc, tctx->handle);
> +			dev_dbg(salg->dev[0], "Failed to open SPAcc context\n");
> +			tctx->handle = -1;
> +			put_device(tctx->dev);
> +			goto fallback;
> +		}
> +		tctx->ctx_valid = true;
> +	} else {
> +		;/* do nothing */
> +	}

Do we need this else?

> +
> +	/* alloc ppp_sgl */
> +	tctx->ppp_sgl = kmalloc(sizeof(*(tctx->ppp_sgl)) * 2, GFP_KERNEL);
> +	if (!tctx->ppp_sgl)
> +		return -ENOMEM;
> +
> +	sg_init_table(tctx->ppp_sgl, 2);
> +
> +	return 0;
> +fallback:
> +
> +	ctx->fb.hash_req.base = req->base;
> +	ahash_request_set_tfm(&ctx->fb.hash_req, tctx->fb.hash);
> +
> +	return crypto_ahash_init(&ctx->fb.hash_req);
> +}
> +
> +static int spacc_hash_final_part_pck(struct ahash_request *req)
> +{
> +	struct crypto_ahash *reqtfm = crypto_ahash_reqtfm(req);
> +	struct spacc_crypto_ctx *tctx = crypto_ahash_ctx(reqtfm);
> +	struct spacc_crypto_reqctx *ctx = ahash_request_ctx(req);
> +	struct spacc_priv *priv = dev_get_drvdata(tctx->dev);
> +
> +	int rc;
> +
> +	ctx->final_part_pck = 1;
> +
> +	/* In all the final calls the data is same as prev update and
> +	 * hence we can skip this init dma part and just enQ ddt
> +	 * No use in calling initdata, just process remaining bytes in ppp_sgl
> +	 * and be done with it.
> +	 */
> +
> +	rc = spacc_hash_init_dma(tctx->dev, req, 1);
> +
> +	if (rc < 0)
> +		return -ENOMEM;
> +
> +	if (rc == 0) {
> +		;/* small packet */
> +	}

Please cleanup these do-nothing comment code paths throughout.

> +
> +	/* enqueue ddt for the remaining bytes of data, everything else
> +	 * would have been processed already, req->nbytes need not be
> +	 * processed
> +	 * Since this will hit only for small pkts, hence the condition
> +	 *  ctx->rem_len-req->nbytes for the small pkt len
> +	 */
> +	if (ctx->rem_len)
> +		rc = spacc_packet_enqueue_ddt(&priv->spacc,
> +				ctx->acb.new_handle, &ctx->src, &ctx->dst,
> +				tctx->ppp_sgl[0].length,
> +				0, tctx->ppp_sgl[0].length, 0, 0, 0);
> +	else {
> +		/* zero msg handling */
> +		rc = spacc_packet_enqueue_ddt(&priv->spacc,
> +				ctx->acb.new_handle,
> +				&ctx->src, &ctx->dst, 0, 0, 0, 0, 0, 0);
> +	}
> +
> +	if (rc < 0) {
> +		spacc_hash_cleanup_dma(tctx->dev, req);
> +		spacc_close(&priv->spacc, ctx->acb.new_handle);
> +
> +		if (rc != -EBUSY) {
> +			dev_err(tctx->dev, "ERR: Failed to enqueue job: %d\n", rc);
> +			return rc;
> +		}
> +
> +		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
> +			return -EBUSY;
> +	}
> +
> +	return -EINPROGRESS;
> +}
> +

<snip>

Thanks,
Easwar
