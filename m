From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 4/7] arm64: marvell: dts: add crypto engine description
 for 7k/8k
Date: Tue, 18 Apr 2017 09:34:18 +0200
Message-ID: <20170418073418.tpgg7i27uigatddu@kwain>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
 <20170329124432.27457-5-antoine.tenart@free-electrons.com>
 <20170412105608.41501b63@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6917686420323071512=="
Cc: andrew@lunn.ch, herbert@gondor.apana.org.au,
 boris.brezillon@free-electrons.com, igall@marvell.com,
 Antoine Tenart <antoine.tenart@free-electrons.com>, oferh@marvell.com,
 nadavh@marvell.com, linux-crypto@vger.kernel.org,
 gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com,
 davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
 jason@lakedaemon.net
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170412105608.41501b63@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org


--===============6917686420323071512==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dpjtucoqyjtczpw6"
Content-Disposition: inline


--dpjtucoqyjtczpw6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Wed, Apr 12, 2017 at 10:56:08AM +0200, Thomas Petazzoni wrote:
> On Wed, 29 Mar 2017 14:44:29 +0200, Antoine Tenart wrote:
>=20
> > +			cpm_crypto: crypto@800000 {
> > +				compatible =3D "inside-secure,safexcel-eip197";
> > +				reg =3D <0x800000 0x200000>;
> > +				interrupts =3D <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_=
HIGH)>,
>=20
> Now that I look into this, does it makes sense for an interrupt to be
> both an edge interrupt and a level interrupt at the same time? This
> looks odd.

I agree this looks odd. I took it from Russel's ICU mapping:
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-February/489040.=
html

Also note the driver does not use it (yet?).

Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--dpjtucoqyjtczpw6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY9cF4AAoJEFxNi8it27zYZa4QAIrpdtjcxXhkA8+MPoe285at
DcZxdSufidlS5tc8L6H/qn/0DYFu/5Ec9OsmQZswaR53hUEPYlyAcuBdOILwuEEv
rjQHK6a2bQCZKo1DhMso/F/lwu6tppqISQBWEHdY0M+vfkXyRHsZWrSG11GItYqp
4U4nFfGkVApLHwbdjgecIPu1XlkqXyTYQtglkSMUssrBNQkKkP9D1vrLIFPHJF7K
HT8TNvs0R8yEe7zhMry+c+02+Ja1MehAqwSH3qFyM5hrGVpj63P+xb5Luu0d1GbJ
ijXsVDsuxr1h0QVFq6XqPfTa8w40HXOmZtsVKIaXAGv6BsKft1Ltb6mjjrk6OWO3
aCl7/l/kHJQnUkl3m/euoe0c2qkbhhKsOy/bLMQKeD3tbfXMWQlj12apcCFprez2
+0uHgRKKvTzrjflDvSdxZyLH8xmISFS80SHeKMGYzfo9TjUfInSMiADF49+9fDzb
K8r5kx8YshCDJFGos5sfYcgYrRzMPvMVU2Bh7t3mPOPYht1MiBVxDR+oV9Ilhq+O
Tmf7JzlSIbQIlwwfFsjd1pAAoHozxN6wTEa5ALR1b9euGK421wXKRL/Bw0t6AtUO
5IEU27KobwdOjjJNbpkSBpq85fEWUPLQwCXtA1HNtN63Lq7U9OtON9nzOP7mms/4
qGNRHzZZVhA2NK7MyO5g
=q+9q
-----END PGP SIGNATURE-----

--dpjtucoqyjtczpw6--


--===============6917686420323071512==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============6917686420323071512==--
