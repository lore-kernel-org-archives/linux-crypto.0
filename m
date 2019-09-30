Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4218C35280
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 16:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15FC216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 16:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="isZPLgxz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732330AbfI3Qcn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 12:32:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40310 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfI3Qcn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 12:32:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so5910408pfb.7
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 09:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TgAtzBTR9GVb1+VVw+AirmCcBrIK/gjv2Ur5vU5bS4Q=;
        b=isZPLgxzRR2p8XjDSYvy9EQHYeWYPl38+eLTVnyCVxIMrVA8eJpeblRB7CzqBfgJal
         Wnwu1Yuvf5vq8GtvDcr9/u5mJ9wQ4YDnyJB86JxlPDk1S/OeoHTUHs0PbIb7E6AZzrk2
         7z+FXgqj1lh2JdlOmn5Krq/vVf1RZ6SIuY6QPAOL0YmUsZ/miJZZdMo8E+tw2UXM5vhc
         M0vtVMqVuFm3+dr/eP3ouIj93QozF1rs8JGroCcP6wzHm/x5ESxOiaFZv9X+yptjc3D6
         eLvOEbKE1rx74OPVClwyH9ENhsMfjs8LXFb3r+jZdjXzUF2WPs/oNAcPk0AEexL4/wU/
         +BNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=TgAtzBTR9GVb1+VVw+AirmCcBrIK/gjv2Ur5vU5bS4Q=;
        b=b0imEMpr9v7TwMdDxgZ5zZnvEdZ7BtoF1yHfZ2x1d/KtIr9WftFT5uvwK5siHQucfm
         boyhdIiu/1luQ2mtYdgHpi6CNcZZMSqi9ZQUt4TZ9c4hEnxXrsYsezs3hLf2w0zvRSTx
         U8oVBQpZF99xCdGYX7bXjwCba9WnWdh6hleEvPc1CI97Aos8c4KzHombCSdzinYCVL65
         yirg7onOwu7j2e2sYWzGym79ge5pJfeGF54ZIti4jYLAez7FCEImoEiowmYkcn6SZ9n+
         j7ceeLoMj6qupnfDYYRGsiQvmM7cEYKk/dSIqb2Lfp8oSsMP/YeqNzWWJ8iXsLari1tJ
         Ga+g==
X-Gm-Message-State: APjAAAVRtLd935ftTNNiGcgyGSPQywzP0s6AYLz9jNItrDtN7PVXV2Xe
        9rjEqcyQrzP2GydOTwgY4RQ0+uWB
X-Google-Smtp-Source: APXvYqw+J/ts23kzVsR8sDR6Ab8dVdc3aYxRGHIdo2QaF1XsIiGfWbRPazVHDiyRpyIp6vbnk0n6gA==
X-Received: by 2002:a17:90a:1b46:: with SMTP id q64mr59861pjq.97.1569861162828;
        Mon, 30 Sep 2019 09:32:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w2sm11865663pfn.57.2019.09.30.09.32.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Sep 2019 09:32:42 -0700 (PDT)
Date:   Mon, 30 Sep 2019 09:32:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org
Subject: Re: [PATCH 15/17] crypto: arm/aes-ce - implement ciphertext stealing
 for CBC
Message-ID: <20190930163241.GA14355@roeck-us.net>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-16-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821143253.30209-16-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 21, 2019 at 05:32:51PM +0300, Ard Biesheuvel wrote:
> Instead of relying on the CTS template to wrap the accelerated CBC
> skcipher, implement the ciphertext stealing part directly.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

For arm:allmodconfig built with gcc 9.2.0, this patch results in

arch/arm/crypto/aes-ce-core.S: Assembler messages:
arch/arm/crypto/aes-ce-core.S:299: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:300: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:337: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:338: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:552: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:553: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:638: Error: selected processor does not support `movw ip,:lower16:.Lcts_permute_table' in ARM mode
arch/arm/crypto/aes-ce-core.S:639: Error: selected processor does not support `movt ip,:upper16:.Lcts_permute_table' in ARM mode

Any idea how to avoid that ?

Guenter

> ---
>  arch/arm/crypto/aes-ce-core.S |  85 +++++++++
>  arch/arm/crypto/aes-ce-glue.c | 188 ++++++++++++++++++--
>  2 files changed, 256 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
> index 763e51604ab6..b978cdf133af 100644
> --- a/arch/arm/crypto/aes-ce-core.S
> +++ b/arch/arm/crypto/aes-ce-core.S
> @@ -284,6 +284,91 @@ ENTRY(ce_aes_cbc_decrypt)
>  	pop		{r4-r6, pc}
>  ENDPROC(ce_aes_cbc_decrypt)
>  
> +
> +	/*
> +	 * ce_aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
> +	 *			  int rounds, int bytes, u8 const iv[])
> +	 * ce_aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
> +	 *			  int rounds, int bytes, u8 const iv[])
> +	 */
> +
> +ENTRY(ce_aes_cbc_cts_encrypt)
> +	push		{r4-r6, lr}
> +	ldrd		r4, r5, [sp, #16]
> +
> +	movw		ip, :lower16:.Lcts_permute_table
> +	movt		ip, :upper16:.Lcts_permute_table
> +	sub		r4, r4, #16
> +	add		lr, ip, #32
> +	add		ip, ip, r4
> +	sub		lr, lr, r4
> +	vld1.8		{q5}, [ip]
> +	vld1.8		{q6}, [lr]
> +
> +	add		ip, r1, r4
> +	vld1.8		{q0}, [r1]			@ overlapping loads
> +	vld1.8		{q3}, [ip]
> +
> +	vld1.8		{q1}, [r5]			@ get iv
> +	prepare_key	r2, r3
> +
> +	veor		q0, q0, q1			@ xor with iv
> +	bl		aes_encrypt
> +
> +	vtbl.8		d4, {d0-d1}, d10
> +	vtbl.8		d5, {d0-d1}, d11
> +	vtbl.8		d2, {d6-d7}, d12
> +	vtbl.8		d3, {d6-d7}, d13
> +
> +	veor		q0, q0, q1
> +	bl		aes_encrypt
> +
> +	add		r4, r0, r4
> +	vst1.8		{q2}, [r4]			@ overlapping stores
> +	vst1.8		{q0}, [r0]
> +
> +	pop		{r4-r6, pc}
> +ENDPROC(ce_aes_cbc_cts_encrypt)
> +
> +ENTRY(ce_aes_cbc_cts_decrypt)
> +	push		{r4-r6, lr}
> +	ldrd		r4, r5, [sp, #16]
> +
> +	movw		ip, :lower16:.Lcts_permute_table
> +	movt		ip, :upper16:.Lcts_permute_table
> +	sub		r4, r4, #16
> +	add		lr, ip, #32
> +	add		ip, ip, r4
> +	sub		lr, lr, r4
> +	vld1.8		{q5}, [ip]
> +	vld1.8		{q6}, [lr]
> +
> +	add		ip, r1, r4
> +	vld1.8		{q0}, [r1]			@ overlapping loads
> +	vld1.8		{q1}, [ip]
> +
> +	vld1.8		{q3}, [r5]			@ get iv
> +	prepare_key	r2, r3
> +
> +	bl		aes_decrypt
> +
> +	vtbl.8		d4, {d0-d1}, d10
> +	vtbl.8		d5, {d0-d1}, d11
> +	vtbx.8		d0, {d2-d3}, d12
> +	vtbx.8		d1, {d2-d3}, d13
> +
> +	veor		q1, q1, q2
> +	bl		aes_decrypt
> +	veor		q0, q0, q3			@ xor with iv
> +
> +	add		r4, r0, r4
> +	vst1.8		{q1}, [r4]			@ overlapping stores
> +	vst1.8		{q0}, [r0]
> +
> +	pop		{r4-r6, pc}
> +ENDPROC(ce_aes_cbc_cts_decrypt)
> +
> +
>  	/*
>  	 * aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
>  	 *		   int blocks, u8 ctr[])
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index c215792a2494..cdb1a07e7ad0 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c
> @@ -35,6 +35,10 @@ asmlinkage void ce_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
>  				   int rounds, int blocks, u8 iv[]);
>  asmlinkage void ce_aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[],
>  				   int rounds, int blocks, u8 iv[]);
> +asmlinkage void ce_aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
> +				   int rounds, int bytes, u8 const iv[]);
> +asmlinkage void ce_aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
> +				   int rounds, int bytes, u8 const iv[]);
>  
>  asmlinkage void ce_aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
>  				   int rounds, int blocks, u8 ctr[]);
> @@ -210,48 +214,182 @@ static int ecb_decrypt(struct skcipher_request *req)
>  	return err;
>  }
>  
> -static int cbc_encrypt(struct skcipher_request *req)
> +static int cbc_encrypt_walk(struct skcipher_request *req,
> +			    struct skcipher_walk *walk)
>  {
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>  	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	struct skcipher_walk walk;
>  	unsigned int blocks;
> -	int err;
> +	int err = 0;
>  
> -	err = skcipher_walk_virt(&walk, req, false);
> -
> -	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
> +	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
>  		kernel_neon_begin();
> -		ce_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> +		ce_aes_cbc_encrypt(walk->dst.virt.addr, walk->src.virt.addr,
>  				   ctx->key_enc, num_rounds(ctx), blocks,
> -				   walk.iv);
> +				   walk->iv);
>  		kernel_neon_end();
> -		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
> +		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
>  	}
>  	return err;
>  }
>  
> -static int cbc_decrypt(struct skcipher_request *req)
> +static int cbc_encrypt(struct skcipher_request *req)
>  {
> -	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> -	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
>  	struct skcipher_walk walk;
> -	unsigned int blocks;
>  	int err;
>  
>  	err = skcipher_walk_virt(&walk, req, false);
> +	if (err)
> +		return err;
> +	return cbc_encrypt_walk(req, &walk);
> +}
>  
> -	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
> +static int cbc_decrypt_walk(struct skcipher_request *req,
> +			    struct skcipher_walk *walk)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	unsigned int blocks;
> +	int err = 0;
> +
> +	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
>  		kernel_neon_begin();
> -		ce_aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> +		ce_aes_cbc_decrypt(walk->dst.virt.addr, walk->src.virt.addr,
>  				   ctx->key_dec, num_rounds(ctx), blocks,
> -				   walk.iv);
> +				   walk->iv);
>  		kernel_neon_end();
> -		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
> +		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
>  	}
>  	return err;
>  }
>  
> +static int cbc_decrypt(struct skcipher_request *req)
> +{
> +	struct skcipher_walk walk;
> +	int err;
> +
> +	err = skcipher_walk_virt(&walk, req, false);
> +	if (err)
> +		return err;
> +	return cbc_decrypt_walk(req, &walk);
> +}
> +
> +static int cts_cbc_encrypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> +	struct scatterlist *src = req->src, *dst = req->dst;
> +	struct scatterlist sg_src[2], sg_dst[2];
> +	struct skcipher_request subreq;
> +	struct skcipher_walk walk;
> +	int err;
> +
> +	skcipher_request_set_tfm(&subreq, tfm);
> +	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
> +				      NULL, NULL);
> +
> +	if (req->cryptlen <= AES_BLOCK_SIZE) {
> +		if (req->cryptlen < AES_BLOCK_SIZE)
> +			return -EINVAL;
> +		cbc_blocks = 1;
> +	}
> +
> +	if (cbc_blocks > 0) {
> +		skcipher_request_set_crypt(&subreq, req->src, req->dst,
> +					   cbc_blocks * AES_BLOCK_SIZE,
> +					   req->iv);
> +
> +		err = skcipher_walk_virt(&walk, &subreq, false) ?:
> +		      cbc_encrypt_walk(&subreq, &walk);
> +		if (err)
> +			return err;
> +
> +		if (req->cryptlen == AES_BLOCK_SIZE)
> +			return 0;
> +
> +		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
> +		if (req->dst != req->src)
> +			dst = scatterwalk_ffwd(sg_dst, req->dst,
> +					       subreq.cryptlen);
> +	}
> +
> +	/* handle ciphertext stealing */
> +	skcipher_request_set_crypt(&subreq, src, dst,
> +				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
> +				   req->iv);
> +
> +	err = skcipher_walk_virt(&walk, &subreq, false);
> +	if (err)
> +		return err;
> +
> +	kernel_neon_begin();
> +	ce_aes_cbc_cts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> +			       ctx->key_enc, num_rounds(ctx), walk.nbytes,
> +			       walk.iv);
> +	kernel_neon_end();
> +
> +	return skcipher_walk_done(&walk, 0);
> +}
> +
> +static int cts_cbc_decrypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
> +	struct scatterlist *src = req->src, *dst = req->dst;
> +	struct scatterlist sg_src[2], sg_dst[2];
> +	struct skcipher_request subreq;
> +	struct skcipher_walk walk;
> +	int err;
> +
> +	skcipher_request_set_tfm(&subreq, tfm);
> +	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
> +				      NULL, NULL);
> +
> +	if (req->cryptlen <= AES_BLOCK_SIZE) {
> +		if (req->cryptlen < AES_BLOCK_SIZE)
> +			return -EINVAL;
> +		cbc_blocks = 1;
> +	}
> +
> +	if (cbc_blocks > 0) {
> +		skcipher_request_set_crypt(&subreq, req->src, req->dst,
> +					   cbc_blocks * AES_BLOCK_SIZE,
> +					   req->iv);
> +
> +		err = skcipher_walk_virt(&walk, &subreq, false) ?:
> +		      cbc_decrypt_walk(&subreq, &walk);
> +		if (err)
> +			return err;
> +
> +		if (req->cryptlen == AES_BLOCK_SIZE)
> +			return 0;
> +
> +		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
> +		if (req->dst != req->src)
> +			dst = scatterwalk_ffwd(sg_dst, req->dst,
> +					       subreq.cryptlen);
> +	}
> +
> +	/* handle ciphertext stealing */
> +	skcipher_request_set_crypt(&subreq, src, dst,
> +				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
> +				   req->iv);
> +
> +	err = skcipher_walk_virt(&walk, &subreq, false);
> +	if (err)
> +		return err;
> +
> +	kernel_neon_begin();
> +	ce_aes_cbc_cts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
> +			       ctx->key_dec, num_rounds(ctx), walk.nbytes,
> +			       walk.iv);
> +	kernel_neon_end();
> +
> +	return skcipher_walk_done(&walk, 0);
> +}
> +
>  static int ctr_encrypt(struct skcipher_request *req)
>  {
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> @@ -486,6 +624,22 @@ static struct skcipher_alg aes_algs[] = { {
>  	.setkey			= ce_aes_setkey,
>  	.encrypt		= cbc_encrypt,
>  	.decrypt		= cbc_decrypt,
> +}, {
> +	.base.cra_name		= "__cts(cbc(aes))",
> +	.base.cra_driver_name	= "__cts-cbc-aes-ce",
> +	.base.cra_priority	= 300,
> +	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
> +	.base.cra_blocksize	= AES_BLOCK_SIZE,
> +	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
> +	.base.cra_module	= THIS_MODULE,
> +
> +	.min_keysize		= AES_MIN_KEY_SIZE,
> +	.max_keysize		= AES_MAX_KEY_SIZE,
> +	.ivsize			= AES_BLOCK_SIZE,
> +	.walksize		= 2 * AES_BLOCK_SIZE,
> +	.setkey			= ce_aes_setkey,
> +	.encrypt		= cts_cbc_encrypt,
> +	.decrypt		= cts_cbc_decrypt,
>  }, {
>  	.base.cra_name		= "__ctr(aes)",
>  	.base.cra_driver_name	= "__ctr-aes-ce",
