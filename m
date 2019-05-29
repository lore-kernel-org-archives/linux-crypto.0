Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD08C28CC0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 20:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36EEC24169
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 20:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559161652;
	bh=L8h2IoFAWDipnv/lvbb9bdY6ESNQY9JFCL26yJfVOT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=E6AyH7bbLbnx4ecnjy2J5BE5hSCo7kZ4QEhiHSffN/Yy8AUkAt6fXJtLeBwIiVBif
	 UxIwqHM4fjFEn1W+RRFo994EIBANc9j9diIj74I/PpmUIVn5Rb1EsVjFs3/3OTlsNG
	 fMtiZI95AXbzi+AwV11d16sPn7n8fLcfWaE9svWE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfE2U1b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 16:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfE2U1b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 16:27:31 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C3424168;
        Wed, 29 May 2019 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559161650;
        bh=L8h2IoFAWDipnv/lvbb9bdY6ESNQY9JFCL26yJfVOT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0mfqRccY09gmih0Dw2ejbDdKRKJQaa0uPvjwsC/WZFqRAXgvKAmo4GRKv6FKj7a9x
         qTLV0v3pN/dqea4zonxE7EPeeUhiDb6sXIOFQf3q+6tOczkip6rZpHgPstwK4txNDp
         VoPkTpX8qMKZXGG4pQr3PKT1JV9OZCMU9DgM85RE=
Date:   Wed, 29 May 2019 13:27:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Message-ID: <20190529202728.GA35103@gmail.com>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 29, 2019 at 08:10:56PM +0300, Iuliana Prodan wrote:
> The generic GCM driver should ensure that whatever it passes into
> scatterlists is safe for non-cache coherent DMA.
> The issue was seen while running GCM on CAAM driver. But, since CAAM
> does not support GHASH on i.MX6, only CTR skcipher part of the GCM is
> offloaded.
> The skcipher request received by CAAM has req->src pointing to
> auth_tag[16] and req->iv pointing to iv[16]. Problem is that when
> the iv is updated (crypto API requires skcipher implementations to
> update the IV with the last ciphertext block) is written in iv[16],
> which is on the same cacheline as auth_tag[16] that was previously
> DMA mapped.
> Solution is to use a pointer, aligned to cache line, instead of auth_tag
> buffer, for encryption/decryption and then free it on completion.
> 
> Link: https://lore.kernel.org/linux-crypto/20190208114459.5nixe76xmmkhur75@gondor.apana.org.au/
> Cc: <stable@vger.kernel.org> # v4.19+
> Fixes: adcbc688fe2f ("crypto: gcm - Convert to new AEAD interface")
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> 
> ---
> I've checked the reproducibility of this issue starting with 4.19.y.
> ---
>  crypto/gcm.c         | 26 +++++++++++++++++---------
>  include/crypto/gcm.h |  1 +
>  2 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/crypto/gcm.c b/crypto/gcm.c
> index 33f45a9..53e3ce5 100644
> --- a/crypto/gcm.c
> +++ b/crypto/gcm.c
> @@ -66,7 +66,7 @@ struct crypto_gcm_ghash_ctx {
>  
>  struct crypto_gcm_req_priv_ctx {
>  	u8 iv[16];
> -	u8 auth_tag[16];
> +	u8 *auth_tag;
>  	u8 iauth_tag[16];
>  	struct scatterlist src[3];
>  	struct scatterlist dst[3];
> @@ -177,19 +177,23 @@ static void crypto_gcm_init_common(struct aead_request *req)
>  	__be32 counter = cpu_to_be32(1);
>  	struct scatterlist *sg;
>  
> -	memset(pctx->auth_tag, 0, sizeof(pctx->auth_tag));
> +	/*
> +	 * kzalloc alignment is at least the cache line size
> +	 * for non-cache coherent architectures.
> +	 */
> +	pctx->auth_tag = kzalloc(GCM_MAX_AUTH_SIZE, GFP_KERNEL);
>  	memcpy(pctx->iv, req->iv, GCM_AES_IV_SIZE);
>  	memcpy(pctx->iv + GCM_AES_IV_SIZE, &counter, 4);
>  
>  	sg_init_table(pctx->src, 3);
> -	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
> +	sg_set_buf(pctx->src, pctx->auth_tag, GCM_MAX_AUTH_SIZE);
>  	sg = scatterwalk_ffwd(pctx->src + 1, req->src, req->assoclen);
>  	if (sg != pctx->src + 1)
>  		sg_chain(pctx->src, 2, sg);
>  
>  	if (req->src != req->dst) {
>  		sg_init_table(pctx->dst, 3);
> -		sg_set_buf(pctx->dst, pctx->auth_tag, sizeof(pctx->auth_tag));
> +		sg_set_buf(pctx->dst, pctx->auth_tag, GCM_MAX_AUTH_SIZE);
>  		sg = scatterwalk_ffwd(pctx->dst + 1, req->dst, req->assoclen);
>  		if (sg != pctx->dst + 1)
>  			sg_chain(pctx->dst, 2, sg);
> @@ -208,9 +212,8 @@ static void crypto_gcm_init_crypt(struct aead_request *req,
>  	dst = req->src == req->dst ? pctx->src : pctx->dst;
>  
>  	skcipher_request_set_tfm(skreq, ctx->ctr);
> -	skcipher_request_set_crypt(skreq, pctx->src, dst,
> -				     cryptlen + sizeof(pctx->auth_tag),
> -				     pctx->iv);
> +	skcipher_request_set_crypt(skreq, pctx->src, dst, cryptlen +
> +				   GCM_MAX_AUTH_SIZE, pctx->iv);
>  }
>  
>  static inline unsigned int gcm_remain(unsigned int len)
> @@ -440,6 +443,7 @@ static int gcm_enc_copy_hash(struct aead_request *req, u32 flags)
>  	scatterwalk_map_and_copy(auth_tag, req->dst,
>  				 req->assoclen + req->cryptlen,
>  				 crypto_aead_authsize(aead), 1);
> +	kfree(auth_tag);
>  	return 0;
>  }
>  
> @@ -492,11 +496,15 @@ static int crypto_gcm_verify(struct aead_request *req)
>  	u8 *iauth_tag = pctx->iauth_tag;
>  	unsigned int authsize = crypto_aead_authsize(aead);
>  	unsigned int cryptlen = req->cryptlen - authsize;
> +	int err;
>  
>  	crypto_xor(auth_tag, iauth_tag, 16);
>  	scatterwalk_map_and_copy(iauth_tag, req->src,
>  				 req->assoclen + cryptlen, authsize, 0);
> -	return crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
> +	err = crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
> +	kfree(auth_tag);
> +
> +	return err;
>  }
>  

So what about the other places that also pass an IV located next to the data,
like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to make this a
new API requirement, then we need to add a debugging option that makes the API
detect this violation so that the other places can be fixed too.

Also, doing a kmalloc() per requset is inefficient and very error-prone.  In
fact there are at least 3 bugs here: (1) not checking the return value, (2)
incorrectly using GFP_KERNEL when it may be atomic context, and (3) not always
freeing the memory.  Why not use cacheline-aligned memory within the request
context, so that a separate kmalloc() isn't needed?

Also, did you consider whether there's any way to make the crypto API handle
this automatically, so that all the individual users don't have to?

- Eric
