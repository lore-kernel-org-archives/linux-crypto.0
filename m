From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Mon, 3 Nov 2014 10:34:46 +0100
Message-ID: <20141103093446.GG11263@lukather>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
 <20141031100522.GA8655@gondor.apana.org.au>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Cc: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org,
	mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRBR4Y3WRAKGQEOVYCCTA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141031100522.GA8655-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 06:05:22PM +0800, Herbert Xu wrote:
> On Fri, Oct 31, 2014 at 10:57:06AM +0100, Maxime Ripard wrote:
> >
> > On a 3.18-rc2 kernel:
> >=20
> > $ git grep kmap -- crypto/
> > crypto/ahash.c:                         walk->data =3D kmap(walk->pg);
> > crypto/ahash.c:                         walk->data =3D kmap_atomic(walk=
->pg);
> > crypto/async_tx/async_memcpy.c:         dest_buf =3D kmap_atomic(dest) =
+ dest_offset;
> > crypto/async_tx/async_memcpy.c:         src_buf =3D kmap_atomic(src) + =
src_offset;
> > crypto/scatterwalk.c:                   return kmap_atomic(scatterwalk_=
page(walk)) +
> > crypto/shash.c:                         data =3D kmap_atomic(sg_page(sg=
));
> > crypto/shash.c:                         data =3D kmap_atomic(sg_page(sg=
));
> >=20
> > None of the drivers are.
>=20
> What do you mean? It's precisely because the page can be in highmem
> that we are mapping it.  If it's not in highmem it'll be a noop.

What I mean is that since you are saying that drivers should do the
kmap themselves, then *all* of the drivers are broken if they are not
using it. And all of them are missing this kmap.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV0w2AAoJEBx+YmzsjxAg/zUP/RYiTHvBw1aa+/lHomPgAEs0
OQVMt3GAKLK72eym+H4kee7Xkx4X+dA7JhArMKSsm6w7NnTFn/SeUqcAzEhn6eKh
GpKkjgfwDDwfBvM9ayeimQuKsPmBTHLCuQVmehcD3c9WzTTaWIMHekbN0cztRUM0
WfKmrOiclBuBYWHyQr22ZuXptSN95RdAqpG4VNUSl47zQztaJEg1iO5Rb6JbVug9
7FheB4BnXtlok95X1IfP58i0rAiqFzX1LaTa7nhUo14GZ1EnQH+aVRg00q2PtwBy
kWFYn2wWY4SD4dG/TrSeJVfwt4pari2wkjDaS6iSdHK/xpDXh9yZQlsh3NSxsfUy
010tvNr45DYPlpRFzPHrhm952AXjbHwJgKnMgrt1zDtFTBBt9jOd4xKMpsX6v3on
0VtzSSjaZD2Ro6bFan/l4/Co0d0G/NNqqt9swxdMw80Zfy6hVs75Lr5KlOD8Oyey
HZUi9CAhloqbM+q+4tNfTMxYufcLjpYPPLRrXSNZOE7BaZuidW8Q8qqDUElE16ys
Lq72scAikcsveNGt2uTdfwr9Jgx15BN+TQRL2Lr4Tf/bxxp5O2TSIRf7uQrbZB5J
Y1QWwDweprX3ry3+l/yHqu0FxGO8bFv+oqONl3GpD+xYGrgs0iakM7oQwLIOV7eM
Zc/q99AwyNzJ0LXg2XeO
=8cj2
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
