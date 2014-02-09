From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - Fix job ring discovery in controller
 driver
Date: Sun, 9 Feb 2014 17:20:04 +0800
Message-ID: <20140209092004.GB19429@gondor.apana.org.au>
References: <1390554205-19771-1-git-send-email-NiteshNarayanLal@freescale.com>
 <52F49624.3070400@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nitesh Lal <NiteshNarayanLal@freescale.com>,
	linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41998 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaBIJUF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Feb 2014 04:20:05 -0500
Content-Disposition: inline
In-Reply-To: <52F49624.3070400@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 07, 2014 at 08:15:32AM +0000, Horia Geant=C4=83 wrote:
> On 1/24/2014 11:03 AM, Nitesh Lal wrote:
> >The SEC Controller driver creates platform devices for it's child jo=
b ring nodes.
> >Currently the driver uses for_each_compatible routine which traverse=
s
> >the whole device tree to create the job rings for the platform devic=
e.
> >The patch changes this to search for the compatible property of job =
ring
> >only in the child nodes i.e., the job rings are created as per the n=
umber
> >of children associated with the crypto node.
> >
> >Signed-off-by: Nitesh Lal <NiteshNarayanLal@freescale.com>
> >---
> >  drivers/crypto/caam/ctrl.c | 25 ++++++-------------------
> >  1 file changed, 6 insertions(+), 19 deletions(-)
>=20
> Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
