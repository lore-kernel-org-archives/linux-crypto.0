Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr730086.outbound.protection.outlook.com ([40.107.73.86]:46720
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfAIIxF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 03:53:05 -0500
From: Kalyani Akula <kalyania@xilinx.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: RE: [RFC PATCH 2/3] crypto: Add Xilinx SHA3 driver
Date: Wed, 9 Jan 2019 08:53:00 +0000
Message-ID: <BN7PR02MB5124F96B9291015478AC8F85AF8B0@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1546851776-3456-1-git-send-email-kalyani.akula@xilinx.com>
 <1546851776-3456-3-git-send-email-kalyani.akula@xilinx.com>
 <20190107101313.GA17747@Red>
In-Reply-To: <20190107101313.GA17747@Red>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

Thanks for the review,
Please find my response inline.

> -----Original Message-----
> From: Corentin Labbe [mailto:clabbe.montjoie@gmail.com]
> Sent: Monday, January 7, 2019 3:43 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Kalyani Akula
> <kalyania@xilinx.com>; Sarat Chand Savitala <saratcha@xilinx.com>
> Subject: Re: [RFC PATCH 2/3] crypto: Add Xilinx SHA3 driver
>=20
> On Mon, Jan 07, 2019 at 02:32:55PM +0530, Kalyani Akula wrote:
> > This patch adds SHA3 driver suuport for the Xilinx ZynqMP SoC.
> >
> > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
>=20
> Hello
>=20
> I have some comment below
>=20
> > +static int zynqmp_sha_init(struct ahash_request *req) {
> > +	const struct zynqmp_eemi_ops *eemi_ops =3D
> zynqmp_pm_get_eemi_ops();
> > +	struct zynqmp_sha_reqctx *ctx =3D ahash_request_ctx(req);
> > +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> > +	struct zynqmp_sha_ctx *tctx =3D crypto_ahash_ctx(tfm);
> > +	struct zynqmp_sha_dev *dd =3D NULL;
> > +	struct zynqmp_sha_dev *tmp;
> > +	int ret;
> > +
> > +	if (!eemi_ops || !eemi_ops->sha_hash)
> > +		return -ENOTSUPP;
> > +
>=20
> Where can I find sha_hash() ?
> It seems that your serie miss some patchs.

This API should go into drivers/firmware/xilinx/zynqmp.c file. Will send fi=
x and send next version.
I was in assumption that the above driver is not in main-line as it was sen=
t as drivers/firmware/Xilinx/zynqmp/firmware.c initially and renamed later =
to zynqmp.c.

>=20
> > +	spin_lock_bh(&zynqmp_sha.lock);
> > +	if (!tctx->dd) {
> > +		list_for_each_entry(tmp, &zynqmp_sha.dev_list, list) {
> > +			dd =3D tmp;
> > +			break;
> > +		}
> > +		tctx->dd =3D dd;
> > +	} else {
> > +		dd =3D tctx->dd;
> > +	}
> > +	spin_unlock_bh(&zynqmp_sha.lock);
> > +
> > +	ctx->dd =3D dd;
> > +	dev_dbg(dd->dev, "init: digest size: %d\n",
> > +		crypto_ahash_digestsize(tfm));
> > +
> > +	ret =3D eemi_ops->sha_hash(0, 0, ZYNQMP_SHA3_INIT);
> > +
> > +	return ret;
> > +}
> > +
> > +static int zynqmp_sha_update(struct ahash_request *req) {
> > +	const struct zynqmp_eemi_ops *eemi_ops =3D
> zynqmp_pm_get_eemi_ops();
> > +	struct zynqmp_sha_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> > +	struct zynqmp_sha_dev *dd =3D tctx->dd;
> > +	size_t dma_size =3D req->nbytes;
> > +	dma_addr_t dma_addr;
> > +	char *kbuf;
> > +	int ret;
> > +
> > +	if (!req->nbytes)
> > +		return 0;
> > +
> > +	if (!eemi_ops || !eemi_ops->sha_hash)
> > +		return -ENOTSUPP;
> > +
> > +	kbuf =3D dma_alloc_coherent(dd->dev, dma_size, &dma_addr,
> GFP_KERNEL);
> > +	if (!kbuf)
> > +		return -ENOMEM;
> > +
> > +	scatterwalk_map_and_copy(kbuf, req->src, 0, req->nbytes, 0);
> > +	 __flush_cache_user_range((unsigned long)kbuf,
> > +				  (unsigned long)kbuf + dma_size);
> > +	ret =3D eemi_ops->sha_hash(dma_addr, req->nbytes,
> ZYNQMP_SHA3_UPDATE);
>=20
> Even with the sha_hash prototype missing, I think your driver have a
> problem:
> You support having more than one device, but sha_hash lacks any reference
> on the device doing the request.

Actually this is taken care using PM API id's by which the request is ident=
ified in the firmware (platform management unit (PMU-FW)) and sent to speci=
fic HW engine.=20
The ID specific to SHA3 engine will be added include/linux/firmware/xlnx-zy=
nqmp.h in the next version.=20

>=20
> > +static int zynqmp_sha_final(struct ahash_request *req) {
> > +	const struct zynqmp_eemi_ops *eemi_ops =3D
> zynqmp_pm_get_eemi_ops();
> > +	struct zynqmp_sha_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
> > +	struct zynqmp_sha_dev *dd =3D tctx->dd;
> > +	size_t dma_size =3D SHA384_DIGEST_SIZE;
> > +	dma_addr_t dma_addr;
> > +	char *kbuf;
> > +	int ret;
> > +
> > +	if (!eemi_ops || !eemi_ops->sha_hash)
> > +		return -ENOTSUPP;
> > +
> > +	kbuf =3D dma_alloc_coherent(dd->dev, dma_size, &dma_addr,
> GFP_KERNEL);
> > +	if (!kbuf)
> > +		return -ENOMEM;
> > +
> > +	ret =3D eemi_ops->sha_hash(dma_addr, dma_size,
> ZYNQMP_SHA3_FINAL);
> > +	memcpy(req->result, kbuf, 48);
>=20
> It is better to use SHA384_DIGEST_SIZE instead of 48

Will fix in the next version.

>=20
> [...]
> > +static int zynqmp_sha_probe(struct platform_device *pdev) {
> > +	struct zynqmp_sha_dev *sha_dd;
> > +	struct device *dev =3D &pdev->dev;
> > +	int err;
> > +
> > +	sha_dd =3D devm_kzalloc(&pdev->dev, sizeof(*sha_dd),
> GFP_KERNEL);
> > +	if (!sha_dd)
> > +		return -ENOMEM;
> > +
> > +	sha_dd->dev =3D dev;
> > +	platform_set_drvdata(pdev, sha_dd);
> > +	INIT_LIST_HEAD(&sha_dd->list);
> > +	spin_lock_init(&sha_dd->lock);
> > +	crypto_init_queue(&sha_dd->queue,
> ZYNQMP_SHA_QUEUE_LENGTH);
>=20
> You create a queue, but you didnt use it.
>=20
> [...]
> > +	spin_lock(&zynqmp_sha.lock);
> > +	list_add_tail(&sha_dd->list, &zynqmp_sha.dev_list);
> > +	spin_unlock(&zynqmp_sha.lock);
> > +
> > +	err =3D dma_set_mask_and_coherent(&pdev->dev,
> DMA_BIT_MASK(44));
> > +	if (err < 0)
> > +		dev_err(dev, "no usable DMA configuration");
>=20
> It is an error that you ignore, you miss some goto errxxx.
>
Will fix it in the next version.

Regards,
kalyani
=20
> Regards
