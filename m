From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 6/8] async_tx: adding mult and sum_product flags
Date: Wed, 13 May 2015 10:45:27 +0200
Message-ID: <20150513084527.GV10961@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <1431445063-20226-7-git-send-email-maxime.ripard@free-electrons.com>
 <20150512160535.GK19927@lunn.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CSNFvL6ilyiKL/Hs"
Cc: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53543 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753450AbbEMIuF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 04:50:05 -0400
Content-Disposition: inline
In-Reply-To: <20150512160535.GK19927@lunn.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--CSNFvL6ilyiKL/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2015 at 06:05:35PM +0200, Andrew Lunn wrote:
> On Tue, May 12, 2015 at 05:37:41PM +0200, Maxime Ripard wrote:
> > From: Lior Amsalem <alior@marvell.com>
> >=20
> > Some engines (like Marvell mv_xor) do not support mult and sum_product
> > operations as part of the pq support.
> >=20
> > This patch adds new flags: DMA_PREP_PQ_MULT & DMA_PREP_PQ_SUM_PRODUCT t=
hese
> > flags helps the driver identify such operations.
> >=20
> > Signed-off-by: Lior Amsalem <alior@marvell.com>
> > Reviewed-by: Ofer Heifetz <oferh@marvell.com>
> > Reviewed-by: Nadav Haklai <nadavh@marvell.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  crypto/async_tx/async_raid6_recov.c | 4 ++--
> >  include/linux/dmaengine.h           | 4 ++++
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/asyn=
c_raid6_recov.c
> > index 934a84981495..2db5486fd873 100644
> > --- a/crypto/async_tx/async_raid6_recov.c
> > +++ b/crypto/async_tx/async_raid6_recov.c
> > @@ -47,7 +47,7 @@ async_sum_product(struct page *dest, struct page **sr=
cs, unsigned char *coef,
> >  		struct device *dev =3D dma->dev;
> >  		dma_addr_t pq[2];
> >  		struct dma_async_tx_descriptor *tx;
> > -		enum dma_ctrl_flags dma_flags =3D DMA_PREP_PQ_DISABLE_P;
> > +		enum dma_ctrl_flags dma_flags =3D DMA_PREP_PQ_DISABLE_P | DMA_PREP_P=
Q_SUM_PRODUCT;
> > =20
> >  		if (submit->flags & ASYNC_TX_FENCE)
> >  			dma_flags |=3D DMA_PREP_FENCE;
> > @@ -111,7 +111,7 @@ async_mult(struct page *dest, struct page *src, u8 =
coef, size_t len,
> >  		dma_addr_t dma_dest[2];
> >  		struct device *dev =3D dma->dev;
> >  		struct dma_async_tx_descriptor *tx;
> > -		enum dma_ctrl_flags dma_flags =3D DMA_PREP_PQ_DISABLE_P;
> > +		enum dma_ctrl_flags dma_flags =3D DMA_PREP_PQ_DISABLE_P | DMA_PREP_P=
Q_MULT;
> > =20
> >  		if (submit->flags & ASYNC_TX_FENCE)
> >  			dma_flags |=3D DMA_PREP_FENCE;
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index ad419757241f..f19ecebb4d3f 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -174,6 +174,8 @@ struct dma_interleaved_template {
> >   *  operation it continues the calculation with new sources
> >   * @DMA_PREP_FENCE - tell the driver that subsequent operations depend
> >   *  on the result of this operation
> > + * @DMA_PREP_PQ_MULT - tell the driver that this is a mult request
> > + * @DMA_PREP_PQ_SUM_PRODUCT - tell the driver that this is a sum produ=
ct request
> >   */
> >  enum dma_ctrl_flags {
> >  	DMA_PREP_INTERRUPT =3D (1 << 0),
> > @@ -182,6 +184,8 @@ enum dma_ctrl_flags {
> >  	DMA_PREP_PQ_DISABLE_Q =3D (1 << 3),
> >  	DMA_PREP_CONTINUE =3D (1 << 4),
> >  	DMA_PREP_FENCE =3D (1 << 5),
> > +	DMA_PREP_PQ_MULT =3D (1 << 10),
> > +	DMA_PREP_PQ_SUM_PRODUCT =3D (1 << 11),

None. I just forgot to change this. Thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CSNFvL6ilyiKL/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVUw8nAAoJEBx+YmzsjxAgI4gP/R7DmYIddxVc+Lgqv2OUXit1
yGmQck1cdTyluAxGfNOe+OjzIjMPreQZjyWyDh6hQ3cb3Kk56duKcshj2+pcTWKK
AzNoDg1F4CHrSKCnsZQrZdflSBANgvkQe9Mx9NWAw0CJSAFHDKkcfSA4gxxryR+6
DebtGWIGGMc586ZfA6iIQL68vqhOlk5iiGOpeVMw6j2LnUAf3nIWAGdoLlfqaevK
7w6z6QPplyhcHz3ZHioWOKCC0zDcBho0Bc8SNvMLYKeTYKtTrPYuOFU5zpcltmUL
3g8LrlCTadcw1Z5PB9EQLJl3JUAxN+EdcBVuIrKI0I8MpgOSSSnqWBejnbW77L1D
cc71d7x6I7wzW0MYgsDj45zj8lNmZ94/EfoQq3aZ9Y8/gMEGvcQTRKb0b/0Q2Arp
L7eiLRAvDwQX6fYFpIVtzIRiudWm04m4LdWZldSflcsk6dd4DLnW/Haa3NsbAG5S
EcLW1c4TKA9OhvDpdD2BRDWEjot2EbNYDv3+IoZzni4txmuk/xjiPk9A+o4wpLcO
j6GtE1tLMXB1Oekohdbe2oky6xqpV8gZP8pbMgzf6yZgigfnCc7o4MQTNP+xPhpy
2Yxns1OTdrbPJ2mqhTcV44zLzjgIkVfYPF/jO4FNwsyeVIZhmIlKHQl27nSrby6I
J3yGo92rHh9NEFiqYf0f
=bURe
-----END PGP SIGNATURE-----

--CSNFvL6ilyiKL/Hs--
