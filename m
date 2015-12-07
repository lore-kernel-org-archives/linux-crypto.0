From: Zain <zain.wang@rock-chips.com>
Subject: Re: [RFC PATCH] Crypto: rockchip/crypto - add hash support for crypto
 engine in rk3288
Date: Mon, 7 Dec 2015 08:37:19 +0800
Message-ID: <5664D4BF.9010908@rock-chips.com>
References: <1449297025-8400-1-git-send-email-zain.wang@rock-chips.com>
 <17463675.3g1QGOEpU1@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: heiko@sntech.de, herbert@gondor.apana.org.au, davem@davemloft.net,
	eddie.cai@rock-chips.com, linux-rockchip@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:50710 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbbLGAhk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 Dec 2015 19:37:40 -0500
In-Reply-To: <17463675.3g1QGOEpU1@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



=E5=9C=A8 2015=E5=B9=B412=E6=9C=8805=E6=97=A5 20:22, Stephan Mueller =E5=
=86=99=E9=81=93:
> Am Samstag, 5. Dezember 2015, 14:30:25 schrieb Zain Wang:
>
> Hi Zain,
>
>> Add md5 sha1 sha256 support for crypto engine in rk3288.
>> This patch can't support multiple updatings because of limited of IC=
,
>> as result, it can't support import and export too.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>> drivers/crypto/rockchip/Makefile                   |   1 +
>> drivers/crypto/rockchip/rk3288_crypto.c            |  33 +-
>> drivers/crypto/rockchip/rk3288_crypto.h            |  50 ++-
>> drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
>> drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 369
>> +++++++++++++++++++++ 5 files changed, 455 insertions(+), 18 deletio=
ns(-)
>> create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ahash.c
>>
>> diff --git a/drivers/crypto/rockchip/Makefile
>> b/drivers/crypto/rockchip/Makefile index 7051c6c..30f9129 100644
>> --- a/drivers/crypto/rockchip/Makefile
>> +++ b/drivers/crypto/rockchip/Makefile
>> @@ -1,3 +1,4 @@
>> obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) +=3D rk_crypto.o
>> rk_crypto-objs :=3D rk3288_crypto.o \
>> 		  rk3288_crypto_ablkcipher.o \
>> +		  rk3288_crypto_ahash.o
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c
>> b/drivers/crypto/rockchip/rk3288_crypto.c index 82f3044..67d69d2 100=
644
>> --- a/drivers/crypto/rockchip/rk3288_crypto.c
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
>> @@ -190,7 +190,6 @@ static void rk_crypto_tasklet_cb(unsigned long d=
ata)
>> {
>> 	struct rk_crypto_info *dev =3D (struct rk_crypto_info *)data;
>> 	struct crypto_async_request *async_req, *backlog;
>> -	struct rk_cipher_reqctx *ablk_reqctx;
>> 	int err =3D 0;
>> 	unsigned long flags;
>>
>> @@ -207,10 +206,10 @@ static void rk_crypto_tasklet_cb(unsigned long=
 data)
>> 		backlog =3D NULL;
>> 	}
>>
>> -	if (crypto_tfm_alg_type(async_req->tfm) =3D=3D CRYPTO_ALG_TYPE_ABL=
KCIPHER)=20
> {
>> +	if (crypto_tfm_alg_type(async_req->tfm) =3D=3D CRYPTO_ALG_TYPE_ABL=
KCIPHER)
>> 		dev->ablk_req =3D ablkcipher_request_cast(async_req);
>> -		ablk_reqctx   =3D ablkcipher_request_ctx(dev->ablk_req);
>> -	}
>> +	else
>> +		dev->ahash_req =3D ahash_request_cast(async_req);
>> 	err =3D dev->start(dev);
>> 	if (err)
>> 		dev->complete(dev, err);
>> @@ -223,6 +222,9 @@ static struct rk_crypto_tmp *rk_cipher_algs[] =3D=
 {
>> 	&rk_cbc_des_alg,
>> 	&rk_ecb_des3_ede_alg,
>> 	&rk_cbc_des3_ede_alg,
>> +	&rk_ahash_sha1,
>> +	&rk_ahash_sha256,
>> +	&rk_ahash_md5,
>> };
>>
>> static int rk_crypto_register(struct rk_crypto_info *crypto_info)
>> @@ -232,15 +234,24 @@ static int rk_crypto_register(struct rk_crypto=
_info
>> *crypto_info)
>>
>> 	for (i =3D 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
>> 		rk_cipher_algs[i]->dev =3D crypto_info;
>> -		err =3D crypto_register_alg(&rk_cipher_algs[i]->alg);
>> +		if (rk_cipher_algs[i]->type =3D=3D ALG_TYPE_CIPHER)
>> +			err =3D crypto_register_alg(
>> +					&rk_cipher_algs[i]->alg.crypto);
>> +		else
>> +			err =3D crypto_register_ahash(
>> +					&rk_cipher_algs[i]->alg.hash);
>> 		if (err)
>> 			goto err_cipher_algs;
>> 	}
>> 	return 0;
>>
>> err_cipher_algs:
>> -	for (k =3D 0; k < i; k++)
>> -		crypto_unregister_alg(&rk_cipher_algs[k]->alg);
>> +	for (k =3D 0; k < i; k++) {
>> +		if (rk_cipher_algs[i]->type =3D=3D ALG_TYPE_CIPHER)
>> +			crypto_unregister_alg(&rk_cipher_algs[k]->alg.crypto);
>> +		else
>> +			crypto_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
>> +	}
>> 	return err;
>> }
>>
>> @@ -248,8 +259,12 @@ static void rk_crypto_unregister(void)
>> {
>> 	unsigned int i;
>>
>> -	for (i =3D 0; i < ARRAY_SIZE(rk_cipher_algs); i++)
>> -		crypto_unregister_alg(&rk_cipher_algs[i]->alg);
>> +	for (i =3D 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
>> +		if (rk_cipher_algs[i]->type =3D=3D ALG_TYPE_CIPHER)
>> +			crypto_unregister_alg(&rk_cipher_algs[i]->alg.crypto);
>> +		else
>> +			crypto_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
>> +	}
>> }
>>
>> static void rk_crypto_action(void *data)
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h
>> b/drivers/crypto/rockchip/rk3288_crypto.h index 604ffe7..453a00f 100=
644
>> --- a/drivers/crypto/rockchip/rk3288_crypto.h
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
>> @@ -6,6 +6,10 @@
>> #include <crypto/algapi.h>
>> #include <linux/interrupt.h>
>> #include <linux/delay.h>
>> +#include <crypto/internal/hash.h>
>> +
>> +#include "crypto/md5.h"
>> +#include "crypto/sha.h"
>>
>> #define _SBF(v, f)			((v) << (f))
>>
>> @@ -149,6 +153,28 @@
>> #define RK_CRYPTO_TDES_KEY3_0		0x0130
>> #define RK_CRYPTO_TDES_KEY3_1		0x0134
>>
>> +/* HASH */
>> +#define RK_CRYPTO_HASH_CTRL		0x0180
>> +#define RK_CRYPTO_HASH_SWAP_DO		BIT(3)
>> +#define RK_CRYPTO_HASH_SWAP_DI		BIT(2)
>> +#define RK_CRYPTO_HASH_SHA1		_SBF(0x00, 0)
>> +#define RK_CRYPTO_HASH_MD5		_SBF(0x01, 0)
>> +#define RK_CRYPTO_HASH_SHA256		_SBF(0x02, 0)
>> +#define RK_CRYPTO_HASH_PRNG		_SBF(0x03, 0)
>> +
>> +#define RK_CRYPTO_HASH_STS		0x0184
>> +#define RK_CRYPTO_HASH_DONE		BIT(0)
>> +
>> +#define RK_CRYPTO_HASH_MSG_LEN		0x0188
>> +#define RK_CRYPTO_HASH_DOUT_0		0x018c
>> +#define RK_CRYPTO_HASH_DOUT_1		0x0190
>> +#define RK_CRYPTO_HASH_DOUT_2		0x0194
>> +#define RK_CRYPTO_HASH_DOUT_3		0x0198
>> +#define RK_CRYPTO_HASH_DOUT_4		0x019c
>> +#define RK_CRYPTO_HASH_DOUT_5		0x01a0
>> +#define RK_CRYPTO_HASH_DOUT_6		0x01a4
>> +#define RK_CRYPTO_HASH_DOUT_7		0x01a8
>> +
>> #define CRYPTO_READ(dev, offset)		  \
>> 		readl_relaxed(((dev)->reg + (offset)))
>> #define CRYPTO_WRITE(dev, offset, val)	  \
>> @@ -166,6 +192,7 @@ struct rk_crypto_info {
>> 	struct crypto_queue		queue;
>> 	struct tasklet_struct		crypto_tasklet;
>> 	struct ablkcipher_request	*ablk_req;
>> +	struct ahash_request		*ahash_req;
>> 	/* device lock */
>> 	spinlock_t			lock;
>>
>> @@ -194,6 +221,12 @@ struct rk_crypto_info {
>> 			 struct scatterlist *sg_dst);
>> 	void (*unload_data)(struct rk_crypto_info *dev);
>> };
>> +/* the private variable of hash */
>> +struct rk_ahash_ctx {
>> +	struct rk_crypto_info		*dev;
>> +	int				FLAG_FINUP;
>> +	int				first_op;
>> +};
>>
>> /* the private variable of cipher */
>> struct rk_cipher_ctx {
>> @@ -201,9 +234,18 @@ struct rk_cipher_ctx {
>> 	unsigned int			keylen;
>> };
>>
>> +enum alg_type {
>> +	ALG_TYPE_HASH,
>> +	ALG_TYPE_CIPHER,
>> +};
>> +
>> struct rk_crypto_tmp {
>> -	struct rk_crypto_info *dev;
>> -	struct crypto_alg alg;
>> +	struct rk_crypto_info		*dev;
>> +	union {
>> +		struct crypto_alg	crypto;
>> +		struct ahash_alg	hash;
>> +	} alg;
>> +	enum alg_type			type;
>> };
>>
>> extern struct rk_crypto_tmp rk_ecb_aes_alg;
>> @@ -213,4 +255,8 @@ extern struct rk_crypto_tmp rk_cbc_des_alg;
>> extern struct rk_crypto_tmp rk_ecb_des3_ede_alg;
>> extern struct rk_crypto_tmp rk_cbc_des3_ede_alg;
>>
>> +extern struct rk_crypto_tmp rk_ahash_sha1;
>> +extern struct rk_crypto_tmp rk_ahash_sha256;
>> +extern struct rk_crypto_tmp rk_ahash_md5;
>> +
>> #endif
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
>> b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c index 3624080..=
a260203
>> 100644
>> --- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
>> +++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
>> @@ -322,7 +322,7 @@ static int rk_ablk_cra_init(struct crypto_tfm *t=
fm)
>> 	struct crypto_alg *alg =3D tfm->__crt_alg;
>> 	struct rk_crypto_tmp *algt;
>>
>> -	algt =3D container_of(alg, struct rk_crypto_tmp, alg);
>> +	algt =3D container_of(alg, struct rk_crypto_tmp, alg.crypto);
>>
>> 	ctx->dev =3D algt->dev;
>> 	ctx->dev->align_size =3D crypto_tfm_alg_alignmask(tfm) + 1;
>> @@ -343,7 +343,8 @@ static void rk_ablk_cra_exit(struct crypto_tfm *=
tfm)
>> }
>>
>> struct rk_crypto_tmp rk_ecb_aes_alg =3D {
>> -	.alg =3D {
>> +	.type =3D ALG_TYPE_CIPHER,
>> +	.alg.crypto =3D {
>> 		.cra_name		=3D "ecb(aes)",
>> 		.cra_driver_name	=3D "ecb-aes-rk",
>> 		.cra_priority		=3D 300,
>> @@ -367,7 +368,8 @@ struct rk_crypto_tmp rk_ecb_aes_alg =3D {
>> };
>>
>> struct rk_crypto_tmp rk_cbc_aes_alg =3D {
>> -	.alg =3D {
>> +	.type =3D ALG_TYPE_CIPHER,
>> +	.alg.crypto =3D {
>> 		.cra_name		=3D "cbc(aes)",
>> 		.cra_driver_name	=3D "cbc-aes-rk",
>> 		.cra_priority		=3D 300,
>> @@ -392,7 +394,8 @@ struct rk_crypto_tmp rk_cbc_aes_alg =3D {
>> };
>>
>> struct rk_crypto_tmp rk_ecb_des_alg =3D {
>> -	.alg =3D {
>> +	.type =3D ALG_TYPE_CIPHER,
>> +	.alg.crypto =3D {
>> 		.cra_name		=3D "ecb(des)",
>> 		.cra_driver_name	=3D "ecb-des-rk",
>> 		.cra_priority		=3D 300,
>> @@ -416,7 +419,8 @@ struct rk_crypto_tmp rk_ecb_des_alg =3D {
>> };
>>
>> struct rk_crypto_tmp rk_cbc_des_alg =3D {
>> -	.alg =3D {
>> +	.type =3D ALG_TYPE_CIPHER,
>> +	.alg.crypto =3D {
>> 		.cra_name		=3D "cbc(des)",
>> 		.cra_driver_name	=3D "cbc-des-rk",
>> 		.cra_priority		=3D 300,
>> @@ -441,7 +445,8 @@ struct rk_crypto_tmp rk_cbc_des_alg =3D {
>> };
>>
>> struct rk_crypto_tmp rk_ecb_des3_ede_alg =3D {
>> -	.alg =3D {
>> +	.type =3D ALG_TYPE_CIPHER,
>> +	.alg.crypto =3D {
>> 		.cra_name		=3D "ecb(des3_ede)",
>> 		.cra_driver_name	=3D "ecb-des3-ede-rk",
>> 		.cra_priority		=3D 300,
>> @@ -466,7 +471,8 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg =3D {
>> };
>>
>> struct rk_crypto_tmp rk_cbc_des3_ede_alg =3D {
>> -	.alg =3D {
>> +	.type =3D ALG_TYPE_CIPHER,
>> +	.alg.crypto =3D {
>> 		.cra_name		=3D "cbc(des3_ede)",
>> 		.cra_driver_name	=3D "cbc-des3-ede-rk",
>> 		.cra_priority		=3D 300,
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
>> b/drivers/crypto/rockchip/rk3288_crypto_ahash.c new file mode 100644
>> index 0000000..c049656
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
>> @@ -0,0 +1,369 @@
>> +/*
>> + * Crypto acceleration support for Rockchip RK3288
>> + *
>> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Zain Wang <zain.wang@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify it
>> + * under the terms and conditions of the GNU General Public License=
,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
>> + */
>> +#include "rk3288_crypto.h"
>> +
>> +static u8 *outdata[3] =3D {
>> +		"\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55"
>> +		"\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09",
>> +
>> +		"\xe3\xb0\xc4\x42\x98\xfc\x1c\x14"
>> +		"\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24"
>> +		"\x27\xae\x41\xe4\x64\x9b\x93\x4c"
>> +		"\xa4\x95\x99\x1b\x78\x52\xb8\x55",
>> +
>> +		"\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
>> +		"\xe9\x80\x09\x98\xec\xf8\x42\x7e",
>> +};
>> +
>> +static void nodata_process(struct ahash_request *req)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>> +	int rk_digest_size;
>> +
>> +	rk_digest_size =3D crypto_ahash_digestsize(tfm);
>> +
>> +	if (rk_digest_size =3D=3D SHA1_DIGEST_SIZE)
>> +		memcpy(req->result, outdata[0], rk_digest_size);
>> +	else if (rk_digest_size =3D=3D SHA256_DIGEST_SIZE)
>> +		memcpy(req->result, outdata[1], rk_digest_size);
>> +	else if (rk_digest_size =3D=3D MD5_DIGEST_SIZE)
>> +		memcpy(req->result, outdata[2], rk_digest_size);
>> +}
> What is the purpose of this code?
Because IC cann't process zero message hash, this function is out put
fixed hash to result depending on digestsize .
>> +
>> +static void rk_ahash_crypto_complete(struct rk_crypto_info *dev, in=
t err)
>> +{
>> +	if (dev->ahash_req->base.complete)
>> +		dev->ahash_req->base.complete(&dev->ahash_req->base, err);
>> +}
>> +
>> +static void rk_ahash_hw_init(struct rk_crypto_info *dev)
>> +{
>> +	int reg_status =3D 0;
>> +
>> +	reg_status =3D CRYPTO_READ(dev, RK_CRYPTO_CTRL) |
>> +		     RK_CRYPTO_HASH_FLUSH |
>> +		     _SBF(0xffff, 16);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
>> +
>> +	reg_status =3D CRYPTO_READ(dev, RK_CRYPTO_CTRL);
>> +	reg_status &=3D (~RK_CRYPTO_HASH_FLUSH);
>> +	reg_status |=3D _SBF(0xffff, 16);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
>> +
>> +	memset_io(dev->reg + RK_CRYPTO_HASH_DOUT_0, 0, 32);
>> +}
>> +
>> +static void rk_ahash_reg_init(struct rk_crypto_info *dev)
>> +{
>> +	rk_ahash_hw_init(dev);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTENA, RK_CRYPTO_HRDMA_ERR_ENA |
>> +					    RK_CRYPTO_HRDMA_DONE_ENA);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, RK_CRYPTO_HRDMA_ERR_INT |
>> +					    RK_CRYPTO_HRDMA_DONE_INT);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_HASH_CTRL, dev->mode |
>> +					       RK_CRYPTO_HASH_SWAP_DO);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CONF, RK_CRYPTO_BYTESWAP_HRFIFO |
>> +					  RK_CRYPTO_BYTESWAP_BRFIFO |
>> +					  RK_CRYPTO_BYTESWAP_BTFIFO);
>> +}
>> +
>> +static int rk_ahash_init(struct ahash_request *req)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
>> +	struct rk_crypto_info *dev =3D NULL;
>> +	int rk_digest_size;
>> +
>> +	dev =3D tctx->dev;
>> +	dev->left_bytes =3D 0;
>> +	dev->aligned =3D 0;
>> +	dev->ahash_req =3D req;
>> +	dev->mode =3D 0;
>> +	dev->align_size =3D 4;
>> +	dev->sg_dst =3D NULL;
>> +
>> +	tctx->first_op =3D 1;
>> +
>> +	rk_digest_size =3D crypto_ahash_digestsize(tfm);
>> +	if (!rk_digest_size)
>> +		dev_err(dev->dev, "can't get digestsize\n");
>> +	if (rk_digest_size =3D=3D SHA1_DIGEST_SIZE)
>> +		dev->mode =3D RK_CRYPTO_HASH_SHA1;
>> +	else if (rk_digest_size =3D=3D SHA256_DIGEST_SIZE)
>> +		dev->mode =3D RK_CRYPTO_HASH_SHA256;
>> +	else if (rk_digest_size =3D=3D MD5_DIGEST_SIZE)
>> +		dev->mode =3D RK_CRYPTO_HASH_MD5;
>> +
>> +	rk_ahash_reg_init(dev);
>> +	return 0;
>> +}
>> +
>> +static int rk_ahash_final(struct ahash_request *req)
>> +{
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
>> +	struct rk_crypto_info *dev =3D tctx->dev;
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(dev->ahash_req);
>> +
>> +	if (!dev->total) {
>> +		nodata_process(dev->ahash_req);
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * IC should process the result again after last dma interrupt.
>> +	 * And the last processing is very quick so than it may entry
>> +	 * interrupt before finishing last interrupt.
>> +	 * So I don't use interrupt finished hash.
>> +	 */
>> +	while (!CRYPTO_READ(dev, RK_CRYPTO_HASH_STS))
>> +		usleep_range(50, 100);
>> +
>> +	memcpy_fromio(dev->ahash_req->result, dev->reg +=20
> RK_CRYPTO_HASH_DOUT_0,
>> +		      crypto_ahash_digestsize(tfm));
>> +	return 0;
>> +}
>> +
>> +static int rk_ahash_update(struct ahash_request *req)
>> +{
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
>> +	struct rk_crypto_info *dev =3D tctx->dev;
>> +	int ret;
>> +
>> +	dev->total =3D req->nbytes;
>> +	dev->left_bytes =3D req->nbytes;
>> +	dev->sg_src =3D req->src;
>> +	dev->first =3D req->src;
>> +	dev->nents =3D sg_nents(req->src);
>> +
>> +	/* IC can calculate 0 data hash, so it should finish update here *=
/
>> +	if (!dev->total) {
>> +		pr_err("[%s:%d] no data\n", __func__, __LINE__);
>> +		return 0;
>> +	}
>> +
>> +	if (tctx->first_op) {
>> +		tctx->first_op =3D 0;
>> +		CRYPTO_WRITE(dev, RK_CRYPTO_HASH_MSG_LEN, dev->total);
>> +	} else {
>> +		/*
>> +		 * IC must know the length of total data at first,
>> +		 * multiple updatings cannot support this variable.
>> +		 */
>> +		dev_warn(dev->dev, "Cannot carry multiple updatings!\n");
>> +		return 0;
>> +	}
>> +	spin_lock(&dev->lock);
>> +	ret =3D crypto_enqueue_request(&dev->queue, &req->base);
>> +	spin_unlock(&dev->lock);
>> +
>> +	tasklet_schedule(&dev->crypto_tasklet);
>> +
>> +	return ret;
>> +}
>> +
>> +static int rk_ahash_finup(struct ahash_request *req)
>> +{
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
>> +	int err;
>> +
>> +	/*
>> +	 * finup should should process one updating and final.
>> +	 * and we should wait for updating in finup so that we can
>> +	 * fetching result by calling rk_ahash_final in finup.
>> +	 */
>> +
>> +	tctx->FLAG_FINUP =3D 1;
>> +	err =3D rk_ahash_update(req);
>> +	if (err =3D=3D -EINPROGRESS || err =3D=3D -EBUSY)
>> +		while (tctx->FLAG_FINUP)
>> +			usleep_range(50, 500);
>> +
>> +	return rk_ahash_final(req);
>> +}
>> +
>> +static int rk_ahash_digest(struct ahash_request *req)
>> +{
>> +	return rk_ahash_init(req) ? -EINVAL : rk_ahash_finup(req);
>> +}
>> +
>> +static void crypto_ahash_dma_start(struct rk_crypto_info *dev)
>> +{
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_HRDMAS, dev->addr_in);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_HRDMAL, (dev->count + 3) / 4);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, RK_CRYPTO_HASH_START |
>> +					  (RK_CRYPTO_HASH_START << 16));
>> +}
>> +
>> +static int rk_ahash_set_data_start(struct rk_crypto_info *dev)
>> +{
>> +	int err;
>> +
>> +	err =3D dev->load_data(dev, dev->sg_src, NULL);
>> +	if (!err)
>> +		crypto_ahash_dma_start(dev);
>> +	return err;
>> +}
>> +
>> +static int rk_ahash_start(struct rk_crypto_info *dev)
>> +{
>> +	return rk_ahash_set_data_start(dev);
>> +}
>> +
>> +/*
>> + * return:
>> + * true: some err was occurred
>> + * fault: no err, please continue
>> + */
>> +static int rk_ahash_crypto_rx(struct rk_crypto_info *dev)
>> +{
>> +	int err =3D 0;
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(dev->ahash_req->base.=
tfm);
>> +
>> +	dev->unload_data(dev);
>> +	if (dev->left_bytes) {
>> +		if (dev->aligned) {
>> +			if (sg_is_last(dev->sg_src)) {
>> +				dev_warn(dev->dev, "[%s:%d], lack of data\n",
>> +					 __func__, __LINE__);
>> +				err =3D -ENOMEM;
>> +				goto out_rx;
>> +			}
>> +			dev->sg_src =3D sg_next(dev->sg_src);
>> +		}
>> +		err =3D rk_ahash_set_data_start(dev);
>> +	} else {
>> +		tctx->FLAG_FINUP =3D 0;
>> +		dev->complete(dev, 0);
>> +		return 0;
>> +	}
>> +
>> +out_rx:
>> +	return err;
>> +}
>> +
>> +static int rk_cra_hash_init(struct crypto_tfm *tfm)
>> +{
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(tfm);
>> +	struct rk_crypto_tmp *algt;
>> +	struct ahash_alg *alg =3D __crypto_ahash_alg(tfm->__crt_alg);
>> +
>> +	algt =3D container_of(alg, struct rk_crypto_tmp, alg.hash);
>> +
>> +	tctx->dev =3D algt->dev;
>> +	tctx->dev->addr_vir =3D (void *)__get_free_page(GFP_KERNEL);
>> +	if (!tctx->dev->addr_vir) {
>> +		pr_err("failed to kmalloc for addr_vir\n");
>> +		return -ENOMEM;
>> +	}
>> +	tctx->dev->start =3D rk_ahash_start;
>> +	tctx->dev->update =3D rk_ahash_crypto_rx;
>> +	tctx->dev->complete =3D rk_ahash_crypto_complete;
>> +	return tctx->dev->enable_clk(tctx->dev);
>> +}
>> +
>> +static void rk_cra_hash_exit(struct crypto_tfm *tfm)
>> +{
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	free_page((unsigned long)tctx->dev->addr_vir);
>> +	return tctx->dev->disable_clk(tctx->dev);
>> +}
>> +
>> +struct rk_crypto_tmp rk_ahash_sha1 =3D {
>> +	.type =3D ALG_TYPE_HASH,
>> +	.alg.hash =3D {
>> +		.init =3D rk_ahash_init,
>> +		.update =3D rk_ahash_update,
>> +		.final =3D rk_ahash_final,
>> +		.finup =3D rk_ahash_finup,
>> +		.digest =3D rk_ahash_digest,
>> +		.halg =3D {
>> +			 .digestsize =3D SHA1_DIGEST_SIZE,
>> +			 .statesize =3D sizeof(struct sha1_state),
>> +			 .base =3D {
>> +				  .cra_name =3D "sha1",
>> +				  .cra_driver_name =3D "rk-sha1",
>> +				  .cra_priority =3D 300,
>> +				  .cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					       CRYPTO_ALG_NEED_FALLBACK,
>> +				  .cra_blocksize =3D SHA1_BLOCK_SIZE,
>> +				  .cra_ctxsize =3D sizeof(struct rk_ahash_ctx),
>> +				  .cra_alignmask =3D 3,
>> +				  .cra_init =3D rk_cra_hash_init,
>> +				  .cra_exit =3D rk_cra_hash_exit,
>> +				  .cra_module =3D THIS_MODULE,
>> +				  }
>> +			 }
>> +	}
>> +};
>> +
>> +struct rk_crypto_tmp rk_ahash_sha256 =3D {
>> +	.type =3D ALG_TYPE_HASH,
>> +	.alg.hash =3D {
>> +	.init =3D rk_ahash_init,
>> +	.update =3D rk_ahash_update,
>> +	.final =3D rk_ahash_final,
>> +	.finup =3D rk_ahash_finup,
>> +	.digest =3D rk_ahash_digest,
>> +		.halg =3D {
>> +			 .digestsize =3D SHA256_DIGEST_SIZE,
>> +			 .statesize =3D sizeof(struct sha256_state),
>> +			 .base =3D {
>> +				  .cra_name =3D "sha256",
>> +				  .cra_driver_name =3D "rk-sha256",
>> +				  .cra_priority =3D 300,
>> +				  .cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					       CRYPTO_ALG_NEED_FALLBACK,
>> +				  .cra_blocksize =3D SHA256_BLOCK_SIZE,
>> +				  .cra_ctxsize =3D sizeof(struct rk_ahash_ctx),
>> +				  .cra_alignmask =3D 0,
>> +				  .cra_init =3D rk_cra_hash_init,
>> +				  .cra_exit =3D rk_cra_hash_exit,
>> +				  .cra_module =3D THIS_MODULE,
>> +				  }
>> +			 }
>> +	}
>> +};
>> +
>> +struct rk_crypto_tmp rk_ahash_md5 =3D {
>> +	.type =3D ALG_TYPE_HASH,
>> +	.alg.hash =3D {
>> +		.init =3D rk_ahash_init,
>> +		.update =3D rk_ahash_update,
>> +		.final =3D rk_ahash_final,
>> +		.finup =3D rk_ahash_finup,
>> +		.digest =3D rk_ahash_digest,
>> +		.halg =3D {
>> +			 .digestsize =3D MD5_DIGEST_SIZE,
>> +			 .statesize =3D sizeof(struct md5_state),
>> +			 .base =3D {
>> +				  .cra_name =3D "md5",
>> +				  .cra_driver_name =3D "rk-md5",
>> +				  .cra_priority =3D 300,
>> +				  .cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					       CRYPTO_ALG_NEED_FALLBACK,
>> +				  .cra_blocksize =3D SHA1_BLOCK_SIZE,
>> +				  .cra_ctxsize =3D sizeof(struct rk_ahash_ctx),
>> +				  .cra_alignmask =3D 0,
>> +				  .cra_init =3D rk_cra_hash_init,
>> +				  .cra_exit =3D rk_cra_hash_exit,
>> +				  .cra_module =3D THIS_MODULE,
>> +				  }
>> +			}
>> +	}
>> +};
>
> Ciao
> Stephan
>
>
>
