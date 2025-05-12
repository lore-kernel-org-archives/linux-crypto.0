Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C01F80B;
	Mon, 12 May 2025 05:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747027906; cv=none; b=I6VUpqkgw8ngyAQzDcxa1oMD/T+9WMmy6+ziCqi5SMR8CU2vf1BO4Gdu46RlJfGjEedKYBxkD7TCl1D5C89dkzgTmelsR1CkxZUjmuKhFURqvgZrShy4J7DcTIGU2D4EQjY5Ri5e7OzRrIP2+zBtIOc4GaRX7jLWhuTu3KO56Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747027906; c=relaxed/simple;
	bh=2DC8abopmBoDowjWYMQqQQYb8/6NOGZ2UrtOyytbuQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RX+zPyRtkdZhqStvo66uWidJ9+yIZDI35ETDCxmjzZ0JCCVYTNCKL2AksIFCmyObBbrWmWMlfQO/Fbe56MXTTJagzHorn5SyRCQy3yWcM3UfeKndMd0tqBKRd50XJJBvDwLz0jWv2C0XbInhB8gy0D+BknOQf5Kkb0+4EyM1+nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZbbF12EV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZbbF12EV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FkiaF5ShVJ8/RxqNbEWvxjLwiXFT+c2UB6gm8Y0G4xA=; b=ZbbF12EVAXljuXAZZkJH1/7cCa
	kVjZL3tJVKvA/Is88/iIuM2YCqDhc5QHEkWqKJFkBmhPMLoiC1BMxJIaeRcwupDMLIyaYkc7ChHWZ
	xoPpvSwEs3HIz9BWKBPfBQOwglVvfq3IQLQifG/UpLdSPZiLWjzYReJ0v/dazr5w1UeRq5ioMHWXK
	42ht1aK2hfOuaADSUpEWZfCO2omFXu2+ZGpxJ93qhaAiXE5uM8cYYoRU8rmZtB2ABIdnvBcjopiWV
	TM25j3y9GpFaeBBy0jib1QqBz5Rv8SSghQbPW5h51PRBOtxY11U6AZiku762RZm/2KDugKEOcwiSZ
	woCAF/2w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uELlG-005LgZ-0J;
	Mon, 12 May 2025 13:31:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 May 2025 13:31:34 +0800
Date: Mon, 12 May 2025 13:31:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	robh@kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: Re: [PATCH v2 4/6] Add SPAcc ahash support
Message-ID: <aCGHtqVp1KUJQkHx@gondor.apana.org.au>
References: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
 <20250505125538.2991314-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505125538.2991314-5-pavitrakumarm@vayavyalabs.com>

On Mon, May 05, 2025 at 06:25:36PM +0530, Pavitrakumar M wrote:
> From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> 
> Add ahash support to SPAcc driver.
> Below are the hash algos supported:
> - cmac(aes)
> - xcbc(aes)
> - cmac(sm4)
> - xcbc(sm4)
> - hmac(md5)
> - md5
> - hmac(sha1)
> - sha1
> - sha224
> - sha256
> - sha384
> - sha512
> - hmac(sha224)
> - hmac(sha256)
> - hmac(sha384)
> - hmac(sha512)
> - sha3-224
> - sha3-256
> - sha3-384
> - sha3-512
> - hmac(sm3)
> - sm3
> - michael_mic
> 
> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  drivers/crypto/dwc-spacc/spacc_ahash.c | 972 +++++++++++++++++++++++++
>  1 file changed, 972 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c

Please rebase this on top of the ahash partial block patch:

https://patchwork.kernel.org/project/linux-crypto/list/?series=961711

For an example of what the driver should look like, see

https://patchwork.kernel.org/project/linux-crypto/patch/aBnJ-fhTAuuf4Vfa@gondor.apana.org.au/

> +static int spacc_hash_cra_init(struct crypto_tfm *tfm)

cra_init is obsolete, please use init_tfm.

> +{
> +	struct spacc_priv *priv = NULL;
> +	const struct spacc_alg *salg = spacc_tfm_ahash(tfm);
> +	struct spacc_crypto_ctx *tctx = crypto_tfm_ctx(tfm);
> +
> +	tctx->handle    = -1;
> +	tctx->ctx_valid = false;
> +	tctx->dev       = get_device(salg->dev);
> +
> +	if (salg->mode->sw_fb) {

The API now provides a synchornous fallback for all async ahash
drivers.  Please use that rather than allocating your own.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
