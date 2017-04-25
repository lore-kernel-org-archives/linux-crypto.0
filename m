From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v3 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Tue, 25 Apr 2017 08:53:40 +0200
Message-ID: <20170425065340.xdhmilo5caswkmxp@kwain>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-3-antoine.tenart@free-electrons.com>
 <2475079.gcOV5qCq7E@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jsrqfl7eypfixw7w"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42802 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165276AbdDYGxv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 02:53:51 -0400
Content-Disposition: inline
In-Reply-To: <2475079.gcOV5qCq7E@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--jsrqfl7eypfixw7w
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephan,

On Mon, Apr 24, 2017 at 02:59:05PM +0200, Stephan M=FCller wrote:
> Am Montag, 24. April 2017, 09:54:06 CEST schrieb Antoine Tenart:
>=20
> > +struct safexcel_cipher_ctx {
> > +	struct safexcel_context base;
> > +	struct safexcel_crypto_priv *priv;
> > +
> > +	enum safexcel_cipher_direction direction;
> > +	u32 mode;
> > +
> > +	__le32 key[8];
>=20
> Can you please help me find the location where this memory is zeroized wh=
en=20
> released?

It's not, I'll fix this.

> > +static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx,
> > +				  struct crypto_async_request *async,
> > +				  struct safexcel_command_desc *cdesc,
> > +				  u32 length)
> > +{
> > +	struct ablkcipher_request *req =3D ablkcipher_request_cast(async);
> > +	struct safexcel_token *token;
> > +	unsigned offset =3D 0;
> > +
> > +	if (ctx->mode =3D=3D CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> > +		offset =3D AES_BLOCK_SIZE / sizeof(u32);
> > +		memcpy(cdesc->control_data.token, req->info, AES_BLOCK_SIZE);
> > +
> > +		cdesc->control_data.options |=3D EIP197_OPTION_4_TOKEN_IV_CMD;
> > +	}
> > +
> > +	token =3D (struct safexcel_token *)(cdesc->control_data.token + offse=
t);
> > +
> > +	token[0].opcode =3D EIP197_TOKEN_OPCODE_DIRECTION;
> > +	token[0].packet_length =3D length;
> > +	token[0].stat =3D EIP197_TOKEN_STAT_LAST_PACKET;
> > +	token[0].instructions =3D EIP197_TOKEN_INS_LAST |
> > +				EIP197_TOKEN_INS_TYPE_CRYTO |
> > +				EIP197_TOKEN_INS_TYPE_OUTPUT;
> > +}
> > +
> > +static int safexcel_aes_setkey(struct crypto_ablkcipher *ctfm, const u8
> > *key, +			       unsigned int len)
> > +{
>=20
> You still use ablkcipher. I thought that it is on its way out in favor of=
 the=20
> skcipher API. Why do you stick to ablkcipher?
>=20
> Note, a change could be as simple as s/ablkcipher/skcipher/g

Because I wasn't aware of this :) I'll update.

> > +	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(ctfm);
> > +	struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> > +	struct crypto_aes_ctx aes;
> > +	int ret, i;
> > +
> > +	ret =3D crypto_aes_expand_key(&aes, key, len);
> > +	if (ret) {
> > +		crypto_ablkcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > +		return ret;
> > +	}
> > +
> > +	for (i =3D 0; i < len / sizeof(u32); i++) {
> > +		if (ctx->key[i] !=3D cpu_to_le32(aes.key_enc[i])) {
> > +			ctx->base.needs_inv =3D true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	for (i =3D 0; i < len / sizeof(u32); i++)
> > +		ctx->key[i] =3D cpu_to_le32(aes.key_enc[i]);
> > +
> > +	ctx->key_len =3D len;
>=20
> memzero_explicit(aes)?

OK, I'll update.

> > +static int safexcel_aes_send(struct crypto_async_request *async,
> > +			     int ring, struct safexcel_request *request,
> > +			     int *commands, int *results)
> > +{
> > +	struct ablkcipher_request *req =3D ablkcipher_request_cast(async);
> > +	struct safexcel_cipher_ctx *ctx =3D crypto_tfm_ctx(req->base.tfm);
> > +	struct safexcel_crypto_priv *priv =3D ctx->priv;
> > +	struct safexcel_command_desc *cdesc;
> > +	struct safexcel_result_desc *rdesc;
> > +	struct scatterlist *sg;
> > +	int nr_src, nr_dst, n_cdesc =3D 0, n_rdesc =3D 0, queued =3D req->nby=
tes;
> > +	int i, ret =3D 0;
> > +
> > +	request->req =3D &req->base;
> > +
> > +	if (req->src =3D=3D req->dst) {
> > +		nr_src =3D dma_map_sg(priv->dev, req->src,
> > +				    sg_nents_for_len(req->src, req->nbytes),
> > +				    DMA_BIDIRECTIONAL);
> > +		nr_dst =3D nr_src;
> > +		if (!nr_src)
> > +			return -EINVAL;
> > +	} else {
> > +		nr_src =3D dma_map_sg(priv->dev, req->src,
> > +				    sg_nents_for_len(req->src, req->nbytes),
> > +				    DMA_TO_DEVICE);
> > +		if (!nr_src)
> > +			return -EINVAL;
> > +
> > +		nr_dst =3D dma_map_sg(priv->dev, req->dst,
> > +				    sg_nents_for_len(req->dst, req->nbytes),
> > +				    DMA_FROM_DEVICE);
> > +		if (!nr_dst) {
> > +			dma_unmap_sg(priv->dev, req->src,
> > +				     sg_nents_for_len(req->src, req->nbytes),
> > +				     DMA_TO_DEVICE);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
>=20
> Is ctxr->data properly zeroized?

No, I'll update.

Thanks for the review!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--jsrqfl7eypfixw7w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJY/vJxAAoJEFxNi8it27zYQ+oP/jViTBvbzzoNKzPsc4bIQ4s9
byhMzAQ52Ics5C5EmcXcsX1EkvHe+DqwxV3SHZqjSe5NkBiMqrDEmVLoLNyc3LUC
OuHyeqw87TbLEn3NH47Uyr094jqJAFd/oACB6LoJDFHvYK682aHFEQvE07Uza2am
iecdzxiBsGJY62Rv+zfyCPZeakIkDFUbJZAZBKigLVysMJSAaUgXopj4sAJaQcdS
dNhTVae6PePH1no0Csq9aawloTyC6W1EL4sMeWcKzq/n5hticNHmcZshr00/E9Qp
VUdji1j/qBCtCwgEe5wC+9h4Nu2LzDPz2JJ8O2XBdQmEPLO/o4fT9oqw7PLehXd6
QPkstYl4VARgaScFE4lUiT+eS6PQD7LHk/3banIGW+dtMAtgRKdpfCWH2V5f0SVN
agGMPbvD0qz+ltJfAgiprPI9/xUOkY9QZZHIMcbjuYnt/YJz9ofEEg1kau22fLuw
YAWyPRAm78gZY6Zj608eq4nPr5LxEXcQtG1GeBqdOnkNHEKCzMYovEnFekusqbGb
mMZuKlLgJCq8LgqjRGbd9k7odVTf2oTKmbYaPJDsLxRidPkJh4BDqbIdg69DbEaE
zRcxq2gdMN5bNxIz7y1hKtoyKtbVTXI8WlRRZZHK4BoGi1aL/AL25kcU4NnqZiS8
zoM0UOd34dZ26CD+yQYo
=bNSi
-----END PGP SIGNATURE-----

--jsrqfl7eypfixw7w--
