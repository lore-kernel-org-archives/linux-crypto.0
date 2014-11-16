From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sun, 16 Nov 2014 18:13:14 +0100
Message-ID: <20141116171314.GN6414@lukather>
References: <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
 <20141031100522.GA8655@gondor.apana.org.au>
 <20141103093446.GG11263@lukather>
 <20141103103528.GA30154@gondor.apana.org.au>
 <20141106142633.GK2989@lukather>
 <20141106143217.GA3636@gondor.apana.org.au>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+utxuhC6KVTvgNz"
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
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRBF5XUORQKGQEKGBTT7I-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141106143217.GA3636-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org


--m+utxuhC6KVTvgNz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 10:32:18PM +0800, Herbert Xu wrote:
> On Thu, Nov 06, 2014 at 03:26:33PM +0100, Maxime Ripard wrote:
> >=20
> > But you still haven't explain why the driver, while it doesn't handle
> > the user space buffer at any time, should be worried that the data the
> > framework has given him are actually mapped.
>=20
> Encryption is used by IPsec and SKBs can be allocated in highmem.
> algif also exposes all ciphers to user-space memory which can also
> be in highmem.

Ok. We keep going in circles here.

I know that algif handles userspace memory that can be in
highmem. What I don't get, is that just like a *driver* doesn't have
to call copy_from_user, why would it need to call kmap...

That's something that should be in the framework itself, not the
driver. And the argument that most drivers use DMA seems like a broken
assumption.

But hey, you're the one that will maintain this mess, so I guess you
have the final word.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--m+utxuhC6KVTvgNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUaNsqAAoJEBx+YmzsjxAg9vgP+IU8hDK3gJJOytYQo3W3a15a
uhIELk8oJwM13juoNz2ZofzzuuO1ZKyy3vxMl+qnFdcsJvz3eAkMmLF/0D0HXlwC
ORafGw/BIzF9zoUSl99SliSaPsshtbKGS0itpiswbXpvfkFotnDuSwFckVCbhN/K
ez/Jc/uH6LsviGOEzpTa506ISXwpAxE+QpG7e/bcUDxUN66j0Xhz7e9eGhMSQXGu
z494yGS75QB6K1aI/ckaWTZFMhQJCF/5eOCbV/nwG3942xHx5LzB7m6bvo4wKEMR
G10q7FA+SwkKqSdCn+nw7k67Zyt5LWnHk58IdyUUUgoeLYmkdGO5t/kkMtfRA8Ou
lBFR0qDJvNn0x/Xh7szkVqKOeXH/jArk4HHBkJ2frH1HYdIbVwzZk+Zfk/ckm4dX
75JigGIJvMYVDA9+k6Xy+C3yYgPDp9PJYqcqaXQHWxGGIkk9zqPz8qTPKz0NPCX+
IMV19Hb/wlfbTcnNewFqsYwo6wMU+v18odZYkzfEpbywwfpRztHV0NOdCACGa6W3
8ciE+ctUXlulfqAVrSkUPvHQYpsZTaEueVhJI89yiBG9kJTe770dultEH7DjVyRW
ZwpXZglNMhZU2C5o5NOZyMIVOmeGbVSQPTnIFTbPeaem3KyYA43YLH4jt3TVAr19
AxGnRmvnanGdskF7UX4=
=tuhn
-----END PGP SIGNATURE-----

--m+utxuhC6KVTvgNz--
