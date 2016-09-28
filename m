From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 09:55:58 -0300
Message-ID: <20160928125558.GE15729@gallifrey>
References: <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
 <1597189480.51836.1475048451846.JavaMail.zimbra@redhat.com>
 <20160928122935.GA20839@gondor.apana.org.au>
 <20160928123841.GD15729@gallifrey>
 <20160928124452.GA21011@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Cc: Jan Stancek <jstancek@redhat.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34887 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbcI1M4G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 08:56:06 -0400
Received: by mail-qt0-f175.google.com with SMTP id t63so18761028qtd.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 05:56:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160928124452.GA21011@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 28, 2016 at 08:44:52PM +0800, Herbert Xu wrote:
> On Wed, Sep 28, 2016 at 09:38:41AM -0300, Marcelo Cerri wrote:
> >=20
> > The patch forces ghash-generic as the fallback. And I don't think that
> > is a big problem if we decide to go by this path.
>=20
> Right it should work but could break for example if we ever decide
> to change the exported state structure for ghash and someone unloads
> the ghash-generic module and reloads a new one.
>=20

Great! If we check the descsize every time a fallback tfm is allocated
that should be enough to prevent bigger problems such as memory
corruptions.

> > That would be nice because it would allow p8_ghash to keep using a
> > dynamic fallback, but I'm not that is viable. What do you think?
>=20
> We did it for SHA because it was desirable to have multiple
> fallbacks, i.e., a generic C version plus an assembly-optimised
> version.
>=20
> Not sure whether the same motiviation exists for GHASH.
>=20
> > > Otherwise we can go back to allocating just ghash-generic and
> > > also move its data structure into an exported header file.
> > >=20
> >=20
> > That would make the fix much more simple and it wouldn't require to get
> > the fallback descsize at runtime.
>=20
> This is the easiest fix so let's go with this now.  If we ever
> care enough to have multiple fallbacks for GHASH we can always
> revisit this.  The exported format is not exposed to user-space
> so it can always be changed.

Can I move ghash_desc_ctx to a header file under include/crypto/? Or do
you do you prefer to do that?

Maybe include/crypto/internal/hash.h or a new header file
include/crypto/internal/ghash.h ?

>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX673dAAoJEM8aS8c01e1H/cgH/13snWydL877pXR3vIqkYMux
B79Iv40IKIOFLjoSxpWC9+YJ5SsUvQysBhHgjass3un23Zbuai0JedrqCUCSXDew
d+QrjBgy8onFeM4h96jYaYpEzqM0oXzuTILzUlwb6VCw4LAjlhWsXFuig/poVm/e
UeSMQSTFVAoSSdR7gZYCcblZyr7VjjXomfmDrHU8D7TlcWvC6DBfacbHwcreI2ca
x121O5KBNQ57y5Jc1IQdQJQ8+mfIM1JQu9wdF8oosA3tDawpHR6HaDZSgmKp3+TC
8Y7u3xOC0hPaJL+g7IEkPmZaSzDEA23ZX7SHtfM4coHXPtDAVzc5tg+9GFw0FBc=
=oj0D
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
