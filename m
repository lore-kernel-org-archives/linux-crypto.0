Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06B722AE7E;
	Wed, 16 Apr 2025 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744787021; cv=none; b=XOKsP2f+jmG9rHwurg81z0T5URLa9eJwDW08dOL/3E1EelZd70X/Qxne4aiYUFzkYqj6rFNeHFuUAvBxEcMCJbC3U0wu4hhFa72Veag0uif+PlvBovEsnfoR19Kq8plkCCOmXCYSXGI688H9rSQn0SXFhzIdJYD6ONasqPS9QHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744787021; c=relaxed/simple;
	bh=jp5cuusuZlWSG9qC8WkJbw+y7WybCshjWUXUvRyu0lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXEgAjfjRGv8lRffoIA2TXwRiydPxnuLcw672w/TLDKVOE8Do7/YQhNUrU+Cneu88rZawf9ODEw/KX1RM6THOZNilpHl8ZFQ/abhlnNgCQCeKYD6Z30zuWmDUqLGkrQ8EbUr1hsjtXvoD7LFg7LYZ/h2RFIdvM5YnSG3JI6XPtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Xu13jP7Y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Xu13jP7Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Obah4dDcC5p/Xr+tamvOubSTzdyNUfy7HNjgymRkE4c=; b=Xu13jP7YnvsA0jxvBfQyX0R6vf
	zhlgZgAo1i/qge45QVxgDuVwZDuzvMimYoferLCTr0cmX6S5vFCUkGHzYSYyTDXxbzrJS4hkJr8Sg
	xUuWzxvOntEdI2IO6tLQotFV0fWWolKuT2bo+tzqXHhYU8IQEEEtHSTo9ByLKaD97n6R2bCuilWPz
	hoYifsqQrcl/+OmSWVIttTBNTTWS4SGqMzLDYhU7ThIHGI/FmHxWwA4l02w6ee1fgZ5ex1otHs25k
	2N0kKdSH9JlSy0B3vZR69C+ZgbHiOI+SxxOg/Bsd7mMdCt0wMDdtvQyXJnVclrlu8K3/JVO2A9FQN
	pDP9qnNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wnv-00G74J-2C;
	Wed, 16 Apr 2025 15:03:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:03:27 +0800
Date: Wed, 16 Apr 2025 15:03:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
Message-ID: <Z_9WPwz-xVdVDMMw@gondor.apana.org.au>
References: <20250411091321.2925308-1-t-pratham@ti.com>
 <20250411091321.2925308-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411091321.2925308-3-t-pratham@ti.com>

On Fri, Apr 11, 2025 at 02:43:22PM +0530, T Pratham wrote:
>
> +	// Need to do a timeout to ensure mutex gets unlocked if DMA callback fails for any reason
> +	ret = wait_for_completion_timeout(&actx->aes_compl, msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));

You cannot wait here.  The preferred method of indicating completion
is through an interrupt.  If you hardware can't do that, then you need
to use crypto_engine and poll in that thread.

> +static int dthe_aes_crypt(struct skcipher_request *req, int enc)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +
> +	/*
> +	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
> +	 * If data length input is zero, no need to do any operation.
> +	 */
> +	if (req->cryptlen % AES_BLOCK_SIZE) {
> +		skcipher_request_complete(req, -EINVAL);

The completion function must not be called unless you first
returned EINPROGRESS.

PS Please set the bit KERN_DRIVER_ONLY in cra_flags.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
