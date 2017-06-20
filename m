From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v6 1/5] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Tue, 20 Jun 2017 08:21:24 +0200
Message-ID: <20170620062124.GA14254@kwain>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
 <20170524141035.21031-2-antoine.tenart@free-electrons.com>
 <20170611085353.GG31464@kwain>
 <20170620033747.GB17764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        davem@davemloft.net, jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:38455 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbdFTGV1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 02:21:27 -0400
Content-Disposition: inline
In-Reply-To: <20170620033747.GB17764@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2017 at 11:37:47AM +0800, Herbert Xu wrote:
> On Sun, Jun 11, 2017 at 10:53:53AM +0200, Antoine Tenart wrote:
> > On Wed, May 24, 2017 at 04:10:31PM +0200, Antoine Tenart wrote:
> > > The Inside Secure Safexcel cryptographic engine is found on some Marv=
ell
> > > SoCs (7k/8k). Document the bindings used by its driver.
> > >=20
> > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> >=20
> > Since you applied the Safexcel crypto driver patch, I think you should
> > also apply this patch adding the corresponding bindings documentation.
>=20
> OK I've restored it in the patch queue.

Thanks!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZSL7iAAoJEFxNi8it27zYdLYP/2staQ3rpYIm2LxZndDbVhJs
GfQjJoFO19kkToHDNSTyuchfdpCthsYXAFmKAdteipx8NEvb0Un1yF1n0g06YCTM
OdkHWmoQOqucNmEZFttaUfyzY125f5XgQC1FYGOG8iV+KxAaBXgOXNTtOhLdTxc/
C4nKK/1zmha3xXPGhqTAuUxViux0rCCrnZm/b63SmOR5eVDqZtm/Evhi2hpAAnY6
RHifaAL9jcJrIXGWEyr7f7UqTc/9AtRhl2Nz1W4h1z7i0JMohfxL5FQpD5VteNYE
UsSVEHegeIE/sA+hy7kH8kZ15ASqwJx3mI/tkn9AsLOKBqU+t7I3AW3L7BDgqdC2
96+MkOjY5djTv+/jLnSDwQmAoE4BR687fhvy9+C1cRHJ59wefBsPpyxS9pUp9s66
TrKddUKNxbwQGkcigQ8cIAtThF7YPNxkYebfen8MNG/lp518LYB9AZ/IvNDpEQUj
mmbWcp1PH1h4SV81QAjQH4JrSrIKgX2ecdmcb/+k9VleDpLDjY0R6FPwePCyTXsr
q7G7O2CWbw2W67Shct9be0DJc/wXjtlo1oWOu5097IsVUynSCIf5GD+/JQYQqkmD
BFf+ZYPmXASSKd5sctmuFC9h4VkCGzU7B8ms+IrKMFNumIyrGF11XggXyRoYn3IP
3WNzhmR7OD3RGHuTqZa/
=adVM
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
