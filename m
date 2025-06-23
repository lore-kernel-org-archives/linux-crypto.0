Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60692940F;
	Mon, 23 Jun 2025 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670297; cv=none; b=ra3TWF0bM9VoGhzpHFXhT19+zZm0ITmwJCj8PIcVCR18nFEcuVWwIhetM81eqYkQCxg/zwwjOCzQseKUSBE+GEDKtRrgzRYfLbGB5O/DOG4FnaYTZTDrqwwrIuArZkpvcKWRW9rQbiQtL7sWQwt2vNGWLrPJ1d1JD/K76/1wtvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670297; c=relaxed/simple;
	bh=uUCG0PtgoY0CiWy/SYGswt6YhPYBd5m46i/7r2ff9zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJNTSvUTPnxuAXN0FSOLjpdRzi+OlTRu0zxXqF3NCL3fXzrzyBFAfSBGCgMbuFUDnmvevuNDdI2lKtZdnIxyhLRk4Vo6bfVEU/odA6nfU0DeOccq6KDYVE0/uRDYAFzAJThoCyfbhBwmfsH6iqz91imTAe99Lxw0LJyV4GltOGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=drXULibQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="drXULibQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=34TxypIJyscDJLphDBw7+DPinr1/GPNGSO+jpo8aCL0=; b=drXULibQwGxgidQrP7A6XdplMP
	YFYg4bPm5y2irU5k0RG2tJU3tjk1xkOdUXoGbpAwV4RRbDVk910WkE8wC58VhuBZRBKmLJQnwnWJj
	KtYTWmlYqxuQzTjNv8/n8vd4hUySlo5Kksl8XPEGCru9CFj9LyS+36CbPd0cKCDBejg7li2yWTNFj
	3imYR6R3fVY6gu/hg6Qsj1r/6QEpzZ664vd8QneO6gv+WXT36RFg1EAvXl2/JQRf8QFT4y3drW6M5
	JI+F1P4YabWroEYJ7GSS+4OdKvlYzmTLaRrsutQBIZLncxkYJ6owHvSvswAE5D/HwmIrY/l6gYVPd
	OjQP0/3g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd3z-000FU3-1a;
	Mon, 23 Jun 2025 17:18:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:17:59 +0800
Date: Mon, 23 Jun 2025 17:17:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: John Ernberg <john.ernberg@actia.se>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 0/4] crypto: caam - iMX8QXP support (and related fixes)
Message-ID: <aFkbx_39WopOdwdV@gondor.apana.org.au>
References: <20250611113748.2986988-1-john.ernberg@actia.se>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250611113748.2986988-1-john.ernberg@actia.se>

On Wed, Jun 11, 2025 at 11:38:08AM +0000, John Ernberg wrote:
> This series enables the use of the CAAM (Cryptographic Acceleration and
> Assurance Module) on the iMX8QXP (and its variants).
> 
> v6: (detailed changelog in each patch)
>  - Fix property order in bindings (Frank Li)
>  - Collect tags
> 
> v5: https://lore.kernel.org/linux-crypto/20250610085110.2295392-1-john.ernberg@actia.se/T
>  - Fix indentation issues in bindings (Rob Herring's bot)
>  - Collect tags
> 
> v4: https://lore.kernel.org/linux-crypto/20250605132754.1771368-1-john.ernberg@actia.se/T
>  - Declare more compatibles in bindings (Frank Li)
>  - Move job-ring compat check under the job-ring subschema (Rob Herring)
> 
> v3: https://lore.kernel.org/linux-crypto/20250528144259.2603914-1-john.ernberg@actia.se/T
>  - Fix devicetree CI detected errors (Rob Herring's bot)
>  - Declare the compatibles correctly in bindings (Krzysztof Kozlowski)
> 
> v2: https://lore.kernel.org/linux-crypto/20250527071552.1424997-1-john.ernberg@actia.se/T
>  - Clarify in the commit message how the crash fix works (Frank Li)
>  - Restrict power-domains only for iMX8Q* SoCs in bindings (Frank Li)
>  - Collect tags
> 
> v1: https://lore.kernel.org/linux-crypto/20250523131814.1047662-1-john.ernberg@actia.se/T
> 
> Horia Geantă (1):
>   arm64: dts: freescale: imx8qxp/imx8qm: Add CAAM support
> 
> John Ernberg (3):
>   crypto: caam - Prevent crash on suspend with iMX8QM / iMX8ULP
>   crypto: caam - Support iMX8QXP and variants thereof
>   dt-bindings: crypto: fsl,sec-v4.0: Add power domains for iMX8QM and
>     iMX8QXP
> 
>  .../bindings/crypto/fsl,sec-v4.0.yaml         | 41 ++++++++++++++++++-
>  .../boot/dts/freescale/imx8-ss-security.dtsi  | 38 +++++++++++++++++
>  arch/arm64/boot/dts/freescale/imx8qm.dtsi     |  1 +
>  .../dts/freescale/imx8qxp-ss-security.dtsi    | 16 ++++++++
>  arch/arm64/boot/dts/freescale/imx8qxp.dtsi    |  2 +
>  drivers/crypto/caam/ctrl.c                    |  7 ++--
>  drivers/crypto/caam/intern.h                  |  1 +
>  7 files changed, 102 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8-ss-security.dtsi
>  create mode 100644 arch/arm64/boot/dts/freescale/imx8qxp-ss-security.dtsi
> 
> -- 
> 2.49.0

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
