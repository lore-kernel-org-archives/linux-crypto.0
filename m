From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC 00/13] Further iMX CAAM updates
Date: Wed, 9 Dec 2015 18:21:30 +0000
Message-ID: <20151209182130.GI8644@n2100.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
 <5668435B.3020000@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37823 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbbLISVr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 13:21:47 -0500
Content-Disposition: inline
In-Reply-To: <5668435B.3020000@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 05:06:03PM +0200, Horia Geant=C4=83 wrote:
> On 12/7/2015 9:11 PM, Russell King - ARM Linux wrote:
> > Here are further imx-caam updates that I've had since before the
> > previous merge window.  Please review and (I guess) if Freescale
> > folk can provide acks etc that would be nice.  Thanks.
>=20
> Thanks Russell.
>=20
> Note that the patch set does not apply cleanly, please rebase on late=
st
> cryptodev-2.6 tree.

I'm afraid I'm not a fan of digging out random git trees, rebasing
patches on top of them, and then not being able to test them locally
without dragging the entire tree into my own tree.  I'd rather wait
another kernel cycle instead of polluting my own tree with commits
from other trees.

--=20
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
=46TTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
