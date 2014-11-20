From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND 0/4] ARM: at91: remove at91sam9g45/9m10 legacy
 board support
Date: Thu, 20 Nov 2014 12:05:55 +0800
Message-ID: <20141120040555.GA28420@gondor.apana.org.au>
References: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
 <546CC233.6090605@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Matt Mackall <mpm@selenic.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andrew Victor <linux@maxim.org.za>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52758 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaKTEGj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 23:06:39 -0500
Content-Disposition: inline
In-Reply-To: <546CC233.6090605@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 19, 2014 at 05:15:47PM +0100, Nicolas Ferre wrote:
> On 19/11/2014 17:07, Boris Brezillon :
> > Hello,
> > 
> > This series adds DT support for the TRNG (True Random Generator) block and
> > adds missing trng nodes to dtsi files.
> 
> Nitpicking: subject of this cover letter seems not good ;-)
> 
> Herbert, do you think you can take this series yourself or do I have to
> take it?

Sure I can take this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
