From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 10/10] crypto: caam - add support for RSA algorithm
Date: Sat, 19 Mar 2016 17:59:09 +0100
Message-ID: <3630222.vHD2IgIHAY@tauon.atsec.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com> <1458325927-14737-10-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com,
	linux-crypto@vger.kernel.org, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33176 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbcCSQ7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Mar 2016 12:59:23 -0400
In-Reply-To: <1458325927-14737-10-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 18. M=E4rz 2016, 20:32:07 schrieb Tudor Ambarus:

Hi Tudor,

> Add RSA support to caam driver.
>=20
> Coauthored-by: Yashpal Dutta <yashpal.dutta@freescale.com>
>=20
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> ---
>  drivers/crypto/caam/Kconfig    |  12 +
>  drivers/crypto/caam/Makefile   |   4 +
>  drivers/crypto/caam/caampkc.c  | 513
> +++++++++++++++++++++++++++++++++++++++++ drivers/crypto/caam/caampkc=
=2Eh  |=20
> 84 +++++++
>  drivers/crypto/caam/desc.h     |   2 +
>  drivers/crypto/caam/pdb.h      |  16 +-
>  drivers/crypto/caam/pkc_desc.c | 138 +++++++++++
>  7 files changed, 768 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/caam/caampkc.c
>  create mode 100644 drivers/crypto/caam/caampkc.h
>  create mode 100644 drivers/crypto/caam/pkc_desc.c
>=20
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfi=
g
> index 5652a53..5427e63 100644
> --- a/drivers/crypto/caam/Kconfig
> +++ b/drivers/crypto/caam/Kconfig
> @@ -99,6 +99,18 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
>  	  To compile this as a module, choose M here: the module
>  	  will be called caamhash.
>=20
> +config CRYPTO_DEV_FSL_CAAM_PKC_API
> +        tristate "Register public key cryptography implementations w=
ith
> Crypto API" +        depends on CRYPTO_DEV_FSL_CAAM &&
> CRYPTO_DEV_FSL_CAAM_JR
> +        default y
> +        select CRYPTO_RSA_HELPER
> +        help
> +          Selecting this will allow SEC Public key support for RSA.
> +          Supported cryptographic primitives: encryption, decryption=
,
> +          signature and verification.
> +          To compile this as a module, choose M here: the module
> +          will be called caam_pkc.
> +
>  config CRYPTO_DEV_FSL_CAAM_RNG_API
>  	tristate "Register caam device for hwrng API"
>  	depends on CRYPTO_DEV_FSL_CAAM && CRYPTO_DEV_FSL_CAAM_JR
> diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makef=
ile
> index 550758a..399ad55 100644
> --- a/drivers/crypto/caam/Makefile
> +++ b/drivers/crypto/caam/Makefile
> @@ -5,11 +5,15 @@ ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
>  	EXTRA_CFLAGS :=3D -DDEBUG
>  endif
>=20
> +ccflags-y +=3D -I$(srctree)/crypto
> +
>  obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) +=3D caam.o
>  obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) +=3D caam_jr.o
>  obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) +=3D caamalg.o
>  obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) +=3D caamhash.o
>  obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) +=3D caamrng.o
> +obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) +=3D caam_pkc.o
>=20
>  caam-objs :=3D ctrl.o
>  caam_jr-objs :=3D jr.o key_gen.o error.o
> +caam_pkc-y :=3D caampkc.o pkc_desc.o
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caam=
pkc.c
> new file mode 100644
> index 0000000..1c53158
> --- /dev/null
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -0,0 +1,513 @@
> +/*
> + * caam - Freescale FSL CAAM support for Public Key Cryptography
> + *
> + * Copyright 2016 Freescale Semiconductor, Inc.
> + *
> + * There is no Shared Descriptor for PKC so that the Job Descriptor =
must
> carry + * all the desired key parameters, input and output pointers.
> + */
> +#include <linux/dma-mapping.h>
> +#include <linux/fips.h>
> +#include "compat.h"
> +#include "caampkc.h"
> +#include "sg_sw_sec4.h"
> +#include "regs.h"
> +#include "intern.h"
> +#include "jr.h"
> +#include "error.h"
> +
> +void rsa_free_key(struct rsa_raw_key *key)
> +{
> +	kzfree(key->d);
> +	key->d =3D NULL;
> +
> +	kfree(key->e);
> +	key->e =3D NULL;
> +
> +	kfree(key->n);
> +	key->n =3D NULL;
> +
> +	key->n_sz =3D 0;
> +	key->e_sz =3D 0;
> +}

As you implement raw key support for use in other drivers, shouldn't th=
at=20
function go into some helper file like free_mpis().
> +
> +static int caam_rsa_setpubkey(struct crypto_akcipher *tfm, const voi=
d *key,
> +			      unsigned int keylen)
> +{
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *raw_key =3D &ctx->key;
> +	int ret;
> +
> +	set_raw_rsa_pub_action(&ctx->action);
> +
> +	/* Free the old key if any */
> +	rsa_free_key(raw_key);
> +
> +	ret =3D asn1_ber_decoder(&rsapubkey_decoder, ctx, key, keylen);
> +	if (ret < 0)
> +		goto free;
> +
> +	if (!raw_key->n || !raw_key->e) {
> +		/* Invalid key provided */
> +		ret =3D -EINVAL;
> +		goto free;
> +	}
> +
> +	return 0;
> +free:
> +	rsa_free_key(raw_key);
> +	return ret;
> +}
> +
> +static int caam_rsa_setprivkey(struct crypto_akcipher *tfm, const vo=
id
> *key, +			       unsigned int keylen)
> +{
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *raw_key =3D &ctx->key;
> +	int ret;
> +
> +	set_raw_rsa_priv_action(&ctx->action);
> +
> +	/* Free the old key if any */
> +	rsa_free_key(raw_key);
> +
> +	ret =3D asn1_ber_decoder(&rsaprivkey_decoder, ctx, key, keylen);
> +	if (ret < 0)
> +		goto free;
> +
> +	if (!raw_key->n || !raw_key->e || !raw_key->d) {
> +		/* Invalid key provided */
> +		ret =3D -EINVAL;
> +		goto free;
> +	}
> +
> +	return 0;
> +free:
> +	rsa_free_key(raw_key);
> +	return ret;
> +}
> +
> +static void rsa_pub_unmap(struct device *dev, struct rsa_edesc *edes=
c,
> +			  struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	struct rsa_pub_desc *hw_desc =3D (struct rsa_pub_desc *)edesc->hw_d=
esc;
> +
> +	dma_unmap_single(dev, hw_desc->n_dma, key->n_sz, DMA_TO_DEVICE);
> +	dma_unmap_single(dev, hw_desc->e_dma, key->e_sz, DMA_TO_DEVICE);
> +	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
> +	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
> +}
> +
> +static void rsa_priv_f1_unmap(struct device *dev, struct rsa_edesc *=
edesc,
> +			      struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	struct rsa_priv_f1_desc *hw_desc =3D
> +			(struct rsa_priv_f1_desc *)edesc->hw_desc;
> +
> +	dma_unmap_single(dev, hw_desc->n_dma, key->n_sz, DMA_TO_DEVICE);
> +	dma_unmap_single(dev, hw_desc->d_dma, key->n_sz, DMA_TO_DEVICE);
> +	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
> +	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
> +}
> +
> +static size_t skip_to_nonzero(u8 *ptr, size_t nbytes)
> +{
> +	size_t nr_zeros =3D 0;
> +
> +	while (!(*ptr) && nbytes) {
> +		nbytes--;
> +		ptr++;
> +		nr_zeros++;
> +	}
> +
> +	return nr_zeros;
> +}
> +
> +static size_t scatterwalk_skip_zeros(struct scatter_walk *walk, size=
_t
> nbytes) +{
> +	size_t len_this_page, nr_zeros, cnt =3D 0;
> +	u8 *vaddr, *ptr;
> +
> +	for (;;) {
> +		nr_zeros =3D 0;
> +		len_this_page =3D scatterwalk_pagelen(walk);
> +
> +		if (len_this_page > nbytes)
> +			len_this_page =3D nbytes;
> +
> +		vaddr =3D scatterwalk_map(walk);
> +		ptr =3D vaddr;
> +		nr_zeros =3D skip_to_nonzero(ptr, len_this_page);
> +		scatterwalk_unmap(vaddr);
> +
> +		/* count total number of zeros */
> +		cnt +=3D nr_zeros;
> +
> +		/* advance scatterwalk to the nonzero data */
> +		scatterwalk_advance(walk, nr_zeros);
> +
> +		if (nr_zeros < len_this_page || nbytes =3D=3D len_this_page)
> +			break;
> +
> +		nbytes -=3D len_this_page;
> +
> +		scatterwalk_pagedone(walk, 0, 1);
> +	}
> +
> +	return cnt;
> +}
> +
> +/*
> + * This function drops the leading zeros and copies the data to the =
initial
> + * pointer so that it can be freed later on. Returns the updated dat=
a
> length. + */
> +static size_t drop_leading_zeros(struct scatterlist *sg, size_t nbyt=
es)
> +{
> +	struct scatter_walk walk_src, walk_dst;
> +	size_t nr_zeros =3D 0;
> +
> +	scatterwalk_start(&walk_src, sg);
> +	nr_zeros =3D scatterwalk_skip_zeros(&walk_src, nbytes);
> +
> +	if (nr_zeros) {
> +		nbytes =3D nbytes - nr_zeros;
> +
> +		scatterwalk_start(&walk_dst, sg);
> +		scatterwalk_sg_copychunks(&walk_dst, &walk_src, nbytes);
> +		scatterwalk_done(&walk_dst, 0, 0);
> +	}
> +
> +	scatterwalk_done(&walk_src, 0, 0);
> +
> +	return nbytes;
> +}
> +
> +/* RSA Job Completion handler */
> +static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, voi=
d
> *context) +{
> +	struct akcipher_request *req =3D context;
> +	struct rsa_edesc *edesc;
> +
> +	if (err)
> +		caam_jr_strstatus(dev, err);
> +
> +	/*
> +	 * RSA's output is expected to be a big integer. Drop the leading
> +	 * zeros since they are not meaningful in the world of numbers.
> +	 */
> +	req->dst_len =3D drop_leading_zeros(req->dst, req->dst_len);
> +
> +	edesc =3D container_of(desc, struct rsa_edesc, hw_desc[0]);
> +
> +	rsa_pub_unmap(dev, edesc, req);
> +	kfree(edesc);
> +
> +	akcipher_request_complete(req, err);
> +}
> +
> +static void rsa_priv_f1_done(struct device *dev, u32 *desc, u32 err,
> +			     void *context)
> +{
> +	struct akcipher_request *req =3D context;
> +	struct rsa_edesc *edesc;
> +
> +	if (err)
> +		caam_jr_strstatus(dev, err);
> +
> +	/*
> +	 * RSA's output is expected to be a big integer. Drop the leading
> +	 * zeros since they are not meaningful in the world of numbers.
> +	 */
> +	req->dst_len =3D drop_leading_zeros(req->dst, req->dst_len);
> +
> +	edesc =3D container_of(desc, struct rsa_edesc, hw_desc[0]);
> +
> +	rsa_priv_f1_unmap(dev, edesc, req);
> +	kfree(edesc);
> +
> +	akcipher_request_complete(req, err);
> +}
> +
> +static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *re=
q,
> +					 size_t desclen)
> +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct device *dev =3D ctx->dev;
> +	struct rsa_edesc *edesc;
> +	gfp_t flags =3D (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
> +		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
> +	int sgc;
> +	int sec4_sg_index, sec4_sg_len =3D 0, sec4_sg_bytes;
> +	int src_nents, dst_nents;
> +
> +	src_nents =3D sg_nents_for_len(req->src, req->src_len);
> +	dst_nents =3D sg_nents_for_len(req->dst, req->dst_len);
> +
> +	if (src_nents > 1)
> +		sec4_sg_len =3D src_nents;
> +	if (dst_nents > 1)
> +		sec4_sg_len +=3D dst_nents;
> +
> +	sec4_sg_bytes =3D sec4_sg_len * sizeof(struct sec4_sg_entry);
> +
> +	/* allocate space for base edesc, hw desc commands and link tables =
*/
> +	edesc =3D kzalloc(sizeof(*edesc) + desclen + sec4_sg_bytes,
> +			GFP_DMA | flags);
> +	if (!edesc)
> +		return ERR_PTR(-ENOMEM);
> +
> +	sgc =3D dma_map_sg(dev, req->src, src_nents, DMA_TO_DEVICE);
> +	if (unlikely(!sgc)) {
> +		dev_err(dev, "unable to map source\n");
> +		goto src_fail;
> +	}
> +
> +	sgc =3D dma_map_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
> +	if (unlikely(!sgc)) {
> +		dev_err(dev, "unable to map destination\n");
> +		goto dst_fail;
> +	}
> +
> +	edesc->sec4_sg =3D (void *)edesc + sizeof(*edesc) + desclen;
> +
> +	sec4_sg_index =3D 0;
> +	if (src_nents > 1) {
> +		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
> +		sec4_sg_index +=3D src_nents;
> +	}
> +	if (dst_nents > 1) {
> +		sg_to_sec4_sg_last(req->dst, dst_nents,
> +				   edesc->sec4_sg + sec4_sg_index, 0);
> +	}
> +
> +	/* Save nents for later use in Job Descriptor. */
> +	edesc->src_nents =3D src_nents;
> +	edesc->dst_nents =3D dst_nents;
> +
> +	if (!sec4_sg_bytes)
> +		return edesc;
> +
> +	edesc->sec4_sg_dma =3D dma_map_single(dev, edesc->sec4_sg,
> +					    sec4_sg_bytes, DMA_TO_DEVICE);
> +	if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {
> +		dev_err(dev, "unable to map S/G table\n");
> +		goto sec4_sg_fail;
> +	}
> +
> +	return edesc;
> +
> +sec4_sg_fail:
> +	dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
> +dst_fail:
> +	dma_unmap_sg(dev, req->src, src_nents, DMA_TO_DEVICE);
> +src_fail:
> +	kfree(edesc);
> +	return ERR_PTR(-ENOMEM);
> +}
> +
> +static int caam_rsa_enc(struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	struct device *jrdev =3D ctx->dev;
> +	struct rsa_edesc *edesc =3D NULL;
> +	size_t desclen =3D sizeof(struct rsa_pub_desc);
> +	int ret;
> +
> +	if (unlikely(!key->n || !key->e))
> +		return -EINVAL;
> +
> +	if (req->dst_len < key->n_sz) {
> +		req->dst_len =3D key->n_sz;
> +		dev_err(jrdev, "Output buffer length less than parameter=20
n\n");
> +		return -EOVERFLOW;
> +	}
> +
> +	/* Allocate extended descriptor. */
> +	edesc =3D rsa_edesc_alloc(req, desclen);
> +	if (IS_ERR(edesc))
> +		return PTR_ERR(edesc);
> +
> +	/* Initialize Job Descriptor. */
> +	ret =3D init_rsa_pub_desc(req, edesc);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);
> +	if (!ret) {
> +		ret =3D -EINPROGRESS;
> +	} else {
> +		rsa_pub_unmap(jrdev, edesc, req);
> +		kfree(edesc);
> +	}
> +
> +	return ret;
> +}
> +
> +static int caam_rsa_dec(struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	struct device *jrdev =3D ctx->dev;
> +	struct rsa_edesc *edesc =3D NULL;
> +	size_t desclen =3D sizeof(struct rsa_priv_f1_desc);
> +	int ret;
> +
> +	if (unlikely(!key->n || !key->d))
> +		return -EINVAL;
> +
> +	if (req->dst_len < key->n_sz) {
> +		req->dst_len =3D key->n_sz;
> +		return -EOVERFLOW;
> +	}
> +
> +	/* Allocate extended descriptor. */
> +	edesc =3D rsa_edesc_alloc(req, desclen);
> +	if (IS_ERR(edesc))
> +		return PTR_ERR(edesc);
> +
> +	/* Initialize Job Descriptor. */
> +	ret =3D init_rsa_priv_f1_desc(req, edesc);
> +	if (ret)
> +		return ret;

Same here, kfree?
> +
> +	ret =3D caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f1_done, re=
q);
> +	if (!ret) {
> +		ret =3D -EINPROGRESS;

dto

> +	} else {
> +		rsa_priv_f1_unmap(jrdev, edesc, req);
> +		kfree(edesc);
> +	}
> +
> +	return ret;
> +}
> +
> +static int caam_rsa_max_size(struct crypto_akcipher *tfm)
> +{
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +
> +	return (key->n) ? key->n_sz : -EINVAL;
> +}
> +
> +/* Per session pkc's driver context creation function */
> +static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
> +{
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +
> +	ctx->dev =3D caam_jr_alloc();
> +
> +	if (IS_ERR(ctx->dev)) {
> +		dev_err(ctx->dev, "Job Ring Device allocation for transform=20
failed\n");
> +		return PTR_ERR(ctx->dev);
> +	}
> +
> +	key->is_coherent =3D true;
> +	key->flags =3D GFP_DMA | GFP_KERNEL;
> +	return 0;
> +}
> +
> +/* Per session pkc's driver context cleanup function */
> +static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
> +{
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +
> +	rsa_free_key(key);
> +	caam_jr_free(ctx->dev);
> +}
> +
> +static struct akcipher_alg rsa =3D {

can you please name that something else, like caam_rsa? It is a real ha=
ssle=20
when searching some symbol and I get such a generic name.

> +	.encrypt =3D caam_rsa_enc,
> +	.decrypt =3D caam_rsa_dec,
> +	.sign =3D caam_rsa_dec,
> +	.verify =3D caam_rsa_enc,
> +	.set_pub_key =3D caam_rsa_setpubkey,
> +	.set_priv_key =3D caam_rsa_setprivkey,
> +	.max_size =3D caam_rsa_max_size,
> +	.init =3D caam_rsa_init_tfm,
> +	.exit =3D caam_rsa_exit_tfm,
> +	.base =3D {
> +		.cra_name =3D "rsa",
> +		.cra_driver_name =3D "rsa-caam",
> +		.cra_priority =3D 3000,
> +		.cra_module =3D THIS_MODULE,
> +		.cra_alignmask =3D 0,
> +		.cra_ctxsize =3D sizeof(struct rsa_raw_ctx),
> +	},
> +};
> +
> +/* Public Key Cryptography module initialization handler */
> +static int __init caam_pkc_init(void)
> +{
> +	struct device_node *dev_node;
> +	struct platform_device *pdev;
> +	struct device *ctrldev;
> +	struct caam_drv_private *priv;
> +	u32 cha_inst, pk_inst;
> +	int err =3D 0;
> +
> +	dev_node =3D of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
> +	if (!dev_node) {
> +		dev_node =3D of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
> +		if (!dev_node)
> +			return -ENODEV;
> +	}
> +
> +	pdev =3D of_find_device_by_node(dev_node);
> +	if (!pdev) {
> +		of_node_put(dev_node);
> +		return -ENODEV;
> +	}
> +
> +	ctrldev =3D &pdev->dev;
> +	priv =3D dev_get_drvdata(ctrldev);
> +	of_node_put(dev_node);
> +
> +	/*
> +	 * If priv is NULL, it's probably because the caam driver wasn't
> +	 * properly initialized (e.g. RNG4 init failed). Thus, bail out her=
e.
> +	 */
> +	if (!priv)
> +		return -ENODEV;
> +
> +	/* Determine public key hardware accelerator presence. */
> +	cha_inst =3D rd_reg32(&priv->ctrl->perfmon.cha_num_ls);
> +	pk_inst =3D (cha_inst & CHA_ID_LS_PK_MASK) >> CHA_ID_LS_PK_SHIFT;
> +
> +	/* Do not register algorithms if PKHA is not present. */
> +	if (!pk_inst)
> +		return -ENODEV;
> +
> +	rsa.base.cra_flags =3D 0;
> +	err =3D crypto_register_akcipher(&rsa);
> +	if (err)
> +		dev_warn(ctrldev, "%s alg registration failed\n",
> +			 rsa.base.cra_driver_name);
> +	else
> +		dev_info(ctrldev, "caam algorithms registered in=20
/proc/crypto\n");
> +
> +	return err;
> +}
> +
> +static void __exit caam_pkc_exit(void)
> +{
> +	crypto_unregister_akcipher(&rsa);
> +}
> +
> +module_init(caam_pkc_init);
> +module_exit(caam_pkc_exit);
> +
> +MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_DESCRIPTION("FSL CAAM support for PKC functions of crypto API=
");
> +MODULE_AUTHOR("Freescale Semiconductor");
> diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caam=
pkc.h
> new file mode 100644
> index 0000000..a49d7da
> --- /dev/null
> +++ b/drivers/crypto/caam/caampkc.h
> @@ -0,0 +1,84 @@
> +/*
> + * caam - Freescale FSL CAAM support for Public Key Cryptography
> descriptors + *
> + * Copyright 2016 Freescale Semiconductor, Inc.
> + *
> + * There is no Shared Descriptor for PKC so that the Job Descriptor =
must
> carry + * all the desired key parameters, input and output pointers.
> + */
> +
> +#ifndef _PKC_DESC_H_
> +#define _PKC_DESC_H_
> +
> +#include <crypto/internal/rsa.h>
> +#include <crypto/akcipher.h>
> +#include <crypto/internal/akcipher.h>
> +#include "desc_constr.h"
> +#include "pdb.h"
> +#include "rsapubkey-asn1.h"
> +#include "rsaprivkey-asn1.h"
> +
> +/**
> + * RSA Pub_Key Descriptor
> + * @desc_hdr: Job Descriptor Header command
> + * @sgf: scatter-gather field
> + * @f_dma: dma address of input data
> + * @g_dma: dma address of ecrypted output data
> + * @n_dma: dma address of RSA public exponent
> + * @dma_e: dma address of RSA public exponent
> + * @f_len: length in octets of the input data
> + * @op: RSA Operation command
> + */
> +struct rsa_pub_desc {
> +	u32		desc_hdr;
> +	u32		sgf;
> +	dma_addr_t	f_dma;
> +	dma_addr_t	g_dma;
> +	dma_addr_t	n_dma;
> +	dma_addr_t	e_dma;
> +	u32		f_len;
> +	u32		op;
> +} __packed;
> +
> +/**
> + * Form1 Priv_key Decryption Descriptor.
> + * Private key is represented by (n,d).
> + * @desc_hdr: Job Descriptor Header command
> + * @sgf: scatter-gather field
> + * @g_dma: dma address of ecrypted input data
> + * @f_dma: dma address of output data
> + * @n_dma: dma address of RSA public exponent
> + * @dma_d: dma address of RSA private exponent
> + * @op: RSA Operation command
> + */
> +struct rsa_priv_f1_desc {
> +	u32		desc_hdr;
> +	u32		sgf;
> +	dma_addr_t	g_dma;
> +	dma_addr_t	f_dma;
> +	dma_addr_t	n_dma;
> +	dma_addr_t	d_dma;
> +	u32		op;
> +} __packed;
> +
> +/**
> + * rsa_edesc - s/w-extended rsa descriptor
> + * @src_nents: number of segments in input scatterlist
> + * @dst_nents: number of segments in output scatterlist
> + * @sec4_sg_dma: dma address of h/w link table
> + * @sec4_sg: pointer to h/w link table
> + * @hw_desc: descriptor followed by link tables if any
> + */
> +struct rsa_edesc {
> +	int src_nents;
> +	int dst_nents;
> +	dma_addr_t sec4_sg_dma;
> +	struct sec4_sg_entry *sec4_sg;
> +	u32 hw_desc[];
> +};
> +
> +/* Descriptor construction primitives. */
> +int init_rsa_pub_desc(struct akcipher_request *req, struct rsa_edesc
> *edesc); +int init_rsa_priv_f1_desc(struct akcipher_request *req,
> +			  struct rsa_edesc *edesc);
> +#endif
> diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
> index 1e93c6a..7e5c027 100644
> --- a/drivers/crypto/caam/desc.h
> +++ b/drivers/crypto/caam/desc.h
> @@ -454,6 +454,8 @@ struct sec4_sg_entry {
>  #define OP_PCLID_PUBLICKEYPAIR	(0x14 << OP_PCLID_SHIFT)
>  #define OP_PCLID_DSASIGN	(0x15 << OP_PCLID_SHIFT)
>  #define OP_PCLID_DSAVERIFY	(0x16 << OP_PCLID_SHIFT)
> +#define OP_PCLID_RSAENC_PUBKEY  (0x18 << OP_PCLID_SHIFT)
> +#define OP_PCLID_RSADEC_PRVKEY  (0x19 << OP_PCLID_SHIFT)
>=20
>  /* Assuming OP_TYPE =3D OP_TYPE_DECAP_PROTOCOL/ENCAP_PROTOCOL */
>  #define OP_PCLID_IPSEC		(0x01 << OP_PCLID_SHIFT)
> diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
> index 3a87c0c..1c68d7b 100644
> --- a/drivers/crypto/caam/pdb.h
> +++ b/drivers/crypto/caam/pdb.h
> @@ -1,7 +1,7 @@
>  /*
>   * CAAM Protocol Data Block (PDB) definition header file
>   *
> - * Copyright 2008-2012 Freescale Semiconductor, Inc.
> + * Copyright 2008-2016 Freescale Semiconductor, Inc.
>   *
>   */
>=20
> @@ -399,4 +399,18 @@ struct dsa_verify_pdb {
>  	u8 *ab; /* only used if ECC processing */
>  };
>=20
> +/* RSA Protocol Data Block */
> +#define RSA_PDB_SGF_SHIFT       28
> +#define RSA_PDB_E_SHIFT         12
> +#define RSA_PDB_E_MASK          (0xFFF << RSA_PDB_E_SHIFT)
> +#define RSA_PDB_D_SHIFT         12
> +#define RSA_PDB_D_MASK          (0xFFF << RSA_PDB_D_SHIFT)
> +
> +#define RSA_PDB_SGF_F           (0x8 << RSA_PDB_SGF_SHIFT)
> +#define RSA_PDB_SGF_G           (0x4 << RSA_PDB_SGF_SHIFT)
> +#define RSA_PRIV_PDB_SGF_F      (0x4 << RSA_PDB_SGF_SHIFT)
> +#define RSA_PRIV_PDB_SGF_G      (0x8 << RSA_PDB_SGF_SHIFT)
> +
> +#define RSA_PRIV_KEY_FRM_1      0
> +
>  #endif
> diff --git a/drivers/crypto/caam/pkc_desc.c b/drivers/crypto/caam/pkc=
_desc.c
> new file mode 100644
> index 0000000..5ef4082
> --- /dev/null
> +++ b/drivers/crypto/caam/pkc_desc.c
> @@ -0,0 +1,138 @@
> +/*
> + * caam - Freescale FSL CAAM support for Public Key Cryptography
> descriptors + *
> + * Copyright 2016 Freescale Semiconductor, Inc.
> + *
> + * There is no Shared Descriptor for PKC so that the Job Descriptor =
must
> carry + * all the desired key parameters, input and output pointers.
> + */
> +#include "caampkc.h"
> +
> +/* Descriptor for RSA Public operation */
> +int init_rsa_pub_desc(struct akcipher_request *req, struct rsa_edesc
> *edesc) +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	struct device *dev =3D ctx->dev;
> +	struct rsa_pub_desc *desc =3D (struct rsa_pub_desc *)edesc->hw_desc=
;
> +	u32 start_idx, desc_size;
> +	int sec4_sg_index =3D 0;
> +
> +	/*
> +	 * The PDB has static fields and can be initialized before writing
> +	 * a specific command. Map the memory first, since it can be a poin=
t
> +	 * of failure.
> +	 */
> +	desc->n_dma =3D dma_map_single(dev, key->n, key->n_sz, DMA_TO_DEVIC=
E);
> +	if (dma_mapping_error(dev, desc->n_dma)) {
> +		dev_err(dev, "Unable to map  modulus memory\n");
> +		goto n_fail;
> +	}
> +
> +	desc->e_dma =3D dma_map_single(dev, key->e, key->e_sz, DMA_TO_DEVIC=
E);
> +	if (dma_mapping_error(dev, desc->e_dma)) {
> +		dev_err(dev, "Unable to map exponent memory\n");
> +		goto e_fail;
> +	}
> +
> +	desc_size =3D sizeof(*desc) / CAAM_CMD_SZ;
> +	start_idx =3D (desc_size - 1) & HDR_START_IDX_MASK;
> +	init_job_desc(edesc->hw_desc, (start_idx << HDR_START_IDX_SHIFT) |
> +		      (start_idx & HDR_DESCLEN_MASK) | HDR_ONE);
> +
> +	sec4_sg_index =3D 0;
> +	if (edesc->src_nents > 1) {
> +		desc->sgf |=3D RSA_PDB_SGF_F;
> +		desc->f_dma =3D edesc->sec4_sg_dma;
> +		sec4_sg_index +=3D edesc->src_nents;
> +	} else {
> +		desc->f_dma =3D sg_dma_address(req->src);
> +	}
> +
> +	if (edesc->dst_nents > 1) {
> +		desc->sgf |=3D RSA_PDB_SGF_G;
> +		desc->g_dma =3D edesc->sec4_sg_dma +
> +			sec4_sg_index * sizeof(struct sec4_sg_entry);
> +	} else {
> +		desc->g_dma =3D sg_dma_address(req->dst);
> +	}
> +
> +	desc->sgf |=3D (key->e_sz << RSA_PDB_E_SHIFT) | key->n_sz;
> +	desc->f_len =3D req->src_len;
> +	desc->op =3D CMD_OPERATION | OP_TYPE_UNI_PROTOCOL |
> +		   OP_PCLID_RSAENC_PUBKEY;
> +	return 0;
> +
> +e_fail:
> +	dma_unmap_single(dev, desc->n_dma, key->n_sz, DMA_TO_DEVICE);
> +n_fail:
> +	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
> +	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
> +	kfree(edesc);
> +	return -ENOMEM;
> +}
> +
> +/* Descriptor for RSA Private operation */
> +int init_rsa_priv_f1_desc(struct akcipher_request *req, struct rsa_e=
desc
> *edesc) +{
> +	struct crypto_akcipher *tfm =3D crypto_akcipher_reqtfm(req);
> +	struct rsa_raw_ctx *ctx =3D akcipher_tfm_ctx(tfm);
> +	struct rsa_raw_key *key =3D &ctx->key;
> +	struct device *dev =3D ctx->dev;
> +	struct rsa_priv_f1_desc *desc =3D
> +			(struct rsa_priv_f1_desc *)edesc->hw_desc;
> +	int sec4_sg_index =3D 0;
> +	u32 start_idx, desc_size;
> +
> +	/*
> +	 * The PDB has static fields and can be initialized before writing
> +	 * a specific command. Map the memory first, since it can be a poin=
t
> +	 * of failure.
> +	 */
> +	desc->n_dma =3D dma_map_single(dev, key->n, key->n_sz, DMA_TO_DEVIC=
E);
> +	if (dma_mapping_error(dev, desc->n_dma)) {
> +		dev_err(dev, "Unable to map  modulus memory\n");
> +		goto n_fail;
> +	}
> +
> +	desc->d_dma =3D dma_map_single(dev, key->d, key->n_sz, DMA_TO_DEVIC=
E);
> +	if (dma_mapping_error(dev, desc->d_dma)) {
> +		dev_err(dev, "Unable to map exponent memory\n");
> +		goto d_fail;
> +	}
> +
> +	desc_size =3D sizeof(*desc) / CAAM_CMD_SZ;
> +	start_idx =3D (desc_size - 1) & HDR_START_IDX_MASK;
> +	init_job_desc(edesc->hw_desc, (start_idx << HDR_START_IDX_SHIFT) |
> +		      (start_idx & HDR_DESCLEN_MASK) | HDR_ONE);
> +
> +	if (edesc->src_nents > 1) {
> +		desc->sgf |=3D RSA_PRIV_PDB_SGF_G;
> +		desc->g_dma =3D edesc->sec4_sg_dma;
> +		sec4_sg_index +=3D edesc->src_nents;
> +	} else {
> +		desc->g_dma =3D sg_dma_address(req->src);
> +	}
> +
> +	if (edesc->dst_nents > 1) {
> +		desc->sgf |=3D RSA_PRIV_PDB_SGF_F;
> +		desc->f_dma =3D edesc->sec4_sg_dma +
> +			sec4_sg_index * sizeof(struct sec4_sg_entry);
> +	} else {
> +		desc->f_dma =3D sg_dma_address(req->dst);
> +	}
> +
> +	desc->sgf |=3D (key->n_sz << RSA_PDB_D_SHIFT) | key->n_sz;
> +	desc->op =3D CMD_OPERATION | OP_TYPE_UNI_PROTOCOL |
> +		   OP_PCLID_RSADEC_PRVKEY | RSA_PRIV_KEY_FRM_1;
> +	return 0;
> +
> +d_fail:
> +	dma_unmap_single(dev, desc->n_dma, key->n_sz, DMA_TO_DEVICE);
> +n_fail:
> +	dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
> +	dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
> +	kfree(edesc);
> +	return -ENOMEM;
> +}


Ciao
Stephan
