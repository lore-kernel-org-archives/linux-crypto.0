Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE138C432BE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 12:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C49060E76
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 12:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhHQMfn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:35:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58811 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhHQMfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 08:35:43 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210817123508euoutp024123286ae26f6632e28a16fd970e61c2~cGCQe_p6l2618726187euoutp02Q;
        Tue, 17 Aug 2021 12:35:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210817123508euoutp024123286ae26f6632e28a16fd970e61c2~cGCQe_p6l2618726187euoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629203708;
        bh=I1Lc3QNLRdHMuOOYcM8MCj6OI+Zmefea4cIaC7PS56A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdLvQSnQjR/t66XwqQCKMfspTx8KJ3j8v4j8Z344H3TQWpPF4PM59zoJa4lF39jrW
         OWQAhEvIjUE10ebZ/+bZa2BSprGDeYibSyJf1tz0L5Xswn7Z1NOBXAdX2PSOLY6Vxd
         j9r2gsdUQoidzHj3iGqtMa+ZgoXYUNOcEIONMqj4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210817123508eucas1p2c93495a4bce52ee192987627a73d3195~cGCQJhrc20206802068eucas1p2N;
        Tue, 17 Aug 2021 12:35:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id C3.27.42068.CFCAB116; Tue, 17
        Aug 2021 13:35:08 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210817123507eucas1p120be1e5cc942e20bed39b6d810ccdbd1~cGCPUTBVa3090730907eucas1p1i;
        Tue, 17 Aug 2021 12:35:07 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210817123507eusmtrp1cead64abb7ac154b4b1ebd97f352079d~cGCPTN_Ls0499304993eusmtrp1Z;
        Tue, 17 Aug 2021 12:35:07 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-ad-611bacfc564e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 55.00.31287.BFCAB116; Tue, 17
        Aug 2021 13:35:07 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210817123507eusmtip2cee3d14c4b90be9d235e7a5136e036a4~cGCPFhL2W2877228772eusmtip2N;
        Tue, 17 Aug 2021 12:35:07 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: rng: convert Samsung Exynos TRNG to
 dtschema
Date:   Tue, 17 Aug 2021 14:34:56 +0200
In-Reply-To: <c3a1d7d2-7b32-b7eb-4647-f86e22f5e5ff@canonical.com> (Krzysztof
        Kozlowski's message of "Tue, 17 Aug 2021 12:05:20 +0200")
Message-ID: <dleftj8s10fdvz.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7djP87p/1kgnGhzfwmUx/8g5VovuVzIW
        G9/+YLLY9Pgaq8X9ez+ZLC7vmsNmMeP8PiaLnXNOslos2NbHaNG69wi7xeZNU5kduD1mNfSy
        eWw7oOqxaVUnm8e7c+fYPTYvqffoe7mB0ePzJrkA9igum5TUnMyy1CJ9uwSujFlntrAU3FWs
        OLyzmb2B8bpMFyMnh4SAicT7f2tYuhi5OIQEVjBKrLl0EMr5wijxYtEGJgjnM6PE1G3X2WBa
        tmyeygyRWM4osWj5DFYI5zmQs/ItUD8HB5uAnsTatREgDSIC1hJHt85nBrGZBZ4wSVxrMQCx
        hQVCJO5PmQQWZxFQlfh5uJERxOYU6GCUmDEtH8TmFTCXOH93NSuILSpgKbHlxX12iLigxMmZ
        T1ggZuZKzDz/hhHkBgmB+ZwS+xonQ13qIjF/wQ8WCFtY4tXxLewQtozE6ck9YHdKCNRLTJ5k
        BtHbwyixbQ5MvbXEnXO/2CBqHCX693NBmHwSN94KQqzlk5i0bTozRJhXoqNNCKJRRWJd/x6o
        IVISva9WMELYHhIzm+cxQkJqCqPE+m1t7BMYFWYh+WYWkm9mAY1lFtCUWL9LHyKsLbFs4Wtm
        CNtWYt269ywLGFlXMYqnlhbnpqcWG+WllusVJ+YWl+al6yXn525iBCa00/+Of9nBuPzVR71D
        jEwcjIcYVYCaH21YfYFRiiUvPy9VSYRXnUMqUYg3JbGyKrUoP76oNCe1+BCjNAeLkjhv0pY1
        8UIC6YklqdmpqQWpRTBZJg5OqQYmhZvaazYqNteukX4m1fByyutXn+YpdmXfy1dmMraqqTss
        fWDvp4rZ1nde5Bb+D618aKfybwuP1Oz7syb8VxK/usMio935RKzJnO0Cd2ft1HktvOnWFImL
        sZULzi2/91/tmOePDwFvrTqXxHnHBVuwfvfvqP7zj73cw+zs9XBnc/P79ta/jfpWlAisM56u
        VKAUW6NwMU/b5rG5tK7ztbUaNkde/rUr2JvQy2851e31ropD7tmPRaQX+zU9PTfp5kG3/q1/
        3J7lvX6m/VKT/+TbKcHWUx2FBVNWJQf/t9lXlGHRIHTkafvELwvOzz/t+VvYx0iAoSHXZOJd
        gYC3TvaMyjtMrA9Ehq79kh7XmqqtxFKckWioxVxUnAgA1DuXLOMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7q/10gnGjw5xm8x/8g5VovuVzIW
        G9/+YLLY9Pgaq8X9ez+ZLC7vmsNmMeP8PiaLnXNOslos2NbHaNG69wi7xeZNU5kduD1mNfSy
        eWw7oOqxaVUnm8e7c+fYPTYvqffoe7mB0ePzJrkA9ig9m6L80pJUhYz84hJbpWhDCyM9Q0sL
        PSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jFlntrAU3FWsOLyzmb2B8bpMFyMnh4SAicSW
        zVOZuxi5OIQEljJKnL7+DMjhAEpISaycmw5RIyzx51oXG0TNU0aJs43LwGrYBPQk1q6NAKkR
        EbCWOLp1PtgcZoG7TBKdFxaygSSEBYIkJq15C2YLCThI7Fj5kx3EZhFQlfh5uJERxOYU6GCU
        mDEtH8TmFTCXOH93NSuILSpgKbHlxX12iLigxMmZT1hAbGaBbImvq58zT2AUmIUkNQtJahbQ
        ecwCmhLrd+lDhLUlli18zQxh20qsW/eeZQEj6ypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzA
        eNx27OfmHYzzXn3UO8TIxMF4iFEFqPPRhtUXGKVY8vLzUpVEeNU5pBKFeFMSK6tSi/Lji0pz
        UosPMZoCvTaRWUo0OR+YKPJK4g3NDEwNTcwsDUwtzYyVxHm3zl0TLySQnliSmp2aWpBaBNPH
        xMEp1cBUuu2zVkTeP8P6JUxsbHldXcs+cfr/u3ysY+a/3x+qpBd+9XBL+Gt61O1OoY90xkX/
        G7+FlCdpP9lUf3n91Cafz71J1pUH1/gw9IlveOmf+vhkSkqVYx+X/9vZ/SH8sapiFW8vu4ot
        bF7B+7XrTdNZIf4jF1p/Szzj+3wi9O4Ppqt9a6pSz18RO5JYnri+XM3ywMyFjzK3iF0y6Ehd
        t6Th/4Ufn2OTNr492lQ67fT1C87x355aHZvlktMjdnivvsay3P23jqyc/GPvuh6hLPHe5yVv
        P8jr9fguZZnBe1ZeYOJuqd37euL/pzP752loVO7XTTHV/Hw1z+6G0Wfnpujvxxx5VQsOGG5w
        zHLojG9UYinOSDTUYi4qTgQA3iVTs1wDAAA=
X-CMS-MailID: 20210817123507eucas1p120be1e5cc942e20bed39b6d810ccdbd1
X-Msg-Generator: CA
X-RootMTR: 20210817123507eucas1p120be1e5cc942e20bed39b6d810ccdbd1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210817123507eucas1p120be1e5cc942e20bed39b6d810ccdbd1
References: <c3a1d7d2-7b32-b7eb-4647-f86e22f5e5ff@canonical.com>
        <CGME20210817123507eucas1p120be1e5cc942e20bed39b6d810ccdbd1@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-08-17 wto 12:05>, when Krzysztof Kozlowski wrote:
> On 17/08/2021 11:55, Lukasz Stelmach wrote:
>> It was <2021-08-11 =C5=9Bro 10:43>, when Krzysztof Kozlowski wrote:
>>> Convert Samsung Exynos SoC True Random Number Generator bindings to DT
>>> schema format using json-schema.
>>>
>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>> ---
>>>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
>>>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++++++
>>>  MAINTAINERS                                   |  2 +-
>>>  3 files changed, 45 insertions(+), 18 deletions(-)
>>>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exyno=
s5250-trng.txt
>>>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exyno=
s5250-trng.yaml
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>> deleted file mode 100644
>>> index 5a613a4ec780..000000000000
>>> --- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>> +++ /dev/null
>>> @@ -1,17 +0,0 @@
>>> -Exynos True Random Number Generator
>>> -
>>> -Required properties:
>>> -
>>> -- compatible  : Should be "samsung,exynos5250-trng".
>>> -- reg         : Specifies base physical address and size of the regist=
ers map.
>>> -- clocks      : Phandle to clock-controller plus clock-specifier pair.
>>> -- clock-names : "secss" as a clock name.
>>> -
>>> -Example:
>>> -
>>> -	rng@10830600 {
>>> -		compatible =3D "samsung,exynos5250-trng";
>>> -		reg =3D <0x10830600 0x100>;
>>> -		clocks =3D <&clock CLK_SSS>;
>>> -		clock-names =3D "secss";
>>> -	};
>>> diff --git
>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>> new file mode 100644
>>> index 000000000000..a50c34d5d199
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>> @@ -0,0 +1,44 @@
>>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id:
>>> https://protect2.fireeye.com/v1/url?k=3Df38ca35b-ac179a0d-f38d2814-0cc4=
7a31ce52-1faa1ecb65482b8a&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=
=3Dhttp%3A%2F%2Fdevicetree.org%2Fschemas%2Frng%2Fsamsung%2Cexynos5250-trng.=
yaml%23
>>> +$schema:
>>> https://protect2.fireeye.com/v1/url?k=3D9409519d-cb9268cb-9408dad2-0cc4=
7a31ce52-12394c4409905980&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=
=3Dhttp%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
>>> +
>>> +title: Samsung Exynos SoC True Random Number Generator
>>> +
>>> +maintainers:
>>> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>> +  - =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: samsung,exynos5250-trng
>>> +
>>> +  clocks:
>>> +    maxItems: 1
>>=20
>> How about copying description from above into the description: property?
>
> But what to copy? There is no description except generic clock bindings.
>

The description that "was" in the txt file.

>>=20
>>> +
>>> +  clock-names:
>>> +    items:
>>> +      - const: secss
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>=20
>> ditto.
>
> The same, I have no clue what to copy. It's obvious that reg contains
> "physical address and size of the registers map".
>
>
> Best regards,
> Krzysztof
>
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmEbrPAACgkQsK4enJil
gBC5wggAq3vSstvJVjG17xqU5QPzv9fHJejUx5HQRCQcGRHUCQN4knqekli34bhg
1B1QpfVpFF/fm9jL4HlXCCvgAefpIJf3m3fLOxdK9881M8s5Ekgh3lWSR82wUKZi
WP6vspLVSpiSa5JZqsChqAdtaeYLhsSbOndVdnlUya6W+DuqNQ4e7On3l6rWCld/
bKch2tW1uaKY6LXHBRWGAJ4exwzE2jcYPXp9/9Tjd5NZICnnXWRovlajQyaT3DO/
XlxKNd8F+J5bYph2Wd0XlUugi4aqQfIuNPHsMMSooMyfvixpKr+27iEJ4N/27XXq
XN4WSjOsNsFvxVfgiblXLNps+OSmdg==
=wvZL
-----END PGP SIGNATURE-----
--=-=-=--
