Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0850EC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 05:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4772073A
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 05:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="S/OgcVUl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgGMFFC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 01:05:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:36703 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgGMFFC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 01:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594616698;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=JCWCujAu6sh7YsrdJ7tEkcESK7l3HSFOXmb6hqxOtzc=;
        b=S/OgcVUlebXvUDz84jJVs8R8tksdQoFOHhipp0WQQw6HorBNG+NI9EWRraYoOSQUW+
        OVQabpg7kYl17gLFD9UELKLBZJ1GeSHn2HNBvS82J8afJFNUeUn+q//s/cVOF+SwUkkv
        zpWNY5tCyF9bDojk2dHXjMttZWKrPj2U/f524PK9t6x2KGxqvoevaegjLRPpBQ8c4LA9
        t1MenDRh4Xmf/RjBiiXcq5z5YRV978nsGD9bN/7Q1t5bWeKdLVGTWdhlqDVzO/HRdtnm
        pFm6B2crbgUq2/C8wWIYYhVHd1i64L1k9SWMi6pXJvBu1rgL76DVfRwn53ZkddEUjNIH
        mmSQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6D54djfK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 13 Jul 2020 07:04:39 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 5/5] crypto: ECDH SP800-56A rev 3 local public key validation
Date:   Mon, 13 Jul 2020 07:04:39 +0200
Message-ID: <5856902.DvuYhMxLoT@tauon.chronox.de>
In-Reply-To: <20200712180613.dkzaklumuxndpgfw@altlinux.org>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <3168469.44csPzL39Z@positron.chronox.de> <20200712180613.dkzaklumuxndpgfw@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 12. Juli 2020, 20:06:13 CEST schrieb Vitaly Chikunov:

Hi Vitaly,

> Stephan,
>=20
> On Sun, Jul 12, 2020 at 06:42:14PM +0200, Stephan M=FCller wrote:
> > After the generation of a local public key, SP800-56A rev 3 section
> > 5.6.2.1.3 mandates a validation of that key with a full validation
> > compliant to section 5.6.2.3.3.
> >=20
> > Only if the full validation passes, the key is allowed to be used.
> >=20
> > The patch adds the full key validation compliant to 5.6.2.3.3 and
> > performs the required check on the generated public key.
> >=20
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >=20
> >  crypto/ecc.c | 31 ++++++++++++++++++++++++++++++-
> >  crypto/ecc.h | 14 ++++++++++++++
> >  2 files changed, 44 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/crypto/ecc.c b/crypto/ecc.c
> > index 52e2d49262f2..7308487e7c55 100644
> > --- a/crypto/ecc.c
> > +++ b/crypto/ecc.c
> > @@ -1404,7 +1404,9 @@ int ecc_make_pub_key(unsigned int curve_id, unsig=
ned
> > int ndigits,>=20
> >  	}
> >  =09
> >  	ecc_point_mult(pk, &curve->g, priv, NULL, curve, ndigits);
> >=20
> > -	if (ecc_point_is_zero(pk)) {
> > +
> > +	/* SP800-56A rev 3 5.6.2.1.3 key check */
> > +	if (ecc_is_pubkey_valid_full(curve, pk)) {
> >=20
> >  		ret =3D -EAGAIN;
> >  		goto err_free_point;
> >  =09
> >  	}
> >=20
> > @@ -1452,6 +1454,33 @@ int ecc_is_pubkey_valid_partial(const struct
> > ecc_curve *curve,>=20
> >  }
> >  EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
> >=20
> > +/* SP800-56A section 5.6.2.3.3 full verification */
>=20
> Btw, 5.6.2.3.3 is partial validation, 5.6.2.3.2 is full validation
> routine.

Looking at SP800-56A revision 3 from April 2018 I see:

"5.6.2.3.3 ECC Full Public-Key Validation Routine"

Thanks for the review.

Ciao
Stephan


