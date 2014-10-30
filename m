From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Thu, 30 Oct 2014 18:19:33 +0100
Message-ID: <20141030171933.GR21251@lukather>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxNrNKeE/ptr8Zbn"
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
	joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRBRHGZGRAKGQEFCLA4QY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <544A9FEA.6020304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org


--wxNrNKeE/ptr8Zbn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 08:52:26PM +0200, Corentin LABBE wrote:
> On 10/21/14 21:11, Maxime Ripard wrote:
> > Hi Corentin,
> >=20
> > Thanks for resending it.
> >=20
> > On Sun, Oct 19, 2014 at 04:16:22PM +0200, LABBE Corentin wrote:
> >> Add support for the Security System included in Allwinner SoC A20.
> >> The Security System is a hardware cryptographic accelerator that suppo=
rt AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> >>
> >> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  drivers/crypto/Kconfig                    |  17 ++
> >> +static int sunxi_ss_aes_poll_atomic(struct ablkcipher_request *areq)
> >> +{
> >> +	u32 spaces;
> >> +	struct scatterlist *in_sg =3D areq->src;
> >> +	struct scatterlist *out_sg =3D areq->dst;
> >> +	void *src_addr;
> >> +	void *dst_addr;
> >> +	unsigned int ileft =3D areq->nbytes;
> >> +	unsigned int oleft =3D areq->nbytes;
> >> +	unsigned int todo;
> >> +	u32 *src32;
> >> +	u32 *dst32;
> >> +	u32 rx_cnt =3D 32;
> >> +	u32 tx_cnt =3D 0;
> >> +	int i;
> >> +
> >> +	src_addr =3D kmap_atomic(sg_page(in_sg)) + in_sg->offset;
> >=20
> > Where does this scatter_list is coming from? Can it even be allocated
> > in highmem?
> >=20
>=20
> With AF_ALG and cryptodev, the SG is in highmem. Verified with some
> PageHighMem().

Then fix AF_ALG and cryptodev, because all of the other drivers might
be affected.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wxNrNKeE/ptr8Zbn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUnMlAAoJEBx+YmzsjxAgL04P/3wLU5wri3bag19jOZt/ZcaX
y8p8EO0EGheG0mogxwjuVDmTW31RyYstrkgOivMAGy6WRabHSE0Lv0OcZsvplkxH
ivx07+9ZNE5A+LjIy6P8slgp64AAuzdtCh0cb4EUAQmN7G3O544qL20H3poK95Gi
xuFxoGatMz43WNDYA6Hhh+h7lX3VbIo8Qt8+ccHyttw7jdIld+gmadd27L/ySDx9
rJKhQuxuh9OB7k7BplujlZCf0TXKAAmBmRm17qzI+pA2SUMoKR/U70X1qoOqhj4y
jfis4Dd2UCGW+u0SWnx1+WrJKF4YbAapkeviO+dFZ4E+5C1kI+/JWPcAmnobCYXU
41b9KA3aNecnbeMuxUS4xNFdD+GFzPXIhwRN9DyEgRdZbR2f/IArlcyIiUbN2uIJ
d10g/KNL+V8vMISHJlEVdWjoMf3CtWIbl/6CJ3gZgUdGhkHjWicdATYdbBvYa739
N6LAWS2gEvh5jhSqey4pGuEotril3LeZsEVjB0pQy362IEsctPaH0IysXZgppfO7
a0neWUaQZemjXvp1PFLAhSBNUFLC2jT1b/sunS2T7Z3zQkdTzPzd5rHjtRMEB6qN
1h4Z5ujd3gsuMUAAn82Wf8N3C7AIg9KMu9CubjOdf+9z920E/n74n93LBT7KFw1n
yKV0dorV+2ex/2fNBxtT
=C1Uz
-----END PGP SIGNATURE-----

--wxNrNKeE/ptr8Zbn--
