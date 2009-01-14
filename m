From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Wed, 14 Jan 2009 17:54:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0901141753090.31703@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <3f9a31f40901140845r6a0cd136ha27304c76001d1c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:37927 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754152AbZANQyy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 11:54:54 -0500
In-Reply-To: <3f9a31f40901140845r6a0cd136ha27304c76001d1c7@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 14 Jan 2009, Jaswinder Singh Rajput wrote:
> On Tue, Jan 13, 2009 at 9:29 PM, Geert Uytterhoeven
> <Geert.Uytterhoeven@sonycom.com> wrote:
> > +static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pco=
mp *tfm)
> > +{
> > +       return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg)=
;
> > +}
> > +
> > +static inline int crypto_pcomp_setup(struct crypto_pcomp *tfm,
> > +                                    const void *params)
> > +{
> > +       return crypto_pcomp_alg(tfm)->setup(crypto_pcomp_tfm(tfm), =
params);
> > +}
> > +
> > +static inline int crypto_pcomp_compress_init(struct crypto_pcomp *=
tfm)
> > +{
> > +       return crypto_pcomp_alg(tfm)->compress_init(crypto_pcomp_tf=
m(tfm));
> > +}
> > +
> > +static inline int crypto_pcomp_compress_update(struct crypto_pcomp=
 *tfm,
> > +                                              struct comp_request =
*req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->compress_update(crypto_pcomp_=
tfm(tfm),
> > +                                                     req);
> > +}
> > +
> > +static inline int crypto_pcomp_compress_final(struct crypto_pcomp =
*tfm,
> > +                                             struct comp_request *=
req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->compress_final(crypto_pcomp_t=
fm(tfm),
> > +                                                    req);
> > +}
> > +
> > +static inline int crypto_pcomp_decompress_init(struct crypto_pcomp=
 *tfm)
> > +{
> > +       return crypto_pcomp_alg(tfm)->decompress_init(crypto_pcomp_=
tfm(tfm));
> > +}
> > +
> > +static inline int crypto_pcomp_decompress_update(struct crypto_pco=
mp *tfm,
> > +                                                struct comp_reques=
t *req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->decompress_update(crypto_pcom=
p_tfm(tfm),
> > +                                                       req);
> > +}
> > +
> > +static inline int crypto_pcomp_decompress_final(struct crypto_pcom=
p *tfm,
> > +                                               struct comp_request=
 *req)
> > +{
> > +       return crypto_pcomp_alg(tfm)->decompress_final(crypto_pcomp=
_tfm(tfm),
> > +                                                      req);
> > +}
>=20
> Can you please use expressive but short names ?

I admit they're quite long. But they're similar to the ones in use for =
the
already existing crypto modules.

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
