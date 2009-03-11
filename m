From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 6/6] squashfs: Make SquashFS 4 use the new pcomp crypto
 interface
Date: Wed, 11 Mar 2009 18:59:38 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au>
 <49B36A18.5030506@lougher.demon.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64578 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290AbZCKR7l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2009 13:59:41 -0400
In-Reply-To: <49B36A18.5030506@lougher.demon.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Hi Phillip,

On Sun, 8 Mar 2009, Phillip Lougher wrote:
> Herbert Xu wrote:
> > On Wed, Feb 25, 2009 at 02:43:14PM +0100, Geert Uytterhoeven wrote:
> > > Modify SquashFS 4 to use the new "pcomp" crypto interface for
> > > decompression,
> > > instead of calling the underlying zlib library directly. This sim=
plifies
> > > e.g.
> > > the addition of support for hardware decompression and different
> > > decompression
> > > algorithms.
> > >
> > > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com=
>
> > > Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
> >=20
> > I've applied patches 1-5.  I'd like to see an ack on this before
> > applying it.
>=20
> I've not acked it because I've not yet made any decisions as to wheth=
er I want
> it in Squashfs.  Also as Squashfs maintainer I maintain my own tree o=
f patches
> to Squashfs, and so I'll prefer to add it to my tree for subsequent f=
eeding
> into 2.6.30 once the merge window opens.

OK.

> I'm fairly agnostic about what decompression library Squashfs uses.  =
The only
> thing I care about is cleanliness and usability of the API and perfor=
mance.
> If the crypto API is cleaner or the cryto zlib implementation is fast=
er than
> the current zlib implementation then I see no reason not to move over=
 to it.
> But, I've seen no performance figures and the API seems clumsier.

I did not see any noticeable performance impact due to my changes.

> Two API issues of concern (one major, one minor).  Both of these rela=
te to the
> way Squashfs drives the decompression code, where it repeatedly calls=
 it
> supplying additional input/output buffers, rather than using a "singl=
e-shot"
> approach where it calls the decompression code once supplying all the
> necessary input and output buffer space.
>=20
> 1. Minor issue -the lack of a stream.total_out field.  The current
> zlib_inflate code collects the total number of bytes decompressed ove=
r the
> multiple calls into the stream.total_out field.
>=20
>    There is clearly no such field available in the cryto API, leading=
 to the
> somewhat clumsy need to track it, i.e. it leads to the following addi=
tional
> code.

If people feel the need for a total_out field, I can add it to struct
comp_request.

BTW, what about total_in, which is also provided by plain zlib's z_stre=
am?
Do people see a need for a similar field?

> 2. Major issue - working out loop termination.
>=20
> It transpires when decompressing from multiple input buffers into mul=
tiple
> output buffers, determining when the decompressor has consumed all in=
put
> buffers and has flushed all output to the output buffers is difficult=
=2E

    [...]

> With zlib_inflate this is irrelevant because it supplies a suitable e=
xit code
> indicating whether it needs to be called again (Z_OK) or whether deco=
mpression
> has finished (Z_STREAM_END).  This makes loop termination easy.

Zlib indeed provides such a flag. Other decompression algorithms may no=
t
provide this, and keep on `decompressing' as long as you feed them data=
=2E

So while I could add an output flag indicating decompression has finish=
ed, it
cannot be more than a mere hint when considering support for multiple
(de)compression algorithms.

> My biggest criticism against the cryto changes to Squashfs is
> crypto_decompress_update doesn't seem to give this information, leavi=
ng to the
> clumsy introduction of a check to see if crypto_decompress_update pro=
duced any
> output data, i.e.:
>=20
> -		} while (zlib_err =3D=3D Z_OK);
> > -
>=20
> is replaced by:
>=20
> > +		} while (bytes || produced);
> > +
>=20
> This is clearly suboptimal, and always leads to an additional iterati=
on around
> the loop.  Only once we've iterated over the loop one last time doing=
 nothing
> do we decide the decompression has completed.

Given the difficulty in determining the finishing of decompression in a=
 generic
way, I don't see a better solution. If no data has been consumed nor pr=
oduced,
and no -EAGAIN is returned, decompression is finished.

BTW, this is also very similar to reading from a file: read() returns a
non-zero count until the end of the file is reached.

The additional loop also doesn't seem to have any noticeable impact on
performance, though.

> Not only this, but the loop termination also suffers from a major
> unanticipated bug:
>=20
> The loop termination forces an additional iteration around the loop e=
ven
> though we've run out of output buffer space.
>=20
> Consider the usual scenario where we're decompressing a buffer into t=
wo 4K
> pages (pages =3D 2), and the buffer decompresses to 8K.  The final "r=
eal"
> iteration will have produced !=3D 0 and req.avail_out =3D=3D 0 (we've=
 consumed all
> the output bytes in the last output buffer).
>=20
> Because produced !=3D 0 we will iterate over the loop again.  But bec=
ause
> req.avail_out =3D=3D 0 we will load req.next_out with a non-existent =
buffer (we
> will fall off the end of the buffer array), i.e.
>=20
> +			if (req.avail_out =3D=3D 0) {
> > +				req.next_out =3D buffer[page++];
> > +				req.avail_out =3D PAGE_CACHE_SIZE;
> >     }
> >
>=20
> If for any reason crypto_decompress_update produces unexpected output=
 (perhaps
> because of corrupted data), we will trigger a kernel oops.
>=20
> Obviously in the majority of cases (which is why the code works), the=
 "false"
> additional iteration doesn't produce any output.  But it is distinctl=
y bad
> practice to have code in the kernel that in normal operation passes a=
 bad
> pointer to crypto_decompress_output, and relies on its behaviour not =
to use
> that bad pointer.

You are right.  Hence this needs a check for page < pages, cfr. your re=
cent fix
to survive corrupted file system images. I'll take care of that.

Thanks for your comments!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
