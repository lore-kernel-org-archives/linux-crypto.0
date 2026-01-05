Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCCF13DDAE;
	Mon,  5 Jan 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767625310; cv=none; b=JBHnnnWi+UkZMh/YF/2AWqU1Dn0qzcmikCpe3iR6cvY6qTDCgACocal+ib2rYuztxgdetNgpZoZvyFgxa7nRfi6qxpFpbIn4tAki8+OVE6C9RXsSuzKvAM9p9ocrky5de31Dr+FjgNGQ0dwQnRNc0iziJ+mI6M4BqhjhYZaKX4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767625310; c=relaxed/simple;
	bh=GoQcJ6trCvtZigTZJN9vID2JJ2/Z7BJyxfkB5wCVJ8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udNQh/sWCKiuFb3uGXZORtkJmWsdDmL8KZUHB06JvPLQN2tKC3ZF1/U0F1NVrbFye+QgfLHhgSdVpg7o0YdhBP9kCHBH9cv4IAZiSZCvrVAyuQMDbGQFLdl2TGiKYwg8Du8/qIoTItqEyl2a8S+zz8VT3UrRMTPm8vkK8gubU/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+gAvGbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+gAvGbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BA6C116D0;
	Mon,  5 Jan 2026 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767625306;
	bh=GoQcJ6trCvtZigTZJN9vID2JJ2/Z7BJyxfkB5wCVJ8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S+gAvGbcaLLuE0M+jn09OLkvDDHbr3AJhS/rgdDyShJC0hxJfaH8I82P7Zo4NhKY0
	 xOmGSCOQg7Psvi0iOBSffkffyAl71JRsBfjX3X0PGuppVdhyy8ZEP2eSY7BLu92c3j
	 JE8oh7Uz6YBwYxIyep52acOZC+YC2nqI89xQtbXOU6SclrTGsoMidlwfO9HS2acD7t
	 cMW0JFeYYlD6TMVVYA2RQiFPqAL0LzxrOpD+2sTNv9CkKq9vh5Gc+GYSTUlkglrAom
	 spcjd1n8OEAys+W8sFQ+L/Utk1DCmtVYDfHyFMdjmUReZX3aJtO69sMkVUOY6BYwxz
	 KLZcNB/94j75w==
Date: Mon, 5 Jan 2026 16:01:43 +0100
From: Antoine Tenart <atenart@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	vschagen@icloud.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - unregister only available
 algorithm
Message-ID: <aVvRxqB6-Fdu0MXz@kwain>
References: <20251230235222.2113987-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230235222.2113987-1-olek2@wp.pl>

On Wed, Dec 31, 2025 at 12:51:57AM +0100, Aleksander Jan Bajkowski wrote:
> EIP93 has an options register. This register indicates which crypto
> algorithms are implemented in silicon. Supported algorithms are
> registered on this basis. Unregister algorithms on the same basis.
> Currently, all algorithms are unregistered, even those not supported
> by HW. This results in panic on platforms that don't have all options
> implemented in silicon.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  .../crypto/inside-secure/eip93/eip93-main.c   | 107 ++++++++++--------
>  1 file changed, 61 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
> index 3cdc3308dcac..dfac2b23e2d9 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> @@ -77,11 +77,65 @@ inline void eip93_irq_clear(struct eip93_device *eip93, u32 mask)
>  	__raw_writel(mask, eip93->base + EIP93_REG_INT_CLR);
>  }
>  
> -static void eip93_unregister_algs(unsigned int i)
> +static int eip93_algo_is_supported(struct eip93_alg_template *eip93_algo,
> +				   u32 supported_algo_flags)
> +{
> +	u32 alg_flags = eip93_algo->flags;
> +
> +	if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
> +		return 0;
> +
> +	if (IS_AES(alg_flags)) {
> +		if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
> +			return 0;
> +
> +		if (!IS_HMAC(alg_flags)) {
> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
> +				eip93_algo->alg.skcipher.max_keysize =
> +					AES_KEYSIZE_128;
> +
> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
> +				eip93_algo->alg.skcipher.max_keysize =
> +					AES_KEYSIZE_192;
> +
> +			if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
> +				eip93_algo->alg.skcipher.max_keysize =
> +					AES_KEYSIZE_256;
> +
> +			if (IS_RFC3686(alg_flags))
> +				eip93_algo->alg.skcipher.max_keysize +=
> +					CTR_RFC3686_NONCE_SIZE;

Shouldn't the keysize assignment parts be kept in eip93_register_algs as
this has nothing to do with checking if an alg is supported and as
there's no point setting those (again) in the unregistration path?

> +		}
> +	}
> +
> +	if (IS_HASH_MD5(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
> +		return 0;
> +
> +	if (IS_HASH_SHA1(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
> +		return 0;
> +
> +	if (IS_HASH_SHA224(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
> +		return 0;
> +
> +	if (IS_HASH_SHA256(alg_flags) &&
> +	    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static void eip93_unregister_algs(u32 supported_algo_flags, unsigned int i)
>  {
>  	unsigned int j;
>  
>  	for (j = 0; j < i; j++) {
> +		if (!eip93_algo_is_supported(eip93_algs[j], supported_algo_flags))
> +			continue;
> +
>  		switch (eip93_algs[j]->type) {
>  		case EIP93_ALG_TYPE_SKCIPHER:
>  			crypto_unregister_skcipher(&eip93_algs[j]->alg.skcipher);
> @@ -102,51 +156,9 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
>  	int ret = 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(eip93_algs); i++) {
> -		u32 alg_flags = eip93_algs[i]->flags;
> -
>  		eip93_algs[i]->eip93 = eip93;
>  
> -		if ((IS_DES(alg_flags) || IS_3DES(alg_flags)) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_TDES))
> -			continue;
> -
> -		if (IS_AES(alg_flags)) {
> -			if (!(supported_algo_flags & EIP93_PE_OPTION_AES))
> -				continue;
> -
> -			if (!IS_HMAC(alg_flags)) {
> -				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY128)
> -					eip93_algs[i]->alg.skcipher.max_keysize =
> -						AES_KEYSIZE_128;
> -
> -				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY192)
> -					eip93_algs[i]->alg.skcipher.max_keysize =
> -						AES_KEYSIZE_192;
> -
> -				if (supported_algo_flags & EIP93_PE_OPTION_AES_KEY256)
> -					eip93_algs[i]->alg.skcipher.max_keysize =
> -						AES_KEYSIZE_256;
> -
> -				if (IS_RFC3686(alg_flags))
> -					eip93_algs[i]->alg.skcipher.max_keysize +=
> -						CTR_RFC3686_NONCE_SIZE;
> -			}
> -		}
> -
> -		if (IS_HASH_MD5(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_MD5))
> -			continue;
> -
> -		if (IS_HASH_SHA1(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_1))
> -			continue;
> -
> -		if (IS_HASH_SHA224(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_224))
> -			continue;
> -
> -		if (IS_HASH_SHA256(alg_flags) &&
> -		    !(supported_algo_flags & EIP93_PE_OPTION_SHA_256))
> +		if (!eip93_algo_is_supported(eip93_algs[i], supported_algo_flags))
>  			continue;
>  
>  		switch (eip93_algs[i]->type) {
> @@ -167,7 +179,7 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
>  	return 0;
>  
>  fail:
> -	eip93_unregister_algs(i);
> +	eip93_unregister_algs(supported_algo_flags, i);
>  
>  	return ret;
>  }
> @@ -469,8 +481,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>  static void eip93_crypto_remove(struct platform_device *pdev)
>  {
>  	struct eip93_device *eip93 = platform_get_drvdata(pdev);
> +	u32 algo_flags;
> +
> +	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
>  
> -	eip93_unregister_algs(ARRAY_SIZE(eip93_algs));
> +	eip93_unregister_algs(algo_flags, ARRAY_SIZE(eip93_algs));
>  	eip93_cleanup(eip93);
>  }
>  
> -- 
> 2.47.3
> 
