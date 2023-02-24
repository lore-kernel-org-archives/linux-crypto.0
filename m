Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9471CC61DA3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Feb 2023 13:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjBXNEG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Feb 2023 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjBXNEF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2023 08:04:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECDBF97B
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2023 05:03:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5539B81B2C
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2023 13:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D34C433D2;
        Fri, 24 Feb 2023 13:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677243834;
        bh=7hoRLZYLF9HcSIRrT0U6bT98RuRl/yKmcwah5ilZ6Fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZWx2M1YqZq6sPsAWe5KpWQ4W2FDWjFMq+5zqZFafY58pOFpk5p2w/Q5wBgOucs2x
         3pkKaA3io4e+IOW9Vo23Px45A8mjzH/CtB/0Dl0QNcUlI/sK50RxnZ+iBe0vz4IxQI
         OPf1B4Xn+rofWUqgEOR/SMyyzzwMmeRRlWSi0KIMES05zRvOTEyISY2TdDpTdQ8Y3t
         RMNcz0Tv5uKep1HXTD21TsMFKVjGz4wCZKn6aoU8fb8xOcp+cOA0e+nW6vwJIJknNe
         lA0oH+oIwGOhOiKp+Uunba/GVKhzLxJmXLqJxY/osGap1HSfSnFsVdAhrIuYFKhWQw
         O5Zf7G81iokzg==
Date:   Fri, 24 Feb 2023 13:03:49 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Walle <michael@walle.cc>
Cc:     kernelci-results@groups.io, bot@kernelci.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: mainline/master bisection: baseline.dmesg.emerg on
 kontron-pitx-imx8m
Message-ID: <Y/i1tX6th2I8hY0o@sirena.org.uk>
References: <63f7cbc9.170a0220.3200f.5d74@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="156/DNrOuJ6WIXvo"
Content-Disposition: inline
In-Reply-To: <63f7cbc9.170a0220.3200f.5d74@mx.google.com>
X-Cookie: The early worm gets the bird.
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--156/DNrOuJ6WIXvo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 12:25:45PM -0800, KernelCI bot wrote:

The KernelCI bisection bot found an issue in mainline with errors being
displayed on boot on kontron-pitx-imx8m with a defconfig+crypto config
which it bisected to 199354d7fb6e ("crypto: caam - Remove GFP_DMA and
add DMA alignment padding").  We don't have a run from -next for
defconfig+crypto today (yet, perhaps one will appear later).

The algorithms selftests are failing:

  alg: self-tests for cbc(aes) using cbc-aes-caam failed (rc=3D-22)
  alg: self-tests for cbc(des3_ede) using cbc-3des-caam failed (rc=3D-22)
  alg: self-tests for cbc(des) using  failed (rc=3D-22)

Full log showing the problem and backtraces at:

  https://storage.kernelci.org/mainline/master/v6.2-8532-gfcc77d7c8ef6/arm6=
4/defconfig+crypto/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt

=46rom run:

  https://linux.kernelci.org/test/plan/id/63f7f38ad0ae3b27f28c86b4/

I've left the full report from the bot with a tag from it plus links to
more details and a full bisect below:

> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>=20
> mainline/master bisection: baseline.dmesg.emerg on kontron-pitx-imx8m
>=20
> Summary:
>   Start:      9fc2f99030b5 Merge tag 'nfsd-6.3' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/cel/linux
>   Plain log:  https://storage.kernelci.org/mainline/master/v6.2-6669-g9fc=
2f99030b5/arm64/defconfig+crypto/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
>   HTML log:   https://storage.kernelci.org/mainline/master/v6.2-6669-g9fc=
2f99030b5/arm64/defconfig+crypto/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
>   Result:     199354d7fb6e crypto: caam - Remove GFP_DMA and add DMA alig=
nment padding
>=20
> Checks:
>   revert:     PASS
>   verify:     PASS
>=20
> Parameters:
>   Tree:       mainline
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/li=
nux.git
>   Branch:     master
>   Target:     kontron-pitx-imx8m
>   CPU arch:   arm64
>   Lab:        lab-kontron
>   Compiler:   gcc-10
>   Config:     defconfig+crypto
>   Test case:  baseline.dmesg.emerg
>=20
> Breaking commit found:
>=20
> -------------------------------------------------------------------------=
------
> commit 199354d7fb6eaa2cc5bb650af0bca624baffee35
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Dec 30 13:21:38 2022 +0800
>=20
>     crypto: caam - Remove GFP_DMA and add DMA alignment padding
>    =20
>     GFP_DMA does not guarantee that the returned memory is aligned
>     for DMA.  It should be removed where it is superfluous.
>    =20
>     However, kmalloc may start returning DMA-unaligned memory in future
>     so fix this by adding the alignment by hand.
>    =20
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_ge=
n.c
> index f46b161d2cda..87781c1534ee 100644
> --- a/drivers/crypto/caam/blob_gen.c
> +++ b/drivers/crypto/caam/blob_gen.c
> @@ -83,7 +83,7 @@ int caam_process_blob(struct caam_blob_priv *priv,
>  		output_len =3D info->input_len - CAAM_BLOB_OVERHEAD;
>  	}
> =20
> -	desc =3D kzalloc(CAAM_BLOB_DESC_BYTES_MAX, GFP_KERNEL | GFP_DMA);
> +	desc =3D kzalloc(CAAM_BLOB_DESC_BYTES_MAX, GFP_KERNEL);
>  	if (!desc)
>  		return -ENOMEM;
> =20
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index ecc15bc521db..4a9b998a8d26 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -59,6 +59,8 @@
>  #include <crypto/engine.h>
>  #include <crypto/xts.h>
>  #include <asm/unaligned.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> =20
>  /*
>   * crypto alg
> @@ -1379,8 +1381,7 @@ static struct aead_edesc *aead_edesc_alloc(struct a=
ead_request *req,
>  	sec4_sg_bytes =3D sec4_sg_len * sizeof(struct sec4_sg_entry);
> =20
>  	/* allocate space for base edesc and hw desc commands, link tables */
> -	edesc =3D kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
> -			GFP_DMA | flags);
> +	edesc =3D kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes, flags);
>  	if (!edesc) {
>  		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
>  			   0, 0, 0);
> @@ -1608,6 +1609,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(=
struct skcipher_request *req,
>  	u8 *iv;
>  	int ivsize =3D crypto_skcipher_ivsize(skcipher);
>  	int dst_sg_idx, sec4_sg_ents, sec4_sg_bytes;
> +	unsigned int aligned_size;
> =20
>  	src_nents =3D sg_nents_for_len(req->src, req->cryptlen);
>  	if (unlikely(src_nents < 0)) {
> @@ -1681,15 +1683,18 @@ static struct skcipher_edesc *skcipher_edesc_allo=
c(struct skcipher_request *req,
>  	/*
>  	 * allocate space for base edesc and hw desc commands, link tables, IV
>  	 */
> -	edesc =3D kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes + ivsize,
> -			GFP_DMA | flags);
> -	if (!edesc) {
> +	aligned_size =3D ALIGN(ivsize, __alignof__(*edesc));
> +	aligned_size +=3D sizeof(*edesc) + desc_bytes + sec4_sg_bytes;
> +	aligned_size =3D ALIGN(aligned_size, dma_get_cache_alignment());
> +	iv =3D kzalloc(aligned_size, flags);
> +	if (!iv) {
>  		dev_err(jrdev, "could not allocate extended descriptor\n");
>  		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
>  			   0, 0, 0);
>  		return ERR_PTR(-ENOMEM);
>  	}
> =20
> +	edesc =3D (void *)(iv + ALIGN(ivsize, __alignof__(*edesc)));
>  	edesc->src_nents =3D src_nents;
>  	edesc->dst_nents =3D dst_nents;
>  	edesc->mapped_src_nents =3D mapped_src_nents;
> @@ -1701,7 +1706,6 @@ static struct skcipher_edesc *skcipher_edesc_alloc(=
struct skcipher_request *req,
> =20
>  	/* Make sure IV is located in a DMAable area */
>  	if (ivsize) {
> -		iv =3D (u8 *)edesc->sec4_sg + sec4_sg_bytes;
>  		memcpy(iv, req->iv, ivsize);
> =20
>  		iv_dma =3D dma_map_single(jrdev, iv, ivsize, DMA_BIDIRECTIONAL);
> diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caama=
lg_qi.c
> index c37b67be0492..5e218bf20d5b 100644
> --- a/drivers/crypto/caam/caamalg_qi.c
> +++ b/drivers/crypto/caam/caamalg_qi.c
> @@ -20,6 +20,8 @@
>  #include "caamalg_desc.h"
>  #include <crypto/xts.h>
>  #include <asm/unaligned.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> =20
>  /*
>   * crypto alg
> @@ -959,7 +961,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aea=
d_request *req,
>  		return (struct aead_edesc *)drv_ctx;
> =20
>  	/* allocate space for base edesc and hw desc commands, link tables */
> -	edesc =3D qi_cache_alloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_alloc(flags);
>  	if (unlikely(!edesc)) {
>  		dev_err(qidev, "could not allocate extended descriptor\n");
>  		return ERR_PTR(-ENOMEM);
> @@ -1317,8 +1319,9 @@ static struct skcipher_edesc *skcipher_edesc_alloc(=
struct skcipher_request *req,
>  		qm_sg_ents =3D 1 + pad_sg_nents(qm_sg_ents);
> =20
>  	qm_sg_bytes =3D qm_sg_ents * sizeof(struct qm_sg_entry);
> -	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
> -		     ivsize > CAAM_QI_MEMCACHE_SIZE)) {
> +	if (unlikely(ALIGN(ivsize, __alignof__(*edesc)) +
> +		     offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes >
> +		     CAAM_QI_MEMCACHE_SIZE)) {
>  		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
>  			qm_sg_ents, ivsize);
>  		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
> @@ -1327,17 +1330,18 @@ static struct skcipher_edesc *skcipher_edesc_allo=
c(struct skcipher_request *req,
>  	}
> =20
>  	/* allocate space for base edesc, link tables and IV */
> -	edesc =3D qi_cache_alloc(GFP_DMA | flags);
> -	if (unlikely(!edesc)) {
> +	iv =3D qi_cache_alloc(flags);
> +	if (unlikely(!iv)) {
>  		dev_err(qidev, "could not allocate extended descriptor\n");
>  		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
>  			   0, DMA_NONE, 0, 0);
>  		return ERR_PTR(-ENOMEM);
>  	}
> =20
> +	edesc =3D (void *)(iv + ALIGN(ivsize, __alignof__(*edesc)));
> +
>  	/* Make sure IV is located in a DMAable area */
>  	sg_table =3D &edesc->sgt[0];
> -	iv =3D (u8 *)(sg_table + qm_sg_ents);
>  	memcpy(iv, req->iv, ivsize);
> =20
>  	iv_dma =3D dma_map_single(qidev, iv, ivsize, DMA_BIDIRECTIONAL);
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caam=
alg_qi2.c
> index 1b0dd742c53f..0ddef9a033a1 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -16,7 +16,9 @@
>  #include "caamalg_desc.h"
>  #include "caamhash_desc.h"
>  #include "dpseci-debugfs.h"
> +#include <linux/dma-mapping.h>
>  #include <linux/fsl/mc.h>
> +#include <linux/kernel.h>
>  #include <soc/fsl/dpaa2-io.h>
>  #include <soc/fsl/dpaa2-fd.h>
>  #include <crypto/xts.h>
> @@ -370,7 +372,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aea=
d_request *req,
>  	struct dpaa2_sg_entry *sg_table;
> =20
>  	/* allocate space for base edesc, link tables and IV */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (unlikely(!edesc)) {
>  		dev_err(dev, "could not allocate extended descriptor\n");
>  		return ERR_PTR(-ENOMEM);
> @@ -1189,7 +1191,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(=
struct skcipher_request *req)
>  	}
> =20
>  	/* allocate space for base edesc, link tables and IV */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (unlikely(!edesc)) {
>  		dev_err(dev, "could not allocate extended descriptor\n");
>  		caam_unmap(dev, req->src, req->dst, src_nents, dst_nents, 0,
> @@ -3220,14 +3222,14 @@ static int hash_digest_key(struct caam_hash_ctx *=
ctx, u32 *keylen, u8 *key,
>  	int ret =3D -ENOMEM;
>  	struct dpaa2_fl_entry *in_fle, *out_fle;
> =20
> -	req_ctx =3D kzalloc(sizeof(*req_ctx), GFP_KERNEL | GFP_DMA);
> +	req_ctx =3D kzalloc(sizeof(*req_ctx), GFP_KERNEL);
>  	if (!req_ctx)
>  		return -ENOMEM;
> =20
>  	in_fle =3D &req_ctx->fd_flt[1];
>  	out_fle =3D &req_ctx->fd_flt[0];
> =20
> -	flc =3D kzalloc(sizeof(*flc), GFP_KERNEL | GFP_DMA);
> +	flc =3D kzalloc(sizeof(*flc), GFP_KERNEL);
>  	if (!flc)
>  		goto err_flc;
> =20
> @@ -3316,7 +3318,13 @@ static int ahash_setkey(struct crypto_ahash *ahash=
, const u8 *key,
>  	dev_dbg(ctx->dev, "keylen %d blocksize %d\n", keylen, blocksize);
> =20
>  	if (keylen > blocksize) {
> -		hashed_key =3D kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> +		unsigned int aligned_len =3D
> +			ALIGN(keylen, dma_get_cache_alignment());
> +
> +		if (aligned_len < keylen)
> +			return -EOVERFLOW;
> +
> +		hashed_key =3D kmemdup(key, aligned_len, GFP_KERNEL);
>  		if (!hashed_key)
>  			return -ENOMEM;
>  		ret =3D hash_digest_key(ctx, &keylen, hashed_key, digestsize);
> @@ -3560,7 +3568,7 @@ static int ahash_update_ctx(struct ahash_request *r=
eq)
>  		}
> =20
>  		/* allocate space for base edesc and link tables */
> -		edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +		edesc =3D qi_cache_zalloc(flags);
>  		if (!edesc) {
>  			dma_unmap_sg(ctx->dev, req->src, src_nents,
>  				     DMA_TO_DEVICE);
> @@ -3654,7 +3662,7 @@ static int ahash_final_ctx(struct ahash_request *re=
q)
>  	int ret;
> =20
>  	/* allocate space for base edesc and link tables */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (!edesc)
>  		return -ENOMEM;
> =20
> @@ -3743,7 +3751,7 @@ static int ahash_finup_ctx(struct ahash_request *re=
q)
>  	}
> =20
>  	/* allocate space for base edesc and link tables */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (!edesc) {
>  		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
>  		return -ENOMEM;
> @@ -3836,7 +3844,7 @@ static int ahash_digest(struct ahash_request *req)
>  	}
> =20
>  	/* allocate space for base edesc and link tables */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (!edesc) {
>  		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
>  		return ret;
> @@ -3913,7 +3921,7 @@ static int ahash_final_no_ctx(struct ahash_request =
*req)
>  	int ret =3D -ENOMEM;
> =20
>  	/* allocate space for base edesc and link tables */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (!edesc)
>  		return ret;
> =20
> @@ -4012,7 +4020,7 @@ static int ahash_update_no_ctx(struct ahash_request=
 *req)
>  		}
> =20
>  		/* allocate space for base edesc and link tables */
> -		edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +		edesc =3D qi_cache_zalloc(flags);
>  		if (!edesc) {
>  			dma_unmap_sg(ctx->dev, req->src, src_nents,
>  				     DMA_TO_DEVICE);
> @@ -4125,7 +4133,7 @@ static int ahash_finup_no_ctx(struct ahash_request =
*req)
>  	}
> =20
>  	/* allocate space for base edesc and link tables */
> -	edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +	edesc =3D qi_cache_zalloc(flags);
>  	if (!edesc) {
>  		dma_unmap_sg(ctx->dev, req->src, src_nents, DMA_TO_DEVICE);
>  		return ret;
> @@ -4230,7 +4238,7 @@ static int ahash_update_first(struct ahash_request =
*req)
>  		}
> =20
>  		/* allocate space for base edesc and link tables */
> -		edesc =3D qi_cache_zalloc(GFP_DMA | flags);
> +		edesc =3D qi_cache_zalloc(flags);
>  		if (!edesc) {
>  			dma_unmap_sg(ctx->dev, req->src, src_nents,
>  				     DMA_TO_DEVICE);
> @@ -4926,6 +4934,7 @@ static int dpaa2_dpseci_congestion_setup(struct dpa=
a2_caam_priv *priv,
>  {
>  	struct dpseci_congestion_notification_cfg cong_notif_cfg =3D { 0 };
>  	struct device *dev =3D priv->dev;
> +	unsigned int alignmask;
>  	int err;
> =20
>  	/*
> @@ -4936,13 +4945,14 @@ static int dpaa2_dpseci_congestion_setup(struct d=
paa2_caam_priv *priv,
>  	    !(priv->dpseci_attr.options & DPSECI_OPT_HAS_CG))
>  		return 0;
> =20
> -	priv->cscn_mem =3D kzalloc(DPAA2_CSCN_SIZE + DPAA2_CSCN_ALIGN,
> -				 GFP_KERNEL | GFP_DMA);
> +	alignmask =3D DPAA2_CSCN_ALIGN - 1;
> +	alignmask |=3D dma_get_cache_alignment() - 1;
> +	priv->cscn_mem =3D kzalloc(ALIGN(DPAA2_CSCN_SIZE, alignmask + 1),
> +				 GFP_KERNEL);
>  	if (!priv->cscn_mem)
>  		return -ENOMEM;
> =20
> -	priv->cscn_mem_aligned =3D PTR_ALIGN(priv->cscn_mem, DPAA2_CSCN_ALIGN);
> -	priv->cscn_dma =3D dma_map_single(dev, priv->cscn_mem_aligned,
> +	priv->cscn_dma =3D dma_map_single(dev, priv->cscn_mem,
>  					DPAA2_CSCN_SIZE, DMA_FROM_DEVICE);
>  	if (dma_mapping_error(dev, priv->cscn_dma)) {
>  		dev_err(dev, "Error mapping CSCN memory area\n");
> @@ -5174,7 +5184,7 @@ static int dpaa2_caam_probe(struct fsl_mc_device *d=
pseci_dev)
>  	priv->domain =3D iommu_get_domain_for_dev(dev);
> =20
>  	qi_cache =3D kmem_cache_create("dpaa2_caamqicache", CAAM_QI_MEMCACHE_SI=
ZE,
> -				     0, SLAB_CACHE_DMA, NULL);
> +				     0, 0, NULL);
>  	if (!qi_cache) {
>  		dev_err(dev, "Can't allocate SEC cache\n");
>  		return -ENOMEM;
> @@ -5451,7 +5461,7 @@ int dpaa2_caam_enqueue(struct device *dev, struct c=
aam_request *req)
>  		dma_sync_single_for_cpu(priv->dev, priv->cscn_dma,
>  					DPAA2_CSCN_SIZE,
>  					DMA_FROM_DEVICE);
> -		if (unlikely(dpaa2_cscn_state_congested(priv->cscn_mem_aligned))) {
> +		if (unlikely(dpaa2_cscn_state_congested(priv->cscn_mem))) {
>  			dev_dbg_ratelimited(dev, "Dropping request\n");
>  			return -EBUSY;
>  		}
> diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caam=
alg_qi2.h
> index d35253407ade..abb502bb675c 100644
> --- a/drivers/crypto/caam/caamalg_qi2.h
> +++ b/drivers/crypto/caam/caamalg_qi2.h
> @@ -7,13 +7,14 @@
>  #ifndef _CAAMALG_QI2_H_
>  #define _CAAMALG_QI2_H_
> =20
> +#include <crypto/internal/skcipher.h>
> +#include <linux/compiler_attributes.h>
>  #include <soc/fsl/dpaa2-io.h>
>  #include <soc/fsl/dpaa2-fd.h>
>  #include <linux/threads.h>
>  #include <linux/netdevice.h>
>  #include "dpseci.h"
>  #include "desc_constr.h"
> -#include <crypto/skcipher.h>
> =20
>  #define DPAA2_CAAM_STORE_SIZE	16
>  /* NAPI weight *must* be a multiple of the store size. */
> @@ -36,8 +37,6 @@
>   * @tx_queue_attr: array of Tx queue attributes
>   * @cscn_mem: pointer to memory region containing the congestion SCN
>   *	it's size is larger than to accommodate alignment
> - * @cscn_mem_aligned: pointer to congestion SCN; it is computed as
> - *	PTR_ALIGN(cscn_mem, DPAA2_CSCN_ALIGN)
>   * @cscn_dma: dma address used by the QMAN to write CSCN messages
>   * @dev: device associated with the DPSECI object
>   * @mc_io: pointer to MC portal's I/O object
> @@ -58,7 +57,6 @@ struct dpaa2_caam_priv {
> =20
>  	/* congestion */
>  	void *cscn_mem;
> -	void *cscn_mem_aligned;
>  	dma_addr_t cscn_dma;
> =20
>  	struct device *dev;
> @@ -158,7 +156,7 @@ struct ahash_edesc {
>  struct caam_flc {
>  	u32 flc[16];
>  	u32 sh_desc[MAX_SDLEN];
> -} ____cacheline_aligned;
> +} __aligned(CRYPTO_DMA_ALIGN);
> =20
>  enum optype {
>  	ENCRYPT =3D 0,
> @@ -180,7 +178,7 @@ enum optype {
>   * @edesc: extended descriptor; points to one of {skcipher,aead}_edesc
>   */
>  struct caam_request {
> -	struct dpaa2_fl_entry fd_flt[2];
> +	struct dpaa2_fl_entry fd_flt[2] __aligned(CRYPTO_DMA_ALIGN);
>  	dma_addr_t fd_flt_dma;
>  	struct caam_flc *flc;
>  	dma_addr_t flc_dma;
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhas=
h.c
> index 1050e965a438..1f357f48c473 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -66,6 +66,8 @@
>  #include "key_gen.h"
>  #include "caamhash_desc.h"
>  #include <crypto/engine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> =20
>  #define CAAM_CRA_PRIORITY		3000
> =20
> @@ -365,7 +367,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx,=
 u32 *keylen, u8 *key,
>  	dma_addr_t key_dma;
>  	int ret;
> =20
> -	desc =3D kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DM=
A);
> +	desc =3D kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL);
>  	if (!desc) {
>  		dev_err(jrdev, "unable to allocate key input memory\n");
>  		return -ENOMEM;
> @@ -432,7 +434,13 @@ static int ahash_setkey(struct crypto_ahash *ahash,
>  	dev_dbg(jrdev, "keylen %d\n", keylen);
> =20
>  	if (keylen > blocksize) {
> -		hashed_key =3D kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> +		unsigned int aligned_len =3D
> +			ALIGN(keylen, dma_get_cache_alignment());
> +
> +		if (aligned_len < keylen)
> +			return -EOVERFLOW;
> +
> +		hashed_key =3D kmemdup(key, keylen, GFP_KERNEL);
>  		if (!hashed_key)
>  			return -ENOMEM;
>  		ret =3D hash_digest_key(ctx, &keylen, hashed_key, digestsize);
> @@ -702,7 +710,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct a=
hash_request *req,
>  	struct ahash_edesc *edesc;
>  	unsigned int sg_size =3D sg_num * sizeof(struct sec4_sg_entry);
> =20
> -	edesc =3D kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);
> +	edesc =3D kzalloc(sizeof(*edesc) + sg_size, flags);
>  	if (!edesc) {
>  		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
>  		return NULL;
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> index aef031946f33..e40614fef39d 100644
> --- a/drivers/crypto/caam/caampkc.c
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -16,6 +16,8 @@
>  #include "desc_constr.h"
>  #include "sg_sw_sec4.h"
>  #include "caampkc.h"
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> =20
>  #define DESC_RSA_PUB_LEN	(2 * CAAM_CMD_SZ + SIZEOF_RSA_PUB_PDB)
>  #define DESC_RSA_PRIV_F1_LEN	(2 * CAAM_CMD_SZ + \
> @@ -310,8 +312,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcip=
her_request *req,
>  	sec4_sg_bytes =3D sec4_sg_len * sizeof(struct sec4_sg_entry);
> =20
>  	/* allocate space for base edesc, hw desc commands and link tables */
> -	edesc =3D kzalloc(sizeof(*edesc) + desclen + sec4_sg_bytes,
> -			GFP_DMA | flags);
> +	edesc =3D kzalloc(sizeof(*edesc) + desclen + sec4_sg_bytes, flags);
>  	if (!edesc)
>  		goto dst_fail;
> =20
> @@ -898,7 +899,7 @@ static u8 *caam_read_rsa_crt(const u8 *ptr, size_t nb=
ytes, size_t dstlen)
>  	if (!nbytes)
>  		return NULL;
> =20
> -	dst =3D kzalloc(dstlen, GFP_DMA | GFP_KERNEL);
> +	dst =3D kzalloc(dstlen, GFP_KERNEL);
>  	if (!dst)
>  		return NULL;
> =20
> @@ -910,7 +911,7 @@ static u8 *caam_read_rsa_crt(const u8 *ptr, size_t nb=
ytes, size_t dstlen)
>  /**
>   * caam_read_raw_data - Read a raw byte stream as a positive integer.
>   * The function skips buffer's leading zeros, copies the remained data
> - * to a buffer allocated in the GFP_DMA | GFP_KERNEL zone and returns
> + * to a buffer allocated in the GFP_KERNEL zone and returns
>   * the address of the new buffer.
>   *
>   * @buf   : The data to read
> @@ -923,7 +924,7 @@ static inline u8 *caam_read_raw_data(const u8 *buf, s=
ize_t *nbytes)
>  	if (!*nbytes)
>  		return NULL;
> =20
> -	return kmemdup(buf, *nbytes, GFP_DMA | GFP_KERNEL);
> +	return kmemdup(buf, *nbytes, GFP_KERNEL);
>  }
> =20
>  static int caam_rsa_check_key_length(unsigned int len)
> @@ -949,13 +950,13 @@ static int caam_rsa_set_pub_key(struct crypto_akcip=
her *tfm, const void *key,
>  		return ret;
> =20
>  	/* Copy key in DMA zone */
> -	rsa_key->e =3D kmemdup(raw_key.e, raw_key.e_sz, GFP_DMA | GFP_KERNEL);
> +	rsa_key->e =3D kmemdup(raw_key.e, raw_key.e_sz, GFP_KERNEL);
>  	if (!rsa_key->e)
>  		goto err;
> =20
>  	/*
>  	 * Skip leading zeros and copy the positive integer to a buffer
> -	 * allocated in the GFP_DMA | GFP_KERNEL zone. The decryption descriptor
> +	 * allocated in the GFP_KERNEL zone. The decryption descriptor
>  	 * expects a positive integer for the RSA modulus and uses its length as
>  	 * decryption output length.
>  	 */
> @@ -983,6 +984,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rs=
a_ctx *ctx,
>  	struct caam_rsa_key *rsa_key =3D &ctx->key;
>  	size_t p_sz =3D raw_key->p_sz;
>  	size_t q_sz =3D raw_key->q_sz;
> +	unsigned aligned_size;
> =20
>  	rsa_key->p =3D caam_read_raw_data(raw_key->p, &p_sz);
>  	if (!rsa_key->p)
> @@ -994,11 +996,13 @@ static void caam_rsa_set_priv_key_form(struct caam_=
rsa_ctx *ctx,
>  		goto free_p;
>  	rsa_key->q_sz =3D q_sz;
> =20
> -	rsa_key->tmp1 =3D kzalloc(raw_key->p_sz, GFP_DMA | GFP_KERNEL);
> +	aligned_size =3D ALIGN(raw_key->p_sz, dma_get_cache_alignment());
> +	rsa_key->tmp1 =3D kzalloc(aligned_size, GFP_KERNEL);
>  	if (!rsa_key->tmp1)
>  		goto free_q;
> =20
> -	rsa_key->tmp2 =3D kzalloc(raw_key->q_sz, GFP_DMA | GFP_KERNEL);
> +	aligned_size =3D ALIGN(raw_key->q_sz, dma_get_cache_alignment());
> +	rsa_key->tmp2 =3D kzalloc(aligned_size, GFP_KERNEL);
>  	if (!rsa_key->tmp2)
>  		goto free_tmp1;
> =20
> @@ -1051,17 +1055,17 @@ static int caam_rsa_set_priv_key(struct crypto_ak=
cipher *tfm, const void *key,
>  		return ret;
> =20
>  	/* Copy key in DMA zone */
> -	rsa_key->d =3D kmemdup(raw_key.d, raw_key.d_sz, GFP_DMA | GFP_KERNEL);
> +	rsa_key->d =3D kmemdup(raw_key.d, raw_key.d_sz, GFP_KERNEL);
>  	if (!rsa_key->d)
>  		goto err;
> =20
> -	rsa_key->e =3D kmemdup(raw_key.e, raw_key.e_sz, GFP_DMA | GFP_KERNEL);
> +	rsa_key->e =3D kmemdup(raw_key.e, raw_key.e_sz, GFP_KERNEL);
>  	if (!rsa_key->e)
>  		goto err;
> =20
>  	/*
>  	 * Skip leading zeros and copy the positive integer to a buffer
> -	 * allocated in the GFP_DMA | GFP_KERNEL zone. The decryption descriptor
> +	 * allocated in the GFP_KERNEL zone. The decryption descriptor
>  	 * expects a positive integer for the RSA modulus and uses its length as
>  	 * decryption output length.
>  	 */
> @@ -1185,8 +1189,7 @@ int caam_pkc_init(struct device *ctrldev)
>  		return 0;
> =20
>  	/* allocate zero buffer, used for padding input */
> -	zero_buffer =3D kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |
> -			      GFP_KERNEL);
> +	zero_buffer =3D kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_KERNEL);
>  	if (!zero_buffer)
>  		return -ENOMEM;
> =20
> diff --git a/drivers/crypto/caam/caamprng.c b/drivers/crypto/caam/caamprn=
g.c
> index 4839e66300a2..6e4c1191cb28 100644
> --- a/drivers/crypto/caam/caamprng.c
> +++ b/drivers/crypto/caam/caamprng.c
> @@ -8,6 +8,8 @@
> =20
>  #include <linux/completion.h>
>  #include <crypto/internal/rng.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
>  #include "compat.h"
>  #include "regs.h"
>  #include "intern.h"
> @@ -75,6 +77,7 @@ static int caam_prng_generate(struct crypto_rng *tfm,
>  			     const u8 *src, unsigned int slen,
>  			     u8 *dst, unsigned int dlen)
>  {
> +	unsigned int aligned_dlen =3D ALIGN(dlen, dma_get_cache_alignment());
>  	struct caam_prng_ctx ctx;
>  	struct device *jrdev;
>  	dma_addr_t dst_dma;
> @@ -82,7 +85,10 @@ static int caam_prng_generate(struct crypto_rng *tfm,
>  	u8 *buf;
>  	int ret;
> =20
> -	buf =3D kzalloc(dlen, GFP_KERNEL);
> +	if (aligned_dlen < dlen)
> +		return -EOVERFLOW;
> +
> +	buf =3D kzalloc(aligned_dlen, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
> =20
> @@ -94,7 +100,7 @@ static int caam_prng_generate(struct crypto_rng *tfm,
>  		return ret;
>  	}
> =20
> -	desc =3D kzalloc(CAAM_PRNG_MAX_DESC_LEN, GFP_KERNEL | GFP_DMA);
> +	desc =3D kzalloc(CAAM_PRNG_MAX_DESC_LEN, GFP_KERNEL);
>  	if (!desc) {
>  		ret =3D -ENOMEM;
>  		goto out1;
> @@ -156,7 +162,7 @@ static int caam_prng_seed(struct crypto_rng *tfm,
>  		return ret;
>  	}
> =20
> -	desc =3D kzalloc(CAAM_PRNG_MAX_DESC_LEN, GFP_KERNEL | GFP_DMA);
> +	desc =3D kzalloc(CAAM_PRNG_MAX_DESC_LEN, GFP_KERNEL);
>  	if (!desc) {
>  		caam_jr_free(jrdev);
>  		return -ENOMEM;
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 1f0e82050976..1fd8ff965006 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -12,6 +12,8 @@
>  #include <linux/hw_random.h>
>  #include <linux/completion.h>
>  #include <linux/atomic.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
>  #include <linux/kfifo.h>
> =20
>  #include "compat.h"
> @@ -176,17 +178,18 @@ static int caam_init(struct hwrng *rng)
>  	int err;
> =20
>  	ctx->desc_sync =3D devm_kzalloc(ctx->ctrldev, CAAM_RNG_DESC_LEN,
> -				      GFP_DMA | GFP_KERNEL);
> +				      GFP_KERNEL);
>  	if (!ctx->desc_sync)
>  		return -ENOMEM;
> =20
>  	ctx->desc_async =3D devm_kzalloc(ctx->ctrldev, CAAM_RNG_DESC_LEN,
> -				       GFP_DMA | GFP_KERNEL);
> +				       GFP_KERNEL);
>  	if (!ctx->desc_async)
>  		return -ENOMEM;
> =20
> -	if (kfifo_alloc(&ctx->fifo, CAAM_RNG_MAX_FIFO_STORE_SIZE,
> -			GFP_DMA | GFP_KERNEL))
> +	if (kfifo_alloc(&ctx->fifo, ALIGN(CAAM_RNG_MAX_FIFO_STORE_SIZE,
> +					  dma_get_cache_alignment()),
> +			GFP_KERNEL))
>  		return -ENOMEM;
> =20
>  	INIT_WORK(&ctx->worker, caam_rng_worker);
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 32253a064d0f..6278afb951c3 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -199,7 +199,7 @@ static int deinstantiate_rng(struct device *ctrldev, =
int state_handle_mask)
>  	u32 *desc, status;
>  	int sh_idx, ret =3D 0;
> =20
> -	desc =3D kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL | GFP_DMA);
> +	desc =3D kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
>  	if (!desc)
>  		return -ENOMEM;
> =20
> @@ -276,7 +276,7 @@ static int instantiate_rng(struct device *ctrldev, in=
t state_handle_mask,
>  	int ret =3D 0, sh_idx;
> =20
>  	ctrl =3D (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
> -	desc =3D kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
> +	desc =3D kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
>  	if (!desc)
>  		return -ENOMEM;
> =20
> diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
> index b0e8a4939b4f..88cc4fe2a585 100644
> --- a/drivers/crypto/caam/key_gen.c
> +++ b/drivers/crypto/caam/key_gen.c
> @@ -64,7 +64,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
>  	if (local_max > max_keylen)
>  		return -EINVAL;
> =20
> -	desc =3D kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DM=
A);
> +	desc =3D kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL);
>  	if (!desc) {
>  		dev_err(jrdev, "unable to allocate key input memory\n");
>  		return ret;
> diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
> index c36f27376d7e..4c52c9365558 100644
> --- a/drivers/crypto/caam/qi.c
> +++ b/drivers/crypto/caam/qi.c
> @@ -614,7 +614,7 @@ static int alloc_rsp_fq_cpu(struct device *qidev, uns=
igned int cpu)
>  	struct qman_fq *fq;
>  	int ret;
> =20
> -	fq =3D kzalloc(sizeof(*fq), GFP_KERNEL | GFP_DMA);
> +	fq =3D kzalloc(sizeof(*fq), GFP_KERNEL);
>  	if (!fq)
>  		return -ENOMEM;
> =20
> @@ -756,7 +756,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
>  	}
> =20
>  	qi_cache =3D kmem_cache_create("caamqicache", CAAM_QI_MEMCACHE_SIZE, 0,
> -				     SLAB_CACHE_DMA, NULL);
> +				     0, NULL);
>  	if (!qi_cache) {
>  		dev_err(qidev, "Can't allocate CAAM cache\n");
>  		free_rsp_fqs();
> diff --git a/drivers/crypto/caam/qi.h b/drivers/crypto/caam/qi.h
> index 5894f16f8fe3..a96e3d213c06 100644
> --- a/drivers/crypto/caam/qi.h
> +++ b/drivers/crypto/caam/qi.h
> @@ -9,6 +9,8 @@
>  #ifndef __QI_H__
>  #define __QI_H__
> =20
> +#include <crypto/algapi.h>
> +#include <linux/compiler_attributes.h>
>  #include <soc/fsl/qman.h>
>  #include "compat.h"
>  #include "desc.h"
> @@ -58,8 +60,10 @@ enum optype {
>   * @qidev: device pointer for CAAM/QI backend
>   */
>  struct caam_drv_ctx {
> -	u32 prehdr[2];
> -	u32 sh_desc[MAX_SDLEN];
> +	struct {
> +		u32 prehdr[2];
> +		u32 sh_desc[MAX_SDLEN];
> +	} __aligned(CRYPTO_DMA_ALIGN);
>  	dma_addr_t context_a;
>  	struct qman_fq *req_fq;
>  	struct qman_fq *rsp_fq;
> @@ -67,7 +71,7 @@ struct caam_drv_ctx {
>  	int cpu;
>  	enum optype op_type;
>  	struct device *qidev;
> -} ____cacheline_aligned;
> +};
> =20
>  /**
>   * caam_drv_req - The request structure the driver application should fi=
ll while
> @@ -88,7 +92,7 @@ struct caam_drv_req {
>  	struct caam_drv_ctx *drv_ctx;
>  	caam_qi_cbk cbk;
>  	void *app_ctx;
> -} ____cacheline_aligned;
> +} __aligned(CRYPTO_DMA_ALIGN);
> =20
>  /**
>   * caam_drv_ctx_init - Initialise a CAAM/QI driver context
> -------------------------------------------------------------------------=
------
>=20
>=20
> Git bisection log:
>=20
> -------------------------------------------------------------------------=
------
> git bisect start
> # good: [1f2d9ffc7a5f916935749ffc6e93fb33bfe94d2f] Merge tag 'sched-core-=
2023-02-20' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 1f2d9ffc7a5f916935749ffc6e93fb33bfe94d2f
> # bad: [9fc2f99030b55027d84723b0dcbbe9f7e21b9c6c] Merge tag 'nfsd-6.3' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux
> git bisect bad 9fc2f99030b55027d84723b0dcbbe9f7e21b9c6c
> # good: [d1fabc68f8e0541d41657096dc713cb01775652d] Merge git://git.kernel=
=2Eorg/pub/scm/linux/kernel/git/netdev/net
> git bisect good d1fabc68f8e0541d41657096dc713cb01775652d
> # bad: [f3dd0c53370e70c0f9b7e931bbec12916f3bb8cc] bpf: add missing header=
 file include
> git bisect bad f3dd0c53370e70c0f9b7e931bbec12916f3bb8cc
> # skip: [877934769e5b91798d304d4641647900ee614ce8] Merge tag 'x86_cpu_for=
_v6.3_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect skip 877934769e5b91798d304d4641647900ee614ce8
> # good: [a5c926acd03aacbf558605f3352939dda86c8808] Merge back Intel therm=
al control changes for 6.3.
> git bisect good a5c926acd03aacbf558605f3352939dda86c8808
> # bad: [555c5661317e9c3090b9d181106d8bc31dd8e29a] crypto: sahara - Use re=
quest_complete helpers
> git bisect bad 555c5661317e9c3090b9d181106d8bc31dd8e29a
> # bad: [d52b0c780c1f8cdd0cef9c6e683ab568d04bb19d] Revert "crypto: rsa-pkc=
s1pad - Replace GFP_ATOMIC with GFP_KERNEL in pkcs1pad_encrypt_sign_complet=
e"
> git bisect bad d52b0c780c1f8cdd0cef9c6e683ab568d04bb19d
> # bad: [2f1cf4e50c956f882c9fc209c7cded832b67b8a3] crypto: aspeed - Add AC=
RY RSA driver
> git bisect bad 2f1cf4e50c956f882c9fc209c7cded832b67b8a3
> # good: [1ce94a8c2c3721be1d9bc85fd38fc8c520aa37d6] crypto: testmgr - disa=
llow plain cbcmac(aes) in FIPS mode
> git bisect good 1ce94a8c2c3721be1d9bc85fd38fc8c520aa37d6
> # bad: [37d8d3ae7a58cb16fa3f4f1992d2ee36bc621438] crypto: x86/aria - impl=
ement aria-avx2
> git bisect bad 37d8d3ae7a58cb16fa3f4f1992d2ee36bc621438
> # bad: [8e613cec25196b51601dfac50c5bf229acd72bc6] crypto: talitos - Remov=
e GFP_DMA and add DMA alignment padding
> git bisect bad 8e613cec25196b51601dfac50c5bf229acd72bc6
> # good: [c27b2d2012e1826674255b9e45b61c172a267e1c] crypto: testmgr - allo=
w ecdsa-nist-p256 and -p384 in FIPS mode
> git bisect good c27b2d2012e1826674255b9e45b61c172a267e1c
> # bad: [199354d7fb6eaa2cc5bb650af0bca624baffee35] crypto: caam - Remove G=
FP_DMA and add DMA alignment padding
> git bisect bad 199354d7fb6eaa2cc5bb650af0bca624baffee35
> # first bad commit: [199354d7fb6eaa2cc5bb650af0bca624baffee35] crypto: ca=
am - Remove GFP_DMA and add DMA alignment padding
> -------------------------------------------------------------------------=
------
>=20
>=20
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
> Groups.io Links: You receive all messages sent to this group.
> View/Reply Online (#38627): https://groups.io/g/kernelci-results/message/=
38627
> Mute This Topic: https://groups.io/mt/97192113/1131744
> Group Owner: kernelci-results+owner@groups.io
> Unsubscribe: https://groups.io/g/kernelci-results/unsub [broonie@kernel.o=
rg]
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
>=20
>=20

--156/DNrOuJ6WIXvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmP4tbQACgkQJNaLcl1U
h9C/2Qf/TdsaM2nd0mxSNWzhYC7n02+k5f8nYPU4wNytZsm0YFEq7mv41InGroEc
coyL1oAzZMIqH4qRsLXXwPXUKP3X84W8H5Htc+9prXXs6Kv4ZD9MppzMnSpNJQfp
2ucDTaEKRkCEJkjxGd0LYNCAPGhrJ23DNsZ7YqAM2clunz+Zh89qYpgJnxdVn1Hd
6s+4sYn3SM/dQNelZHnXRO7krCUeoAcNgdTmvpmNmYq5gGPa0dMew8TqeeE4xe85
446kHO6ZlYxvfXC2lZbi6bjpnEI3f0tEsgXgEaMWCGk6mR8mYX6NxvmujjhvI7d+
F9gr+4UCJHgUiZJn6kF26n41yFskEQ==
=A/xy
-----END PGP SIGNATURE-----

--156/DNrOuJ6WIXvo--
