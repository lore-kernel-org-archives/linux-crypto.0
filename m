From: Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: Re: IXP4xx: Fix whitespace problems in ixp4xx_crypto.
Date: Tue, 12 Jan 2010 18:12:00 +0100
Message-ID: <20100112171159.GI3056@elara.bln.innominate.local>
References: <m34omu3rf7.fsf@intrepid.localdomain>
 <m3iqb93lvy.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:34228 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0ALRMD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 12:12:03 -0500
Content-Disposition: inline
In-Reply-To: <m3iqb93lvy.fsf@intrepid.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 10, 2010 at 06:33:37PM +0100, Krzysztof Halasa wrote:
> Signed-off-by: Krzysztof Ha=C5=82asa <khc@pm.waw.pl>
>=20
> diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_c=
rypto.c
> index 0c7e4f5..f8f6515 100644
> --- a/drivers/crypto/ixp4xx_crypto.c
> +++ b/drivers/crypto/ixp4xx_crypto.c
> @@ -64,7 +64,7 @@
> =20
>  #define MOD_DES     0x0000
>  #define MOD_TDEA2   0x0100
> -#define MOD_3DES   0x0200
> +#define MOD_3DES    0x0200
>  #define MOD_AES     0x0800
>  #define MOD_AES128  (0x0800 | KEYLEN_128)
>  #define MOD_AES192  (0x0900 | KEYLEN_192)
> @@ -137,7 +137,7 @@ struct crypt_ctl {
>  	u32 aadAddr;		/* Additional Auth Data Addr for CCM mode */
>  	u32 crypto_ctx;		/* NPE Crypto Param structure address */
> =20
> -	/* Used by Host: 4*4 bytes*/
> +	/* Used only by host: 4 * 4 bytes */
>  	unsigned ctl_flags;
>  	union {
>  		struct ablkcipher_request *ablk_req;
> @@ -208,10 +208,10 @@ static const struct ix_hash_algo hash_alg_sha1 =
=3D {
>  };
> =20
>  static struct npe *npe_c;
> -static struct dma_pool *buffer_pool =3D NULL;
> -static struct dma_pool *ctx_pool =3D NULL;
> +static struct dma_pool *buffer_pool;
> +static struct dma_pool *ctx_pool;
> =20
> -static struct crypt_ctl *crypt_virt =3D NULL;
> +static struct crypt_ctl *crypt_virt;

This is not a whitespace-fix.
The error-path in init_ixp_crypto() depends on them being either NULL
or correctly allocated.

Or is it guaranteed that static variables are always initially zero ?

>  static dma_addr_t crypt_phys;
> =20
>  static int support_aes =3D 1;

But this initialization is superflous, since it will be initialized bef=
ore use.

> @@ -246,12 +246,12 @@ static inline struct crypt_ctl *crypt_phys2virt=
(dma_addr_t phys)
> =20
>  static inline u32 cipher_cfg_enc(struct crypto_tfm *tfm)
>  {
> -	return container_of(tfm->__crt_alg, struct ixp_alg,crypto)->cfg_enc=
;
> +	return container_of(tfm->__crt_alg, struct ixp_alg, crypto)->cfg_en=
c;
>  }
> =20
>  static inline u32 cipher_cfg_dec(struct crypto_tfm *tfm)
>  {
> -	return container_of(tfm->__crt_alg, struct ixp_alg,crypto)->cfg_dec=
;
> +	return container_of(tfm->__crt_alg, struct ixp_alg, crypto)->cfg_de=
c;
>  }
> =20
>  static inline const struct ix_hash_algo *ix_hash(struct crypto_tfm *=
tfm)
> @@ -275,7 +275,7 @@ static spinlock_t desc_lock;
>  static struct crypt_ctl *get_crypt_desc(void)
>  {
>  	int i;
> -	static int idx =3D 0;
> +	static int idx;

This static index must be initialized with 0.

>  	unsigned long flags;
>  	struct crypt_ctl *desc =3D NULL;
> =20
> @@ -318,13 +318,13 @@ static struct crypt_ctl *get_crypt_desc_emerg(v=
oid)
>  		if (++idx >=3D NPE_QLEN_TOTAL)
>  			idx =3D NPE_QLEN;
>  		crypt_virt[i].ctl_flags =3D CTL_FLAG_USED;
> -		desc =3D crypt_virt +i;
> +		desc =3D crypt_virt + i;
>  	}
>  	spin_unlock_irqrestore(&emerg_lock, flags);
>  	return desc;
>  }
> =20
> -static void free_buf_chain(struct device *dev, struct buffer_desc *b=
uf,u32 phys)
> +static void free_buf_chain(struct device *dev, struct buffer_desc *b=
uf, u32 phys)

Introduces a line-length > 80.

>  {
>  	while (buf) {
>  		struct buffer_desc *buf1;
> @@ -349,10 +349,9 @@ static void finish_scattered_hmac(struct crypt_c=
tl *crypt)
>  	int authsize =3D crypto_aead_authsize(tfm);

[ snip ]

> @@ -1416,7 +1393,7 @@ static struct ixp_alg ixp4xx_algos[] =3D {
>  static int __init ixp_module_init(void)
>  {
>  	int num =3D ARRAY_SIZE(ixp4xx_algos);
> -	int i,err ;
> +	int i, err ;

Missed one before the ;

> =20
>  	if (platform_device_register(&pseudo_dev))
>  		return -ENODEV;
> @@ -1429,18 +1406,14 @@ static int __init ixp_module_init(void)
>  		platform_device_unregister(&pseudo_dev);
>  		return err;
>  	}
> -	for (i=3D0; i< num; i++) {
> +	for (i =3D 0; i < num; i++) {
>  		struct crypto_alg *cra =3D &ixp4xx_algos[i].crypto;
> =20
>  		if (snprintf(cra->cra_driver_name, CRYPTO_MAX_ALG_NAME,
> -			"%s"IXP_POSTFIX, cra->cra_name) >=3D
> -			CRYPTO_MAX_ALG_NAME)
> -		{
> +			"%s"IXP_POSTFIX, cra->cra_name) >=3D CRYPTO_MAX_ALG_NAME)
>  			continue;
> -		}
> -		if (!support_aes && (ixp4xx_algos[i].cfg_enc & MOD_AES)) {
> +		if (!support_aes && (ixp4xx_algos[i].cfg_enc & MOD_AES))
>  			continue;
> -		}
>  		if (!ixp4xx_algos[i].hash) {
>  			/* block ciphers */
>  			cra->cra_type =3D &crypto_ablkcipher_type;
> @@ -1484,7 +1457,7 @@ static void __exit ixp_module_exit(void)
>  	int num =3D ARRAY_SIZE(ixp4xx_algos);
>  	int i;
> =20
> -	for (i=3D0; i< num; i++) {
> +	for (i =3D 0; i < num; i++) {
>  		if (ixp4xx_algos[i].registered)
>  			crypto_unregister_alg(&ixp4xx_algos[i].crypto);
>  	}

Christian Hohnstaedt

--=20
Christian Hohnstaedt / Project Manager Hardware and Manufacturing

Innominate Security Technologies AG / protecting industrial networks
tel: +49.30.921028.208 / fax: +49.30.921028.020
Rudower Chaussee 13, D-12489 Berlin / http://www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Volker Bibelhausen
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
