From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: b43 crashes on rmmod (bcm4331)
Date: Wed, 13 Jun 2018 14:01:48 +0200
Message-ID: <20180613140148.1b57a566@wiggum>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/8WVnbKlrdBO.JQW.sj5ulir"; protocol="application/pgp-signature"
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180613130905.420695e7@wiggum>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--Sig_/8WVnbKlrdBO.JQW.sj5ulir
Content-Type: multipart/mixed; boundary="MP_/K3lxBUniP9O/V1zAbtPGBkL"

--MP_/K3lxBUniP9O/V1zAbtPGBkL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 13 Jun 2018 13:09:05 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> On Wed, 13 Jun 2018 14:01:53 +0300
> Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org> wrote:
>=20
> > > CONFIG_B43_HWRNG completely switches off hwrng support in b43.
> > > I don't see how a change in hwrng core could still lead to a crash in
> > > b43 with this option switched off.
> > >=20
> > > What do you mean by "manually in the .config"?   =20
> >=20
> > What I meant is, that I have outcommented the line 'CONFIG_B43_HWRNG=3D=
y'
> > in .config.
> >  =20
> > > Can you try to properly switch off the setting with make menuconfig a=
nd
> > > then recompile everything from scratch (make clean)?   =20
> >=20
> > I was intending to do that before, but I cannot find the option for
> > that.  Searching for b43_hwrng in menuconfig only shows the dependencies
> > of that option, and the Kconfig file where it is defined, but not the
> > path in menuconfig.  Do I indirectly set CONFIG_B43_HWRNG through the
> > parameters it depends on?  I'm sorry, but this is obviously above my
> > level of expertise ... =20
>=20
> Whoops, sorry. You are right. This is an automatic config option.
> That also means your manual editing of .config would be overridden.
>=20
> You can edit drivers/net/wireless/broadcom/b43/Kconfig
> go to the section config B43_HWRNG
> and change 'default y' to 'default n'
>=20
> That should disable it.



Could you please also try the attached patch?
There seems to be a problem in hwrng core in that it does not disable
the current RNG, if the new RNG fails to initialize.
I don't know if that's the problem here, though.


diff --git a/drivers/char/hw_random/core.c
b/drivers/char/hw_random/core.c index 91bb98c42a1c..aaf9e5afaad4 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -516,11 +516,18 @@ EXPORT_SYMBOL_GPL(hwrng_register);
=20
 void hwrng_unregister(struct hwrng *rng)
 {
+	int err;
+
 	mutex_lock(&rng_mutex);
=20
 	list_del(&rng->list);
-	if (current_rng =3D=3D rng)
-		enable_best_rng();
+	if (current_rng =3D=3D rng) {
+		err =3D enable_best_rng();
+		if (err) {
+			drop_current_rng();
+			cur_rng_set_by_user =3D 0;
+		}
+	}
=20
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);



--=20
Michael

--MP_/K3lxBUniP9O/V1zAbtPGBkL
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=rng_new_init_fail.patch

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 91bb98c42a1c..aaf9e5afaad4 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -516,11 +516,18 @@ EXPORT_SYMBOL_GPL(hwrng_register);
=20
 void hwrng_unregister(struct hwrng *rng)
 {
+	int err;
+
 	mutex_lock(&rng_mutex);
=20
 	list_del(&rng->list);
-	if (current_rng =3D=3D rng)
-		enable_best_rng();
+	if (current_rng =3D=3D rng) {
+		err =3D enable_best_rng();
+		if (err) {
+			drop_current_rng();
+			cur_rng_set_by_user =3D 0;
+		}
+	}
=20
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);

--MP_/K3lxBUniP9O/V1zAbtPGBkL--

--Sig_/8WVnbKlrdBO.JQW.sj5ulir
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlshB6wACgkQ9TK+HZCN
iw6vsA//TxxjHcXvxm09mYcPvojdmPW466FdEAqyyWXC2IjtCT02eXzkUWPjVPv1
LXBxno8sq7QZwd5Lx+ubcY6mrCmUvdkLdAI+msxXuy6CdSRccfWjflW+7R3fYF4W
hYDrpA9i7JooVt2ITZrWRxKImWK4AjyGFGJDLB/X3aQS82ioVkx3iIC4O4RSCQN/
+MsbxAsi54KWD00lHcbQQeUFdOYdk3Q2EM/a2EmWw6GAfqba15Yb46sp1/lMo+Fr
eP+w8ECQrS1ywIqRRyquQXO+06ItTPqYOPGyA6ruLlkdTK4Nw7sQYiNmvtPS0PM5
l26Ae86zKNYKkrpO/tqnRIrrTr2gLO91cQvbIqbsJY+BadzEXDZrMVULecBYqsce
cbjRpn9Eb4frLGIrR2fBggakUONl4AzWBKA1VjAy29jzoSrpUSZ7wEy/FLQBnSI9
qQptFl47me5iq0w/72YZAz7H7BIzqiAY3QlMs+yzORsq1C6j1So0MioMfcK8WrgQ
eJ164PCHHFB0hnx0TLW8IJFFqRM0wFFveBJZ9gOSjGbOQ1prMfGGw0Ly1B2bi36E
64kMgdAtotMVfZZQ5Lp7CorrwbAhO9+h4pN4q5YSS3F+0QZtpCocaRS1SefVnv6I
vjHiMpy8Csj/Sxeq48n9ftUNKYMgvy9E3hsfgvgfunEDvRn+DY8=
=vlRj
-----END PGP SIGNATURE-----

--Sig_/8WVnbKlrdBO.JQW.sj5ulir--
