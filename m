From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: LRW endian issues?
Date: Thu, 12 Feb 2009 16:29:42 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902121628160.29413@vixen.sonytel.be>
References: <alpine.LRH.2.00.0902051146540.6558@vixen.sonytel.be> <20090206040124.GA4299@gondor.apana.org.au> <20090210105842.GA22326@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: rsnel@cube.dyndns.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34052 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026AbZBLP3p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Feb 2009 10:29:45 -0500
In-Reply-To: <20090210105842.GA22326@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 10 Feb 2009, Herbert Xu wrote:
> On Fri, Feb 06, 2009 at 03:01:24PM +1100, Herbert Xu wrote:
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > > When running "modprobe tcrypt mode=3D10" on ppc64 (PS3), I get th=
e following
> > > error:
> > >=20
> > > | alg: skcipher: Test 8 failed on encryption for lrw(aes-generic)
>=20
> Does this patch help?
>=20
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index 8ef664e..358f80b 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -45,7 +45,13 @@ struct priv {
> =20
>  static inline void setbit128_bbe(void *b, int bit)
>  {
> -	__set_bit(bit ^ 0x78, b);
> +	__set_bit(bit ^ (0x80 -
> +#ifdef __BIG_ENDIAN
> +			 BITS_PER_LONG
> +#else
> +			 BITS_PER_BYTE
> +#endif
> +			), b);
>  }
> =20
>  static int setkey(struct crypto_tfm *parent, const u8 *key,

Thanks! Now the test succeeds on both ppc64 and ppc32.

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
