Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5E4C432BE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 09:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4EC604D7
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 09:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhHQJ4a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:56:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50937 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbhHQJ43 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 05:56:29 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210817095554euoutp014e786d7fc6416f73dd1270dc12a7c12d~cD3Obbh3Y3055130551euoutp01U;
        Tue, 17 Aug 2021 09:55:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210817095554euoutp014e786d7fc6416f73dd1270dc12a7c12d~cD3Obbh3Y3055130551euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629194154;
        bh=PVou2Xz0htuhiyPBV3jKDHAmv+LpNphcnbuFbuKDuxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap+Udf+KqblEPjwD9U5PlXJTao3SPtROdLxTGiZEO+hLv8MIJuwaruHMdu9R/g/kE
         JKqvOzS8bP7z8abhq9rIjt+0obUhFz5IQtYaJU7bnMmE/4mtNRniaUaAGJXW0+n13N
         JQ4oJANDHgKABaJZEoMSS/dXz5HK7e+PIkCVgmec=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210817095554eucas1p112f2965aa464d208f65001e38ff065ff~cD3OQgs3y2324923249eucas1p1x;
        Tue, 17 Aug 2021 09:55:54 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 13.B6.56448.AA78B116; Tue, 17
        Aug 2021 10:55:54 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210817095553eucas1p174e68fc6d7cfad9c2fd34f729272b01a~cD3NyE1p01848618486eucas1p1q;
        Tue, 17 Aug 2021 09:55:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210817095553eusmtrp181c6d5870928418f08e683be329ea300~cD3NxSlfk1276012760eusmtrp1u;
        Tue, 17 Aug 2021 09:55:53 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-cc-611b87aa666e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 57.99.31287.9A78B116; Tue, 17
        Aug 2021 10:55:53 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210817095553eusmtip2ae6fea021774f30ddc7455633e13e449~cD3NiojzG0976509765eusmtip23;
        Tue, 17 Aug 2021 09:55:53 +0000 (GMT)
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
Date:   Tue, 17 Aug 2021 11:55:44 +0200
In-Reply-To: <20210811084306.28740-2-krzysztof.kozlowski@canonical.com>
        (Krzysztof Kozlowski's message of "Wed, 11 Aug 2021 10:43:06 +0200")
Message-ID: <dleftjeeasfl9b.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTdxTO797b20uXkh8FwkklzdZUzdgsLlu2S3CKwcS7ZS+HW3AzcTd4
        KW60kFZ0LnGyhTFUXuFZujJAEQkDhn1ZGkYsIIgs1I2MR+KojyawjkoIU2GPOuqtif995zvf
        951zfvkxpOIXiZI5YjgqGA18vpqWUa7Rdd+2rm838dsf/EezLSOTEvZsMJm9FFojWNvdaQnr
        n18n2CmPlWbNvkGC7beOS9hWVyViv/lpRMrabfVkxjOcpbiC5lxXNnO2rtM0d29yUsrZ209x
        lX/0IW7VpnpP+pFsx2Eh/8gxwZi68xNZ3rWyC5LCgObz9SYrVYxWVGdQDAP4FRj2NkvPIBmj
        wJ0IqvrdtFj8heD7trMoolLgVQTu0XeeOKz9zqjjIoJAuIMSiwUEXsfARodhaKyFnp7siCEB
        p8NVZwsZwSQOEDBdsj2C4/F+8NfVPOYpvBm8szOSSE4MrkSwONjzuCHHr0Fr/Zo0ghNxGjgW
        /VKRj4PxpgAlhuqhybeEImbA52OgvPKcVFx1DwQ7vLSI4yE45ojyyTBRW05FFgV8CmprXhW9
        5Qhc1jVK1KTDzcm/o97dUBv2RfWxMBuKE+fGQo2rkRRpOZSVKkS1BnqrBqIpSqgIdiIRc1DX
        XEyKb2VBEP71AapGz1qeOsfy1DmWjVgSPw8/elJF+gXoaPuTFPHr0Nu7TLUiSRdKEopMep1g
        etkgHNeaeL2pyKDT5hTobWjjp02Ex+67UWdwRTuECAYNIc2G+U7fDzeQkjIUGAR1gnwro+QV
        8sP8iS8EY8EhY1G+YBpCmxhKnST3OLsPKbCOPyp8JgiFgvFJl2BilMVExxsnPfD1KsrY6Z4e
        0+YmrNXlJFfjnJTMd6+rtlbvyNlWpjIad6X83MBo8uxfztU5M5fuDypDie26hty3G8zWxG6d
        fpQ87vv9SvPlN22yFzULsYmX3faM1LkseWln3DXr8PlHrpu30t/Knr/j4a/b89KYPmpo5BGz
        nLJXWjF8Q3L7YlLj6IX1ldzbUyd20YpgzW6P4+PxqiyzvLC+dGC6hPG3+ydi9yoHvB/i7H9K
        emc/MBM4/uHiV9ZLmaF/zd3j9i0lSVn3iNN39205qH7/pMI5NRcKOvI5x9J898xDWVnad4Gr
        lozqFlXbgcY9y8cO7pt5biEufOsAFw5O/PapmjLl8S+lkEYT/z8S46k+5AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7or26UTDRY+VLaYf+Qcq0X3KxmL
        jW9/MFlsenyN1eL+vZ9MFpd3zWGzmHF+H5PFzjknWS0WbOtjtGjde4TdYvOmqcwO3B6zGnrZ
        PLYdUPXYtKqTzePduXPsHpuX1Hv0vdzA6PF5k1wAe5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWF
        npGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexomOpawFT1Qqfs6cw9LA+FGui5GTQ0LARGLO
        zq3sXYxcHEICSxkl5nZ0s3YxcgAlpCRWzk2HqBGW+HOtiw2i5imjxLPta8Fq2AT0JNaujQCp
        ERGwlji6dT4zSA2zwF0mic4LC9lAEsICQRKT1rxlA6kXEnCTmL6PEyTMIqAqcfDGdVaQek6B
        PkaJF/vWMoMkeAXMJRZM/cEOYosKWEpseXGfHSIuKHFy5hMWEJtZIFvi6+rnzBMYBWYhSc1C
        kpoFtI5ZQFNi/S59iLC2xLKFr5khbFuJdevesyxgZF3FKJJaWpybnltsqFecmFtcmpeul5yf
        u4kRGI/bjv3cvINx3quPeocYmTgYDzGqAHU+2rD6AqMUS15+XqqSCK86h1SiEG9KYmVValF+
        fFFpTmrxIUZToN8mMkuJJucDE0VeSbyhmYGpoYmZpYGppZmxkjjv1rlr4oUE0hNLUrNTUwtS
        i2D6mDg4pRqY+K9trn+Qus2rNN2wP8CscXbxnUyG2L+vm4v+GW9JDmZ2vNnxUMD2ziEZLpv5
        b/sclnl8Unu8L3Kjn6xVzKrkK5wBhR5LeDPO7JywJ33B68sZOwITg889yAxfnHHq/feoxKXv
        1rkzvfBK8OqoeP7bdapXyx+ZqZlbe9RmfhF6XuJXs/nKIeutPU1dubNOGuxUtQtUXte/dK3P
        x6D/kov8/7fo392WcuTF/dsXneznRPx231U29+QtxgQGpUad25ttOIx8K79tTXfZLn7AU/S9
        IHcNs82lWZcOmzMx2kukFzdWPb+8YfuLBf3PsjL/uDqZTaqedN1H9v7x6weE/E1Pxk0Qv2SY
        dPB4/f2D97I8lViKMxINtZiLihMBRZcB11wDAAA=
X-CMS-MailID: 20210817095553eucas1p174e68fc6d7cfad9c2fd34f729272b01a
X-Msg-Generator: CA
X-RootMTR: 20210817095553eucas1p174e68fc6d7cfad9c2fd34f729272b01a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210817095553eucas1p174e68fc6d7cfad9c2fd34f729272b01a
References: <20210811084306.28740-2-krzysztof.kozlowski@canonical.com>
        <CGME20210817095553eucas1p174e68fc6d7cfad9c2fd34f729272b01a@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-08-11 =C5=9Bro 10:43>, when Krzysztof Kozlowski wrote:
> Convert Samsung Exynos SoC True Random Number Generator bindings to DT
> schema format using json-schema.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 45 insertions(+), 18 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5=
250-trng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5=
250-trng.yaml
>
> diff --git
> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> deleted file mode 100644
> index 5a613a4ec780..000000000000
> --- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -Exynos True Random Number Generator
> -
> -Required properties:
> -
> -- compatible  : Should be "samsung,exynos5250-trng".
> -- reg         : Specifies base physical address and size of the register=
s map.
> -- clocks      : Phandle to clock-controller plus clock-specifier pair.
> -- clock-names : "secss" as a clock name.
> -
> -Example:
> -
> -	rng@10830600 {
> -		compatible =3D "samsung,exynos5250-trng";
> -		reg =3D <0x10830600 0x100>;
> -		clocks =3D <&clock CLK_SSS>;
> -		clock-names =3D "secss";
> -	};
> diff --git
> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
> new file mode 100644
> index 000000000000..a50c34d5d199
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
> @@ -0,0 +1,44 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id:
> https://protect2.fireeye.com/v1/url?k=3Df38ca35b-ac179a0d-f38d2814-0cc47a=
31ce52-1faa1ecb65482b8a&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=3D=
http%3A%2F%2Fdevicetree.org%2Fschemas%2Frng%2Fsamsung%2Cexynos5250-trng.yam=
l%23
> +$schema:
> https://protect2.fireeye.com/v1/url?k=3D9409519d-cb9268cb-9408dad2-0cc47a=
31ce52-12394c4409905980&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=3D=
http%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
> +
> +title: Samsung Exynos SoC True Random Number Generator
> +
> +maintainers:
> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> +  - =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> +
> +properties:
> +  compatible:
> +    const: samsung,exynos5250-trng
> +
> +  clocks:
> +    maxItems: 1

How about copying description from above into the description: property?

> +
> +  clock-names:
> +    items:
> +      - const: secss
> +
> +  reg:
> +    maxItems: 1

ditto.

> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/exynos5250.h>
> +
> +    rng@10830600 {
> +        compatible =3D "samsung,exynos5250-trng";
> +        reg =3D <0x10830600 0x100>;
> +        clocks =3D <&clock CLK_SSS>;
> +        clock-names =3D "secss";
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4477215ef649..ebdb07a49b02 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16398,7 +16398,7 @@ SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG=
) DRIVER
>  M:	=C5=81ukasz Stelmach <l.stelmach@samsung.com>
>  L:	linux-samsung-soc@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> +F:	Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>  F:	drivers/char/hw_random/exynos-trng.c
>=20=20
>  SAMSUNG FRAMEBUFFER DRIVER

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmEbh6AACgkQsK4enJil
gBBrvwf+M6PmwkzlMcctBMq1Xv46ut5s4E/x2C+OeepW2+ZVAPhuikZRE6pYYUd2
wCEdxX32AleXoiYBTMb24B35+a6jv0fBOE0s+KtEKuEh+P0ctkAbvy3sdOoQrYG2
m7aGvnu02/46k/dW3BEAv1IMrBQ6A/vfHe3upB+Cxx6/Z8IFYzsdxmVMNgU+ECxJ
4yQnWzUgomfkZ8nb6qyGUI8Yo1MbAV84AyTOOlIJbr4nUBY54LaiSxbOtlvdGDn3
t8nc0G1dsF3cAS9Vj9cMjHe+dsdX0sTHIEirw38KbQ/mP/55hEQXqFiq1ZXU/aCx
pI5eEg8Ygz22vN2KshA1CG6UaHdtbQ==
=6rbg
-----END PGP SIGNATURE-----
--=-=-=--
