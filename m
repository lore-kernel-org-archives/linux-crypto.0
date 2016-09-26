From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Mon, 26 Sep 2016 14:43:17 -0300
Message-ID: <20160926174317.GA21317@gallifrey>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Cc: Jan Stancek <jstancek@redhat.com>, rui.y.wang@intel.com,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34779 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034478AbcIZRnX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 13:43:23 -0400
Received: by mail-qk0-f175.google.com with SMTP id n185so172423476qke.1
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2016 10:43:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160926145934.GA5520@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Herbert,

Wouldn't be enough to provide a pair of import/export functions as the
padlock-sha driver does?

--=20
Regards,
Marcelo

On Mon, Sep 26, 2016 at 10:59:34PM +0800, Herbert Xu wrote:
> On Fri, Sep 23, 2016 at 08:22:27PM -0400, Jan Stancek wrote:
> >
> > This seems to directly correspond with:
> >   p8_ghash_alg.descsize =3D sizeof(struct p8_ghash_desc_ctx) =3D=3D 56
> >   shash_tfm->descsize =3D sizeof(struct p8_ghash_desc_ctx) + crypto_sha=
sh_descsize(fallback) =3D=3D 56 + 20
> > where 20 is presumably coming from "ghash_alg.descsize".
> >=20
> > My gut feeling was that these 2 should match, but I'd love to hear
> > what crypto people think.
>=20
> Indeed.  The vmx driver is broken.  It is allocating a fallback
> but is not providing any space for the state of the fallback.
>=20
> Unfortunately our interface doesn't really provide a way to provide
> the state size dynamically.  So what I'd suggest is to fix the
> fallback to the generic ghash implementation and export its state
> size like we do for md5/sha.
>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX6V41AAoJEM8aS8c01e1H6mwIAMW9pypR4X11IG2iRz0Mci2S
irMDyO2x8MWtdlHGB7LVKq/Lo/t1mDCtbSzKO8LnhzyucVzTQtKOsQU3TAxeozZE
TCInKB6DRpd06pW+nEAN7omvYnHNyJX9ELxKAUTl1nTub1ftimYOY/yfKa0veyHK
tRd3GSbdQCpoiXNR0PFW9j/9MUW7XC/V1vCxnhBJHYo3OygRPtLDSVeloLbeLQKo
CBz++OIU6bzKIxH7aIfLCvZEWgQCc4L5XzXShxIIDY0EnLkn6/UjN7zjAHXXFGcl
HECy+yTuhJJGgPX6RuPnKFUwfru5YZ4K5gQQ6gp0XhOj+v+w4QEb9ZUdqSiok8c=
=DS2v
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
