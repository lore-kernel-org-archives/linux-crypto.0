From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC 06/11] crypto: caam: ensure that we clean up after an
 error
Date: Wed, 9 Dec 2015 18:30:13 +0000
Message-ID: <20151209183013.GJ8644@n2100.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
 <E1a61Cz-0007mm-QP@rmk-PC.arm.linux.org.uk>
 <566843F9.6000508@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37843 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbbLISaY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 13:30:24 -0500
Content-Disposition: inline
In-Reply-To: <566843F9.6000508@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 05:08:41PM +0200, Horia Geant=C4=83 wrote:
> On 12/7/2015 9:12 PM, Russell King wrote:
> > Ensure that we clean up allocations and DMA mappings after encounte=
ring
> > an error rather than just giving up and leaking memory and resource=
s.
> >=20
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>=20
> I guess the error cleanup code should be grouped under an "err" label=
,
> instead of duplicating it.

It'd be useful if you could quote the code you were commenting on pleas=
e.
I now need to dig out the patch from my git tree to work out the releva=
nce
of your comment is.

--=20
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
=46TTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
