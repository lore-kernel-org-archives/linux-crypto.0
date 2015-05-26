From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 14/16] ARM: marvell/dt: enable crypto on armada-xp-gp
Date: Tue, 26 May 2015 10:59:36 +0200
Message-ID: <20150526105936.25db3afb@bbrezillon>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-15-git-send-email-boris.brezillon@free-electrons.com>
	<55633B6D.7080307@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [37.187.137.238] ([37.187.137.238]:48919 "EHLO
	mail.free-electrons.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751275AbbEZJAE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 05:00:04 -0400
In-Reply-To: <55633B6D.7080307@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 25 May 2015 17:10:37 +0200
Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:

> Hi Boris,
> 
> On 22/05/2015 15:34, Boris Brezillon wrote:
> > Enable the crypto IP on armada-xp-gp.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/armada-xp-gp.dts | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
> > index 565227e..8a739f4 100644
> > --- a/arch/arm/boot/dts/armada-xp-gp.dts
> > +++ b/arch/arm/boot/dts/armada-xp-gp.dts
> > @@ -94,7 +94,9 @@
> >  	soc {
> >  		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xf1000000 0x100000
> >  			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000
> > -			  MBUS_ID(0x01, 0x2f) 0 0 0xf0000000 0x1000000>;
> > +			  MBUS_ID(0x01, 0x2f) 0 0 0xf0000000 0x1000000
> > +			  MBUS_ID(0x09, 0x09) 0 0 0xf1100000 0x10000
> > +			  MBUS_ID(0x09, 0x05) 0 0 0xf1110000 0x10000>;
> 
> As the crypto engine really depend on the SoC itself and not of the board,
> what about updating the dts of the other board using an Armada XP?

But that means introducing changes I haven't tested. Are you okay with
that ?


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
