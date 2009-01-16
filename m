From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH crypto -v4 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 16 Jan 2009 10:37:02 +0800
Message-ID: <1232073422.13948.3.camel@yhuang-dev.sh.intel.com>
References: <1232008119.5937.200.camel@yhuang-dev.sh.intel.com>
	 <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com>
	 <1232068858.5937.222.camel@yhuang-dev.sh.intel.com>
	 <20090116015356.GA9822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dnnTInnrSLItRgHTp1M3"
Cc: roel kluin <roel.kluin@gmail.com>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbZAPChE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 21:37:04 -0500
In-Reply-To: <20090116015356.GA9822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-dnnTInnrSLItRgHTp1M3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 09:53 +0800, Herbert Xu wrote:
> On Fri, Jan 16, 2009 at 09:20:58AM +0800, Huang Ying wrote:
> > On Thu, 2009-01-15 at 17:47 +0800, roel kluin wrote:
> >
> > > > +       kernel_fpu_begin();
> > > > +       while ((nbytes =3D walk.nbytes)) {
> > > > +               aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.vir=
t.addr,
> > > > +                             nbytes & AES_BLOCK_MASK);
> > > > +               nbytes &=3D AES_BLOCK_SIZE - 1;
> > > > +               err =3D blkcipher_walk_done(desc, &walk, nbytes);
> > > > +       }
> > > > +       kernel_fpu_end();
> > > > +
> > > > +       return err;
> > > > +}
> > >=20
> > > if blkcipher_walk_{virt,done} returns an error, don't we have to brea=
k
> > > out of the loop?
> > > i.e.
> > >=20
> > > while (!err && (nbytes =3D walk.nbytes))
> > >=20
> > > (if that's erroneous, it occurs in other places as well)
>=20
> That's not necessary because blkcipher_walk_done will ensure
> that walk.nbytes =3D=3D 0 if there is an error.

But after checking blkcipher_walk_done() in 2.6.28, If input argument
err !=3D 0 and walk->flags & BLKCIPHER_WALK_SLOW !=3D 0, when
blkcipher_walk_done() return non-zero, walk->nbytes !=3D 0. So I think it
is a little fragile to use walk->nbytes =3D=3D 0 indicate error.

int blkcipher_walk_done(struct blkcipher_desc *desc,
                        struct blkcipher_walk *walk, int err)
{
        struct crypto_blkcipher *tfm =3D desc->tfm;
        unsigned int nbytes =3D 0;

        if (likely(err >=3D 0)) {
                unsigned int n =3D walk->nbytes - err;

                if (likely(!(walk->flags & BLKCIPHER_WALK_SLOW)))
                        n =3D blkcipher_done_fast(walk, n);
                else if (WARN_ON(err)) {
                        err =3D -EINVAL;
                        goto err;
                } else
                        n =3D blkcipher_done_slow(tfm, walk, n);

                nbytes =3D walk->total - n;
                err =3D 0;
        }

        scatterwalk_done(&walk->in, 0, nbytes);
        scatterwalk_done(&walk->out, 1, nbytes);

        walk->total =3D nbytes;
        walk->nbytes =3D nbytes;

        if (nbytes) {
                crypto_yield(desc->flags);
                return blkcipher_walk_next(desc, walk);
        }

err:
        if (walk->iv !=3D desc->info)
                memcpy(desc->info, walk->iv, crypto_blkcipher_ivsize(tfm));
        if (walk->buffer !=3D walk->page)
                kfree(walk->buffer);
        if (walk->page)
                free_page((unsigned long)walk->page);

        return err;
}

Best Regards,
Huang Ying


--=-dnnTInnrSLItRgHTp1M3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklv8ssACgkQKhFGF+eHlpjOygCgnZuYT7QNMMl15UqATpV8gIiN
gfsAnA3qxwVDxxgaxIMcxYYdOhwVV2w5
=ocqV
-----END PGP SIGNATURE-----

--=-dnnTInnrSLItRgHTp1M3--

