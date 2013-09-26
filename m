From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Thu, 26 Sep 2013 14:13:33 +0200
Message-ID: <21060.9453.908125.71858@ipc1.ka-ro>
References: <1380194306-5243-1-git-send-email-marex@denx.de>
	<1380194306-5243-2-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:50516 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab3IZMNi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 08:13:38 -0400
In-Reply-To: <1380194306-5243-2-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marek,

some small comments below.

Marek Vasut writes:
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> new file mode 100644
> index 0000000..c2b35c7
> --- /dev/null
> +++ b/drivers/crypto/mxs-dcp.c
[...]
> +/* AES 128 ECB and AES 128 CBC */
> +static struct crypto_alg dcp_aes_algs[] =3D {
> +	[0] =3D {
> +		.cra_name		=3D "ecb(aes)",
> +		.cra_driver_name	=3D "ecb-aes-dcp",
> +		.cra_priority		=3D 400,
> +		.cra_alignmask		=3D 15,
> +		.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +					  CRYPTO_ALG_ASYNC |
> +					  CRYPTO_ALG_NEED_FALLBACK,
> +		.cra_init		=3D mxs_dcp_aes_fallback_init,
> +		.cra_exit		=3D mxs_dcp_aes_fallback_exit,
> +		.cra_blocksize		=3D AES_BLOCK_SIZE,
> +		.cra_ctxsize		=3D sizeof(struct dcp_async_ctx),
> +		.cra_type		=3D &crypto_ablkcipher_type,
> +		.cra_module		=3D THIS_MODULE,
> +		.cra_u	=3D {
> +			.ablkcipher =3D {
> +				.min_keysize	=3D AES_MIN_KEY_SIZE,
> +				.max_keysize	=3D AES_MAX_KEY_SIZE,
> +				.setkey		=3D mxs_dcp_aes_setkey,
> +				.encrypt	=3D mxs_dcp_aes_ecb_encrypt,
> +				.decrypt	=3D mxs_dcp_aes_ecb_decrypt
> +			}
missing ',' after '}'
> +		}
dto.

> +	},
> +	[1] =3D {
> +		.cra_name		=3D "cbc(aes)",
> +		.cra_driver_name	=3D "cbc-aes-dcp",
> +		.cra_priority		=3D 400,
> +		.cra_alignmask		=3D 15,
> +		.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +					  CRYPTO_ALG_ASYNC |
> +					  CRYPTO_ALG_NEED_FALLBACK,
> +		.cra_init		=3D mxs_dcp_aes_fallback_init,
> +		.cra_exit		=3D mxs_dcp_aes_fallback_exit,
> +		.cra_blocksize		=3D AES_BLOCK_SIZE,
> +		.cra_ctxsize		=3D sizeof(struct dcp_async_ctx),
> +		.cra_type		=3D &crypto_ablkcipher_type,
> +		.cra_module		=3D THIS_MODULE,
> +		.cra_u =3D {
> +			.ablkcipher =3D {
> +				.min_keysize	=3D AES_MIN_KEY_SIZE,
> +				.max_keysize	=3D AES_MAX_KEY_SIZE,
> +				.setkey		=3D mxs_dcp_aes_setkey,
> +				.encrypt	=3D mxs_dcp_aes_cbc_encrypt,
> +				.decrypt	=3D mxs_dcp_aes_cbc_decrypt,
> +				.ivsize		=3D AES_BLOCK_SIZE,
> +			}
dto.
> +		}
dto.
> +	},
> +};
> +
> +/* SHA1 */
> +static struct ahash_alg dcp_sha1_alg =3D {
> +	.init	=3D dcp_sha_init,
> +	.update	=3D dcp_sha_update,
> +	.final	=3D dcp_sha_final,
> +	.finup	=3D dcp_sha_finup,
> +	.digest	=3D dcp_sha_digest,
> +	.halg	=3D {
> +		.digestsize	=3D SHA1_DIGEST_SIZE,
> +		.base		=3D {
> +			.cra_name		=3D "sha1",
> +			.cra_driver_name	=3D "sha1-dcp",
> +			.cra_priority		=3D 400,
> +			.cra_alignmask		=3D 63,
> +			.cra_flags		=3D CRYPTO_ALG_ASYNC,
> +			.cra_blocksize		=3D SHA1_BLOCK_SIZE,
> +			.cra_ctxsize		=3D sizeof(struct dcp_async_ctx),
> +			.cra_module		=3D THIS_MODULE,
> +			.cra_init		=3D dcp_sha_cra_init,
> +			.cra_exit		=3D dcp_sha_cra_exit,
> +		}
dto.
> +	}
dto.

> +};
> +
> +/* SHA256 */
> +static struct ahash_alg dcp_sha256_alg =3D {
> +	.init	=3D dcp_sha_init,
> +	.update	=3D dcp_sha_update,
> +	.final	=3D dcp_sha_final,
> +	.finup	=3D dcp_sha_finup,
> +	.digest	=3D dcp_sha_digest,
> +	.halg	=3D {
> +		.digestsize	=3D SHA256_DIGEST_SIZE,
> +		.base		=3D {
> +			.cra_name		=3D "sha256",
> +			.cra_driver_name	=3D "sha256-dcp",
> +			.cra_priority		=3D 400,
> +			.cra_alignmask		=3D 63,
> +			.cra_flags		=3D CRYPTO_ALG_ASYNC,
> +			.cra_blocksize		=3D SHA256_BLOCK_SIZE,
> +			.cra_ctxsize		=3D sizeof(struct dcp_async_ctx),
> +			.cra_module		=3D THIS_MODULE,
> +			.cra_init		=3D dcp_sha_cra_init,
> +			.cra_exit		=3D dcp_sha_cra_exit,
> +		}
dto.
> +	}
dto.

> +static const struct of_device_id mxs_dcp_dt_ids[] =3D {
> +	{.compatible =3D "fsl,mxs-dcp", .data =3D NULL,},
>
missing spaces after '{' and before '}'


Lothar Wa=C3=9Fmann
--=20
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstra=C3=9Fe 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Gesch=C3=A4ftsf=C3=BChrer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
