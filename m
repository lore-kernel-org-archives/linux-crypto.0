From: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
Date: Wed, 13 Jun 2018 16:07:02 +0300
Message-ID: <6b84a788-e11f-91db-309c-4ff79fdcad66@lukas-wirz.de>
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
 <20180613130905.420695e7@wiggum> <20180613140148.1b57a566@wiggum>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="77YjpeHHDd3wxb83I6cHBbeZrwp96vD0L"
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180613140148.1b57a566@wiggum>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--77YjpeHHDd3wxb83I6cHBbeZrwp96vD0L
Content-Type: multipart/mixed; boundary="7bqoPWCYmEXEXUbYW8Xyz7QgmVNP09Ajq";
 protected-headers="v1"
From: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
 Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <6b84a788-e11f-91db-309c-4ff79fdcad66-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <d9896c10-87bb-8362-f302-8b1888c3421c-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <20180611224634.28ccd288@wiggum>
 <7d564b8b-2b71-73f6-3ae7-ede0187a4151-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <20180613122751.2fe89737@wiggum>
 <538cd7b7-8d63-1795-7bfc-69231d2bf3c0-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <20180613130905.420695e7@wiggum> <20180613140148.1b57a566@wiggum>
In-Reply-To: <20180613140148.1b57a566@wiggum>

--7bqoPWCYmEXEXUbYW8Xyz7QgmVNP09Ajq
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable


>>>> CONFIG_B43_HWRNG completely switches off hwrng support in b43.
>>>> I don't see how a change in hwrng core could still lead to a crash i=
n
>>>> b43 with this option switched off.
>>>>
>>>> What do you mean by "manually in the .config"?   =20
>>>
>>> What I meant is, that I have outcommented the line 'CONFIG_B43_HWRNG=3D=
y'
>>> in .config.
>>>  =20
>>>> Can you try to properly switch off the setting with make menuconfig =
and
>>>> then recompile everything from scratch (make clean)?   =20
>>>
>>> I was intending to do that before, but I cannot find the option for
>>> that.  Searching for b43_hwrng in menuconfig only shows the dependenc=
ies
>>> of that option, and the Kconfig file where it is defined, but not the=

>>> path in menuconfig.  Do I indirectly set CONFIG_B43_HWRNG through the=

>>> parameters it depends on?  I'm sorry, but this is obviously above my
>>> level of expertise ... =20
>>
>> Whoops, sorry. You are right. This is an automatic config option.
>> That also means your manual editing of .config would be overridden.
>>
>> You can edit drivers/net/wireless/broadcom/b43/Kconfig
>> go to the section config B43_HWRNG
>> and change 'default y' to 'default n'
>>
>> That should disable it.
>=20
>=20
>=20
> Could you please also try the attached patch?
> There seems to be a problem in hwrng core in that it does not disable
> the current RNG, if the new RNG fails to initialize.
> I don't know if that's the problem here, though.

Ok. Do I apply your patch to the first version that fails for me, and
revert my change to Kconfig?

At the moment the test without B43_HWRNG compiles, I will test that later=
=2E


> diff --git a/drivers/char/hw_random/core.c
> b/drivers/char/hw_random/core.c index 91bb98c42a1c..aaf9e5afaad4 100644=

> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -516,11 +516,18 @@ EXPORT_SYMBOL_GPL(hwrng_register);
> =20
>  void hwrng_unregister(struct hwrng *rng)
>  {
> +	int err;
> +
>  	mutex_lock(&rng_mutex);
> =20
>  	list_del(&rng->list);
> -	if (current_rng =3D=3D rng)
> -		enable_best_rng();
> +	if (current_rng =3D=3D rng) {
> +		err =3D enable_best_rng();
> +		if (err) {
> +			drop_current_rng();
> +			cur_rng_set_by_user =3D 0;
> +		}
> +	}
> =20
>  	if (list_empty(&rng_list)) {
>  		mutex_unlock(&rng_mutex);
>=20
>=20
>=20


--=20
Do not believe the naysayers who say it cannot be done.


--7bqoPWCYmEXEXUbYW8Xyz7QgmVNP09Ajq--

--77YjpeHHDd3wxb83I6cHBbeZrwp96vD0L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWyEW9gAKCRDWbaSYbwIj
LeuFAJ9PGfbpQLElXqhcHE8B3Au8OGRIJQCfboPpx+Ft2Vbgbmzged1PX8ftE6A=
=Mu/Z
-----END PGP SIGNATURE-----

--77YjpeHHDd3wxb83I6cHBbeZrwp96vD0L--
