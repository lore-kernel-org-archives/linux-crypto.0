From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Thu, 26 Sep 2013 16:09:29 +0200
Message-ID: <21060.16409.341402.552996@ipc1.ka-ro>
References: <1380194306-5243-1-git-send-email-marex@denx.de>
	<1380194306-5243-2-git-send-email-marex@denx.de>
	<21060.9453.908125.71858@ipc1.ka-ro>
	<201309261604.37168.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:49734 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3IZOJc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 10:09:32 -0400
In-Reply-To: <201309261604.37168.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Marek Vasut writes:
> Dear Lothar Wa=C3=9Fmann,
>=20
> > Hi Marek,
> >=20
> > some small comments below.
> >=20
> > Marek Vasut writes:
> > > diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> > > new file mode 100644
> > > index 0000000..c2b35c7
> > > --- /dev/null
> > > +++ b/drivers/crypto/mxs-dcp.c
> >=20
> > [...]
> >=20
> > > +/* AES 128 ECB and AES 128 CBC */
> > > +static struct crypto_alg dcp_aes_algs[] =3D {
> > > +	[0] =3D {
> > > +		.cra_name		=3D "ecb(aes)",
> > > +		.cra_driver_name	=3D "ecb-aes-dcp",
> > > +		.cra_priority		=3D 400,
> > > +		.cra_alignmask		=3D 15,
> > > +		.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > > +					  CRYPTO_ALG_ASYNC |
> > > +					  CRYPTO_ALG_NEED_FALLBACK,
> > > +		.cra_init		=3D mxs_dcp_aes_fallback_init,
> > > +		.cra_exit		=3D mxs_dcp_aes_fallback_exit,
> > > +		.cra_blocksize		=3D AES_BLOCK_SIZE,
> > > +		.cra_ctxsize		=3D sizeof(struct dcp_async_ctx),
> > > +		.cra_type		=3D &crypto_ablkcipher_type,
> > > +		.cra_module		=3D THIS_MODULE,
> > > +		.cra_u	=3D {
> > > +			.ablkcipher =3D {
> > > +				.min_keysize	=3D AES_MIN_KEY_SIZE,
> > > +				.max_keysize	=3D AES_MAX_KEY_SIZE,
> > > +				.setkey		=3D mxs_dcp_aes_setkey,
> > > +				.encrypt	=3D mxs_dcp_aes_ecb_encrypt,
> > > +				.decrypt	=3D mxs_dcp_aes_ecb_decrypt
> > > +			}
> >=20
> > missing ',' after '}'
>=20
> Is this a problem? The last ',' is not needed by the C standard.
>=20
The problem arises when someone wants to append another item to the
list. Without the comma he has to change two lines which may cause
merge conflicts if two people add different items to the same struct.

That's why we usually have (unnecessary) commas on the last element of
a struct initializer (except when they are meant to be the last
element of course).


Lothar Wa=C3=9Fmann
--=20
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstra=C3=9Fe 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Gesch=C3=A4ftsf=C3=BChrer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
