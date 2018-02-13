From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 14/14] x86/crypto: aesni: Update aesni-intel_glue to use scatter/gather
Date: Tue, 13 Feb 2018 08:42:50 +0100
Message-ID: <54235286.FU8BX9VrCl@tauon.chronox.de>
References: <cover.1518211765.git.davejwatson@fb.com> <20180212195128.GA61087@davejwatson-mba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        linux-kernel@vger.kernel.org, Ilya Lesokhin <ilyal@mellanox.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:10059 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933463AbeBMHnK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 02:43:10 -0500
In-Reply-To: <20180212195128.GA61087@davejwatson-mba.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 12. Februar 2018, 20:51:28 CET schrieb Dave Watson:

Hi Dave,

> Add gcmaes_en/decrypt_sg routines, that will do scatter/gather
> by sg. Either src or dst may contain multiple buffers, so
> iterate over both at the same time if they are different.
> If the input is the same as the output, iterate only over one.
> 
> Currently both the AAD and TAG must be linear, so copy them out
> with scatterlist_map_and_copy.
> 
> Only the SSE routines are updated so far, so leave the previous
> gcmaes_en/decrypt routines, and branch to the sg ones if the
> keysize is inappropriate for avx, or we are SSE only.
> 
> Signed-off-by: Dave Watson <davejwatson@fb.com>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 166
> +++++++++++++++++++++++++++++++++++++ 1 file changed, 166 insertions(+)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c
> b/arch/x86/crypto/aesni-intel_glue.c index de986f9..1e32fbe 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -791,6 +791,82 @@ static int generic_gcmaes_set_authsize(struct
> crypto_aead *tfm, return 0;
>  }
> 
> +static int gcmaes_encrypt_sg(struct aead_request *req, unsigned int
> assoclen, +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
> +{
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
> +	struct gcm_context_data data AESNI_ALIGN_ATTR;
> +	struct scatter_walk dst_sg_walk = {};
> +	unsigned long left = req->cryptlen;
> +	unsigned long len, srclen, dstlen;
> +	struct scatter_walk src_sg_walk;
> +	struct scatterlist src_start[2];
> +	struct scatterlist dst_start[2];
> +	struct scatterlist *src_sg;
> +	struct scatterlist *dst_sg;
> +	u8 *src, *dst, *assoc;
> +	u8 authTag[16];
> +
> +	assoc = kmalloc(assoclen, GFP_ATOMIC);
> +	if (unlikely(!assoc))
> +		return -ENOMEM;
> +	scatterwalk_map_and_copy(assoc, req->src, 0, assoclen, 0);

Have you tested that this code does not barf when assoclen is 0?

Maybe it is worth while to finally add a test vector to testmgr.h which 
validates such scenario. If you would like, here is a vector you could add to 
testmgr:

https://github.com/smuellerDD/libkcapi/blob/master/test/test.sh#L315

This is a decryption of gcm(aes) with no message, no AAD and just a tag. The 
result should be EBADMSG.
> +
> +	src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);

Why do you use assoclen in the map_and_copy, and req->assoclen in the ffwd?

> +	scatterwalk_start(&src_sg_walk, src_sg);
> +	if (req->src != req->dst) {
> +		dst_sg = scatterwalk_ffwd(dst_start, req->dst, req->assoclen);

Dto: req->assoclen or assoclen?

> +		scatterwalk_start(&dst_sg_walk, dst_sg);
> +	}
> +
> +	kernel_fpu_begin();
> +	aesni_gcm_init(aes_ctx, &data, iv,
> +		hash_subkey, assoc, assoclen);
> +	if (req->src != req->dst) {
> +		while (left) {
> +			src = scatterwalk_map(&src_sg_walk);
> +			dst = scatterwalk_map(&dst_sg_walk);
> +			srclen = scatterwalk_clamp(&src_sg_walk, left);
> +			dstlen = scatterwalk_clamp(&dst_sg_walk, left);
> +			len = min(srclen, dstlen);
> +			if (len)
> +				aesni_gcm_enc_update(aes_ctx, &data,
> +						     dst, src, len);
> +			left -= len;
> +
> +			scatterwalk_unmap(src);
> +			scatterwalk_unmap(dst);
> +			scatterwalk_advance(&src_sg_walk, len);
> +			scatterwalk_advance(&dst_sg_walk, len);
> +			scatterwalk_done(&src_sg_walk, 0, left);
> +			scatterwalk_done(&dst_sg_walk, 1, left);
> +		}
> +	} else {
> +		while (left) {
> +			dst = src = scatterwalk_map(&src_sg_walk);
> +			len = scatterwalk_clamp(&src_sg_walk, left);
> +			if (len)
> +				aesni_gcm_enc_update(aes_ctx, &data,
> +						     src, src, len);
> +			left -= len;
> +			scatterwalk_unmap(src);
> +			scatterwalk_advance(&src_sg_walk, len);
> +			scatterwalk_done(&src_sg_walk, 1, left);
> +		}
> +	}
> +	aesni_gcm_finalize(aes_ctx, &data, authTag, auth_tag_len);
> +	kernel_fpu_end();
> +
> +	kfree(assoc);
> +
> +	/* Copy in the authTag */
> +	scatterwalk_map_and_copy(authTag, req->dst,
> +				req->assoclen + req->cryptlen,
> +				auth_tag_len, 1);
> +	return 0;
> +}
> +
>  static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
>  			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
>  {
> @@ -802,6 +878,11 @@ static int gcmaes_encrypt(struct aead_request *req,
> unsigned int assoclen, struct scatter_walk dst_sg_walk = {};
>  	struct gcm_context_data data AESNI_ALIGN_ATTR;
> 
> +	if (((struct crypto_aes_ctx *)aes_ctx)->key_length != AES_KEYSIZE_128 ||
> +		aesni_gcm_enc_tfm == aesni_gcm_enc) {
> +		return gcmaes_encrypt_sg(req, assoclen, hash_subkey, iv,
> +					aes_ctx);
> +	}
>  	if (sg_is_last(req->src) &&
>  	    (!PageHighMem(sg_page(req->src)) ||
>  	    req->src->offset + req->src->length <= PAGE_SIZE) &&
> @@ -854,6 +935,86 @@ static int gcmaes_encrypt(struct aead_request *req,
> unsigned int assoclen, return 0;
>  }
> 
> +static int gcmaes_decrypt_sg(struct aead_request *req, unsigned int
> assoclen, +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
> +{

This is a lot of code duplication.

> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
> +	unsigned long left = req->cryptlen - auth_tag_len;
> +	struct gcm_context_data data AESNI_ALIGN_ATTR;
> +	struct scatter_walk dst_sg_walk = {};
> +	unsigned long len, srclen, dstlen;
> +	struct scatter_walk src_sg_walk;
> +	struct scatterlist src_start[2];
> +	struct scatterlist dst_start[2];
> +	struct scatterlist *src_sg;
> +	struct scatterlist *dst_sg;
> +	u8 *src, *dst, *assoc;
> +	u8 authTagGen[16];
> +	u8 authTag[16];
> +
> +	assoc = kmalloc(assoclen, GFP_ATOMIC);
> +	if (unlikely(!assoc))
> +		return -ENOMEM;
> +	scatterwalk_map_and_copy(assoc, req->src, 0, assoclen, 0);
> +
> +	src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);
> +	scatterwalk_start(&src_sg_walk, src_sg);
> +	if (req->src != req->dst) {
> +		dst_sg = scatterwalk_ffwd(dst_start, req->dst, req->assoclen);
> +		scatterwalk_start(&dst_sg_walk, dst_sg);
> +	}
> +
> +	kernel_fpu_begin();
> +	aesni_gcm_init(aes_ctx, &data, iv,
> +		hash_subkey, assoc, assoclen);
> +	if (req->src != req->dst) {
> +		while (left) {
> +			src = scatterwalk_map(&src_sg_walk);
> +			dst = scatterwalk_map(&dst_sg_walk);
> +			srclen = scatterwalk_clamp(&src_sg_walk, left);
> +			dstlen = scatterwalk_clamp(&dst_sg_walk, left);
> +			len = min(srclen, dstlen);
> +			if (len)
> +				aesni_gcm_dec_update(aes_ctx, &data,
> +						     dst, src, len);
> +			left -= len;
> +
> +			scatterwalk_unmap(src);
> +			scatterwalk_unmap(dst);
> +			scatterwalk_advance(&src_sg_walk, len);
> +			scatterwalk_advance(&dst_sg_walk, len);
> +			scatterwalk_done(&src_sg_walk, 0, left);
> +			scatterwalk_done(&dst_sg_walk, 1, left);
> +		}
> +	} else {
> +		while (left) {
> +			dst = src = scatterwalk_map(&src_sg_walk);
> +			len = scatterwalk_clamp(&src_sg_walk, left);
> +			if (len)
> +				aesni_gcm_dec_update(aes_ctx, &data,
> +						     src, src, len);
> +			left -= len;
> +			scatterwalk_unmap(src);
> +			scatterwalk_advance(&src_sg_walk, len);
> +			scatterwalk_done(&src_sg_walk, 1, left);
> +		}
> +	}
> +	aesni_gcm_finalize(aes_ctx, &data, authTagGen, auth_tag_len);
> +	kernel_fpu_end();
> +
> +	kfree(assoc);
> +
> +	/* Copy out original authTag */
> +	scatterwalk_map_and_copy(authTag, req->src,
> +				req->assoclen + req->cryptlen - auth_tag_len,
> +				auth_tag_len, 0);
> +
> +	/* Compare generated tag with passed in tag. */
> +	return crypto_memneq(authTagGen, authTag, auth_tag_len) ?
> +		-EBADMSG : 0;
> +}
> +
>  static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
>  			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
>  {
> @@ -868,6 +1029,11 @@ static int gcmaes_decrypt(struct aead_request *req,
> unsigned int assoclen, struct gcm_context_data data AESNI_ALIGN_ATTR;
>  	int retval = 0;
> 
> +	if (((struct crypto_aes_ctx *)aes_ctx)->key_length != AES_KEYSIZE_128 ||
> +		aesni_gcm_enc_tfm == aesni_gcm_enc) {
> +		return gcmaes_decrypt_sg(req, assoclen, hash_subkey, iv,
> +					aes_ctx);
> +	}
>  	tempCipherLen = (unsigned long)(req->cryptlen - auth_tag_len);
> 
>  	if (sg_is_last(req->src) &&



Ciao
Stephan
