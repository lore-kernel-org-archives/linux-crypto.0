Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97950201261;
	Mon, 23 Jun 2025 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670319; cv=none; b=QO/ZgB26azLx/4fmgS9h6gaH+8Iy+kADu+PpnHR308PXTWBYvp3FYHDIA9K3C4/cr7xtOTo8h6FsUws8WatKLDei/wurlLoT91vNL5AypxfnYjeu4iyvx3hY0v1ytBPcs5rVxotBTYcgV/1NHvBjXFB5Jk9tTGl6+YlGYp/vH3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670319; c=relaxed/simple;
	bh=vDUFKM5H4Fo9oxcdW0YHCSD3LvMeoTgVOpS0tg1jPas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBDH9fzvyUDi9LruSBMj1T6tu8GUm9gsqvO8Jlaw2eYAk65vZGsQI0JTDbksHRmR91O5ykjtPf9Ahvh2kUaw/t2vz8LzigGp5k9iDCgG5X+Lrg05/vWIl8jru+VjRa7bFaetNe86itCZSivt9Z+Eg7eJQV11pPDWe2yiLLUMYxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r68pb9F7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r68pb9F7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=n7uybZ6Jee+DgIMG+lVOiH43zJ3SvTr/jowuILPWQbc=; b=r68pb9F75zKL7vGHnhM3q3TasE
	GnEJcd6PwKGQ01hH6MjERdCWMdmSaUKyWUt3CNPlJ6ltkyPWk74NKhBuwNpdjQ4uvIYD/H1Jv0uJw
	hmIPS8SBah+NdgEqRjduZxon6P/bh0DscmQSQi5AFGTUUp3b25iVRzJ9cMfXdwfAeZYZBE+dIr5Tb
	vrgcK/sptmlNak6K1kQ+xipDGEZ+gFEEhxcDcfDtamb8CI/Ui66Gkee26EjSVSBelIDafk+TedmX5
	Ulo+CoKwH4vMdBGrSEaOdX/9nwq6ALhQ+mw77SSRCSocvr0X+//2Dz6s7oMo5oH9VDJ6j+P52o82k
	L2YTri1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd4I-000FUF-1u;
	Mon, 23 Jun 2025 17:18:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:18:18 +0800
Date: Mon, 23 Jun 2025 17:18:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan.Wanner@microchip.com
Cc: davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev,
	olivia@selenic.com, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] SAMA7D65 Add support for Crypto, CAN and PWM
Message-ID: <aFkb2u8hCgHmDMsI@gondor.apana.org.au>
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1749666053.git.Ryan.Wanner@microchip.com>

On Wed, Jun 11, 2025 at 12:47:24PM -0700, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> This set adds support for the SAMA7D65 SoC crypto subsystem and enabling
> them in the device tree. This set also adds PWM to the device tree, and
> adds and enables the CAN bus system for the SAMA7D65 SoC.
> 
> Changes v1 -> v2:
> - Clean up formatting issues in the device tree and DT bindings.
> - Add a description of the capabilities for the cyrpto IPs for this SoC.
> 
> Ryan Wanner (10):
>   dt-bindings: crypto: add sama7d65 in Atmel AES
>   dt-bindings: crypto: add sama7d65 in Atmel SHA
>   dt-bindings: crypto: add sama7d65 in Atmel TDES
>   dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
>   crypto: atmel - add support for AES and SHA IPs available on sama7d65
>     SoC
>   ARM: dts: microchip: sama7d65: Add crypto support
>   ARM: dts: microchip: sama7d65: Add PWM support
>   ARM: dts: microchip: sama7d65: Add CAN bus support
>   ARM: dts: microchip: sama7d65: Clean up extra space
>   ARM: dts: microchip: sama7d65: Enable CAN bus
> 
>  .../crypto/atmel,at91sam9g46-aes.yaml         |   4 +-
>  .../crypto/atmel,at91sam9g46-sha.yaml         |   4 +-
>  .../crypto/atmel,at91sam9g46-tdes.yaml        |   4 +-
>  .../bindings/rng/atmel,at91-trng.yaml         |   1 +
>  .../dts/microchip/at91-sama7d65_curiosity.dts |  35 +++++
>  arch/arm/boot/dts/microchip/sama7d65.dtsi     | 128 ++++++++++++++++++
>  drivers/crypto/atmel-aes.c                    |   1 +
>  drivers/crypto/atmel-sha.c                    |   1 +
>  8 files changed, 175 insertions(+), 3 deletions(-)
> 
> -- 
> 2.43.0

Patches 1-5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
