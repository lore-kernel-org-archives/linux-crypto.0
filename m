From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto engine driver
Date: Mon, 24 Apr 2017 14:59:05 +0200
Message-ID: <2475079.gcOV5qCq7E@tauon.chronox.de>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com> <20170424075407.19730-3-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59268 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1170319AbdDXM7I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 08:59:08 -0400
In-Reply-To: <20170424075407.19730-3-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 24. April 2017, 09:54:06 CEST schrieb Antoine Tenart:

Hi Antoine,

> +struct safexcel_cipher_ctx {
> +	struct safexcel_context base;
> +	struct safexcel_crypto_priv *priv;
> +
> +	enum safexcel_cipher_direction direction;
> +	u32 mode;
> +
> +	__le32 key[8];

Can you please help me find the location where this memory is zeroized when 
released?


> +	unsigned int key_len;
> +};
> +
> +static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx,
> +				  struct crypto_async_request *async,
> +				  struct safexcel_command_desc *cdesc,
> +				  u32 length)
> +{
> +	struct ablkcipher_request *req = ablkcipher_request_cast(async);
> +	struct safexcel_token *token;
> +	unsigned offset = 0;
> +
> +	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> +		offset = AES_BLOCK_SIZE / sizeof(u32);
> +		memcpy(cdesc->control_data.token, req->info, AES_BLOCK_SIZE);
> +
> +		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
> +	}
> +
> +	token = (struct safexcel_token *)(cdesc->control_data.token + offset);
> +
> +	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
> +	token[0].packet_length = length;
> +	token[0].stat = EIP197_TOKEN_STAT_LAST_PACKET;
> +	token[0].instructions = EIP197_TOKEN_INS_LAST |
> +				EIP197_TOKEN_INS_TYPE_CRYTO |
> +				EIP197_TOKEN_INS_TYPE_OUTPUT;
> +}
> +
> +static int safexcel_aes_setkey(struct crypto_ablkcipher *ctfm, const u8
> *key, +			       unsigned int len)
> +{

You still use ablkcipher. I thought that it is on its way out in favor of the 
skcipher API. Why do you stick to ablkcipher?

Note, a change could be as simple as s/ablkcipher/skcipher/g

> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ctfm);
> +	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct crypto_aes_ctx aes;
> +	int ret, i;
> +
> +	ret = crypto_aes_expand_key(&aes, key, len);
> +	if (ret) {
> +		crypto_ablkcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < len / sizeof(u32); i++) {
> +		if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
> +			ctx->base.needs_inv = true;
> +			break;
> +		}
> +	}
> +
> +	for (i = 0; i < len / sizeof(u32); i++)
> +		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
> +
> +	ctx->key_len = len;

memzero_explicit(aes)?

> +
> +	return 0;
> +}
> +
> +static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
> +				    struct safexcel_command_desc *cdesc)
> +{
> +	struct safexcel_crypto_priv *priv = ctx->priv;
> +	int ctrl_size;
> +
> +	if (ctx->direction == SAFEXCEL_ENCRYPT)
> +		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
> +	else
> +		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_IN;
> +
> +	cdesc->control_data.control0 |= CONTEXT_CONTROL_KEY_EN;
> +	cdesc->control_data.control1 |= ctx->mode;
> +
> +	switch (ctx->key_len) {
> +	case AES_KEYSIZE_128:
> +		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES128;
> +		ctrl_size = 4;
> +		break;
> +	case AES_KEYSIZE_192:
> +		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES192;
> +		ctrl_size = 6;
> +		break;
> +	case AES_KEYSIZE_256:
> +		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES256;
> +		ctrl_size = 8;
> +		break;
> +	default:
> +		dev_err(priv->dev, "aes keysize not supported: %u\n",
> +			ctx->key_len);
> +		return -EINVAL;
> +	}
> +	cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(ctrl_size);
> +
> +	return 0;
> +}
> +
> +static int safexcel_handle_result(struct safexcel_crypto_priv *priv, int
> ring, +				  struct crypto_async_request *async,
> +				  bool *should_complete, int *ret)
> +{
> +	struct ablkcipher_request *req = ablkcipher_request_cast(async);
> +	struct safexcel_result_desc *rdesc;
> +	int ndesc = 0;
> +
> +	*ret = 0;
> +
> +	spin_lock_bh(&priv->ring[ring].egress_lock);
> +	do {
> +		rdesc = safexcel_ring_next_rptr(priv, &priv->ring[ring].rdr);
> +		if (IS_ERR(rdesc)) {
> +			dev_err(priv->dev,
> +				"cipher: result: could not retrieve the result descriptor\n");
> +			*ret = PTR_ERR(rdesc);
> +			break;
> +		}
> +
> +		if (rdesc->result_data.error_code) {
> +			dev_err(priv->dev,
> +				"cipher: result: result descriptor error (%d)\n",
> +				rdesc->result_data.error_code);
> +			*ret = -EIO;
> +		}
> +
> +		ndesc++;
> +	} while (!rdesc->last_seg);
> +
> +	safexcel_complete(priv, ring);
> +	spin_unlock_bh(&priv->ring[ring].egress_lock);
> +
> +	if (req->src == req->dst) {
> +		dma_unmap_sg(priv->dev, req->src,
> +			     sg_nents_for_len(req->src, req->nbytes),
> +			     DMA_BIDIRECTIONAL);
> +	} else {
> +		dma_unmap_sg(priv->dev, req->src,
> +			     sg_nents_for_len(req->src, req->nbytes),
> +			     DMA_TO_DEVICE);
> +		dma_unmap_sg(priv->dev, req->dst,
> +			     sg_nents_for_len(req->dst, req->nbytes),
> +			     DMA_FROM_DEVICE);
> +	}
> +
> +	*should_complete = true;
> +
> +	return ndesc;
> +}
> +
> +static int safexcel_aes_send(struct crypto_async_request *async,
> +			     int ring, struct safexcel_request *request,
> +			     int *commands, int *results)
> +{
> +	struct ablkcipher_request *req = ablkcipher_request_cast(async);
> +	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct safexcel_crypto_priv *priv = ctx->priv;
> +	struct safexcel_command_desc *cdesc;
> +	struct safexcel_result_desc *rdesc;
> +	struct scatterlist *sg;
> +	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = req->nbytes;
> +	int i, ret = 0;
> +
> +	request->req = &req->base;
> +
> +	if (req->src == req->dst) {
> +		nr_src = dma_map_sg(priv->dev, req->src,
> +				    sg_nents_for_len(req->src, req->nbytes),
> +				    DMA_BIDIRECTIONAL);
> +		nr_dst = nr_src;
> +		if (!nr_src)
> +			return -EINVAL;
> +	} else {
> +		nr_src = dma_map_sg(priv->dev, req->src,
> +				    sg_nents_for_len(req->src, req->nbytes),
> +				    DMA_TO_DEVICE);
> +		if (!nr_src)
> +			return -EINVAL;
> +
> +		nr_dst = dma_map_sg(priv->dev, req->dst,
> +				    sg_nents_for_len(req->dst, req->nbytes),
> +				    DMA_FROM_DEVICE);
> +		if (!nr_dst) {
> +			dma_unmap_sg(priv->dev, req->src,
> +				     sg_nents_for_len(req->src, req->nbytes),
> +				     DMA_TO_DEVICE);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);

Is ctxr->data properly zeroized?


Ciao
Stephan
