Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EC729A1;
	Thu,  6 Nov 2025 04:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762403622; cv=none; b=NdkajAXwRDF9utyEKws9E9/UNKcz4AtXfa7bXxFg9cu7zJCHBh5iTeoxqTGzrxuU7gIEhiLsYqWZlmsdSl6a8JZBe87RLIlYSCmDRu26h8fjwiQcKpuQN/fg4KmCao9jdei8z0pIMik64eg59QqjVyzD+03kbIC4HtZwPHrE0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762403622; c=relaxed/simple;
	bh=8o+IJNUe0F8ZlMA1RfLXOVLUTLBUd0sZPcNe4Bv2zYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtI8UXHujCf9bzmSnx4jyw4LcpuafgS54JF6FYVroIuZ1M+kXL1wc3YvUmV1BK4Jz/tUkp25dzwt8zE6kv27tdlSwHYwnsXDT7qrFZ9BRivPpGGnl6Ju4mjG7aueV/TPEmj9vZOz6e0jhS60C9C1LMXT1QnZCaVa0wvfv0msHIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=V21XD2ci; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="V21XD2ci"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xFVF8hcyyJXywbekbwZWS0m4c7TNp2T6eU3I4HWZyY0=; 
	b=V21XD2ciC8mWSIgvOmJBojTX0vMkPP04EFgOkmJrcZN6TmUxITVstbnIrV/jq8J59DNAlgvtJJW
	8swxpyfbZI4rL0lT3mcWtbRm47/wW3EfQZy7jEgDxtlYlo56YtYiPOVmnknDL5MlDsrZnm5L+tT1G
	kuWauin+hDLmcwsxoaYndsq7nEDTrCKkuVFXYekNn31CJ3H3N75dTlo5/8ToFxxUjaJayDMZvO2zr
	SkEUCMpgq+bAByJDYFfBUaSv2PJqPzSylu5lP+QFpbIS7Pvd3HPXXSDOwDV2QjuyAYw+6eXC6PkhP
	XBmkEAhaESb9lOE2jHz/9HPse101Mi35PAFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGrgY-000qB9-2T;
	Thu, 06 Nov 2025 12:33:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 12:33:22 +0800
Date: Thu, 6 Nov 2025 12:33:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, michal.simek@amd.com,
	linux-arm-kernel@lists.infradead.org, jay.buddhabhatti@amd.com
Subject: Re: [PATCH 09/15] crypto: zynqmp-aes-gcm: Fix setkey operation to
 select HW keys
Message-ID: <aQwlEgMlYr8EPrTo@gondor.apana.org.au>
References: <20251029102158.3190743-1-h.jain@amd.com>
 <20251029102158.3190743-10-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029102158.3190743-10-h.jain@amd.com>

On Wed, Oct 29, 2025 at 03:51:52PM +0530, Harsh Jain wrote:
> Currently keylen 1 is used to select hw key. There are -ve self test
> which can fail for setkey length 1. Update driver to use 4 bytes
> with magic number to select H/W key type.
> 
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 94 ++++++++++++++++----------
>  1 file changed, 60 insertions(+), 34 deletions(-)

The hardware key support should be registered under the name paes
instead of aes.  Grep for paes in drivers/crypto for examples.

> @@ -218,32 +220,42 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
>  				  unsigned int keylen)
>  {
>  	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> -	struct zynqmp_aead_tfm_ctx *tfm_ctx =
> -			(struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
> +	struct xilinx_hwkey_info hwkey;
>  	unsigned char keysrc;
> +	int err;
>  
> -	if (keylen == ZYNQMP_KEY_SRC_SEL_KEY_LEN) {
> -		keysrc = *key;
> +	if (keylen == sizeof(struct xilinx_hwkey_info)) {
> +		memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
> +		if (hwkey.magic != XILINX_KEY_MAGIC)
> +			return -EINVAL;
> +		keysrc = hwkey.type;
>  		if (keysrc == ZYNQMP_AES_KUP_KEY ||
>  		    keysrc == ZYNQMP_AES_DEV_KEY ||
>  		    keysrc == ZYNQMP_AES_PUF_KEY) {
> -			tfm_ctx->keysrc = (enum zynqmp_aead_keysrc)keysrc;
> -		} else {
> -			tfm_ctx->keylen = keylen;
> +			tfm_ctx->keysrc = keysrc;
> +			tfm_ctx->keylen = sizeof(struct xilinx_hwkey_info);
> +			return 0;
>  		}
> -	} else {
> +		return -EINVAL;
> +	}
> +
> +	if (keylen == ZYNQMP_AES_KEY_SIZE && tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY) {
>  		tfm_ctx->keylen = keylen;
> -		if (keylen == ZYNQMP_AES_KEY_SIZE) {
> -			tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
> -			memcpy(tfm_ctx->key, key, keylen);
> -		}
> +		memcpy(tfm_ctx->key, key, keylen);
> +	} else if (tfm_ctx->keysrc != ZYNQMP_AES_KUP_KEY) {
> +		return -EINVAL;
>  	}
>  
>  	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
>  	tfm_ctx->fbk_cipher->base.crt_flags |= (aead->base.crt_flags &
>  					CRYPTO_TFM_REQ_MASK);
>  
> -	return crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
> +	err = crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
> +	if (!err)
> +		tfm_ctx->keylen = keylen;

You can't have a fallback when there is a hardware key.  How did
the fallback not return an error here?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
