From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 2/7] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Tue, 18 Apr 2017 10:04:22 +0200
Message-ID: <20170418080422.55k63czpmnuqn7ku@kwain>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
 <20170329124432.27457-3-antoine.tenart@free-electrons.com>
 <5a016e1e-1443-158a-5ced-58dcb4ad63cc@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c3kwbi6r5oxbnufm"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        oferh@marvell.com, linux-arm-kernel@lists.infradead.org
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:37944 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbdDRIEZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 04:04:25 -0400
Content-Disposition: inline
In-Reply-To: <5a016e1e-1443-158a-5ced-58dcb4ad63cc@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--c3kwbi6r5oxbnufm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robin,

On Wed, Apr 12, 2017 at 02:54:13PM +0100, Robin Murphy wrote:
>=20
> Bit of a drive-by, but since I have it in my head that crypto drivers
> are a hotspot for dodgy DMA usage (in part due to the hardware often
> being a bit esoteric with embedded RAMs and such), this caught my eye
> and I thought I'd give this a quick once-over to check for anything
> smelly. Unfortunately, I was not disappointed... ;)

:-)

> On 29/03/17 13:44, Antoine Tenart wrote:
> [...]
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-secure/safexcel.c
> > new file mode 100644
> > index 000000000000..00f3f2c85d05
> > --- /dev/null
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> [...]
> > +int safexcel_invalidate_cache(struct crypto_async_request *async,
> > +			      struct safexcel_context *ctx,
> > +			      struct safexcel_crypto_priv *priv,
> > +			      dma_addr_t ctxr_dma, int ring,
> > +			      struct safexcel_request *request)
> > +{
> > +	struct safexcel_command_desc *cdesc;
> > +	struct safexcel_result_desc *rdesc;
> > +	phys_addr_t ctxr_phys;
> > +	int ret =3D 0;
> > +
> > +	ctxr_phys =3D dma_to_phys(priv->dev, ctxr_dma);
>=20
> No no no. This is a SWIOTLB-specific (or otherwise arch-private,
> depending on implementation) helper, not a DMA API function, and should
> not be called directly by drivers. There is no guarantee it will give
> the result you expect, or even compile, in all cases (if the kbuild
> robot hasn't already revealed via the COMPILE_TEST dependency).
>=20
> That said, AFAICS ctxr_phys ends up in a descriptor which is given to
> the device, so trying to use a physical address is wrong and it should
> still be the DMA address anyway.

I see. The cryptographic engine should always use dma addresses. I'll
update the descriptors structure members from "phys" to "dma" as well.

> [...]
> > +static int safexcel_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev =3D &pdev->dev;
> > +	struct resource *res;
> > +	struct safexcel_crypto_priv *priv;
> > +	int i, ret;
> > +
> > +	priv =3D devm_kzalloc(dev, sizeof(struct safexcel_crypto_priv),
> > +			    GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->dev =3D dev;
> > +
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	priv->base =3D devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(priv->base)) {
> > +		dev_err(dev, "failed to get resource\n");
> > +		return PTR_ERR(priv->base);
> > +	}
> > +
> > +	priv->clk =3D of_clk_get(dev->of_node, 0);
> > +	if (!IS_ERR(priv->clk)) {
> > +		ret =3D clk_prepare_enable(priv->clk);
> > +		if (ret) {
> > +			dev_err(dev, "unable to enable clk (%d)\n", ret);
> > +			return ret;
> > +		}
> > +	} else {
> > +		/* The clock isn't mandatory */
> > +		if (PTR_ERR(priv->clk) =3D=3D -EPROBE_DEFER)
> > +			return -EPROBE_DEFER;
> > +	}
>=20
> You should call dma_set_mask_and_coherent() before any DMA API calls,
> both to confirm DMA really is going to work all, and also (since this IP
> apparently supports >32-bit addresses) to describe the full inherent
> addressing capability, not least to avoid wasting time/space with
> unnecessary bounce buffering otherwise.

OK, I'll add a call to this helper before using DMA API calls.

> > +
> > +err_pool:
> > +	dma_pool_destroy(priv->context_pool);
>=20
> You used dmam_pool_create(), so not only is an explicit destroy
> unnecessary, but doing so with the non-managed version is actively
> harmful, since devres would end up double-freeing the pool after you retu=
rn.

I saw this and fixed it in my local version.

> > +struct safexcel_token {
> > +	u32 packet_length:17;
> > +	u8 stat:2;
> > +	u16 instructions:9;
> > +	u8 opcode:4;
> > +} __packed;
>=20
> Using bitfields in hardware descriptors seems pretty risky, since you've
> no real guarantee two compilers will lay them out the same way (or that
> either would be correct WRT what the hardware expects). I'd be more
> inclined to construct all these fields with explicit masking and shifting.

Hmm, I'm not sure to follow you here. If I use bitfields in a __packed
structure, we should be safe. Why would the compiler have a different
behaviour?

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
> > +	phys_addr_t ctxr_phys;
> > +	int nr_src, nr_dst, n_cdesc =3D 0, n_rdesc =3D 0, queued =3D req->nby=
tes;
> > +	int i, ret =3D 0;
> > +
> > +	request->req =3D &req->base;
> > +
> > +	if (req->src =3D=3D req->dst) {
> > +		nr_src =3D sg_nents_for_len(req->src, req->nbytes);
> > +		nr_dst =3D nr_src;
> > +
> > +		if (dma_map_sg(priv->dev, req->src, nr_src, DMA_BIDIRECTIONAL) <=3D =
0)
>=20
> Nit: you only need to check for zero/nonzero to determine failure
> (similarly below) - dma_map_sg() cannot return negative values.

OK.

> Bigger complaint: you should not ignore the successful return value and
> rely on it being equal to nr_src - please see the description of
> dma_map_sg() in Documenatation/DMA-API.txt

OK, I'll have a look at it and fix this.

> > +	/* command descriptors */
> > +	for_each_sg(req->src, sg, nr_src, i) {
> > +		phys_addr_t sg_phys =3D dma_to_phys(priv->dev, sg_dma_address(sg));
> > +		int len =3D sg_dma_len(sg);
>=20
> If dma_map_sg() coalesced any entries into the same mapping such that
> count < nents, these could well give bogus values toward the end of the
> list once i >=3D count(if you're lucky, at least len might be 0).

OK, I'll fix this.

> > +	/* Add a command descriptor for the cached data, if any */
> > +	if (cache_len) {
> > +		ctx->base.cache_dma =3D dma_map_single(priv->dev, req->cache,
>=20
> This is pretty dodgy, since req->cache is inside a live data structure,
> adjoining parts of which are updated whilst still mapped (the update of
> req->processed below). You just about get away without data corruption
> since we *probably* don't invalidate anything when unmapping
> DMA_TO_DEVICE, and the coherency hardware *probably* doesn't do anything
> crazy, but you've no real guarantee of that - any DMA buffer should
> really be separately kmalloced. "That's a nice dirty cache line you've
> got there, it'd be a shame if anything were to happen to it..."

OK, good to know.

> > +	rdr->base =3D dmam_alloc_coherent(priv->dev,
> > +					rdr->offset * EIP197_DEFAULT_RING_SIZE,
> > +					&rdr->base_dma, GFP_KERNEL);
> > +	if (!rdr->base) {
> > +		dmam_free_coherent(priv->dev,
> > +				   cdr->offset * EIP197_DEFAULT_RING_SIZE,
> > +				   cdr->base, cdr->base_dma);
>=20
> Returning an error here will abort your probe routine, so devres will
> clean these up there and then - there's no need to do free anything
> explicitly. That's rather the point of using devm_*() to begin with.

Sure.

> > +	dmam_free_coherent(priv->dev,
> > +			   cdr->offset * EIP197_DEFAULT_RING_SIZE,
> > +			   cdr->base, cdr->base_dma);
> > +	dmam_free_coherent(priv->dev,
> > +			   rdr->offset * EIP197_DEFAULT_RING_SIZE,
> > +			   rdr->base, rdr->base_dma);
> > +}
>=20
> Again, this is only called at device teardown, so the whole function is
> redundant.

OK, I'll remove these.

Thanks for the review!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--c3kwbi6r5oxbnufm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY9ciGAAoJEFxNi8it27zYjT0P/AtdhgwW6iC54DtM7zZ4jC/F
a1liWqzLsELwzQY0u2uYsJ8ueHYFLdEwZ4nEfdJmQmafZIg9Im6O7Y9M/ZDUodjr
6+KdvR60rNCiT0WyZ5xqug5ecXtpX2oJyjReQSqtnUJq7Hi7SpKfuipRFqxdmktS
wja+6+f5nOeost6VZrcYdr+exJQzKQDT4dvWUMnLLYHxVJ0Rt9RSHh/j+vjYuvFe
vxw5Rm6N5EKSm42uExkuECZ0+ztatyqq1M+o9EhIIpFeZU8t2xWZC5agGh4i4pRc
ZKRDvRPFWXhO3S42VstjbIQ7yYdHEfVRhoa1ihoj1IU/xCdrozZM0md5rypHiWsL
UwPDanretMms49jd/1KlgFJjUn70IvIhWEWitk6RONkeMrEzWUJ+L4hlJ8tVZ2XU
q8k0Sdxk1lc4dtwp8fYIEfpY619Gmuxj9I7vjTuaFjBdlZhr3IiNxPKDRArRTV/Z
OIMfbtTYah8be6JkhqxF8u8eYRzbST7Clx6UumdRGZqxKLeiFvDeSZA/E8ovy3FJ
aZqwLblSVIC9bHD83x+hRagaOiWE/YwYZfbwoisXjhfM6nMN+ayshHDkuM9+ynp2
xVy1nBzhTzN5BIZGZmcD6+WqGGkEk6UypENZPuQNAOldZAsQhC8Cgj16vrTfSg++
kfutymvYiJJqeEa/MSso
=OYG+
-----END PGP SIGNATURE-----

--c3kwbi6r5oxbnufm--
