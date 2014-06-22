From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sun, 22 Jun 2014 13:58:08 +0200
Message-ID: <53A6C4D0.1030102@gmail.com>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <1402404197-4236-2-git-send-email-clabbe.montjoie@gmail.com> <201406142101.02747.marex@denx.de>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
 linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Marek Vasut <marex-ynQEQJNshbs@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBVEJTOOQKGQEDFAX5GA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <201406142101.02747.marex-ynQEQJNshbs@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

Le 14/06/2014 21:01, Marek Vasut a =E9crit :
> On Tuesday, June 10, 2014 at 02:43:14 PM, LABBE Corentin wrote:
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support
>> AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>>
>> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> [...]
>=20
>> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
>> b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c new file mode 100644
>> index 0000000..fcdc8a4
>> --- /dev/null
>> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
>> @@ -0,0 +1,118 @@
>> +/*
>> + * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 So=
C
>> + *
>> + * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> + *
>> + * Support AES cipher with 128,192,256 bits keysize.
>> + * Support MD5 and SHA1 hash algorithms.
>> + * Support DES and 3DES
>> + * Support PRNG
>> + *
>> + * You could find the datasheet at
>> + * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
>> + *
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation version 2 of the License
>=20
> The license text seems incomplete.
> [...]

I will replace it with a simplier line "Licensed under the GPL-2."

>=20
>> +static int sunxi_des3_cbc_encrypt(struct ablkcipher_request *areq)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +
>> +	if (areq->info =3D=3D NULL) {
>> +		dev_info(ss->dev, "Empty IV\n");
>=20
> dev_err() here.
>=20
>> +		return -EINVAL;
>> +	}
>> +
>> +	op->mode |=3D SS_ENCRYPTION;
>> +	op->mode |=3D SS_OP_3DES;
>> +	op->mode |=3D SS_CBC;
>=20
> You can just op |=3D (foo | bar | baz) here .
>=20
>> +	return sunxi_des_poll(areq);
>> +}
>> +
>> +static int sunxi_des3_cbc_decrypt(struct ablkcipher_request *areq)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +
>> +	if (areq->info =3D=3D NULL) {
>> +		dev_info(ss->dev, "Empty IV\n");
>=20
> DTTO.
>=20
>> +		return -EINVAL;
>> +	}
>> +
>> +	op->mode |=3D SS_DECRYPTION;
>> +	op->mode |=3D SS_OP_3DES;
>> +	op->mode |=3D SS_CBC;
>=20
> DTTO.
>=20
> [...]
>> +static int sunxi_ss_3des_init(void)
>> +{
>> +	int err =3D 0;
>> +	if (ss =3D=3D NULL) {
>> +		pr_err("Cannot get Security System structure\n");
>> +		return -ENODEV;
>> +	}
>> +	err =3D crypto_register_alg(&sunxi_des3_alg);
>> +	if (err)
>> +		dev_err(ss->dev, "crypto_register_alg error for DES3\n");
>> +	else
>> +		dev_dbg(ss->dev, "Registred DES3\n");
>> +	return err;
>> +}
>> +
>> +static void __exit sunxi_ss_3des_exit(void)
>> +{
>> +	crypto_unregister_alg(&sunxi_des3_alg);
>> +}
>> +
>> +module_init(sunxi_ss_3des_init);
>> +module_exit(sunxi_ss_3des_exit);
>=20
> I really dislike how you have multiple modules accessing the same hardwar=
e. That=20
> just seems broken.

OK I abort my tries to make things optionnal.

>=20
> [...]
>=20
>> +static int sunxi_aes_cbc_encrypt(struct ablkcipher_request *areq)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +
>> +	if (areq->info =3D=3D NULL) {
>> +		dev_err(ss->dev, "Empty IV\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	op->mode |=3D SS_ENCRYPTION;
>> +	op->mode |=3D SS_OP_AES;
>> +	op->mode |=3D SS_CBC;
>=20
> This looks just like the 3DES implementation. Please make this into a com=
mon=20
> code if possible. I think you'd just need to have some switch statement b=
ased on=20
> the type of cipher to fill op->mode, that's all.

I agree, I will simplify that.

>=20
>> +	return sunxi_aes_poll(areq);
>> +}
>=20
> [...]
>=20
>> +static int sunxi_des_cbc_encrypt(struct ablkcipher_request *areq)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +
>> +	if (areq->info =3D=3D NULL) {
>> +		dev_info(ss->dev, "Empty IV\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	op->mode |=3D SS_ENCRYPTION;
>> +	op->mode |=3D SS_OP_DES;
>> +	op->mode |=3D SS_CBC;
>=20
> Looks similar to 3DES and AES again.
>=20
>> +	return sunxi_des_poll(areq);
>> +}
>=20
> [...]
>=20
>> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
>> b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c new file mode 100644
>> index 0000000..a27de49
> [...]
>> +int sunxi_cipher_init(struct crypto_tfm *tfm)
>> +{
>> +	struct sunxi_req_ctx *op =3D crypto_tfm_ctx(tfm);
>> +	memset(op, 0, sizeof(struct sunxi_req_ctx));
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(sunxi_cipher_init);
>=20
> This is wrong, you don't want to export this symbol.
>=20
>> +void sunxi_cipher_exit(struct crypto_tfm *tfm)
>> +{
>> +}
>> +EXPORT_SYMBOL_GPL(sunxi_cipher_exit);
>=20
> Why do you even need an empty function ?

Ok, I will clean that

>=20
>> +int sunxi_aes_poll(struct ablkcipher_request *areq)
>> +{
>> +	u32 tmp;
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(areq);
>> +	struct sunxi_req_ctx *op =3D crypto_ablkcipher_ctx(tfm);
>> +	unsigned int ivsize =3D crypto_ablkcipher_ivsize(tfm);
>> +	/* when activating SS, the default FIFO space is 32 */
>> +	u32 rx_cnt =3D 32;
>> +	u32 tx_cnt =3D 0;
>> +	u32 v;
>> +	int i;
>> +	struct scatterlist *in_sg;
>> +	struct scatterlist *out_sg;
>> +	void *src_addr;
>> +	void *dst_addr;
>> +	unsigned int ileft =3D areq->nbytes;
>> +	unsigned int oleft =3D areq->nbytes;
>> +	unsigned int sgileft =3D areq->src->length;
>> +	unsigned int sgoleft =3D areq->dst->length;
>> +	unsigned int todo;
>> +	u32 *src32;
>> +	u32 *dst32;
>> +
>> +	tmp =3D op->mode;
>> +	tmp |=3D SS_ENABLED;
>=20
> tmp is not a good name for a variable .

renamed to mode

>=20
>> +	in_sg =3D areq->src;
>> +	out_sg =3D areq->dst;
>> +	if (areq->src =3D=3D NULL || areq->dst =3D=3D NULL) {
>=20
> You do a NULL pointer test here, yet you access areq->src->length in sgil=
eft=20
> above . DTTO for areq->dst->length . That would crash much earlier than h=
ere.
>=20
>> +		dev_err(ss->dev, "ERROR: Some SGs are NULL %u\n", areq->nbytes);
>> +		return -1;
>> +	}
>> +	mutex_lock(&ss->lock);
>> +	if (areq->info !=3D NULL) {
>> +		for (i =3D 0; i < op->keylen; i +=3D 4) {
>> +			v =3D *(u32 *)(op->key + i);
>=20
> Consider that op->key would be magically unaligned ... then you'd trigger=
=20
> alignment fault here. Make the "op->key" an u32[] and drop those crap cas=
ts=20
> here.

I Agree

>=20
>> +			writel(v, ss->base + SS_KEY0 + i);
>> +		}
>> +		for (i =3D 0; i < 4 && i < ivsize / 4; i++) {
>> +			v =3D *(u32 *)(areq->info + i * 4);
>> +			writel(v, ss->base + SS_IV0 + i * 4);
>> +		}
>> +	}
>> +	writel(tmp, ss->base + SS_CTL);
>> +
>> +	/* If we have only one SG, we can use kmap_atomic */
>> +	if (sg_next(in_sg) =3D=3D NULL && sg_next(out_sg) =3D=3D NULL) {
>> +		src_addr =3D kmap_atomic(sg_page(in_sg)) + in_sg->offset;
>> +		if (src_addr =3D=3D NULL) {
>> +			dev_err(ss->dev, "kmap_atomic error for src SG\n");
>> +			writel(0, ss->base + SS_CTL);
>> +			mutex_unlock(&ss->lock);
>> +			return -1;
>=20
> -EINVAL ?
>=20
>> +		}
>> +		dst_addr =3D kmap_atomic(sg_page(out_sg)) + out_sg->offset;
>> +		if (dst_addr =3D=3D NULL) {
>> +			dev_err(ss->dev, "kmap_atomic error for dst SG\n");
>> +			writel(0, ss->base + SS_CTL);
>> +			mutex_unlock(&ss->lock);
>> +			kunmap_atomic(src_addr);
>> +			return -1;
>=20
> -EINVAL ?
>=20
>> +		}
>> +		src32 =3D (u32 *)src_addr;
>> +		dst32 =3D (u32 *)dst_addr;
>> +		ileft =3D areq->nbytes / 4;
>> +		oleft =3D areq->nbytes / 4;
>> +		do {
>> +			if (ileft > 0 && rx_cnt > 0) {
>> +				todo =3D min(rx_cnt, ileft);
>> +				ileft -=3D todo;
>> +				do {
>> +					writel_relaxed(*src32++,
>> +						       ss->base +
>> +						       SS_RXFIFO);
>> +					todo--;
>> +				} while (todo > 0);
>> +			}
>> +			if (tx_cnt > 0) {
>> +				todo =3D min(tx_cnt, oleft);
>> +				oleft -=3D todo;
>> +				do {
>> +					*dst32++ =3D readl_relaxed(ss->base +
>> +								SS_TXFIFO);
>> +					todo--;
>> +				} while (todo > 0);
>> +			}
>> +			tmp =3D readl_relaxed(ss->base + SS_FCSR);
>> +			rx_cnt =3D SS_RXFIFO_SPACES(tmp);
>> +			tx_cnt =3D SS_TXFIFO_SPACES(tmp);
>> +		} while (oleft > 0);
>> +		writel(0, ss->base + SS_CTL);
>> +		mutex_unlock(&ss->lock);
>> +		kunmap_atomic(src_addr);
>> +		kunmap_atomic(dst_addr);
>> +		return 0;
>> +	}
>> +
>> +	/* If we have more than one SG, we cannot use kmap_atomic since
>> +	 * we hold the mapping too long*/
>=20
> Wrong comment style.
>=20
> btw. can't you use generic scatterwalk here ?

I will check if it simplify the code.

>=20
>> +	src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
>> +	if (src_addr =3D=3D NULL) {
>> +		dev_err(ss->dev, "KMAP error for src SG\n");
>> +		return -1;
>> +	}
>=20
> Why can't you just use dma_map_sg() or somesuch ?

I do not see why I will use a DMA function in a driver without DMA support.
Perhaps I do not know some tricks.
Can I use writel/readl on address gived by DMA API ?


>=20
> [...]
>> +EXPORT_SYMBOL_GPL(sunxi_aes_poll);
>=20
> Again, don't export the symbol please.
>=20
> [...]
>> diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
>> b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h new file mode 100644
>> index 0000000..ecfbf9c
>> --- /dev/null
>> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
>> @@ -0,0 +1,8 @@
>> +#include "sunxi-ss.h"
>> +
>> +extern struct sunxi_ss_ctx *ss;
>=20
> Right. Please make it into one module and you won't need all this horror.
> [...]
>=20

Thanks for your review

Regards

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
