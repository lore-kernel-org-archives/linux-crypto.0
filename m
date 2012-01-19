From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about crypto module dependency
Date: Thu, 19 Jan 2012 23:28:41 +1100
Message-ID: <20120119122841.GA3437@gondor.apana.org.au>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com> <20120118053933.GA23562@gondor.apana.org.au> <CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com> <20120118121325.GA25822@gondor.apana.org.au> <CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com> <20120118222516.GA30542@gondor.apana.org.au> <CAC9WiBgSXRizqSNdnPv7yd8O1Ysd4r89f44CCtG4XY_+z+9Khg@mail.gmail.com> <20120119115831.GA3017@gondor.apana.org.au> <CAC9WiBiLx4=uugZSjrGrmOAX_6aWY_OP3ywWv7aEwOOWgt-yVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48800 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2ASM2n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Jan 2012 07:28:43 -0500
Content-Disposition: inline
In-Reply-To: <CAC9WiBiLx4=uugZSjrGrmOAX_6aWY_OP3ywWv7aEwOOWgt-yVw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2012 at 01:26:30PM +0100, Francis Moreau wrote:
> On Thu, Jan 19, 2012 at 12:58 PM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
> > On Thu, Jan 19, 2012 at 09:10:48AM +0100, Francis Moreau wrote:
> >>
> >> How things are supposed to work when :
> >>
> >> =A0 - crc32c module is not loaded
> >> =A0 - libcrc32c module is not loaded
> >> =A0 - btrfs is not loaded
> >>
> >> and I issue: "modprobe btrfs" ?
> >
> > When libcrc32c is loaded it'll automatically load crc32c through
> > the Crypto API.
> >
>=20
> Did you try ?

Yes it works on my machine.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
