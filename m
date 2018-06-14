From: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
Subject: Re: b43 crashes on rmmod (bcm4331)
Date: Thu, 14 Jun 2018 12:47:19 +0300
Message-ID: <6bef30e0-9405-2ddd-d1eb-612b4d4e3382@lukas-wirz.de>
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
 <6b84a788-e11f-91db-309c-4ff79fdcad66@lukas-wirz.de>
 <20180613152812.5596b460@wiggum>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OBDhBlZUsPROum0mA6nbvX4xLQmLEDnxB"
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180613152812.5596b460@wiggum>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OBDhBlZUsPROum0mA6nbvX4xLQmLEDnxB
Content-Type: multipart/mixed; boundary="WTbq9za79umExicsbC73n8BmhRPupzKMe";
 protected-headers="v1"
From: Wirz <spam-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
 Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <6bef30e0-9405-2ddd-d1eb-612b4d4e3382-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
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
 <6b84a788-e11f-91db-309c-4ff79fdcad66-rxbgZ4vWfLhdz0/ABlLGQA@public.gmane.org>
 <20180613152812.5596b460@wiggum>
In-Reply-To: <20180613152812.5596b460@wiggum>

--WTbq9za79umExicsbC73n8BmhRPupzKMe
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable


>>>> You can edit drivers/net/wireless/broadcom/b43/Kconfig
>>>> go to the section config B43_HWRNG
>>>> and change 'default y' to 'default n'
>>>>
>>>> That should disable it. =20
>>>
>>>
>>>
>>> Could you please also try the attached patch?
>>> There seems to be a problem in hwrng core in that it does not disable=

>>> the current RNG, if the new RNG fails to initialize.
>>> I don't know if that's the problem here, though. =20
>>
>> Ok. Do I apply your patch to the first version that fails for me, and
>> revert my change to Kconfig?
>=20
>=20
> Yes, please test the patch with a version that would otherwise fail.
> You can use 4.16 or the latest kernel for that. I created it with lates=
t
> linus' version.

I tested both suggested cases.  When I disable B43_HWRNG by editing
Kconfig, 'rmmod b43' succeeds in the first version where it previously
failed.  When I apply your patch on top of an unmodified 4.16 it also
succeeds.

cheers, lukas

--=20
Do not believe the naysayers who say it cannot be done.


--WTbq9za79umExicsbC73n8BmhRPupzKMe--

--OBDhBlZUsPROum0mA6nbvX4xLQmLEDnxB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWyI5sQAKCRDWbaSYbwIj
LQfwAJ9uz/BJ752FoL6Q/lS21C6ATbb5bQCfdmUM3fScet/kSyLC84wso4fzEXc=
=5OLH
-----END PGP SIGNATURE-----

--OBDhBlZUsPROum0mA6nbvX4xLQmLEDnxB--
