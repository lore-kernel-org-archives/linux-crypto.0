Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F32E11A5;
	Fri, 13 Jun 2025 19:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749841339; cv=none; b=kScxmnSh9Y/qzmMSVCvfXYSAwUklAtedutqIgoQOmfAnYHTX8GmlE1soxtWwiKOgY8MCJ2SYKFQRzb4Ob/iKefMY4Rk/DHfEeHyUuwiGpx6xdgie+RVe3J8yCArhluOOnMnXEQZR+0Hz0NSAHGJ9y0dyXvlqG19aHAZZ2k9eH2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749841339; c=relaxed/simple;
	bh=6PwNri2M3YdedhjwUN0NNQh3fr8ouiZE3mD0OKU7XBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAeqn3tY4dqsamRw6psbkGH2qoxs/K5F6ORdo3d9ekGDVSWS13YkbbIqVs68N5LTAGDUA3W21HKvaQS4oR6V3nVLQt8wvp61U8w7dktk0W38vV+z4xFvwtJPnhcyAynh/gETYpsvEcpiSutKc3EbjwVtmZcc9KqSV/yihiSM6bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGBG++1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGBG++1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E14C4CEE3;
	Fri, 13 Jun 2025 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749841337;
	bh=6PwNri2M3YdedhjwUN0NNQh3fr8ouiZE3mD0OKU7XBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kGBG++1ZyBY/yRYlusUTWXp0lKESovpxbWY7WGlOWsKvq48M+hKI5wUW2sl5xw56a
	 Yr5dFGsRsKuNCFQsr/SmPtF/SFr8FYy58Qn+heZgZlLCEwghUIeKn2nq47Kmi1nUfv
	 gDjSyGlYg58+mIAD1GotspMVIhU/ASUJWlOYcBUh7LdZbY1YIRUogL5JT02YrDlmca
	 vIqjWR7S7KOsh4qxCkHOSRkfft4ZMP3PRBDCqZiCSC1MLuiCmVNFmSo2nAJ4PNSaOM
	 yNhKeiYTbbQT5Cvl+WBecu2hXvYUzEDVbxjglyDVaWnj4yv2dH+RaZ7a3M7y9ixCfh
	 a26nO/wZmKX6g==
Date: Fri, 13 Jun 2025 12:01:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <20250613190150.GD1284@sol>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613103309.22440-1-giovanni.cabiddu@intel.com>

On Fri, Jun 13, 2025 at 11:32:27AM +0100, Giovanni Cabiddu wrote:
> Most kernel applications utilizing the crypto API operate synchronously
> and on small buffer sizes, therefore do not benefit from QAT acceleration.
> 
> Reduce the priority of QAT implementations for both skcipher and aead
> algorithms, allowing more suitable alternatives to be selected by default.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Link: https://lore.kernel.org/all/20250613012357.GA3603104@google.com/
> Cc: stable@vger.kernel.org
> ---
>  drivers/crypto/intel/qat/qat_common/qat_algs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
> index 3c4bba4a8779..d69cc1e5e023 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
> @@ -1277,7 +1277,7 @@ static struct aead_alg qat_aeads[] = { {
>  	.base = {
>  		.cra_name = "authenc(hmac(sha1),cbc(aes))",
>  		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
> -		.cra_priority = 4001,
> +		.cra_priority = 100,
>  		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
>  		.cra_blocksize = AES_BLOCK_SIZE,
>  		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
> @@ -1294,7 +1294,7 @@ static struct aead_alg qat_aeads[] = { {
>  	.base = {
>  		.cra_name = "authenc(hmac(sha256),cbc(aes))",
>  		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
> -		.cra_priority = 4001,
> +		.cra_priority = 100,
>  		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
>  		.cra_blocksize = AES_BLOCK_SIZE,
>  		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
> @@ -1311,7 +1311,7 @@ static struct aead_alg qat_aeads[] = { {
>  	.base = {
>  		.cra_name = "authenc(hmac(sha512),cbc(aes))",
>  		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
> -		.cra_priority = 4001,
> +		.cra_priority = 100,
>  		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
>  		.cra_blocksize = AES_BLOCK_SIZE,
>  		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
> @@ -1329,7 +1329,7 @@ static struct aead_alg qat_aeads[] = { {
>  static struct skcipher_alg qat_skciphers[] = { {
>  	.base.cra_name = "cbc(aes)",
>  	.base.cra_driver_name = "qat_aes_cbc",
> -	.base.cra_priority = 4001,
> +	.base.cra_priority = 100,
>  	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
>  	.base.cra_blocksize = AES_BLOCK_SIZE,
>  	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
> @@ -1347,7 +1347,7 @@ static struct skcipher_alg qat_skciphers[] = { {
>  }, {
>  	.base.cra_name = "ctr(aes)",
>  	.base.cra_driver_name = "qat_aes_ctr",
> -	.base.cra_priority = 4001,
> +	.base.cra_priority = 100,
>  	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
>  	.base.cra_blocksize = 1,
>  	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
> @@ -1365,7 +1365,7 @@ static struct skcipher_alg qat_skciphers[] = { {
>  }, {
>  	.base.cra_name = "xts(aes)",
>  	.base.cra_driver_name = "qat_aes_xts",
> -	.base.cra_priority = 4001,
> +	.base.cra_priority = 100,
>  	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
>  			  CRYPTO_ALG_ALLOCATES_MEMORY,
>  	.base.cra_blocksize = AES_BLOCK_SIZE,
> -- 
> 2.49.0
> 

Acked-by: Eric Biggers <ebiggers@kernel.org>

But, I think your commit message may be misleading:

> Most kernel applications utilizing the crypto API operate synchronously
> and on small buffer sizes, therefore do not benefit from QAT acceleration.

That implies that QAT acceleration *would* be beneficial for kernel applications
using asynchronous processing, large buffer sizes, or both.

But as far as I know, that hasn't been shown to be true either.  Those things
would likely make the performance characteristics of the QAT driver less bad,
but that doesn't necessarily mean it would become better than VAES.  VAES is
already incredibly fast, and far easier to use.

- Eric
