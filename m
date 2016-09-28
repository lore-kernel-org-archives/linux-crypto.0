From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 09:38:41 -0300
Message-ID: <20160928123841.GD15729@gallifrey>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
 <1597189480.51836.1475048451846.JavaMail.zimbra@redhat.com>
 <20160928122935.GA20839@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Cc: Jan Stancek <jstancek@redhat.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34964 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbcI1Mit (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 08:38:49 -0400
Received: by mail-qk0-f175.google.com with SMTP id t7so45026460qkh.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 05:38:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160928122935.GA20839@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hebert,

On Wed, Sep 28, 2016 at 08:29:35PM +0800, Herbert Xu wrote:
> On Wed, Sep 28, 2016 at 03:40:51AM -0400, Jan Stancek wrote:
> >=20
> > Thanks for clearing up how this works in padlock-sha, but
> > we are not exactly in same situation with p8_ghash.
> >=20
> > p8_ghash_init_tfm() already updates descsize. Problem in original report
> > is that without custom export/import/statesize p8_ghash_alg.statesize
> > gets initialized by shash_prepare_alg() to alg->descsize:
>=20
> Right.
>=20
> > so I think we need either:
> > 1) make sure p8_ghash_alg.descsize is correct before we register shash,
> >    this is what Marcelo's last patch is doing
>=20
> This approach doesn't work because there is no guarantee that
> you'll get the same fallback the next time you allocate a tfm.
> So relying on the descsize being constant can only work if all
> implementations of the fallback use the same desc struct.

The patch forces ghash-generic as the fallback. And I don't think that
is a big problem if we decide to go by this path.
>=20
> > 2) provide custom export/import/statesize for p8_ghash_alg
>=20
> This works for padlock-sha because every implementation of SHA
> uses the same state data structure from sha.h.  If we can make
> all implementations of ghash agree on the exported state then
> we can use the same approach.

That would be nice because it would allow p8_ghash to keep using a
dynamic fallback, but I'm not that is viable. What do you think?

>=20
> Otherwise we can go back to allocating just ghash-generic and
> also move its data structure into an exported header file.
>=20

That would make the fix much more simple and it wouldn't require to get
the fallback descsize at runtime.

> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--=20
Regards,
Marcelo

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX67nRAAoJEM8aS8c01e1HmHYIAMutcyzmlLsAa3DJGwjMFM4h
DrSs03Xr4FcryyasXB/w5xAfPU/iyfLZCjtbxEBr9C/sS8Fo+MD5IkoymwUIuq8o
QDYtIKUeSlynpUhiST3QN94fURyWqR4i5mZQSoHC3diOBaaivcpLCpAPmIHwN6jx
vMxO6TeLlvWmuMffyjxHG2q+wzXv8lzPl1it5aboPsin2PqqGTU8jjFjWf3TNi60
xKEIPWYiB2YAYpDyXFnrBVG6VrHw+XgsmaKt6dM30U7bx2x9Uczmbh8p3wXQVcoe
vsXwsA8Xn8T0DRd5qHqzbekivJ4VJGFofkUzS3FKNjFAgiOX0mOSSeVDy+a8/3M=
=Vznd
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--
