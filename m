Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C8B13B7BC;
	Sun, 10 Nov 2024 03:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731211088; cv=none; b=iaH6j9t0FahVvo806rU87ts7PcwBMxL59KyrPhz3JS0Pe3AUwnH95tzcAS18ABFKCmy5FxyQHMe3smVrn/fVlcfufuFaFFtFbCZ09mlxHlxMLZMXDjY+HJ8Hi3yQdTDj0YW/vmiE1KFA6QrjA7reFcSDm61XD7Le4bMxodeTQJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731211088; c=relaxed/simple;
	bh=v7KRGa2Xq5P41ITSle9qHQxHfag9tq94893b/g4hwD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNLku87PSErXx6IuWbC6Sg3fkNX5DJLHb7Y1Gwh7PWB3iwks5eqlOu9cdedDQRvi7G3sU1MgN4tRi79eQa1hqZpclhD1iDalZEZZOuyrK2dFS4iL3fvkLaSxYGioGacCe6AFcof8C4sQYvRkWJ6/1IfwX+hv9jQVPnyABgOwz4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PCgyLd6T; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PCgyLd6T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/my/R9IxF7ykoiXNc73XyDt3B6bDlwZcW9k4cl4jEQw=; b=PCgyLd6TblnAXq0jU2CEyOXZMI
	O/aH5iKhDKls37C/WXRQDe+o/fIR7jA/R3+V6AvW/uCiKcB9dUGGVpmFwQK6OpfEy64E4JRbEy3I3
	kmZwAm2WvsLCFH7v1Isbj450fMX3F6LkN39ZxnIbBldCE57yG6ppjbbkMrODsvl11MAC42Nyqg0q7
	h+GR4Na9TzFEefyka7RsHy91WvY/synr8UVTbvI7XybCNyZfIxaOIKLgfRlzrVuQn49N9t4vvDLeg
	MyqX072KVZtNlROUBbhZZNPmiFndnEP9pRmT8rw3d4l2VpjhyTTxtvfC9KsPPlVWcG8X7VQ/7TykM
	YPHgwi/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9z4s-00FkGA-0j;
	Sun, 10 Nov 2024 11:57:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:57:30 +0800
Date: Sun, 10 Nov 2024 11:57:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Mayer <mmayer@broadcom.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
Message-ID: <ZzAvKs50olJMI5aU@gondor.apana.org.au>
References: <20241101211316.91345-1-mmayer@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101211316.91345-1-mmayer@broadcom.com>

On Fri, Nov 01, 2024 at 02:13:13PM -0700, Markus Mayer wrote:
> This series adds a driver for the random number generator found on the
> BCM74110 SoC.
> 
> Binding changes from v1:
>   - renamed binding file to brcm,bcm74110-rng.yaml
>   - ensure "brcm,bcm74110-rng" is being used instead of "...-trng"
>   - removed "|" after "description:"
>   - removed label "rng:"
> 
> Code-related changes from v1:
>   - only enable the driver for ARCH_BRCMSTB || COMPILE_TEST
> 
> Markus Mayer (2):
>   dt-bindings: rng: add binding for BCM74110 RNG
>   hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
> 
>  .../bindings/rng/brcm,bcm74110-rng.yaml       |  35 +++++
>  drivers/char/hw_random/Kconfig                |  13 ++
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/bcm74110-rng.c         | 125 ++++++++++++++++++
>  4 files changed, 174 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml
>  create mode 100644 drivers/char/hw_random/bcm74110-rng.c
> 
> -- 
> 2.47.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
