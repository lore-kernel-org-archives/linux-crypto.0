Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946BF2F2B
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 10:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717756253; cv=none; b=utR2YOuEZ8koQcYw7LrVDZbLxfpT7l0fJKN9OCUXkPJkksZnKCSLtl8H8lyKh72PBES02zNFyhNsvwoexP44kCGdUcTcjkg0bNL6yrlx/9KaJNqA+IHx/OUDHXuVdeNHyweV/lR0UJbZo6dXAa5zOkKK6W2XPfGxjl92vndxBU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717756253; c=relaxed/simple;
	bh=hNTEs6DlRSMWNHq9JVbB86K7zzb/hQy0XLD9lIqXo/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOvZ9bS4bAE1fBQC3eeDfEwsKSLo+psNxvPKaHPpMkClwEDkQ7f4qZeJtOeCn+oltiM9Qc7kfnoxfHsoluDc7gkzfhZmTLRbeaq/M7Wzgc5EiwtWafLJ6BY+WMGCpLYYfzC+sjK3n6ReqdeToGUYb5eChW2d5+QI1kLdTAAYkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFWrV-006nL7-2n;
	Fri, 07 Jun 2024 18:30:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 18:30:24 +0800
Date: Fri, 7 Jun 2024 18:30:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, arm@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Olivia Mackall <olivia@selenic.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <ZmLhQBdmg613KdET@gondor.apana.org.au>
References: <20240605161851.13911-1-kabel@kernel.org>
 <20240605161851.13911-7-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240605161851.13911-7-kabel@kernel.org>

On Wed, Jun 05, 2024 at 06:18:49PM +0200, Marek Behún wrote:
>
> +static int omnia_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +	struct omnia_mcu *mcu = (struct omnia_mcu *)rng->priv;

Please don't cast rng->priv in this manner.  Please take a look at
drivers/char/hw_random/bcm2835-rng.c for how it should be done.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
