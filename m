Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00442AEED;
	Wed, 11 Jun 2025 09:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749634361; cv=none; b=QaswcS5sIk0ilSDTK5yLJhmDBUCHK9176vkVvJpYnHCe7q9ai8WYMCEQPaEqHWeSytH1m69ejP0bznU4EFqo+yjNOZa7UZxbgoqH36upxDGcgsuxHsxqwZn21ESV+MageorwmvRTTq49Oj0RbmbmUyOSPBJnkMmM/3Q6bsT+JcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749634361; c=relaxed/simple;
	bh=vNMDl7G+f2zz/DCgY/gXf0grMcMauQrx7UipViQcEd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgxLViYPCkj9Jgw8+V6VYyXnwIe2Ngvo2qug1pFjshqHDYuQYIeaxU8BVOROJaeHNKXSLZjA5fgbGkbCiteqDQFbJpuXIBmQR36MCcSL+PfSqQv7+grm+bu1/vsqT2mMVPEF34sX/FxE8kanpoQMlACx+7HFfT4FV2GmKXaMmAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=beVRT23y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="beVRT23y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nKxji3PxhVfQiiyeHhRwiNW7gl6DkSceGLx1L7nQBoI=; b=beVRT23yBDqNex9G5tF2pULvF/
	6omsqsoWio4Ln45US+O2+xyrQ3z4zyXw1012iqb/l8O9uni5NYWx5FR5TYsgt0PjnhUF02uXCGd83
	MY0BoL+5yUY5K1CjKV8Z13KFYeeHJVu5mDvLHmEmivav4Phubv0az9YoHW4MAYOMsVGRrBFR0Py22
	9KollBHOGizVX2xb8LkUBMlh0zf5GAigstNhxg+MEOzxy7SqwbBw6/eF4NRRCoajUoR05R2tRRdhr
	1awXllDADU3bJopDq/NT4eFVljUIBGFwANNogqEwIlZtjDFKEmHUvlNvVJ8YRtHVqbNHXs4pFJ1sQ
	wgPWzhOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPHor-00CJON-2w;
	Wed, 11 Jun 2025 17:32:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 17:32:29 +0800
Date: Wed, 11 Jun 2025 17:32:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
Message-ID: <aElNLaBWM56vyFC6@gondor.apana.org.au>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250603124217.957116-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603124217.957116-3-t-pratham@ti.com>

On Tue, Jun 03, 2025 at 06:07:29PM +0530, T Pratham wrote:
>
> +static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +	ctx->keylen = 0;
> +}

This is pointless.  Just get rid of the exit_tfm function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
