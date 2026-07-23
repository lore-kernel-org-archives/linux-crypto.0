Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAAD47D45B;
	Thu, 23 Jul 2026 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831684; cv=none; b=cT/0lwLjOzkUb4s7RsGWYOh4GcN8DBSODan+eT98DnZFmATJaxZlM2KVIwJ0RCsDI1BRKH6J4QBy8j/RO5axo6VtwVdniH6KlY9/YseekpsyE65e2kBmmE9QuqWB0hOSHxu4pC7JvmXHMHfJvl8p/cbbyl8+LjqVkVgIBrwQ2yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831684; c=relaxed/simple;
	bh=u/kNO7lqSpiD/7rkaWPsgbQzJdaALeDH8Hehr94V1wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWWgInRDzrjA+ByHST+OY8vuIKjRf6TeVjwk171WkaPUq1QS9lcvQ38cN4ptRO2bo605+qhu2KUcVEvkSe7wwUSybXiU0oPITfNi5BPdtmGzEXl3Fv2+A8MASkDECwReRxQ7lQ31ROA4g6vCooxES2Q6x6/Q52cP7kYxS8nnCH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D291F00A3A;
	Thu, 23 Jul 2026 18:34:40 +0000 (UTC)
Date: Thu, 23 Jul 2026 11:34:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v6 7/8] crypto: qce - Use a fallback for CCM with a
 partial final block
Message-ID: <20260723183438.GB93534@quark>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
 <20260717-qce-fix-self-tests-v6-7-455775fe5f6c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-qce-fix-self-tests-v6-7-455775fe5f6c@oss.qualcomm.com>

On Fri, Jul 17, 2026 at 05:53:36PM +0200, Bartosz Golaszewski wrote:
> CCM builds on AES-CTR for encryption, and the crypto engine stalls on a
> partial final block just as it does for plain ctr(aes): a payload whose
> length is not a multiple of the AES block size leaves the operation
> incomplete and fails with a hardware operation error. This was caught by
> the ccm(aes) crypto self-tests.
> 
> Force the software fallback for CCM requests whose message length is not
> block aligned, reusing the driver's existing need_fallback mechanism.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  drivers/crypto/qce/aead.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
> index 336614a11377e0be246817da584296124f4de5d8..4fa018204cb628c112f64c45ff6c7407df73b945 100644
> --- a/drivers/crypto/qce/aead.c
> +++ b/drivers/crypto/qce/aead.c
> @@ -514,6 +514,14 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
>  			ctx->need_fallback = true;
>  	}
>  
> +	/*
> +	 * CCM uses AES-CTR internally and the CE stalls on a partial final
> +	 * block, so a payload that is not a multiple of the block size has to
> +	 * be handled by the fallback.
> +	 */
> +	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
> +		ctx->need_fallback = true;
> +
>  	/* If fallback is needed, schedule and exit */
>  	if (ctx->need_fallback) {

Here, the driver is storing per-request state ('need_fallback') in the
transformation context, which is a shared structure.  This can cause the
driver to produce incorrect results if used for multiple concurrent
requests with the same algorithm.

On the topic of CCM, there's also a memory leak and buffer overread in
qce_aead_ccm_prepare_buf_assoclen().  It allocates a buffer of length
ALIGN(assoclen,16)+6, then treats it as a buffer of length
ALIGN(assoclen+6,16).  That can be greater than the allocated length,
for example if assoclen = 15.  Then it never frees the buffer.

The allocation is also being done using GFP_ATOMIC, which is
failure-prone.  Users need crypto operations to be reliable.

This driver's CCM implementation also fails to validate that the message
length is allowed for the specified nonce length.

The error handling in qce_aead_async_req_handle() is also incorrect: it
calls dma_unmap_sg() on req->src instead of the actual mapped
scatterlist rctx->src_sg, which differ when assoclen > 0.  It also uses
< 0 to check for failures from dma_map_sg(), when it actually returns an
unsigned int and returns 0 on failure.

Note that the ARMv8 CE implementation of AES-CCM is much faster and does
not have these issues.

- Eric
