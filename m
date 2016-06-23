From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 02/10] crypto: marvell: Check engine is not already
 running when enabling a req
Date: Thu, 23 Jun 2016 18:44:57 +0800
Message-ID: <20160623104457.GC10350@gondor.apana.org.au>
References: <20160622103324.GA30918@gondor.apana.org.au>
 <576A753B.7070507@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
	gregory.clement@free-electrons.com,
	thomas.petazzoni@free-electrons.com, davem@davemloft.net,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49785 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbcFWKpM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 06:45:12 -0400
Content-Disposition: inline
In-Reply-To: <576A753B.7070507@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 01:23:39PM +0200, Romain Perier wrote:
> Hello,
>=20
> Le 22/06/2016 12:33, Herbert Xu a =E9crit :
> >Romain Perier <romain.perier@free-electrons.com> wrote:
> >>Add a BUG_ON() call when the driver tries to launch a crypto reques=
t
> >>while the engine is still processing the previous one. This replace=
s
> >>a silent system hang by a verbose kernel panic with the associated
> >>backtrace to let the user know that something went wrong in the CES=
A
> >>driver.
> >
> >Hmm, so how can this happen?
> If it is triggerable then we better
> >try to recover from it more gracefully.  If it is not triggerable
> >then why bother?
> >
>=20
> Well, It does not happen with the current driver (in mainline). This
> is bug I had when I added support to chain requests. Take a look at
> the patch 008/010, it changes the way the requests are "prepared".
> If you really enable a request while the engine is running, that's
> very hard to debug. This is more useful to have a backtrace to let
> the user know that something is wrong instead of having a silent
> system hang. That's easier to debug and you can detect regressions.

OK.  All applied.  Thanks.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
