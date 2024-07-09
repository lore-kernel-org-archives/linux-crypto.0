Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0917B02B;
	Tue,  9 Jul 2024 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720555921; cv=none; b=IX1O6NdDZSAO7d9F0HJVTy7H1Peei9aknnIwXRajeETWtNAbbSOpK/9l/FHhrAEQn42xb7pW1U3xMQ7PvaKbrkWU48V9VAE15pImnN2M1FX4s9RRjDq5ZmKXYlYFu2rE4FY6ELa5oS7V22Jqx5yw56vfNsDNKAVNKucsQ0DaES8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720555921; c=relaxed/simple;
	bh=IBK+DGO9zAxTZrcZNfXAdczs0w6cSJE55I/WCXZ0AQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdezDHApR+2uGDL18Fwdm49tliaPeWhHIFZqEKRjpKgVQo/NOVq7Z0Uil9daWI/VkPnZsSlmmbfS3VOsiUCgmg219BTlqH8Sb5n5pdYyCNITIgqVur+TXK0e0ChT48qJFls6//nagqF5TzBZu/ZFDt9NqJ7PprU6wj7J4yCinTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sRHBR-000cJ0-36;
	Wed, 10 Jul 2024 06:11:31 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jul 2024 06:11:30 +1000
Date: Wed, 10 Jul 2024 06:11:30 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - enable hash api only on ARM platforms per
 default
Message-ID: <Zo2ZcqP5zSLB0mf+@gondor.apana.org.au>
References: <20240626155724.4045056-1-m.felsch@pengutronix.de>
 <258feb43-382d-4ea0-9164-357924350dec@nxp.com>
 <ZofSbH2Fu/xLnzif@gondor.apana.org.au>
 <20240709085454.you3b3ueb3xbtrv6@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709085454.you3b3ueb3xbtrv6@pengutronix.de>

On Tue, Jul 09, 2024 at 10:54:54AM +0200, Marco Felsch wrote:
>
> We had an patch exactly doing this but depending on the SoC the default
> prio may valid since the CAAM is used on ARMv7 and ARMv8 NXP SoCs. To
> not cause any regression we went this way.

I don't understand.  Why not just set the priority depending on
IS_ENABLED(CONFIG_ARM)? That way it's strictly better than the
Kconfig patch:

1) If the driver is indeed slower then you'd have achieved the same
result of preferring the non-driver algorithm.

2) If the driver ends up being faster then at least the admin can
adjust the priorities.

Or perhaps your Kconfig option should set the priority.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
