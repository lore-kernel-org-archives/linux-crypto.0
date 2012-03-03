From: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Subject: Re: Openswan IPsec: ARM cortex SoC board to board ping works but
 board to Ubuntu does not
Date: Fri, 02 Mar 2012 19:58:01 -0800
Message-ID: <1330747081.4973.2.camel@foxtrot.cjac.ntr.f5net.com>
References: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0c5AY7y29aJer5gS7tba"
Cc: users@openswan.org, linux-crypto@vger.kernel.org
To: satpal parmar <systems.satpal@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38671 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab2CCD6S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Mar 2012 22:58:18 -0500
Received: by dadp12 with SMTP id p12so2593691dad.11
        for <linux-crypto@vger.kernel.org>; Fri, 02 Mar 2012 19:58:18 -0800 (PST)
In-Reply-To: <CAGgcXb7dMetJ0OS498X9Fn3Py6OAfWhN2j+kA1HzyJFzbfJ_tg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-0c5AY7y29aJer5gS7tba
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi there!  Have you found any kernel error messages in /var/log/kern.log
or similar?  I heard rumor of a recent mv_cesa issues.  What's lsmod say?

On Fri, 2012-03-02 at 16:11 +0530, satpal parmar wrote:
> Hi All !
>=20
> I recently ported Openswan on ARM cortex based SOC running linux
> 2.6.37 (ipsec netkey stack) and openswan 2.6.23. On this board I have
> H/W accelerator support for AES/DES/SHA.
> (http://processors.wiki.ti.com/index.php/Installing_AM387x_C6A814x_DM814x=
_Crypto_Support).
> AES/DES crypto operation are working fine and I am able to ping
> through IPsec tunnel from my board to PC and vice versa. However when
> I am trying ping with SHA-MD5 I am not able to ping  to and from
> Ubuntu machine .
>=20
> My ubuntu machine details:
> root@vnl-desktop:~# uname -a
> Linux vnl-desktop 2.6.32-33-generic #72-Ubuntu SMP Fri Jul 29 21:08:37
> UTC 2011 i686 GNU/Linux
>=20
> MYost probably it could be a IPsec configuration issue on Ubuntu
> machine but I am not able to locate  what configuration could affect
> behavior of only one crypto algorithm. Since I am using same
> configuration for IPsec for testing all Crypto algo supported in H/W
> (DES/AES/SHA-MD5 )and  I am successfully able to ping through IPSec
> tunnel for DES and AES.
>=20
> Just wondering if any one came across any such issue before. Do we
> have separate config for SHA-MD5?
>=20
> Appreciate any help /pointer reagrading this issue.
>=20
> -SP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=-0c5AY7y29aJer5gS7tba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABCAAGBQJPUZbJAAoJEEyimPmPQm23yvEIAIgmAzsGtN358kKmmUNPixS1
zhV1knrOrmTyBpPRjvZUBFW8PU9dXdoXp3e0wXnQ1PprHZRoT6OWXvN7YxFD2E3Y
iN/FL0LG9m0zlc3jPuD+kSe2myqtkYC/NGz0GpjpcV04zoOZ2kl3TSr0w4IrqZOA
ePSwdLUjPgd7i97I2bMbaT8Lk8QBvhjQpAmTT4t2gmwCKXtfC2zAjMBbu2UYZPQu
uRPHeDpFXOL+9c8qRlb6rrwuGTXhFYbGIdrGUz3WN2kpfheItT0qrI8nMVgwywhe
o8H6lJRsHoL3hAE7xa/NG4qT0R+xu0lZuPL0nSPO/avSy0GEbN287F+3+CzbNto=
=KsKg
-----END PGP SIGNATURE-----

--=-0c5AY7y29aJer5gS7tba--
