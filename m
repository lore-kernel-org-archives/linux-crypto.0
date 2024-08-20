Received: from riemann.telenet-ops.be (riemann.telenet-ops.be [195.130.137.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D2B17740
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724147489; cv=none; b=nIYX3itKW2INKB0JmE4/kEOTAAjfvT/WEucKO5edXGbrPTDMym1Mmr6EatLlTbvU16ZVwoWjX4wxbI8f2Hk1hEgkRpNJhB7/+gnw/WGeT3NdRNjQLHWIRMzx8vmc2yLtgfoSqPxVLgsLpg9722jxHdU0/ncNuVCCj/TzL3q2/h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724147489; c=relaxed/simple;
	bh=35HErn56jCnPsEUv04Nn9P+mflOsYrUik+G5GA7W7Zg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NQPgN/hQKPX4oWcpIfC0Kpsph8i98kmemLOUZMX1DH/+NqkhGl1xam5BhrDOEC8cz2kecpB/Pf3OKM6U9R3sx1i6Q3wYvP3k1UEEs8FQdrTRZYBZjlFCChgFE6bOOsnBBqp09Sbjylz5Blj3txbN5BkPA/7SQT/rxm6p7i7KW8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
	by riemann.telenet-ops.be (Postfix) with ESMTPS id 4Wp4LR2fJBz4wyKN
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 11:44:31 +0200 (CEST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:a2e4:464c:5828:2da3])
	by xavier.telenet-ops.be with bizsmtp
	id 29kP2D00b2WQTnu019kPfp; Tue, 20 Aug 2024 11:44:24 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1sgLPb-000Mff-FI;
	Tue, 20 Aug 2024 11:44:23 +0200
Date: Tue, 20 Aug 2024 11:44:23 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
    Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
    bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Subject: Re: [PATCH v4 5/7] Add SPAcc Kconfig and Makefile
In-Reply-To: <20240618042750.485720-6-pavitrakumarm@vayavyalabs.com>
Message-ID: <9e607719-656c-6fc6-f722-5d221a529431@linux-m68k.org>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com> <20240618042750.485720-6-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Pavitrakumar,

On Tue, 18 Jun 2024, Pavitrakumar M wrote:
> Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

Thanks for your patch, which is now commit cb67c924b2a7b561
("crypto: spacc - Add SPAcc Kconfig and Makefile") in crypto/master.

> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/Kconfig
> @@ -0,0 +1,95 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +config CRYPTO_DEV_SPACC
> +	tristate "Support for dw_spacc Security protocol accelerators"
> +	depends on HAS_DMA
> +	default m

Please do not default random drivers to "m" (which means "y" if
CONFIG_MODULES is disabled!).

> +
> +	help
> +	  This enables support for the HASH/CRYP/AEAD hw accelerator which can be found
> +	  on dw_spacc IP.

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
