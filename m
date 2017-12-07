From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH 1/3] crypto: exynos - Support Exynos5250+ SoCs
Date: Thu, 07 Dec 2017 10:20:27 +0100
Message-ID: <87y3me99no.fsf%l.stelmach@samsung.com>
References: <CAJKOXPfuGaE1ZaYU7RaLEr1sM+ib5qO8VeNNA_S_RJJm2rSkVw@mail.gmail.com>
        <CGME20171207092032eucas1p296f7cbc547d159c52561182cc6461504@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBo?= =?utf-8?Q?=C5=82nierkiewicz?=
        <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <CAJKOXPfuGaE1ZaYU7RaLEr1sM+ib5qO8VeNNA_S_RJJm2rSkVw@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-06 =C5=9Bro 16:28>, when Krzysztof Kozlowski wrote:
> On Wed, Dec 6, 2017 at 3:53 PM, =C5=81ukasz Stelmach <l.stelmach@samsung.=
com> wrote:
>> It was <2017-12-06 =C5=9Bro 15:05>, when Krzysztof Kozlowski wrote:
>>> On Wed, Dec 6, 2017 at 2:42 PM, =C5=81ukasz Stelmach <l.stelmach@samsun=
g.com> wrote:
>>>> It was <2017-12-05 wto 14:34>, when Krzysztof Kozlowski wrote:
>>>>> On Tue, Dec 5, 2017 at 1:35 PM, =C5=81ukasz Stelmach <l.stelmach@sams=
ung.com> wrote:
>>>>>> Add support for PRNG in Exynos5250+ SoCs.
>>>>>>
>>>>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>>>> ---

[...]

>>>>>> +               dev_info(&pdev->dev,
>>>>>> +                        "Exynos Pseudo Random Number Generator (typ=
e:%d)\n",
>>>>>
>>>>> dev_dbg, this is not that important information to affect the boot ti=
me.
>>>>
>>>> Quite many devices report their presence during boot with such
>>>> messages. For example:
>>>>
>>>> [    3.390247] exynos-ehci 12110000.usb: EHCI Host Controller
>>>> [    3.395493] exynos-ehci 12110000.usb: new USB bus registered, assig=
ned bus number 1
>>>> [    3.403702] exynos-ehci 12110000.usb: irq 80, io mem 0x12110000
>>>> [    3.431793] exynos-ehci 12110000.usb: USB 2.0 started, EHCI 1.00
>>>>
>>>> From my experience it isn't printk() itself that slows down boot but t=
he
>>>> serial console.
>>>
>>> True, the console is bottleneck (not necessarily serial) [1] but that
>>> does not change the fact there is no need to print the type of RNG.
>>
>> With values of the enum not being meaningful themselves printing the
>> type does not make much sense for me too. Is it ok just to print report
>> the device presence?
>
> This does not change mine arguments - this printk does not bring any
> information except that there is such device. Later you might want to
> print this for Exynos TRNG. Later for other module, and other. Thus I
> prefer not to add it. On the other hand that is not a reason to stop
> this patch so for example you could split it into separate commit.

Done.

> It is kind of unrelated change and keeping it separate will not block
> everything if maintainer will not want it.

I will. As a user a prefer when devices report their presence in the log
buffer and I will submit such patch.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaKQfbAAoJELCuHpyYpYAQw3QH/1f5OLQe+NIv24w1/YJikhPX
fpJM9LzXipNTD96cEa+yI9WSXsGIBo4d6iOuM3UGSCmgWIWG5vNap9BjB6fRD+vZ
KYxfeAruW6UzglzjOEcDNlh5x2wIcmaPfDhUi4+rHreEZeqV7Ggl8VjLzEJJTieE
tql9KI9z/iEZ4CYEqRGGsmjVJqnmZKd1OMXffdteEmI/GnNMja4jmq3uF3xiiIHT
efpbwKyxZY6tOQOtqj2ehEHmJ01ex7YkxrLFfEOqWKEFHK/o+/3u9DmWLQVgBffw
1MgIK2ob+d0Pb019Sz4k1YPdAEoj0QAe7c6JpfNBjQc9w+3WXQsH0wgbL0EBLjA=
=8qlz
-----END PGP SIGNATURE-----
--=-=-=--
