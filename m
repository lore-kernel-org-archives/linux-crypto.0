From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 5/5] squashfs: Make SquashFS 4 use the new pcomp crypto
  interface
Date: Thu, 19 Feb 2009 14:42:14 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902191415220.14749@vixen.sonytel.be>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1234972402-24298-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Phillip Lougher <phillip@lougher.demon.co.uk>
To: Jared Hulbert <jaredeh@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43458 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750826AbZBSNmQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2009 08:42:16 -0500
In-Reply-To: <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Hi Jared,

How's AXFS going?

On Wed, 18 Feb 2009, Jared Hulbert wrote:
> > Modify SquashFS 4 to use the new "pcomp" crypto interface for decom=
pression,
> > instead of calling the underlying zlib library directly. This simpl=
ifies e.g.
> > the addition of support for hardware decompression and different de=
compression
> > algorithms.
>=20
> When did this become an option?  I thought zlib in the crypto
> interface was not compatible with zlib.  Is that not the case anymore=
?

The "deflate" crypto module uses hardcoded parameters for the raw defla=
te mode,
that's why it's incompatible.

However, the new "zlib" crypto module is compatible with zlib, as you c=
an
specify the all (de)compression parameters.

BTW, you probably want to read the full patch series, including the
introduction :-)

>  Have you looked at AXFS enough to judge if this would be as easy a
> job as it looks to convert?

I looked at the relevant code in AXFS before.  Yes, I think it would be=
 an
easy job.

> How do you get from here to supporting alternate compressors?

Your file system code needs a mapping from compressor ID (as stored in =
your
file system metadata) to crypto module name and (de)compression paramet=
ers.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
