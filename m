From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Mon, 3 Oct 2016 09:08:35 -0300
Message-ID: <20161003120835.GA10133@gallifrey>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
 <20160929065908.653ec5c2@kryten>
 <20161002144047.GG18268@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Cc: Anton Blanchard <anton@samba.org>, linux-crypto@vger.kernel.org,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        George Wilson <gcwilson@us.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161002144047.GG18268@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thank you.

--=20
Regards,
Marcelo

On Sun, Oct 02, 2016 at 10:40:47PM +0800, Herbert Xu wrote:
> On Thu, Sep 29, 2016 at 06:59:08AM +1000, Anton Blanchard wrote:
> > Hi Marcelo
> >=20
> > > This series fixes the memory corruption found by Jan Stancek in
> > > 4.8-rc7. The problem however also affects previous versions of the
> > > driver.
> >=20
> > If it affects previous versions, please add the lines in the sign off to
> > get it into the stable kernels.
>=20
> I have added them to patches 1 and 2.  Thanks.
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX8kpDAAoJEM8aS8c01e1HzKIH/2KZ33BTs6CedA1TllgLIy0u
go9pOUEObPuC7QRsYLePQhO+zT5qKc4Jp+XIj4JefWaSaMbhuPfCe8SqdCt37IzF
p8tR295srt2C2Wj6g78emq3zmOtF7ILUTsbyXgsOcIemtyzcrOOJk5ZDJBRXwwqr
kUGRIqKZb3BF6+lKC95xguEzNQRW+hOhmADQ5Wy46cjnsnEr0RqyJyJDE2c/c6OM
G0j/zrplPYQfgfa6gbe4uTK243Wi4FZAd8pgsoWEo1Zbj3I7reUScb3SjBqGtuEi
JjvB40AeY9faY38OEkN2njYuOB0fSC5RUxex/i5XHJBpzYHhl18fKa0yNgj5Qns=
=h4R7
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
