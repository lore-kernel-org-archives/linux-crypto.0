From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: b43 crashes on rmmod (bcm4331)
Date: Wed, 13 Jun 2018 15:28:12 +0200
Message-ID: <20180613152812.5596b460@wiggum>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
 <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
 <20180613122751.2fe89737@wiggum>
 <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de>
 <20180613130905.420695e7@wiggum>
 <20180613140148.1b57a566@wiggum>
 <6b84a788-e11f-91db-309c-4ff79fdcad66@lukas-wirz.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/A6XghP3Eyitk7O=xe/23hTQ"; protocol="application/pgp-signature"
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6b84a788-e11f-91db-309c-4ff79fdcad66-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--Sig_/A6XghP3Eyitk7O=xe/23hTQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2018 16:07:02 +0300
Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org> wrote:

> >>>> CONFIG_B43_HWRNG completely switches off hwrng support in b43.
> >>>> I don't see how a change in hwrng core could still lead to a crash in
> >>>> b43 with this option switched off.
> >>>>
> >>>> What do you mean by "manually in the .config"?     =20
> >>>
> >>> What I meant is, that I have outcommented the line 'CONFIG_B43_HWRNG=
=3Dy'
> >>> in .config.
> >>>    =20
> >>>> Can you try to properly switch off the setting with make menuconfig =
and
> >>>> then recompile everything from scratch (make clean)?     =20
> >>>
> >>> I was intending to do that before, but I cannot find the option for
> >>> that.  Searching for b43_hwrng in menuconfig only shows the dependenc=
ies
> >>> of that option, and the Kconfig file where it is defined, but not the
> >>> path in menuconfig.  Do I indirectly set CONFIG_B43_HWRNG through the
> >>> parameters it depends on?  I'm sorry, but this is obviously above my
> >>> level of expertise ...   =20
> >>
> >> Whoops, sorry. You are right. This is an automatic config option.
> >> That also means your manual editing of .config would be overridden.
> >>
> >> You can edit drivers/net/wireless/broadcom/b43/Kconfig
> >> go to the section config B43_HWRNG
> >> and change 'default y' to 'default n'
> >>
> >> That should disable it. =20
> >=20
> >=20
> >=20
> > Could you please also try the attached patch?
> > There seems to be a problem in hwrng core in that it does not disable
> > the current RNG, if the new RNG fails to initialize.
> > I don't know if that's the problem here, though. =20
>=20
> Ok. Do I apply your patch to the first version that fails for me, and
> revert my change to Kconfig?


Yes, please test the patch with a version that would otherwise fail.
You can use 4.16 or the latest kernel for that. I created it with latest
linus' version.


--=20
Michael

--Sig_/A6XghP3Eyitk7O=xe/23hTQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlshG+wACgkQ9TK+HZCN
iw4aCRAA3TAXqp/qPuZTg8yRwFft3N8U/FG6oCQlr3xSYY/mbI9xBwJyTN9Bd4UR
AnGdxLcA0a6bXUPvfxWohpGeNHYeKTHnO8iMYJ84/Sptu9S5c1QcZnqv6fNVPA2H
9yfNooThu3HsKPUKChzYhIZ/8nyanqcCq5xHYyNoI6kcPqhxnYKP1nk3NGg1BYKw
HR3BHuIoEc5iUWCE4oOQBDcKDOusHxkt8ghQxDlUuTYZRYzIVOxXJk5G4Fku+AG4
lCubifEWJOoG/zAzzM8RfwKlO9KI1vFvjHoDj9DkimbujUK57PoGj+ujv/JFWNYw
e/pRax3o9Ii7JBdUQL0BIpr2FFKyl1DaxgdS6aAvANNHKHBYRjb8fDzgEXqVyZhV
tMZAc4t/nVy1oNBaRSx8UPGYcNJwK1puORL72PrnoOgO7xuJPeB/PyJcCel/Bq/F
V9jiA5QkKMV0sJMM1xz0bA3arAOSJlHrxje+Umo3wYd1t+3NNzJ+EVryTpiDh/Xf
igkzKEkioh3IPBSJ0hEI7N++rarrS7KUil4+bcUZMQ7c+1abz5AsGkE6qEN9FsUA
DIx8cPTQv23zwaKrgs86uv5L0Su48CER/DD4HJJ0oq1ggPdk1tUxdxeJF9IuX/Sv
ZI3x2fc04zqSo5FDlnNJI5lPIqjTDhliJJHebDlY9wO+q81C+8c=
=8XX9
-----END PGP SIGNATURE-----

--Sig_/A6XghP3Eyitk7O=xe/23hTQ--
