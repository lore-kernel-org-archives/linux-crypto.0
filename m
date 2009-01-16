From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH crypto -v4 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 16 Jan 2009 09:20:58 +0800
Message-ID: <1232068858.5937.222.camel@yhuang-dev.sh.intel.com>
References: <1232008119.5937.200.camel@yhuang-dev.sh.intel.com>
	 <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vMIvOK/mBmWMve5sk/UB"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: roel kluin <roel.kluin@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29486 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759594AbZAPBVB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 20:21:01 -0500
In-Reply-To: <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-vMIvOK/mBmWMve5sk/UB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 17:47 +0800, roel kluin wrote:
> Sorry to bother,
>=20
> > +static int ecb_encrypt(struct blkcipher_desc *desc,
> > +                      struct scatterlist *dst, struct scatterlist *src=
,
> > +                      unsigned int nbytes)
> > +{
> > +       struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_blkcipher_ctx(des=
c->tfm));
> > +       struct blkcipher_walk walk;
> > +       int err;
> > +
> > +       blkcipher_walk_init(&walk, dst, src, nbytes);
> > +       err =3D blkcipher_walk_virt(desc, &walk);
> > +
> > +       kernel_fpu_begin();
> > +       while ((nbytes =3D walk.nbytes)) {
> > +               aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.ad=
dr,
> > +                             nbytes & AES_BLOCK_MASK);
> > +               nbytes &=3D AES_BLOCK_SIZE - 1;
> > +               err =3D blkcipher_walk_done(desc, &walk, nbytes);
> > +       }
> > +       kernel_fpu_end();
> > +
> > +       return err;
> > +}
>=20
> if blkcipher_walk_{virt,done} returns an error, don't we have to break
> out of the loop?
> i.e.
>=20
> while (!err && (nbytes =3D walk.nbytes))
>=20
> (if that's erroneous, it occurs in other places as well)

It seems that it is a bug.

But it seems that the similar code in geode-aes.c and padlock-aes.c has
same bug. I think we should fix them too.

Best Regards,
Huang Ying


--=-vMIvOK/mBmWMve5sk/UB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklv4PcACgkQKhFGF+eHlpjVMgCghmO+C8bGtYbR2Kl2XXyBemeb
MWkAnim3SAoUya0YLsQQRE+pk2WBm0Ze
=TdQV
-----END PGP SIGNATURE-----

--=-vMIvOK/mBmWMve5sk/UB--

