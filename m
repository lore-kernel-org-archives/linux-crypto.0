From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Mon, 30 Sep 2013 00:05:43 +0200
Message-ID: <201309300005.43296.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <201309261604.37168.marex@denx.de> <21060.16409.341402.552996@ipc1.ka-ro>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35232 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3I2WFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Sep 2013 18:05:47 -0400
In-Reply-To: <21060.16409.341402.552996@ipc1.ka-ro>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Lothar Wa=DFmann,

> Hi,
>=20
> Marek Vasut writes:
> > Dear Lothar Wa=DFmann,
> >=20
> > > Hi Marek,
> > >=20
> > > some small comments below.
> > >=20
> > > Marek Vasut writes:
> > > > diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.=
c
> > > > new file mode 100644
> > > > index 0000000..c2b35c7
> > > > --- /dev/null
> > > > +++ b/drivers/crypto/mxs-dcp.c
> > >=20
> > > [...]
> > >=20
> > > > +/* AES 128 ECB and AES 128 CBC */
> > > > +static struct crypto_alg dcp_aes_algs[] =3D {
> > > > +	[0] =3D {
> > > > +		.cra_name		=3D "ecb(aes)",
> > > > +		.cra_driver_name	=3D "ecb-aes-dcp",
> > > > +		.cra_priority		=3D 400,
> > > > +		.cra_alignmask		=3D 15,
> > > > +		.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > > > +					  CRYPTO_ALG_ASYNC |
> > > > +					  CRYPTO_ALG_NEED_FALLBACK,
> > > > +		.cra_init		=3D mxs_dcp_aes_fallback_init,
> > > > +		.cra_exit		=3D mxs_dcp_aes_fallback_exit,
> > > > +		.cra_blocksize		=3D AES_BLOCK_SIZE,
> > > > +		.cra_ctxsize		=3D sizeof(struct dcp_async_ctx),
> > > > +		.cra_type		=3D &crypto_ablkcipher_type,
> > > > +		.cra_module		=3D THIS_MODULE,
> > > > +		.cra_u	=3D {
> > > > +			.ablkcipher =3D {
> > > > +				.min_keysize	=3D AES_MIN_KEY_SIZE,
> > > > +				.max_keysize	=3D AES_MAX_KEY_SIZE,
> > > > +				.setkey		=3D mxs_dcp_aes_setkey,
> > > > +				.encrypt	=3D=20
mxs_dcp_aes_ecb_encrypt,
> > > > +				.decrypt	=3D=20
mxs_dcp_aes_ecb_decrypt
> > > > +			}
> > >=20
> > > missing ',' after '}'
> >=20
> > Is this a problem? The last ',' is not needed by the C standard.
>=20
> The problem arises when someone wants to append another item to the
> list. Without the comma he has to change two lines which may cause
> merge conflicts if two people add different items to the same struct.
>=20
> That's why we usually have (unnecessary) commas on the last element o=
f
> a struct initializer (except when they are meant to be the last
> element of course).

Good point.

Best regards,
Marek Vasut
