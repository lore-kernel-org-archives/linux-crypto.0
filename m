From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: RFC: support for MV_CESA with TDMA
Date: Tue, 12 Jun 2012 12:24:52 +0200
Message-ID: <20120612102452.GE9122@philter.vipri.net>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
 <20120612100437.GD14078@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:50852 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2FLKZD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 06:25:03 -0400
Content-Disposition: inline
In-Reply-To: <20120612100437.GD14078@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 12, 2012 at 06:04:37PM +0800, Herbert Xu wrote:
> On Fri, May 25, 2012 at 06:08:26PM +0200, Phil Sutter wrote:
> >
> > The point for this being RFC is backwards-compatibility: earlier
> > hardware (Orion) ships a (slightly) different DMA engine (IDMA) alo=
ng
> > with the same crypto engine, so in fact mv_cesa.c is in use on thes=
e
> > platforms, too. But since I don't possess hardware of this kind, I =
am
> > not able to make this code IDMA-compatible. Also, due to the quite
> > massive reorganisation of code flow, I don't really see how to make=
 TDMA
> > support optional in mv_cesa.c.
>=20
> So does this break existing functionality or not?

It does break mv_cesa on Orion-based devices (precisely those with IDMA
instead of TDMA). I am currently working on a version which supports
IDMA, too. Since all CESA-equipped hardware comes with either TDMA or
IDMA, that version then should improve all platforms without breaking
any.

Greetings, Phil


Phil Sutter
Software Engineer

--=20


Viprinet GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Phone/Zentrale:         +49-6721-49030-0
Direct line/Durchwahl:  +49-6721-49030-134
=46ax:                    +49-6721-49030-209

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein
Commercial register/Handelsregister: Amtsgericht Mainz HRB40380
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
