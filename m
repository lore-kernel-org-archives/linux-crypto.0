From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC 07/11] crypto: caam: check and use dma_map_sg()
 return code
Date: Wed, 9 Dec 2015 18:31:32 +0000
Message-ID: <20151209183132.GK8644@n2100.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
 <E1a61D4-0007ms-UR@rmk-PC.arm.linux.org.uk>
 <566846CD.1020607@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37855 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbbLISbm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 13:31:42 -0500
Content-Disposition: inline
In-Reply-To: <566846CD.1020607@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 05:20:45PM +0200, Horia Geant=C4=83 wrote:
> On 12/7/2015 9:12 PM, Russell King wrote:
> > Strictly, dma_map_sg() may coalesce SG entries, but in practise on =
iMX
> > hardware, this will never happen.  However, dma_map_sg() can fail, =
and
> > we completely fail to check its return value.  So, fix this properl=
y.
> >=20
> > Arrange the code to map the scatterlist early, so we know how many
> > scatter table entries to allocate, and then fill them in.  This all=
ows
> > us to keep relatively simple error cleanup paths.
> >=20
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>=20
> Some tcrypt tests fail - looks like those with zero plaintext:
> caam_jr ffe301000.jr: unable to map source for DMA
> alg: hash: digest failed on test 1 for sha1-caam: ret=3D12
> [...]
>=20
> Need to be careful, dma_map_sg() returning zero is an error only if p=
txt
> is not null (alternatively src_nents returned by sg_nents_for_len()
> could be checked).
>=20
> > @@ -1091,7 +1102,7 @@ static int ahash_digest(struct ahash_request =
*req)
> >  	u32 *sh_desc =3D ctx->sh_desc_digest, *desc;
> >  	dma_addr_t ptr =3D ctx->sh_desc_digest_dma;
> >  	int digestsize =3D crypto_ahash_digestsize(ahash);
> > -	int src_nents, sec4_sg_bytes;
> > +	int src_nents, mapped_nents, sec4_sg_bytes;
> >  	dma_addr_t src_dma;
> >  	struct ahash_edesc *edesc;
> >  	int ret =3D 0;
> > @@ -1099,9 +1110,14 @@ static int ahash_digest(struct ahash_request=
 *req)
> >  	int sh_len;
> > =20
> >  	src_nents =3D sg_nents_for_len(req->src, req->nbytes);
> > -	dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
> > -	if (src_nents > 1)
> > -		sec4_sg_bytes =3D src_nents * sizeof(struct sec4_sg_entry);
> > +	mapped_nents =3D dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DE=
VICE);
> > +	if (mapped_nents =3D=3D 0) {
> > +		dev_err(jrdev, "unable to map source for DMA\n");
> > +		return -ENOMEM;
> > +	}
>=20
> This is at least one of the places where the error condition must cha=
nge
> to smth. like (src_nents !=3D 0 && mapped_nents =3D=3D 0).

I guess we should avoid calling dma_map_sg() and dma_unmap_sg() when
src_nents is zero.  Thanks, I'll work that into the next patch revision=
=2E

--=20
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
=46TTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
