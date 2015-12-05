From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [RFC PATCH] Crypto: rockchip/crypto - add hash support for crypto
 engine in rk3288
Date: Sat, 5 Dec 2015 13:36:25 +0100
Message-ID: <5662DA49.3050100@gmail.com>
References: <1449297025-8400-1-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eddie.cai@rock-chips.com, linux-rockchip@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: Zain Wang <zain.wang@rock-chips.com>, heiko@sntech.de,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38097 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbLEMgb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Dec 2015 07:36:31 -0500
Received: by wmec201 with SMTP id c201so97159201wme.1
        for <linux-crypto@vger.kernel.org>; Sat, 05 Dec 2015 04:36:30 -0800 (PST)
In-Reply-To: <1449297025-8400-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 05/12/2015 07:30, Zain Wang a =E9crit :
> Add md5 sha1 sha256 support for crypto engine in rk3288.
> This patch can't support multiple updatings because of limited of IC,
> as result, it can't support import and export too.
>=20
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> ---
>  drivers/crypto/rockchip/Makefile                   |   1 +
>  drivers/crypto/rockchip/rk3288_crypto.c            |  33 +-
>  drivers/crypto/rockchip/rk3288_crypto.h            |  50 ++-
>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 369 +++++++++++=
++++++++++
>  5 files changed, 455 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ahash.c
>=20
> diff --git a/drivers/crypto/rockchip/Makefile b/drivers/crypto/rockch=
ip/Makefile
> index 7051c6c..30f9129 100644
> +++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> @@ -0,0 +1,369 @@
> +/*
> + * Crypto acceleration support for Rockchip RK3288
> + *
> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * Author: Zain Wang <zain.wang@rock-chips.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
> + */
> +#include "rk3288_crypto.h"
> +
> +static u8 *outdata[3] =3D {
> +		"\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55"
> +		"\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09",
> +
> +		"\xe3\xb0\xc4\x42\x98\xfc\x1c\x14"
> +		"\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24"
> +		"\x27\xae\x41\xe4\x64\x9b\x93\x4c"
> +		"\xa4\x95\x99\x1b\x78\x52\xb8\x55",
> +
> +		"\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
> +		"\xe9\x80\x09\x98\xec\xf8\x42\x7e",
> +};
> +

Clearly this array must be set const, and a comment about what are thos=
es numbers is necessary.
Perhaps splitting that in three arrays const xxx_zero_message_hash =3D =
=2E.. is also better.

> +static void nodata_process(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	int rk_digest_size;
> +
> +	rk_digest_size =3D crypto_ahash_digestsize(tfm);
> +
> +	if (rk_digest_size =3D=3D SHA1_DIGEST_SIZE)
> +		memcpy(req->result, outdata[0], rk_digest_size);
> +	else if (rk_digest_size =3D=3D SHA256_DIGEST_SIZE)
> +		memcpy(req->result, outdata[1], rk_digest_size);
> +	else if (rk_digest_size =3D=3D MD5_DIGEST_SIZE)
> +		memcpy(req->result, outdata[2], rk_digest_size);
> +}
> +
> +static void rk_ahash_crypto_complete(struct rk_crypto_info *dev, int=
 err)
> +{
> +	if (dev->ahash_req->base.complete)
> +		dev->ahash_req->base.complete(&dev->ahash_req->base, err);
> +}
> +
> +static void rk_ahash_hw_init(struct rk_crypto_info *dev)
> +{
> +	int reg_status =3D 0;
> +
> +	reg_status =3D CRYPTO_READ(dev, RK_CRYPTO_CTRL) |
> +		     RK_CRYPTO_HASH_FLUSH |
> +		     _SBF(0xffff, 16);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
> +
> +	reg_status =3D CRYPTO_READ(dev, RK_CRYPTO_CTRL);
> +	reg_status &=3D (~RK_CRYPTO_HASH_FLUSH);
> +	reg_status |=3D _SBF(0xffff, 16);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
> +
> +	memset_io(dev->reg + RK_CRYPTO_HASH_DOUT_0, 0, 32);
> +}
> +
> +static void rk_ahash_reg_init(struct rk_crypto_info *dev)
> +{
> +	rk_ahash_hw_init(dev);
> +
> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTENA, RK_CRYPTO_HRDMA_ERR_ENA |
> +					    RK_CRYPTO_HRDMA_DONE_ENA);
> +
> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, RK_CRYPTO_HRDMA_ERR_INT |
> +					    RK_CRYPTO_HRDMA_DONE_INT);
> +
> +	CRYPTO_WRITE(dev, RK_CRYPTO_HASH_CTRL, dev->mode |
> +					       RK_CRYPTO_HASH_SWAP_DO);
> +
> +	CRYPTO_WRITE(dev, RK_CRYPTO_CONF, RK_CRYPTO_BYTESWAP_HRFIFO |
> +					  RK_CRYPTO_BYTESWAP_BRFIFO |
> +					  RK_CRYPTO_BYTESWAP_BTFIFO);
> +}
> +
> +static int rk_ahash_init(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> +	struct rk_crypto_info *dev =3D NULL;
> +	int rk_digest_size;
> +
> +	dev =3D tctx->dev;
> +	dev->left_bytes =3D 0;
> +	dev->aligned =3D 0;
> +	dev->ahash_req =3D req;
> +	dev->mode =3D 0;
> +	dev->align_size =3D 4;
> +	dev->sg_dst =3D NULL;
> +
> +	tctx->first_op =3D 1;
> +
> +	rk_digest_size =3D crypto_ahash_digestsize(tfm);
> +	if (!rk_digest_size)
> +		dev_err(dev->dev, "can't get digestsize\n");
> +	if (rk_digest_size =3D=3D SHA1_DIGEST_SIZE)
> +		dev->mode =3D RK_CRYPTO_HASH_SHA1;
> +	else if (rk_digest_size =3D=3D SHA256_DIGEST_SIZE)
> +		dev->mode =3D RK_CRYPTO_HASH_SHA256;
> +	else if (rk_digest_size =3D=3D MD5_DIGEST_SIZE)
> +		dev->mode =3D RK_CRYPTO_HASH_MD5;
> +
> +	rk_ahash_reg_init(dev);
> +	return 0;
> +}
> +
> +static int rk_ahash_final(struct ahash_request *req)
> +{
> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> +	struct rk_crypto_info *dev =3D tctx->dev;
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(dev->ahash_req);
> +
> +	if (!dev->total) {
> +		nodata_process(dev->ahash_req);
> +		return 0;
> +	}
> +
> +	/*
> +	 * IC should process the result again after last dma interrupt.
> +	 * And the last processing is very quick so than it may entry
> +	 * interrupt before finishing last interrupt.
> +	 * So I don't use interrupt finished hash.
> +	 */
> +	while (!CRYPTO_READ(dev, RK_CRYPTO_HASH_STS))
> +		usleep_range(50, 100);
> +
> +	memcpy_fromio(dev->ahash_req->result, dev->reg + RK_CRYPTO_HASH_DOU=
T_0,
> +		      crypto_ahash_digestsize(tfm));
> +	return 0;
> +}
> +
> +static int rk_ahash_update(struct ahash_request *req)
> +{
> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> +	struct rk_crypto_info *dev =3D tctx->dev;
> +	int ret;
> +
> +	dev->total =3D req->nbytes;
> +	dev->left_bytes =3D req->nbytes;
> +	dev->sg_src =3D req->src;
> +	dev->first =3D req->src;
> +	dev->nents =3D sg_nents(req->src);
> +
> +	/* IC can calculate 0 data hash, so it should finish update here */
> +	if (!dev->total) {
> +		pr_err("[%s:%d] no data\n", __func__, __LINE__);
> +		return 0;
> +	}
> +
> +	if (tctx->first_op) {
> +		tctx->first_op =3D 0;
> +		CRYPTO_WRITE(dev, RK_CRYPTO_HASH_MSG_LEN, dev->total);
> +	} else {
> +		/*
> +		 * IC must know the length of total data at first,
> +		 * multiple updatings cannot support this variable.
> +		 */
> +		dev_warn(dev->dev, "Cannot carry multiple updatings!\n");
> +		return 0;
> +	}
> +	spin_lock(&dev->lock);
> +	ret =3D crypto_enqueue_request(&dev->queue, &req->base);
> +	spin_unlock(&dev->lock);
> +
> +	tasklet_schedule(&dev->crypto_tasklet);
> +
> +	return ret;
> +}
> +
> +static int rk_ahash_finup(struct ahash_request *req)
> +{
> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> +	int err;
> +
> +	/*
> +	 * finup should should process one updating and final.
> +	 * and we should wait for updating in finup so that we can
> +	 * fetching result by calling rk_ahash_final in finup.
> +	 */
> +
> +	tctx->FLAG_FINUP =3D 1;
> +	err =3D rk_ahash_update(req);
> +	if (err =3D=3D -EINPROGRESS || err =3D=3D -EBUSY)
> +		while (tctx->FLAG_FINUP)
> +			usleep_range(50, 500);

Please write a comment on why do you choose those numbers.

> +
> +	return rk_ahash_final(req);
> +}
> +
> +static int rk_ahash_digest(struct ahash_request *req)
> +{
> +	return rk_ahash_init(req) ? -EINVAL : rk_ahash_finup(req);
> +}
> +
> +static void crypto_ahash_dma_start(struct rk_crypto_info *dev)
> +{
> +	CRYPTO_WRITE(dev, RK_CRYPTO_HRDMAS, dev->addr_in);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_HRDMAL, (dev->count + 3) / 4);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, RK_CRYPTO_HASH_START |
> +					  (RK_CRYPTO_HASH_START << 16));
> +}
> +
> +static int rk_ahash_set_data_start(struct rk_crypto_info *dev)
> +{
> +	int err;
> +
> +	err =3D dev->load_data(dev, dev->sg_src, NULL);
> +	if (!err)
> +		crypto_ahash_dma_start(dev);
> +	return err;
> +}
> +
> +static int rk_ahash_start(struct rk_crypto_info *dev)
> +{
> +	return rk_ahash_set_data_start(dev);
> +}
> +
> +/*
> + * return:
> + * true: some err was occurred
> + * fault: no err, please continue
> + */
> +static int rk_ahash_crypto_rx(struct rk_crypto_info *dev)
> +{
> +	int err =3D 0;
> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(dev->ahash_req->base.t=
fm);
> +
> +	dev->unload_data(dev);
> +	if (dev->left_bytes) {
> +		if (dev->aligned) {
> +			if (sg_is_last(dev->sg_src)) {
> +				dev_warn(dev->dev, "[%s:%d], lack of data\n",
> +					 __func__, __LINE__);
> +				err =3D -ENOMEM;
> +				goto out_rx;
> +			}
> +			dev->sg_src =3D sg_next(dev->sg_src);
> +		}
> +		err =3D rk_ahash_set_data_start(dev);
> +	} else {
> +		tctx->FLAG_FINUP =3D 0;
> +		dev->complete(dev, 0);
> +		return 0;
> +	}
> +
> +out_rx:
> +	return err;
> +}
> +
> +static int rk_cra_hash_init(struct crypto_tfm *tfm)
> +{
> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(tfm);
> +	struct rk_crypto_tmp *algt;
> +	struct ahash_alg *alg =3D __crypto_ahash_alg(tfm->__crt_alg);
> +
> +	algt =3D container_of(alg, struct rk_crypto_tmp, alg.hash);
> +
> +	tctx->dev =3D algt->dev;
> +	tctx->dev->addr_vir =3D (void *)__get_free_page(GFP_KERNEL);
> +	if (!tctx->dev->addr_vir) {
> +		pr_err("failed to kmalloc for addr_vir\n");
Prefer dev_err instead of pr_err

Regards
