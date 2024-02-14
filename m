Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF3F2E629
	for <linux-crypto@vger.kernel.org>; Wed, 14 Feb 2024 23:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707951623; cv=none; b=Ef8RypOLLBvVc0HgsdU0dLwk/GY9GphC8xrdzmSh1VzjXWd1IePWOE4SAsdAE+MPLwJdWs3wdZ1sj99XNqjgErE8gQPuw0FrgweJHit4dAubrhcwLtypZ24Gr86ptVztlFTKBmZCr73qouqyEjCyAJauZpb4r1sIxhOEYrGD2mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707951623; c=relaxed/simple;
	bh=ScZm0vwbrsy4nw+Pb0j0jXTfmJkMbSyBprvfetmyFDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGBh23qW+ZcOY6McFBTbrcXkvC9AfM1jmWAAhoxgbbsortG5UvoaHCDvaS8tGrIl+Xvn9/0uLEfFfivYoodzKsCmaTiRptgeFvCUkrwtGirFgfr3tcnJfM0ZIUxbSTZVjwuXz5lKsqplTR9pPHbBiEdf3ui9+Bm2hKw5TJBoP4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8J+DIXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8J+DIXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6A9C433C7;
	Wed, 14 Feb 2024 23:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707951622;
	bh=ScZm0vwbrsy4nw+Pb0j0jXTfmJkMbSyBprvfetmyFDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a8J+DIXS3OjNcotONjCKm59n2cVbdY3VQoIKzfFh2sxbJL48fAO21hHkftl7B8dCG
	 a7ud1bhYUO+bm6oWJBYZXwGCQRZZSn9Ka582F6Vltv3uzq2UQFheGbukErgzd0eqz/
	 IRF6lX8ywwK/9dWgElFePrg1lub/Pau90/Sm2UgTFeagfHsD70Vtc7B8Iz0nTDjHKd
	 AbEvMJYflGbWCVWpoPkhjRHkC7HSSMBmH7ZYws/E9waNB2Cnn+oHzXHEv4KIH0uf9x
	 I0xkUQjRswgsoVY9J4Q4CyBsQ+sTYuSpnlgpcsYSMtKEwdD70GoADpnuZPLGp0+jHA
	 VVUzXN/HwvCKg==
Date: Wed, 14 Feb 2024 15:00:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 13/15] crypto: cts,xts - Update parameters
 blocksize/chunksize/tailsize
Message-ID: <20240214230021.GC1638@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <b149e8743355be694c96da02ced0811963298373.1707815065.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b149e8743355be694c96da02ced0811963298373.1707815065.git.herbert@gondor.apana.org.au>

On Fri, Dec 29, 2023 at 06:47:00PM +0800, Herbert Xu wrote:
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index b668c97663ec..3bfa8accf2c2 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c
> @@ -619,13 +619,15 @@ static struct skcipher_alg aes_algs[] = { {
>  	.base.cra_driver_name	= "__cts-cbc-aes-ce",
>  	.base.cra_priority	= 300,
>  	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
> -	.base.cra_blocksize	= AES_BLOCK_SIZE,
> +	.base.cra_blocksize	= 1,

Before messing around with cra_blocksize, it needs to be decided what it
actually means, and document it appropriately.  According to the current
specification, AES_BLOCK_SIZE is correct here, not 1:

 * @cra_blocksize: Minimum block size of this transformation. The size in bytes
 *		   of the smallest possible unit which can be transformed with
 *		   this algorithm. The users must respect this value.
 *		   In case of HASH transformation, it is possible for a smaller
 *		   block than @cra_blocksize to be passed to the crypto API for
 *		   transformation, in case of any other transformation type, an
 * 		   error will be returned upon any attempt to transform smaller
 *		   than @cra_blocksize chunks.
