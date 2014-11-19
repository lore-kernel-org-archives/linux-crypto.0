From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH RESEND 0/4] hrng: atmel: add DT support
Date: Wed, 19 Nov 2014 17:18:24 +0100
Message-ID: <20141119171824.1e8dc40d@bbrezillon>
References: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
	<546CC233.6090605@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
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
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:40183 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534AbaKSQS2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 11:18:28 -0500
In-Reply-To: <546CC233.6090605@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 19 Nov 2014 17:15:47 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> On 19/11/2014 17:07, Boris Brezillon :
> > Hello,
> > 
> > This series adds DT support for the TRNG (True Random Generator) block and
> > adds missing trng nodes to dtsi files.
> 
> Nitpicking: subject of this cover letter seems not good ;-)

Sorry, you should read:

"hrng: atmel: add DT support"

> 
> Herbert, do you think you can take this series yourself or do I have to
> take it?
> 
> Bye,
> 
> > Boris Brezillon (4):
> >   hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
> >   hwrng: atmel: add DT support
> >   hwrng: atmel: Add TRNG DT binding doc
> >   ARM: at91/dt: add trng node
> > 
> >  Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
> >  arch/arm/boot/dts/at91sam9g45.dtsi                     |  7 +++++++
> >  drivers/char/hw_random/Kconfig                         |  2 +-
> >  drivers/char/hw_random/atmel-rng.c                     | 15 +++++++++++----
> >  4 files changed, 35 insertions(+), 5 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt
> > 
> 
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
