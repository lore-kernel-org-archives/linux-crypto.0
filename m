Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB75A14E2D5;
	Fri, 10 May 2024 09:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715333042; cv=none; b=pH8Vl4GMp3SbggVSgxPJR3JACpsxqxh4JQVo2X4sFPV5a6a01ePwQn7463jwY2T39aTsL8VxmaLxEPaTXY4A3STUMcbE+1CsZzr0VpJgwCVlqvA+NUC2IEZy7Jv/4QvsI1QzMHqqqEvSmZ6eH3JKl8yLt8CgRZJg0noLZJpS7j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715333042; c=relaxed/simple;
	bh=1haYH3ovXTB+9lxBHQncIc19qHitIh/c2PcuOnw0G5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SG19ZjiK0eu7ppCff2mj/7Sr9348DN4W2k9eGXYsoL1s+7OoG3rGqzfnXVeKefG0OKDzwGUmbDrCV58PmkLacRok1DnrK9Nkn/SIS08U3z0NDjiamW4QJw+bVr18uFw+trF6s+Zg9ytzFeDGHgfOm+FXtMAwkEGxJfG/3UDvA5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5MTS-00DKHE-2l;
	Fri, 10 May 2024 17:23:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 17:23:31 +0800
Date: Fri, 10 May 2024 17:23:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: davem@davemloft.net, nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] crypto: atmel-sha204a - read out otp zone
Message-ID: <Zj3nk_W9VflufS-n@gondor.apana.org.au>
References: <20240503211054.1231-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503211054.1231-1-l.rubusch@gmail.com>

On Fri, May 03, 2024 at 09:10:50PM +0000, Lothar Rubusch wrote:
> Read out otp memory zone of this secure eeprom and rng chip. The chip
> has an otp zone and data zone, both still not accessed. The otp zone
> can be used to store persistently serial numbers or similar, if externally
> pre-configured. In any way the Atmel SHA204a needs to be preconfgured and
> fuse locked in order to be useful also for the already implemented RNG
> functionality. Placing data into the otp zone is optional. If empty, the
> chip returns 0xff on all field. The implementation passes the content to
> a new sysfs handle to userspace. If the chip is locked or not accessible
> no sysfs handle is set.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
> v1 -> v2
> - fix typo in commit title
> - drop patch: remove unused includes
> 
> Lothar Rubusch (4):
>   crypto: atmel-i2c - add missing arg description
>   crypto: atmel-i2c - rename read function
>   crypto: atmel-sha204a - add reading from otp zone
>   crypto: atmel-sha204a - provide the otp content
> 
>  drivers/crypto/atmel-i2c.c     | 30 +++++++++++++--
>  drivers/crypto/atmel-i2c.h     |  8 +++-
>  drivers/crypto/atmel-sha204a.c | 68 ++++++++++++++++++++++++++++++++++
>  3 files changed, 102 insertions(+), 4 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
