From: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH v2 06/12] hwrng: bcm2835-rng: Rework interrupt masking
Date: Wed, 08 Nov 2017 12:41:41 -0800
Message-ID: <87efp8bj0a.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-7-f.fainelli@gmail.com> <1086045224.63286.1510166797078@email.1und1.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        linux-rpi-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1086045224.63286.1510166797078-7tX72C7vayboQLBSYMtkGA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org> writes:

> Hi Florian,
>
>> Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> hat am 8. November 2017 um 01:44=
 geschrieben:
>>=20
>>=20
>> The interrupt masking done for Northstart Plus and Northstar (BCM5301X)
>> is moved from being a function pointer mapped to of_device_id::data into
>> a proper part of the hwrng::init callback. While at it, we also make the
>> of_data be a proper structure indicating the platform specifics, since
>> the day we need to add a second type of platform information, we would
>> have to do that anyway.
>
> in the lack of proper documentation for bcm2835 rng, is it possible
> that we should mask the interrupts for bcm2835 as well?

I don't have the RTL nearby and the RNG block doesn't have the usual
#defines for power-on-reset values, so I'm not sure.  I don't see any
use of the RNG by the firmware that should impact Linux -- a driver
exists and it uses IRQs, but it shouldn't have been active, and even if
it was then its teardown process masks the interrupt off again.

However, masking it off ourselves should be harmless at worst.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDbAUACgkQtdYpNtH8
nugQhg//a/ByTkAPxXrEri8S0Jr/+eo/fuUy4pyHogL8YeJekXlkwAce8JscyTe+
8DzE5NILxTPar5+z+wib7a7Ycn/M57Ydpkcaa/qUTbhFYbihgbxmw36cXRXmaQre
7RgX401AyU4UTtLv/COe5rOYtGjwaiIC5huTb7ieqTH92dU9spCzxorWFH6lh2eb
QUhmOUtZkMOFa3PJ3VtpXUbgnGt4q2hHvFFItGfRWj/Q8KcxJjzKP1ZWIn1pusZI
HZITLWp6icSxjCzAqqukKDjLGC53RXlyoLEhSzwKDfAr1DOTWoUSfspcN5x3R8QM
dbIHbh+UpBTc1pyGK2khj+OE790emb18orHkCr5lVMB+iktz4pT+6yzl5MeLPSOc
hOY9CLaROY/FoiL1a8LpqOPAkTS9eaNhpeqT1NORSDKKwYN9H1LcwdgWjqhBk0cF
0LBK7vg/ByoUY9x8fiqIkZvfAOLzl/a1Wo2UYFJmlhMj6Rs2KkOCxnIh2AuHyJ37
6314dGc3H66QHcBdPZoc4S1HhYgPMzDqApvVKIoMRYOzK6QufUCJkkDnopqt9WP2
yDQlutu/O8chcK9Ln8vtxeum0g6t9CbjXK8iU6VnLES8CerhgCOHCU9UH5h0eHkM
WmFDZUiD0SAAe9HOY3pRF/pYNpaj+g0iWt3rnoxtOwevJl6hM/Y=
=fSFI
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
