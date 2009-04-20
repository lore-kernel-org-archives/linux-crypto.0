From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH/RFC] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}() (was: Re: [PATCH/RFC] crypto: compress
 - Add comp_request.total_out (was: Re: [PATCH 6/6] squashfs: Make SquashFS
 4 use the new pcomp crypto interface))
Date: Mon, 20 Apr 2009 09:26:16 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
 <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38317 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753444AbZDTH0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2009 03:26:19 -0400
In-Reply-To: <20090420060313.GA891@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 20 Apr 2009, Herbert Xu wrote:
> On Tue, Mar 24, 2009 at 05:33:01PM +0100, Geert Uytterhoeven wrote:
> > Here's an alternative patch, which does exactly that.
> > Phillip, what do you think?
> >=20
> > Thanks for your comments!
> >=20
> > >From be7d630f96a85d3ce48716b8e328563ba217647b Mon Sep 17 00:00:00 =
2001
> > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > Date: Tue, 24 Mar 2009 17:19:05 +0100
> > Subject: [PATCH] crypto: compress - Return produced bytes in crypto=
_{,de}compress_{update,final}()
> >=20
> > If crypto_{,de}compress_{update,final}() succeed, return the actual=
 number of
> > bytes produced instead of zero, so their users don't have to calcul=
ate that
> > theirselves.
> >=20
> > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>=20
> I certainly prefer this version over the other one? Do you want to
> submit crypto API portion of this?

If you think I should submit it now, I can do it. But I'm still waiting=
 for
Phillip's comments.

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
