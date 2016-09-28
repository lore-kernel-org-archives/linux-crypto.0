From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Wed, 28 Sep 2016 10:27:18 -0300
Message-ID: <20160928132718.GB31082@gallifrey>
References: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com>
 <20160928131551.GA31082@gallifrey>
 <20160928132015.GA21312@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com, "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160928132015.GA21312@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 28, 2016 at 09:20:15PM +0800, Herbert Xu wrote:
> On Wed, Sep 28, 2016 at 10:15:51AM -0300, Marcelo Cerri wrote:
> > Hi Herbert,
> >=20
> > Any thoughts on this one?
>=20
> Can this patch wait until the next merge window? On the broken
> platforms it should just fail the self-test, right?

Yes. It fails on any LE platform (including Ubuntu and RHEL 7.1).

>=20
> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--=20
Regards,
Marcelo

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX68U2AAoJEM8aS8c01e1H0MUH/2nf3eofIx0lT9mTlX5O6Gzo
P91inis1p8gNy7EpJDdEZWfV+fQXAZqS9Vt2aT2QLyWla2ZdwV5cF0MGEmWR60Vb
BtPnVT3bkg0ZAErw5NAMDwIBlX+8jde8l9pk8Gg66dV1k3p6pH0dyAO3dZZnw2ZM
gpw25O1DrpSKz8rZjdUVgPc7KBDEyDmKvoHrzTVwvaFe7QzkOZtm0mWjXIV2N3vO
qC5J8IEi0f6v2KfYfEuaAhK2lFhBKq4iz2/g2j9Efo0H9BnIcb/u0bTg4jm1/rWx
nOQFQbqakfAQRTvGlxh659vpvP/dywwll6D+m2wfZg5Zm4Hz9UNp3SSCaZejalw=
=oKXY
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
