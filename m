From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH RESEND 0/4] ARM: at91: remove at91sam9g45/9m10 legacy
 board support
Date: Wed, 19 Nov 2014 17:15:47 +0100
Message-ID: <546CC233.6090605@atmel.com>
References: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	"Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
	Andrew Victor <linux@maxim.org.za>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-crypto@vger.kernel.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:63757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaKSQPx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 11:15:53 -0500
In-Reply-To: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19/11/2014 17:07, Boris Brezillon :
> Hello,
> 
> This series adds DT support for the TRNG (True Random Generator) block and
> adds missing trng nodes to dtsi files.

Nitpicking: subject of this cover letter seems not good ;-)

Herbert, do you think you can take this series yourself or do I have to
take it?

Bye,

> Boris Brezillon (4):
>   hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
>   hwrng: atmel: add DT support
>   hwrng: atmel: Add TRNG DT binding doc
>   ARM: at91/dt: add trng node
> 
>  Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
>  arch/arm/boot/dts/at91sam9g45.dtsi                     |  7 +++++++
>  drivers/char/hw_random/Kconfig                         |  2 +-
>  drivers/char/hw_random/atmel-rng.c                     | 15 +++++++++++----
>  4 files changed, 35 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt
> 


-- 
Nicolas Ferre
