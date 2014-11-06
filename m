From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Thu, 6 Nov 2014 15:26:33 +0100
Message-ID: <20141106142633.GK2989@lukather>
References: <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
 <20141031100522.GA8655@gondor.apana.org.au>
 <20141103093446.GG11263@lukather>
 <20141103103528.GA30154@gondor.apana.org.au>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JvUS8mwutKMHKosv"
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
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRB3UL52RAKGQEK3MT2WQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141103103528.GA30154-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org


--JvUS8mwutKMHKosv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 06:35:28PM +0800, Herbert Xu wrote:
> On Mon, Nov 03, 2014 at 10:34:46AM +0100, Maxime Ripard wrote:
> > What I mean is that since you are saying that drivers should do the
> > kmap themselves, then *all* of the drivers are broken if they are not
> > using it. And all of them are missing this kmap.
>=20
> kmap is used by the software implementations to map the input/output
> into virtual address space.  Drivers typically use DMA and operate
> on physical addresses so they don't need kmap.

Yes, plus all memory allocated with GFP_KERNEL is in lowmem.

But you still haven't explain why the driver, while it doesn't handle
the user space buffer at any time, should be worried that the data the
framework has given him are actually mapped.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JvUS8mwutKMHKosv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW4UZAAoJEBx+YmzsjxAgDMcP/1PI8AbGVPKn44oM9vlitRY2
zkR4bqd8Ka52kpPFiDzz8BMFjYXyLYxGZRydtAk78XM5WZy0diY5raC8TmU/nWVP
oWjWlPbj9xmHTuUXhawzw71uSfNSAqyDaXGPGBDCovgi7Y5XD9mZmybDx9xqY73V
FNNXyTmmkX+mn3i8pPMVzgPjWS/eWhs6zt3Sy8I8aI6BU+lnUmJAhutCX+F8+XX1
klD7+KQ1ABwaXed1nj3cHYx4pzDfqsCVx04GSuHD0DmLT5/bEv0WYM54kQ2gmXKy
2748Ec7hd07IH0ybcEXYQYCEV0hokF4udABo4XZpp8sqdz+O1jaYW7BLbGco8//g
P+4wlHvHYMMNgqaKZHT9cBNKdB1pHP8iAaYlF3Gk4ekHZWq5K5sSRb8Z0elBJf/m
Wk+XptdoX6Egrxg9O9wj9Ph29s5uDaLEP6Xtm6tmRjynSPWQqf3WEPuIGihD7CCP
7GPZ40LRUXK+9u7DxeBqZPAFBomtRQ1MEhTFjWNQV4wLFPxAEb752s5B8mETwJoo
bqgD60RLVU1FT35VCpnZMcj9tgudR5cZ7O/TzeimUQsDgReix5CWCd25JKU5K8tR
b/d2BIIa9iok6mttNXqCabQeROEdSPnUCDkGX8Ur4EBCwg0vhSOZzFnyPgYZ9vUH
udGNo+6MjczuQVcXdlHu
=AyfL
-----END PGP SIGNATURE-----

--JvUS8mwutKMHKosv--
