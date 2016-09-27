From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Tue, 27 Sep 2016 09:04:14 -0300
Message-ID: <20160927120414.GC21317@gallifrey>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:33552 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932356AbcI0MEV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 08:04:21 -0400
Received: by mail-qt0-f176.google.com with SMTP id 11so5826583qtc.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2016 05:04:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 27, 2016 at 05:01:03AM -0400, Jan Stancek wrote:
> So, if we extended p8_ghash_desc_ctx to accommodate fallback_desc's ctx
> and then provided statesize/import/export, would that be acceptable?
>=20
> struct p8_ghash_desc_ctx {
>         ...
>         struct shash_desc fallback_desc;
> +       char fallback_ctx[sizeof(struct ghash_desc_ctx)];
>=20

I think so. That's the solution mentioned by Herbert. The only drawback
is that we will need to fix "ghash-generic" as the fallback
implementation in order to know beforehand its descsize.

However I would keep the p8_ghash_desc_ctx the way it is and I would
sum sizeof(struct ghash_desc_ctx) to the algorithm descsize instead.

Let me put a quick patch together to test this.

>=20
> Also, does that mean that padlock_sha has similar problem?
> It does not seem to reserve any space for fallback __ctx and it calls
> init()/update()/export() with padlock_sha_desc's fallback:
>=20
> struct padlock_sha_desc {
>         struct shash_desc fallback;
> };
>=20
> static struct shash_alg sha1_alg =3D {
>         .descsize       =3D       sizeof(struct padlock_sha_desc),
>=20

Yeah. It still seems to me that padlock-sha has the same problem. Maybe
we are missing something...

--
Regards,
Marcelo

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX6mA+AAoJEM8aS8c01e1H5hgH/1Mx/FlZMI0Hc/skXsA70u7T
0RVgQ+7+G+z7ts4S6KDAm8VjXF3McTTs7srSOUZu34AUnc0rjwdK9+O4SKHCXpSn
fKHgcF+Qze9pudqRsTGWQJogIRtGBxG8vlbkW9jWNI2yps8HKNTAQgEN2F8dSrYf
ZSWmRAaxgs85zxG716+2AJs6KYFv3nWixRgZW7kii+HUHGSkRLyu5Z5fPXe1SuNA
rTLr5YnMCg1tA3plEIEGOPjZfE0Cr9oovdvC+Dj2j01N0nehSBPNYI8QfmITYvQ3
z9Im8I4hFRn/8duIJvMOazd6Pc269YNrAVGX+YgVoKcOE9VvgNJWx6jHlhSGEog=
=ZZ+X
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
