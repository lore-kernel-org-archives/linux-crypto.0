Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0918926FA6F;
	Thu,  4 Jun 2026 09:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780567057; cv=none; b=jlML5hrUUPPabbghxNXeao3UcYKxqBRT5Y5wYTYd8Ptae13zTUlvWFjKfOy+ffE4gylhabbd7FH4OZLhMSRAapuL8etLL77tS9nlGzuSS9blPTWvJa7j9elP0W1hJdi03YuayWXxtYXd8RXmLqa8sMC5GyPY7CuNPlJcK7VOe34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780567057; c=relaxed/simple;
	bh=nIxCL9Gzv1aZVheYVe15xkgJ4DW6+zEUPpXz+QDBz4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JstgDk11396n1uUqIK+Qnf4Tm9KN77WzDf7MpBA1XhkMgjxBHz3XSvh1yI2mMXFGGg6xqPwVwJK3pXbmapNxPU6vGxxy223z1Fcw3TN9fRBDndTmKBXVunjiZPK6wkG8hQwu38OuTI+EqADqNtJh8nVr4d8kh9aItsc5puP+uXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2Nyh+8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2Nyh+8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2681F00893;
	Thu,  4 Jun 2026 09:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780567054;
	bh=xbqZPPLRj9PsoVY8m0EbXAgX7+0lvAXnf0lL5KyqYFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i2Nyh+8UWU44sQl0SB2DmbOK6GPSa81gWcympDqsGsADnHMfnGxvumpz58Kyet0va
	 IV2fGI6ecoShmNPgLTxDsV67HB+nm+GKw67mUHiTjyJ2Gh59oa+OVFBsaN3jtsse6R
	 XgScRtTidSEWpGBwOkYbh8WF32ZplZ2zDJDhkhWobBiYgNew788GTtAussJDBGrHa7
	 H57BovmGiXYHWPS3wrIUVMMHvO/MoRxfgjAsbZSa07YHoH6GV0bRcSm99LiAORVH6s
	 AFNQi9wcHCDwdeHbmwf8kKB8dxmt7SOLlanx1nYORkXUKuHPATaeOGQkiX2qBWdUFN
	 UKDJZpli/+O+Q==
Message-ID: <a4c06e1e-e9f2-4144-a2c1-68b8a12cd24f@kernel.org>
Date: Thu, 4 Jun 2026 11:57:30 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 27/29] crypto: talitos - Introduce per-SEC-version
 descriptor structures and ops
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-27-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-27-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> The driver used a single shared talitos_desc with overlapping union
> members and a SEC1-specific "hdr1" hack to handle differences between
> SEC1 and SEC2 descriptor layouts.

I'd call it a feature not a hack. We have the chance that allthough 
different the structures are very close and can be kept common at the 
low price of that copy from hdr to hdr1 in talitos submit.

> 
> Introduce distinct sec1_talitos_desc/sec2_talitos_desc and
> sec1_talitos_ptr/sec2_talitos_ptr structures, nested inside a union
> in talitos_desc/talitos_ptr.
> Mark them packed to reflect that these structures are used directly by
> the hardware, even if the structure is naturally aligned.
> 
> Abstract descriptor field access through a new talitos_desc_ops
> structure (set_hdr, get_hdr, get_hdr_lo, get_ptr), and add get_ptr_value
> to the existing talitos_ptr_ops.

Too much abstraction and opacity kills readability and maintainability. 
Especially here your change increases the number of places you have to 
break instructions in two lines or more. This really kills readability.

I really prefer reading

   &edesc->desc.ptr[6]

over

   ctx->desc_ops->get_ptr(&edesc->desc, 6)



> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   drivers/crypto/talitos/talitos-aead.c     | 76 +++++++++++++++++++------------
>   drivers/crypto/talitos/talitos-hash.c     | 51 +++++++++++++--------
>   drivers/crypto/talitos/talitos-sec1.c     | 61 +++++++++++++++++++------
>   drivers/crypto/talitos/talitos-sec2.c     | 56 ++++++++++++++++++-----
>   drivers/crypto/talitos/talitos-skcipher.c | 46 +++++++++++--------
>   drivers/crypto/talitos/talitos.c          |  4 +-
>   drivers/crypto/talitos/talitos.h          | 60 +++++++++++++++++-------
>   7 files changed, 244 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
> index b585abdd2275..d1cec7e4dd3f 100644
> --- a/drivers/crypto/talitos/talitos-aead.c
> +++ b/drivers/crypto/talitos/talitos-aead.c
> @@ -94,12 +94,15 @@ static void ipsec_esp_unmap(struct device *dev,
>   	unsigned int ivsize = crypto_aead_ivsize(aead);
>   	unsigned int authsize = crypto_aead_authsize(aead);
>   	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
> -	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
> -	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
> +	bool is_ipsec_esp = ctx->desc_ops->get_hdr(&edesc->desc) &
> +			    DESC_HDR_TYPE_IPSEC_ESP;
> +	struct talitos_ptr *civ_ptr =
> +		ctx->desc_ops->get_ptr(&edesc->desc, is_ipsec_esp ? 2 : 3);
>   
>   	if (is_ipsec_esp)
> -		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
> -					 DMA_FROM_DEVICE);
> +		unmap_single_talitos_ptr(
> +			dev, ctx->desc_ops->get_ptr(&edesc->desc, 6),
> +			DMA_FROM_DEVICE);
>   	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
>   
>   	talitos_sg_unmap(dev, edesc, areq->src, areq->dst,
> @@ -171,6 +174,7 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
>   					  struct talitos_desc *desc,
>   					  void *context, int err)
>   {
> +	struct talitos_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(context));
>   	struct aead_request *req = context;
>   	struct talitos_edesc *edesc;
>   
> @@ -179,8 +183,8 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
>   	ipsec_esp_unmap(dev, edesc, req, false);
>   
>   	/* check ICV auth status */
> -	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
> -		     DESC_HDR_LO_ICCR1_PASS))
> +	if (!err && ((ctx->desc_ops->get_hdr_lo(desc) &
> +		      DESC_HDR_LO_ICCR1_MASK) != DESC_HDR_LO_ICCR1_PASS))
>   		err = -EBADMSG;
>   
>   	kfree(edesc);
> @@ -210,13 +214,17 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   	bool sync_needed = false;
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	bool is_sec1 = has_ftr_sec1(priv);
> -	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
> -	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
> -	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
> +	bool is_ipsec_esp = ctx->desc_ops->get_hdr(desc) &
> +			    DESC_HDR_TYPE_IPSEC_ESP;
> +	struct talitos_ptr *civ_ptr =
> +		ctx->desc_ops->get_ptr(desc, is_ipsec_esp ? 2 : 3);
> +	struct talitos_ptr *ckey_ptr =
> +		ctx->desc_ops->get_ptr(desc, is_ipsec_esp ? 3 : 2);
>   	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
>   
>   	/* hmac key */
> -	ctx->ptr_ops->to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen);
> +	ctx->ptr_ops->to_talitos_ptr(ctx->desc_ops->get_ptr(desc, 0),
> +				     ctx->dma_key, ctx->authkeylen);
>   
>   	sg_count = edesc->src_nents ?: 1;
>   	if (is_sec1 && sg_count > 1)
> @@ -229,7 +237,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   
>   	/* hmac data */
>   	ret = talitos_sg_map(dev, areq->src, areq->assoclen, edesc,
> -			     &desc->ptr[1], sg_count, 0, tbl_off);
> +			     ctx->desc_ops->get_ptr(desc, 1), sg_count, 0,
> +			     tbl_off);
>   
>   	if (ret > 1) {
>   		tbl_off += ret;
> @@ -249,12 +258,13 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   	 * extent is bytes of HMAC postpended to ciphertext,
>   	 * typically 12 for ipsec
>   	 */
> -	if (is_ipsec_esp && (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
> +	if (is_ipsec_esp &&
> +	    (ctx->desc_ops->get_hdr(desc) & DESC_HDR_MODE1_MDEU_CICV))
>   		elen = authsize;
>   
> -	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
> -				 sg_count, areq->assoclen, tbl_off, elen,
> -				 false, 1);
> +	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc,
> +				 ctx->desc_ops->get_ptr(desc, 4), sg_count,
> +				 areq->assoclen, tbl_off, elen, false, 1);
>   
>   	if (ret > 1) {
>   		tbl_off += ret;
> @@ -272,8 +282,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   		elen = authsize;
>   	else
>   		elen = 0;
> -	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
> -				 sg_count, areq->assoclen, tbl_off, elen,
> +	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc,
> +				 ctx->desc_ops->get_ptr(desc, 5), sg_count,
> +				 areq->assoclen, tbl_off, elen,
>   				 is_ipsec_esp && !encrypt, 1);
>   	tbl_off += ret;
>   
> @@ -286,20 +297,23 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>   
>   		/* icv data follows link tables */
>   		ctx->ptr_ops->to_talitos_ptr(tbl_ptr, dma_icv, authsize);
> -		ctx->ptr_ops->to_talitos_ptr_ext_or(&desc->ptr[5], authsize);
> +		ctx->ptr_ops->to_talitos_ptr_ext_or(
> +			ctx->desc_ops->get_ptr(desc, 5), authsize);
>   		sync_needed = true;
>   	} else if (!encrypt) {
> -		ctx->ptr_ops->to_talitos_ptr(&desc->ptr[6], dma_icv, authsize);
> +		ctx->ptr_ops->to_talitos_ptr(ctx->desc_ops->get_ptr(desc, 6),
> +					     dma_icv, authsize);
>   		sync_needed = true;
>   	} else if (!is_ipsec_esp) {
> -		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
> -			       sg_count, areq->assoclen + cryptlen, tbl_off);
> +		talitos_sg_map(dev, areq->dst, authsize, edesc,
> +			       ctx->desc_ops->get_ptr(desc, 6), sg_count,
> +			       areq->assoclen + cryptlen, tbl_off);
>   	}
>   
>   	/* iv out */
>   	if (is_ipsec_esp)
> -		map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
> -				       DMA_FROM_DEVICE);
> +		map_single_talitos_ptr(dev, ctx->desc_ops->get_ptr(desc, 6),
> +				       ivsize, ctx->iv, DMA_FROM_DEVICE);
>   
>   	if (sync_needed)
>   		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
> @@ -341,7 +355,7 @@ static int aead_encrypt(struct aead_request *req)
>   		return PTR_ERR(edesc);
>   
>   	/* set encrypt */
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
> +	ctx->desc_ops->set_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT);
>   
>   	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
>   }
> @@ -354,21 +368,24 @@ static int aead_decrypt(struct aead_request *req)
>   	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
>   	struct talitos_edesc *edesc;
>   	void *icvdata;
> +	__be32 hdr;
>   
>   	/* allocate extended descriptor */
>   	edesc = aead_edesc_alloc(req, req->iv, 1, false);
>   	if (IS_ERR(edesc))
>   		return PTR_ERR(edesc);
>   
> -	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
> +	hdr = ctx->desc_ops->get_hdr(&edesc->desc);
> +	if ((hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
>   	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
>   	    ((!edesc->src_nents && !edesc->dst_nents) ||
>   	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
>   
>   		/* decrypt and check the ICV */
> -		edesc->desc.hdr = ctx->desc_hdr_template |
> -				  DESC_HDR_DIR_INBOUND |
> -				  DESC_HDR_MODE1_MDEU_CICV;
> +		ctx->desc_ops->set_hdr(&edesc->desc,
> +				       ctx->desc_hdr_template |
> +					       DESC_HDR_DIR_INBOUND |
> +					       DESC_HDR_MODE1_MDEU_CICV);
>   
>   		/* reset integrity check result bits */
>   
> @@ -377,7 +394,8 @@ static int aead_decrypt(struct aead_request *req)
>   	}
>   
>   	/* Have to check the ICV with software */
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
> +	ctx->desc_ops->set_hdr(&edesc->desc,
> +			       ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND);
>   
>   	/* stash incoming ICV for later cmp with ICV generated by the h/w */
>   	icvdata = edesc->buf + edesc->dma_len;
> diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
> index 026eebf037f5..fb4d53e2abf8 100644
> --- a/drivers/crypto/talitos/talitos-hash.c
> +++ b/drivers/crypto/talitos/talitos-hash.c
> @@ -44,7 +44,8 @@ static void common_nonsnoop_hash_unmap(struct talitos_ctx *ctx,
>   	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
>   	struct talitos_desc *desc = &edesc->desc;
>   
> -	unmap_single_talitos_ptr(ctx->dev, &desc->ptr[5], DMA_FROM_DEVICE);
> +	unmap_single_talitos_ptr(ctx->dev, ctx->desc_ops->get_ptr(desc, 5),
> +				 DMA_FROM_DEVICE);
>   
>   	if (edesc->last && req_ctx->last_request)
>   		memcpy(areq->result, req_ctx->hw_context,
> @@ -54,8 +55,9 @@ static void common_nonsnoop_hash_unmap(struct talitos_ctx *ctx,
>   		talitos_sg_unmap(ctx->dev, edesc, edesc->src, NULL, 0, 0);
>   
>   	/* When using hashctx-in, must unmap it. */
> -	if (ctx->ptr_ops->from_talitos_ptr_len(&desc->ptr[1]))
> -		unmap_single_talitos_ptr(ctx->dev, &desc->ptr[1],
> +	if (ctx->ptr_ops->from_talitos_ptr_len(ctx->desc_ops->get_ptr(desc, 1)))
> +		unmap_single_talitos_ptr(ctx->dev,
> +					 ctx->desc_ops->get_ptr(desc, 1),
>   					 DMA_TO_DEVICE);
>   
>   	if (edesc->dma_len)
> @@ -131,7 +133,9 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
>   	};
>   
>   	pr_err_once("Bug in SEC1, padding ourself\n");
> -	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
> +	ctx->desc_ops->set_hdr(&edesc->desc,
> +			       ctx->desc_ops->get_hdr(&edesc->desc) &
> +				       ~DESC_HDR_MODE0_MDEU_PAD);
>   	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
>   			       (char *)padded_hash, DMA_TO_DEVICE);
>   }
> @@ -154,7 +158,8 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
>   
>   	/* hash context in */
>   	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
> -		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
> +		map_single_talitos_ptr_nosync(dev,
> +					      ctx->desc_ops->get_ptr(desc, 1),
>   					      req_ctx->hw_context_size,
>   					      req_ctx->hw_context,
>   					      DMA_TO_DEVICE);
> @@ -165,8 +170,8 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
>   
>   	/* HMAC key */
>   	if (ctx->keylen)
> -		ctx->ptr_ops->to_talitos_ptr(&desc->ptr[2], ctx->dma_key,
> -					     ctx->keylen);
> +		ctx->ptr_ops->to_talitos_ptr(ctx->desc_ops->get_ptr(desc, 2),
> +					     ctx->dma_key, ctx->keylen);
>   
>   	sg_count = edesc->src_nents ?: 1;
>   	if (is_sec1 && sg_count > 1)
> @@ -177,8 +182,10 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
>   	/*
>   	 * data in
>   	 */
> -	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr[3],
> -				  sg_count, 0, 0);
> +	sg_count = talitos_sg_map(dev, edesc->src, length, edesc,
> +				  ctx->desc_ops->get_ptr(desc, 3), sg_count, 0,
> +				  0);
> +
>   	if (sg_count > 1)
>   		sync_needed = true;
>   
> @@ -186,19 +193,22 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
>   
>   	/* hash/HMAC out -or- hash context out */
>   	if (edesc->last && req_ctx->last_request)
> -		map_single_talitos_ptr(dev, &desc->ptr[5],
> +		map_single_talitos_ptr(dev, ctx->desc_ops->get_ptr(desc, 5),
>   				       crypto_ahash_digestsize(tfm),
>   				       req_ctx->hw_context, DMA_FROM_DEVICE);
>   	else
> -		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
> +		map_single_talitos_ptr_nosync(dev,
> +					      ctx->desc_ops->get_ptr(desc, 5),
>   					      req_ctx->hw_context_size,
>   					      req_ctx->hw_context,
>   					      DMA_FROM_DEVICE);
>   
>   	/* last DWORD empty */
>   
> -	if (is_sec1 && ctx->ptr_ops->from_talitos_ptr_len(&desc->ptr[3]) == 0)
> -		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
> +	if (is_sec1 && ctx->ptr_ops->from_talitos_ptr_len(
> +			       ctx->desc_ops->get_ptr(desc, 3)) == 0)
> +		talitos_handle_buggy_hash(ctx, edesc,
> +					  ctx->desc_ops->get_ptr(desc, 3));
>   
>   	if (sync_needed)
>   		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
> @@ -229,6 +239,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
>   	size_t to_hash_this_desc;
>   	struct scatterlist *src;
>   	size_t offset = 0;
> +	__be32 hdr;
>   
>   	do {
>   		src = scatterwalk_ffwd(tmp, areq->src, offset);
> @@ -245,19 +256,19 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
>   		}
>   
>   		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
> -		edesc->desc.hdr = ctx->desc_hdr_template;
> +		hdr = ctx->desc_hdr_template;
>   		edesc->first = offset == 0;
>   		edesc->last = nbytes - to_hash_this_desc == 0;
>   
>   		/* On last one, request SEC to pad; otherwise continue */
>   		if (req_ctx->last_request && edesc->last)
> -			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
> +			hdr |= DESC_HDR_MODE0_MDEU_PAD;
>   		else
> -			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
> +			hdr |= DESC_HDR_MODE0_MDEU_CONT;
>   
>   		/* request SEC to INIT hash. */
>   		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
> -			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
> +			hdr |= DESC_HDR_MODE0_MDEU_INIT;
>   
>   		/*
>   		 * When the tfm context has a keylen, it's an HMAC.
> @@ -265,11 +276,13 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
>   		 */
>   		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
>   				    (req_ctx->last_request && edesc->last)))
> -			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
> +			hdr |= DESC_HDR_MODE0_MDEU_HMAC;
>   
>   		/* clear the DN bit  */
>   		if (is_sec1 && !edesc->last)
> -			edesc->desc.hdr &= ~DESC_HDR_DONE_NOTIFY;
> +			hdr &= ~DESC_HDR_DONE_NOTIFY;
> +
> +		ctx->desc_ops->set_hdr(&edesc->desc, hdr);
>   
>   		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
>   
> diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/talitos/talitos-sec1.c
> index ef1bd19b6772..e4f482520372 100644
> --- a/drivers/crypto/talitos/talitos-sec1.c
> +++ b/drivers/crypto/talitos/talitos-sec1.c
> @@ -76,20 +76,20 @@ DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
>   static void sec1_to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
>   				unsigned int len)
>   {
> -	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
> -	ptr->len1 = cpu_to_be16(len);
> +	ptr->sec1.ptr = cpu_to_be32(lower_32_bits(dma_addr));
> +	ptr->sec1.len = cpu_to_be16(len);
>   }
>   
>   static void sec1_copy_talitos_ptr(struct talitos_ptr *dst_ptr,
>   				  struct talitos_ptr *src_ptr)
>   {
> -	dst_ptr->ptr = src_ptr->ptr;
> -	dst_ptr->len1 = src_ptr->len1;
> +	dst_ptr->sec1.ptr = src_ptr->sec1.ptr;
> +	dst_ptr->sec1.len = src_ptr->sec1.len;
>   }
>   
>   static unsigned short sec1_from_talitos_ptr_len(struct talitos_ptr *ptr)
>   {
> -	return be16_to_cpu(ptr->len1);
> +	return be16_to_cpu(ptr->sec1.len);
>   }
>   
>   static void sec1_to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
> @@ -100,6 +100,31 @@ static void sec1_to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
>   {
>   }
>   
> +static __be32 sec1_get_ptr_value(struct talitos_ptr *ptr)
> +{
> +	return ptr->sec1.ptr;
> +}
> +
> +static __be32 sec1_get_hdr(struct talitos_desc *desc)
> +{
> +	return desc->sec1.hdr;
> +}
> +
> +static __be32 sec1_get_hdr_lo(struct talitos_desc *desc)
> +{
> +	return 0;
> +}
> +
> +static void sec1_set_hdr(struct talitos_desc *desc, __be32 val)
> +{
> +	desc->sec1.hdr = val;
> +}
> +
> +static struct talitos_ptr *sec1_get_ptr(struct talitos_desc *desc, size_t idx)
> +{
> +	return (struct talitos_ptr *)&desc->sec1.ptr[idx];
> +}
> +
>   static int sec1_reset_device(struct device *dev)
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
> @@ -163,9 +188,8 @@ static void sec1_dma_map_request(struct device *dev,
>   	struct talitos_edesc *prev_edesc = NULL;
>   
>   	while (edesc) {
> -		edesc->desc.hdr1 = edesc->desc.hdr;
>   
> -		dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
> +		dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
>   					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
>   
>   		if (!prev_edesc) {
> @@ -175,7 +199,7 @@ static void sec1_dma_map_request(struct device *dev,
>   
>   		/* Chain in any previous descriptors. */
>   
> -		prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
> +		prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
>   
>   		dma_sync_single_for_device(dev, prev_dma_desc,
>   					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
> @@ -196,7 +220,7 @@ static void sec1_dma_unmap_request(struct device *dev,
>   			 DMA_BIDIRECTIONAL);
>   	edesc = container_of(request->desc, struct talitos_edesc, desc);
>   	while (edesc->next_desc) {
> -		dma_unmap_single(dev, be32_to_cpu(edesc->desc.next_desc),
> +		dma_unmap_single(dev, be32_to_cpu(edesc->desc.sec1.next_desc),
>   				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
>   		edesc = edesc->next_desc;
>   	}
> @@ -211,14 +235,14 @@ static __be32 sec1_get_request_hdr(struct device *dev,
>   	edesc = container_of(request->desc, struct talitos_edesc, desc);
>   	dma_desc = request->dma_desc;
>   	while (edesc->next_desc) {
> -		dma_desc = be32_to_cpu(edesc->desc.next_desc);
> +		dma_desc = be32_to_cpu(edesc->desc.sec1.next_desc);
>   		edesc = edesc->next_desc;
>   	}
>   
>   	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
>   				DMA_BIDIRECTIONAL);
>   
> -	return edesc->desc.hdr1;
> +	return edesc->desc.sec1.hdr;
>   }
>   
>   static __be32 sec1_search_desc_hdr_in_request(struct talitos_request *request,
> @@ -228,12 +252,12 @@ static __be32 sec1_search_desc_hdr_in_request(struct talitos_request *request,
>   
>   
>   	if (request->dma_desc == cur_desc)
> -		return request->desc->hdr;
> +		return request->desc->sec1.hdr;
>   
>   	edesc = container_of(request->desc, struct talitos_edesc, desc);
>   	while (edesc->next_desc) {
> -		if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
> -			return edesc->next_desc->desc.hdr1;
> +		if (edesc->desc.sec1.next_desc == cpu_to_be32(cur_desc))
> +			return edesc->next_desc->desc.sec1.hdr;
>   		edesc = edesc->next_desc;
>   	}
>   
> @@ -319,6 +343,14 @@ static const struct talitos_ptr_ops sec1_ptr_ops = {
>   	.from_talitos_ptr_len = sec1_from_talitos_ptr_len,
>   	.to_talitos_ptr_ext_set = sec1_to_talitos_ptr_ext_set,
>   	.to_talitos_ptr_ext_or = sec1_to_talitos_ptr_ext_or,
> +	.get_ptr_value = sec1_get_ptr_value,
> +};
> +
> +static const struct talitos_desc_ops sec1_desc_ops = {
> +	.set_hdr = sec1_set_hdr,
> +	.get_hdr = sec1_get_hdr,
> +	.get_hdr_lo = sec1_get_hdr_lo,
> +	.get_ptr = sec1_get_ptr,
>   };
>   
>   static const struct talitos_ops sec1_ops = {
> @@ -337,5 +369,6 @@ static const struct talitos_ops sec1_ops = {
>   void talitos_register_sec1(struct talitos_private *priv)
>   {
>   	priv->ops = &sec1_ops;
> +	priv->desc_ops = &sec1_desc_ops;
>   	priv->ptr_ops = &sec1_ptr_ops;
>   }
> diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/talitos/talitos-sec2.c
> index 14f0ca13e6e5..52f783ddc8b6 100644
> --- a/drivers/crypto/talitos/talitos-sec2.c
> +++ b/drivers/crypto/talitos/talitos-sec2.c
> @@ -82,32 +82,57 @@ DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
>   static void sec2_to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
>   				unsigned int len)
>   {
> -	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
> -	ptr->len = cpu_to_be16(len);
> -	ptr->eptr = upper_32_bits(dma_addr);
> +	ptr->sec2.ptr = cpu_to_be32(lower_32_bits(dma_addr));
> +	ptr->sec2.len = cpu_to_be16(len);
> +	ptr->sec2.eptr = upper_32_bits(dma_addr);
>   }
>   
>   static void sec2_copy_talitos_ptr(struct talitos_ptr *dst_ptr,
>   				  struct talitos_ptr *src_ptr)
>   {
> -	dst_ptr->ptr = src_ptr->ptr;
> -	dst_ptr->len = src_ptr->len;
> -	dst_ptr->eptr = src_ptr->eptr;
> +	dst_ptr->sec2.ptr = src_ptr->sec2.ptr;
> +	dst_ptr->sec2.len = src_ptr->sec2.len;
> +	dst_ptr->sec2.eptr = src_ptr->sec2.eptr;
>   }
>   
>   static unsigned short sec2_from_talitos_ptr_len(struct talitos_ptr *ptr)
>   {
> -	return be16_to_cpu(ptr->len);
> +	return be16_to_cpu(ptr->sec2.len);
>   }
>   
>   static void sec2_to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
>   {
> -	ptr->j_extent = val;
> +	ptr->sec2.j_extent = val;
>   }
>   
>   static void sec2_to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
>   {
> -	ptr->j_extent |= val;
> +	ptr->sec2.j_extent |= val;
> +}
> +
> +static __be32 sec2_get_ptr_value(struct talitos_ptr *ptr)
> +{
> +	return ptr->sec2.ptr;
> +}
> +
> +static __be32 sec2_get_hdr(struct talitos_desc *desc)
> +{
> +	return desc->sec2.hdr;
> +}
> +
> +static __be32 sec2_get_hdr_lo(struct talitos_desc *desc)
> +{
> +	return desc->sec2.hdr_lo;
> +}
> +
> +static void sec2_set_hdr(struct talitos_desc *desc, __be32 val)
> +{
> +	desc->sec2.hdr = val;
> +}
> +
> +static struct talitos_ptr *sec2_get_ptr(struct talitos_desc *desc, size_t idx)
> +{
> +	return (struct talitos_ptr *)&desc->sec2.ptr[idx];
>   }
>   
>   static int sec2_reset_channel(struct device *dev, int ch)
> @@ -331,14 +356,14 @@ static __be32 sec2_get_request_hdr(struct device *dev,
>   	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
>   				DMA_BIDIRECTIONAL);
>   
> -	return request->desc->hdr;
> +	return request->desc->sec2.hdr;
>   }
>   
>   static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
>   					      dma_addr_t cur_desc)
>   {
>   	if (request->dma_desc == cur_desc)
> -		return request->desc->hdr;
> +		return request->desc->sec2.hdr;
>   	return 0;
>   }
>   
> @@ -348,6 +373,14 @@ static const struct talitos_ptr_ops sec2_ptr_ops = {
>   	.from_talitos_ptr_len = sec2_from_talitos_ptr_len,
>   	.to_talitos_ptr_ext_set = sec2_to_talitos_ptr_ext_set,
>   	.to_talitos_ptr_ext_or = sec2_to_talitos_ptr_ext_or,
> +	.get_ptr_value = sec2_get_ptr_value,
> +};
> +
> +static const struct talitos_desc_ops sec2_desc_ops = {
> +	.set_hdr = sec2_set_hdr,
> +	.get_hdr = sec2_get_hdr,
> +	.get_hdr_lo = sec2_get_hdr_lo,
> +	.get_ptr = sec2_get_ptr,
>   };
>   
>   static const struct talitos_ops sec2_ops = {
> @@ -366,5 +399,6 @@ static const struct talitos_ops sec2_ops = {
>   void talitos_register_sec2(struct talitos_private *priv)
>   {
>   	priv->ops = &sec2_ops;
> +	priv->desc_ops = &sec2_desc_ops;
>   	priv->ptr_ops = &sec2_ptr_ops;
>   }
> diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
> index a96f827c7b93..58ad931ff3a4 100644
> --- a/drivers/crypto/talitos/talitos-skcipher.c
> +++ b/drivers/crypto/talitos/talitos-skcipher.c
> @@ -11,17 +11,21 @@
>   
>   #include "talitos.h"
>   
> -static void common_nonsnoop_unmap(struct device *dev,
> +static void common_nonsnoop_unmap(struct talitos_ctx *ctx,
>   				  struct talitos_edesc *edesc,
>   				  struct skcipher_request *areq)
>   {
> -	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
> +	unmap_single_talitos_ptr(ctx->dev,
> +				 ctx->desc_ops->get_ptr(&edesc->desc, 5),
> +				 DMA_FROM_DEVICE);
>   
> -	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen, 0);
> -	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
> +	talitos_sg_unmap(ctx->dev, edesc, areq->src, areq->dst, areq->cryptlen, 0);
> +	unmap_single_talitos_ptr(ctx->dev,
> +				 ctx->desc_ops->get_ptr(&edesc->desc, 1),
> +				 DMA_TO_DEVICE);
>   
>   	if (edesc->dma_len)
> -		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
> +		dma_unmap_single(ctx->dev, edesc->dma_link_tbl, edesc->dma_len,
>   				 DMA_BIDIRECTIONAL);
>   }
>   
> @@ -37,7 +41,7 @@ static void skcipher_done(struct device *dev,
>   
>   	edesc = container_of(desc, struct talitos_edesc, desc);
>   
> -	common_nonsnoop_unmap(dev, edesc, areq);
> +	common_nonsnoop_unmap(ctx, edesc, areq);
>   	memcpy(areq->iv, ctx->iv, ivsize);
>   
>   	kfree(edesc);
> @@ -61,16 +65,18 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>   	bool sync_needed = false;
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   	bool is_sec1 = has_ftr_sec1(priv);
> -	bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
> -		      (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
> +	bool is_ctr = (ctx->desc_ops->get_hdr(desc) & DESC_HDR_SEL0_MASK) ==
> +			      DESC_HDR_SEL0_AESU &&
> +		      (ctx->desc_ops->get_hdr(desc) &
> +		       DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
>   
>   	/* first DWORD empty */
>   
>   	/* cipher iv */
> -	ctx->ptr_ops->to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize);
> +	ctx->ptr_ops->to_talitos_ptr(ctx->desc_ops->get_ptr(desc, 1), edesc->iv_dma, ivsize);
>   
>   	/* cipher key */
> -	ctx->ptr_ops->to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
> +	ctx->ptr_ops->to_talitos_ptr(ctx->desc_ops->get_ptr(desc, 2), ctx->dma_key, ctx->keylen);
>   
>   	sg_count = edesc->src_nents ?: 1;
>   	if (is_sec1 && sg_count > 1)
> @@ -83,8 +89,9 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>   	/*
>   	 * cipher in
>   	 */
> -	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[3],
> -				      sg_count, 0, 0, 0, false, is_ctr ? 16 : 1);
> +	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc,
> +				      ctx->desc_ops->get_ptr(desc, 3), sg_count,
> +				      0, 0, 0, false, is_ctr ? 16 : 1);
>   	if (sg_count > 1)
>   		sync_needed = true;
>   
> @@ -95,14 +102,15 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>   			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
>   	}
>   
> -	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[4],
> -			     sg_count, 0, (edesc->src_nents + 1));
> +	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc,
> +			     ctx->desc_ops->get_ptr(desc, 4), sg_count, 0,
> +			     (edesc->src_nents + 1));
>   	if (ret > 1)
>   		sync_needed = true;
>   
>   	/* iv out */
> -	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv,
> -			       DMA_FROM_DEVICE);
> +	map_single_talitos_ptr(dev, ctx->desc_ops->get_ptr(desc, 5), ivsize,
> +			       ctx->iv, DMA_FROM_DEVICE);
>   
>   	/* last DWORD empty */
>   
> @@ -112,7 +120,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>   
>   	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
>   	if (ret != -EINPROGRESS) {
> -		common_nonsnoop_unmap(dev, edesc, areq);
> +		common_nonsnoop_unmap(ctx, edesc, areq);
>   		kfree(edesc);
>   	}
>   	return ret;
> @@ -191,7 +199,7 @@ static int skcipher_encrypt(struct skcipher_request *areq)
>   		return PTR_ERR(edesc);
>   
>   	/* set encrypt */
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
> +	ctx->desc_ops->set_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT);
>   
>   	return common_nonsnoop(edesc, areq, skcipher_done);
>   }
> @@ -215,7 +223,7 @@ static int skcipher_decrypt(struct skcipher_request *areq)
>   	if (IS_ERR(edesc))
>   		return PTR_ERR(edesc);
>   
> -	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
> +	ctx->desc_ops->set_hdr(&edesc->desc, ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND);
>   
>   	return common_nonsnoop(edesc, areq, skcipher_done);
>   }
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index 19e63ce6cc3e..a032907e900f 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -81,7 +81,7 @@ void unmap_single_talitos_ptr(struct device *dev,
>   {
>   	struct talitos_private *priv = dev_get_drvdata(dev);
>   
> -	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
> +	dma_unmap_single(dev, be32_to_cpu(priv->ptr_ops->get_ptr_value(ptr)),
>   			 priv->ptr_ops->from_talitos_ptr_len(ptr), dir);
>   }
>   
> @@ -625,6 +625,8 @@ int talitos_init_common(struct talitos_ctx *ctx,
>   
>   	ctx->ptr_ops = priv->ptr_ops;
>   
> +	ctx->desc_ops = priv->desc_ops;
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
> index 54e33da03fd0..2107fb1ade5d 100644
> --- a/drivers/crypto/talitos/talitos.h
> +++ b/drivers/crypto/talitos/talitos.h
> @@ -36,33 +36,49 @@
>   #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
>   
>   /* descriptor pointer entry */
> +
> +struct sec1_talitos_ptr {
> +	__be16 res;
> +	__be16 len;
> +	__be32 ptr;
> +} __packed;
> +
> +struct sec2_talitos_ptr {
> +	__be16 len;
> +	u8 j_extent;
> +	u8 eptr;
> +	__be32 ptr;
> +} __packed;
> +
>   struct talitos_ptr {
>   	union {
> -		struct {		/* SEC2 format */
> -			__be16 len;     /* length */
> -			u8 j_extent;    /* jump to sg link table and/or extent*/
> -			u8 eptr;        /* extended address */
> -		};
> -		struct {			/* SEC1 format */
> -			__be16 res;
> -			__be16 len1;	/* length */
> -		};
> +		struct sec1_talitos_ptr sec1;
> +		struct sec2_talitos_ptr sec2;
>   	};
> -	__be32 ptr;     /* address */
>   };
>   
> -/* descriptor */
> +/* descriptor format */
> +
> +struct sec1_talitos_desc {
> +	__be32 hdr;
> +	struct sec1_talitos_ptr ptr[7];
> +	__be32 next_desc;
> +} __packed;
> +
> +struct sec2_talitos_desc {
> +	__be32 hdr;
> +	__be32 hdr_lo;
> +	struct sec2_talitos_ptr ptr[7];
> +} __packed;
> +
>   struct talitos_desc {
> -	__be32 hdr;                     /* header high bits */
>   	union {
> -		__be32 hdr_lo;		/* header low bits */
> -		__be32 hdr1;		/* header for SEC1 */
> +		struct sec1_talitos_desc sec1;
> +		struct sec2_talitos_desc sec2;
>   	};
> -	struct talitos_ptr ptr[7];      /* ptr/len pair array */
> -	__be32 next_desc;		/* next descriptor (SEC1) */
>   };
>   
> -#define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc) - sizeof(__be32))
> +#define TALITOS_DESC_SIZE	sizeof(struct talitos_desc)
>   
>   /*
>    * talitos_edesc - s/w-extended descriptor
> @@ -148,6 +164,14 @@ struct talitos_ptr_ops {
>   	unsigned short (*from_talitos_ptr_len)(struct talitos_ptr *ptr);
>   	void (*to_talitos_ptr_ext_set)(struct talitos_ptr *ptr, u8 val);
>   	void (*to_talitos_ptr_ext_or)(struct talitos_ptr *ptr, u8 val);
> +	__be32 (*get_ptr_value)(struct talitos_ptr *ptr);
> +};
> +
> +struct talitos_desc_ops {
> +	void (*set_hdr)(struct talitos_desc *desc, __be32 val);
> +	__be32 (*get_hdr)(struct talitos_desc *desc);
> +	__be32 (*get_hdr_lo)(struct talitos_desc *desc);
> +	struct talitos_ptr *(*get_ptr)(struct talitos_desc *desc, size_t idx);
>   };
>   
>   struct talitos_ops {
> @@ -194,6 +218,7 @@ struct talitos_private {
>   
>   	const struct talitos_ops *ops;
>   	const struct talitos_ptr_ops *ptr_ops;
> +	const struct talitos_desc_ops *desc_ops;
>   
>   	/* SEC Compatibility info */
>   	unsigned long features;
> @@ -225,6 +250,7 @@ struct talitos_private {
>   struct talitos_ctx {
>   	struct device *dev;
>   	const struct talitos_ptr_ops *ptr_ops;
> +	const struct talitos_desc_ops *desc_ops;
>   	int ch;
>   	__be32 desc_hdr_template;
>   	u8 key[TALITOS_MAX_KEY_SIZE];
> 

