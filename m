From: Jussi Kivilinna <jukivili@dalek.fi>
Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
Date: Tue, 9 Oct 2012 07:27:37 +0300
Message-ID: <CAAAv+3z-OsE69VZnyCdRdGxqywVJCzoKdzRJdGoh8cY9DeBiWg@mail.gmail.com>
References: <20120807020103.GA21410@mcafee.com>
	<20120906202024.GB24269@gondor.apana.org.au>
	<E7C3A19B6E9F994EB4D796DB533BD7F5B9184896D8@SAFEX1MAIL3.st.com>
	<20121008210022.GA15013@mcafee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ruggero SUSELLA <ruggero.susella@st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: David McCullough <david_mccullough@mcafee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46380 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JIE1i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2012 00:27:38 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so4316113obb.19
        for <linux-crypto@vger.kernel.org>; Mon, 08 Oct 2012 21:27:37 -0700 (PDT)
In-Reply-To: <20121008210022.GA15013@mcafee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2012/10/9 David McCullough <david_mccullough@mcafee.com>
>
>
> Jivin Ruggero SUSELLA lays it down ...
> > Is this code compatible with GPL ?
> >
> > To me it looks like it falls under the OpenSSL license which,
> > accordingly to Wikipedia, is not compatible with GPL.
> > Where am I wrong ?
>
> The license on the 2 asm files from openssl the explicitly states:
>
>         @
> ====================================================================
>         @ Written by Andy Polyakov <appro@fy.chalmers.se> for the OpenSSL
>         @ project. The module is, however, dual licensed under OpenSSL and
>         @ CRYPTOGAMS licenses depending on where you obtain it. For
> further
>         @ details see http://www.openssl.org/~appro/cryptogams/.
>         @
> ====================================================================
>
> If you follow the URL for the CRYPTOGAMS license and read the actual
> license
> at the end of the file it is very clearly dual licensed.  So I think it is
> ok :-)

The FAQ at http://www.openssl.org/~appro/cryptogams/ says "If obtained
as a part of the OpenSSL Toolkit the modules are covered by the
OpenSSL license, while if obtained as a part of the CRYPTOGAMS
distribution - by the CRYPTOGAMS License" and that page only has link
to "CRYPTOGAMS version 0" which does not contain ARM implementations.

-Jussi

>
> Cheers,
> Davidm
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org
> > [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
> > Sent: Thursday, September 06, 2012 10:20 PM
> > To: David McCullough
> > Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org
> > Subject: Re: [PATCH 1/1] arm/crypto: Add optimized AES and SHA1 routines
> >
> > On Tue, Aug 07, 2012 at 02:01:03AM +0000, David McCullough wrote:
> > >
> > > Add assembler versions of AES and SHA1 for ARM platforms.  This has
> > > provided up to a 50% improvement in IPsec/TCP throughout for tunnels
> > > using AES128/SHA1.
> > >
> > > Platform   CPU SPeed    Endian   Before (bps)   After (bps)
> > > Improvement
> > >
> > > IXP425      533 MHz      big     11217042        15566294        ~38%
> > > KS8695      166 MHz     little    3828549         5795373        ~51%
> > >
> > > Signed-off-by: David McCullough <ucdevel@gmail.com>
> >
> > Patch applied.  Thanks!
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> > http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> > in the body of a message to majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> >
> >
>
> --
> David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
> McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
