From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Fri, 12 Dec 2014 05:20:49 +0000
Message-ID: <1418361649.3599.83.camel@decadent.org.uk>
References: <5460987C.9030007@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JyqJ/o/sNmZTScvz15nP"
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au,
	gmazyland@gmail.com, linux-crypto@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5460987C.9030007@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-JyqJ/o/sNmZTScvz15nP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-11-10 at 11:50 +0100, Ondrej Kozina wrote:
> Hello,
>=20
> could you please add this patch (already landed in 3.18-rc1) to=20
> following stable kernels:
>=20
> 3.17.x, 3.14.x, 3.12.x, 3.4.x, 3.2.x?
>=20
> The bugfix allows usage of crypto API socket on archs with PAGE_SIZE >=3D=
=20
> 32 KiB (I have a typo in original changelog).
>=20
> Some background for the bug (with reproducer and report from users)
> - http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg11787.html
> - http://bugzilla.redhat.com/show_bug.cgi?id=3D1160289
[...]

I've queued this up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-JyqJ/o/sNmZTScvz15nP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVIp7POe/yOyVhhEJAQocNg/+N1Csb1p3WYSjmlEPqeOsFrQ/2aCYk1Kz
FdFpmGY6B9/oBRwmSLng/HXb4hqjcVxlwSNX1fCLhndLOMV/I6NpPT4yKOfO5lIC
/2S9E9AsR3hycemGYBGJN+tBtM6mFJQmunx4xiOeP2SZAtqp0H+MnacaVOZR4kw1
haPRd68sdKbWc8ZCNKYSoosLyP7Td4goFdc2qq/AH+yAIrQ5lw752tno3NrKd7BM
s/HAwbmBheqVU6IiAS+bWS+vE17l0hyUPBPSGRdDStxWWjbE0Q1WX1Z1r8K/2HIZ
zjg8zYgtB8IY4aVcRf/2KuClGqgK3U2sTAghzrP+0faEO/FQww2kE54sjCmvLs2D
CQrZRgRSUbGqHT+PK0enrKhSDApflpgyOjxiJYGWASrp3U4INTBoA+UsF71KEvkD
qyZoi/9Quazm4LULJW1slyavzCwexpYW5r1e+qOC07OlRajup5eU2UKjWCfyAMS8
tm9Lt0JxRlhPs5IlS2U9JRoNNcxaNSTPfHHFTlhp/G1MdIYUQR+ZsjtLx8NtLYfx
7MVh8ikk0N2P1iZdD3glFcsKE0Q8DwQ2nay0pPcaQXfVU8wXsLGTarrNk/RjIHYb
saiQTaQgFjiGacYlgPrlnxstOZX+8nEf4O0VxJJ29ZOeUKSrxdZr2y+OF6wJWfdI
b0cReNMZZPY=
=yL2i
-----END PGP SIGNATURE-----

--=-JyqJ/o/sNmZTScvz15nP--
