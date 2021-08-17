Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB028C432BE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 22:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC8C761058
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 22:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhHQWSN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 18:18:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43438 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbhHQWSM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 18:18:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210817221736euoutp0166d93e2c4af679f832566249dfbed19b~cN_0mfRwu1132611326euoutp01X;
        Tue, 17 Aug 2021 22:17:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210817221736euoutp0166d93e2c4af679f832566249dfbed19b~cN_0mfRwu1132611326euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629238656;
        bh=GwQKlvwMKsD/B0fRLGlIp0UXKV91TOh0STTb+wrVD4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POkDt5+JBj7JzTIopcNl3ZFkmwT0KFjjKog7DwNopOgltW1e20fZeqxV9TVhZkA45
         RgjXBk2XLN27+d4gsXH+a1ay9wjs6cN9QAX3rEd8pyJ97/6XVDFOUw66Bgs+CU9mOZ
         SloAA8H1IPIfdHB7MwXnaSf8My3Pk8a86fWSRnC4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210817221735eucas1p20b4a5787717d80fa8a1bfbcca880ae1e~cN_zhuOvU3047830478eucas1p21;
        Tue, 17 Aug 2021 22:17:35 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 58.D5.42068.F753C116; Tue, 17
        Aug 2021 23:17:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6~cN_yKpj2G3047430474eucas1p2o;
        Tue, 17 Aug 2021 22:17:34 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210817221734eusmtrp2ea6b1778903918c20574ee7236dc1083~cN_yJfJH-2058720587eusmtrp2P;
        Tue, 17 Aug 2021 22:17:34 +0000 (GMT)
X-AuditID: cbfec7f4-c71ff7000002a454-b3-611c357f8cf6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 84.C6.20981.E753C116; Tue, 17
        Aug 2021 23:17:34 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210817221733eusmtip27335a602d127a9510a694720437c00f3~cN_x5S2301801418014eusmtip2p;
        Tue, 17 Aug 2021 22:17:33 +0000 (GMT)
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
Date:   Wed, 18 Aug 2021 00:17:24 +0200
In-Reply-To: <da43d243-35b0-2cc6-f8a0-a5d02c997301@canonical.com> (Krzysztof
        Kozlowski's message of "Tue, 17 Aug 2021 16:07:20 +0200")
Message-ID: <dleftjtujnemx7.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsWy7djP87r1pjKJBs3L1S3mHznHatH9SsZi
        49sfTBabHl9jtbh/7yeTxeVdc9gsZpzfx2Sxc85JVosF2/oYLVr3HmG32LxpKrMDt8eshl42
        j20HVD02repk83h37hy7x+Yl9R59LzcwenzeJBfAHsVlk5Kak1mWWqRvl8CV0bBQuKBLreLh
        lzdMDYy7FLoYOTgkBEwk9p2I7GLk5BASWMEocaQlqYuRC8j+wigxs38OE4TzmVGi+9ELFpAq
        kIZNe3eyQiSWM0ocXLOUDcJ5zigxb/onNpCxbAJ6EmvXRoA0iAhYSxzdOp8ZxGYWeMIkca3F
        AMQWFgiRuD9lElicRUBVYs6zfrA5nAIdjBKru9azgyR4Bcwlrh6bAmaLClhKbHlxHyouKHFy
        5hMWiKG5EjPPv2EEaZYQmM0p0fHnBCPEqS4S9y/2skPYwhKvjm+BsmUk/u+czwTxf73E5Elm
        EL09jBLb5vyAetNa4s65X2wQtqPEj9tXoOr5JG68FYTYyycxadt0Zogwr0RHmxBEtYrEuv49
        UFOkJHpfrWCEKPGQuPaOGRJUUxgl1k5pZZrAqDALyTezkHwzC6iFWUBTYv0ufYiwtsSyha+Z
        IWxbiXXr3rMsYGRdxSieWlqcm55abJSXWq5XnJhbXJqXrpecn7uJEZjMTv87/mUH4/JXH/UO
        MTJxMB5iVAFqfrRh9QVGKZa8/LxUJRFedQ6pRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8SVvW
        xAsJpCeWpGanphakFsFkmTg4pRqY2B93dHhdu7F7xSGdP0uN5UQynjTmb1Pz33wq9kLv9vkh
        E+ZlmZ2PUE+OvtJQM30aX+ZnvfiGmUJr8zkii77ujTW/qpze0VGwZXf84tdJXl4rD6dpS/nr
        /XWZE7aFM+jTRtY/zN135cvNrx2WcVm59YeTx0wLiQedX0uzOwW+Wu4z0Rdyay/LCc6/O/nJ
        xOR/Vss3/3x1Tekdb4/7Tn7GpsQ9Cfu7U478M1t2RbH8UL62fmuC3ss1czb/OFhV+tDj4FGe
        6TP1PWZuv/ZLQ+LwQe7PcxTMRGu+LlKz8ubumJCcvUlAIkNtM1NO8gvzKb85zoclGT/46PVv
        q9SPcOVFTSkMs+4Wicz32XKep6VNiaU4I9FQi7moOBEAZ0QSAuEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7p1pjKJBkc/cFjMP3KO1aL7lYzF
        xrc/mCw2Pb7GanH/3k8mi8u75rBZzDi/j8li55yTrBYLtvUxWrTuPcJusXnTVGYHbo9ZDb1s
        HtsOqHpsWtXJ5vHu3Dl2j81L6j36Xm5g9Pi8SS6APUrPpii/tCRVISO/uMRWKdrQwkjP0NJC
        z8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEvo2GhcEGXWsXDL2+YGhh3KXQxcnJICJhIbNq7
        k7WLkYtDSGApo0TH9i1ADgdQQkpi5dx0iBphiT/Xutggap4ySmyZ9YYJpIZNQE9i7doIkBoR
        AWuJo1vnM4PUMAvcZZLovLCQDSQhLBAkMWnNWzBbSMBB4s7vF+wgNouAqsScZ/1gQzkFOhgl
        VnetB0vwCphLXD02BcwWFbCU2PLiPlRcUOLkzCcsIDazQLbE19XPmScwCsxCkpqFJDUL6D5m
        AU2J9bv0IcLaEssWvmaGsG0l1q17z7KAkXUVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYDxu
        O/Zzyw7Gla8+6h1iZOJgPMSoAtT5aMPqC4xSLHn5ealKIrzqHFKJQrwpiZVVqUX58UWlOanF
        hxhNgX6byCwlmpwPTBR5JfGGZgamhiZmlgamlmbGSuK8JkfWxAsJpCeWpGanphakFsH0MXFw
        SjUwOU/coWPHLd/R08tpLjdXZvEno8PLi9kSnPc/4egrdlkg3e+nF/9mO8MEx6C+X7ealzV+
        3mcbdG61/yOnxyG1PKGTnOSPaCxaI+9nnqn17cSP06z9s8NZUk8vfz95oX5q0p37NtJzlhib
        r/W/fOCTSOTc65dfxstrv/7a/vGXaOG+3jOMBtpJ+0z2TZjLYemV9p2Jq6i6Vk02wUDx3pKJ
        hrkW3wQb3nwWi7a//f+l9BL91z+7tvDUrupZNovlk87rV3ZqHPfO3q6d094+uTjyYLW4Xn6e
        wlqD/Ov337J93yTS6eQ8S+3+xv3t/s35xtqbI84KWa+fxOspw3zqWHpJStWhRfWWLSpPcnqD
        S68osRRnJBpqMRcVJwIA6ngBa1wDAAA=
X-CMS-MailID: 20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6
X-Msg-Generator: CA
X-RootMTR: 20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6
References: <da43d243-35b0-2cc6-f8a0-a5d02c997301@canonical.com>
        <CGME20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-08-17 wto 16:07>, when Krzysztof Kozlowski wrote:
> On 17/08/2021 14:34, Lukasz Stelmach wrote:
>> It was <2021-08-17 wto 12:05>, when Krzysztof Kozlowski wrote:
>>> On 17/08/2021 11:55, Lukasz Stelmach wrote:
>>>> It was <2021-08-11 =C5=9Bro 10:43>, when Krzysztof Kozlowski wrote:
>>>>> Convert Samsung Exynos SoC True Random Number Generator bindings to DT
>>>>> schema format using json-schema.
>>>>>
>>>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>>>> ---
>>>>>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
>>>>>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++++=
++
>>>>>  MAINTAINERS                                   |  2 +-
>>>>>  3 files changed, 45 insertions(+), 18 deletions(-)
>>>>>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exy=
nos5250-trng.txt
>>>>>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exy=
nos5250-trng.yaml
>>>>>
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>>> deleted file mode 100644
>>>>> index 5a613a4ec780..000000000000
>>>>> --- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.t=
xt
>>>>> +++ /dev/null
>>>>> @@ -1,17 +0,0 @@
>>>>> -Exynos True Random Number Generator
>>>>> -
>>>>> -Required properties:
>>>>> -
>>>>> -- compatible  : Should be "samsung,exynos5250-trng".
>>>>> -- reg         : Specifies base physical address and size of the regi=
sters map.
>>>>> -- clocks      : Phandle to clock-controller plus clock-specifier pai=
r.
>>>>> -- clock-names : "secss" as a clock name.
>>>>> -
>>>>> -Example:
>>>>> -
>>>>> -	rng@10830600 {
>>>>> -		compatible =3D "samsung,exynos5250-trng";
>>>>> -		reg =3D <0x10830600 0x100>;
>>>>> -		clocks =3D <&clock CLK_SSS>;
>>>>> -		clock-names =3D "secss";
>>>>> -	};
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>>>> new file mode 100644
>>>>> index 000000000000..a50c34d5d199
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.y=
aml
>>>>> @@ -0,0 +1,44 @@
>>>>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>>>>> +%YAML 1.2
>>>>> +---
>>>>> +$id:
>>>>> https://protect2.fireeye.com/v1/url?k=3Df38ca35b-ac179a0d-f38d2814-0c=
c47a31ce52-1faa1ecb65482b8a&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec781403&=
u=3Dhttp%3A%2F%2Fdevicetree.org%2Fschemas%2Frng%2Fsamsung%2Cexynos5250-trng=
.yaml%23
>>>>> +$schema:
>>>>> https://protect2.fireeye.com/v1/url?k=3D9409519d-cb9268cb-9408dad2-0c=
c47a31ce52-12394c4409905980&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec781403&=
u=3Dhttp%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
>>>>> +
>>>>> +title: Samsung Exynos SoC True Random Number Generator
>>>>> +
>>>>> +maintainers:
>>>>> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>>>> +  - =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>>> +
>>>>> +properties:
>>>>> +  compatible:
>>>>> +    const: samsung,exynos5250-trng
>>>>> +
>>>>> +  clocks:
>>>>> +    maxItems: 1
>>>>
>>>> How about copying description from above into the description: propert=
y?
>>>
>>> But what to copy? There is no description except generic clock bindings.
>>>
>>=20
>> The description that "was" in the txt file.
>
> But there was no description of fields except copy&paste of the core
> schema. Do you describe C code like:
>
> ...
> /* unsigned int is a integer number greater or equal 0 */
> unsigned int i;
> ...

I believe having descriptions for reg and clocks

>>>>> -- reg         : Specifies base physical address and size of the regi=
sters map.
>>>>> -- clocks      : Phandle to clock-controller plus clock-specifier pai=
r.

right next to properties' formal definitions is beneficial for anyone
browsing the YAML file. If you think otherwise, oh well, I am fine with
that.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmEcNXQACgkQsK4enJil
gBDdVgf/T8FGoSclFmMA0UY0LD4A2cLtKIyg2z2DuF3Qxr3X9rURYRLxXvPf/T37
kwNa4Jiz4n+v/oDskk6B9u4VhalLpOfW8oCKPSKBwYkurStwdgPxbEQ3/veC+yRE
Kii4jxX8UF3e0Utx8ZuQ6N6sCWvi9hWTvM2wem8TYhtEcHxxE3u6VPc6yBX6fFtS
nKKENMHrCjE4eyCNFuyBlm6m5uSqZanClWjhS2UE0RB1UEULToEsToYUfPEpwyV5
sE1BO1OC4nbexCdyyBAt+hXjOKKL9bYP1q2q7YUInz77SFxooRBnxB3UabItPiDd
Bvk9LzNArYskZxHv6qpv6zK4ozOmVg==
=4+0h
-----END PGP SIGNATURE-----
--=-=-=--
