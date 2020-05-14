Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD00C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 22:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFBC92065D
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 22:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TVGcXZQE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgENWS5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 18:18:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55436 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgENWS4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 18:18:56 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200514221853euoutp02113c0f063a871d2b9517a3b4cddd1a3d~PBQnqf9g30127801278euoutp02r;
        Thu, 14 May 2020 22:18:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200514221853euoutp02113c0f063a871d2b9517a3b4cddd1a3d~PBQnqf9g30127801278euoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589494733;
        bh=rR22A5xOUQkCsTKS2v4Szw5mFYUEuSL6BZh5cpOEtCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVGcXZQE4PP8NJSbunKhKwHyqrpZgAZq2vwQo4lri+NEVebI7QaS6Q3bprLYB6jmJ
         B4nVZJkKL2Hl2ZIlQDL/HWQjXNWzRsn+cElBWbJzi/gRK4iKrkrmqxVtZKBhea4Bvw
         xGuqnOS3bZxMvMNohD0i4W6KBxVsbGwJiqmhvwQk=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200514221852eucas1p270814a796595b1c415fce58b12ca3a74~PBQnDeN-K0805108051eucas1p2H;
        Thu, 14 May 2020 22:18:52 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BB.64.60679.CC3CDBE5; Thu, 14
        May 2020 23:18:52 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200514221852eucas1p2bea169d0b4467b0ec9e195c6ac58a08a~PBQmcqPcs1280312803eucas1p2h;
        Thu, 14 May 2020 22:18:52 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514221852eusmtrp1fc09f23af23c009676e7827525ef4c53~PBQmbxlQ42198821988eusmtrp1i;
        Thu, 14 May 2020 22:18:52 +0000 (GMT)
X-AuditID: cbfec7f4-0e5ff7000001ed07-a3-5ebdc3cc9eb6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 79.01.07950.CC3CDBE5; Thu, 14
        May 2020 23:18:52 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200514221852eusmtip28b435aa7edc85b144ecc5446c7cd2863~PBQmQ9t4w2268422684eusmtip2Y;
        Thu, 14 May 2020 22:18:52 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Fri, 15 May 2020 00:18:41 +0200
In-Reply-To: <4493123.C11H8YMYNy@tauon.chronox.de> (Stephan Mueller's
        message of "Thu, 14 May 2020 22:20:26 +0200")
Message-ID: <dleftjtv0i88ji.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH8/ZceiArOW0xPEFjTNUPzg3xku3ViVGDyfthcVuWJcYEpMoJ
        KL2QHopgTAAVuWmFMjNaagbDKQKlUJpGEYSgUAFtCYO5LGqJsLnCFKJ4Adki5WDit9/7PM//
        /1zycpTqGhvLHTVkCSaDVqdhI2lv35z/83u3O5PjSwu34f+sfXLcWuVisPN8L40DJVcpPP/8
        jhyfrnOxuGxyFb4wPkXhQKBFjt3jvzM4+HhOhn9rd7C4KnBLhmsqJxhc47Ug/JetjcXPGycQ
        vjjopLHvbgm1W03ezVsRsQfvs+TFyIiM3LA/kpM6dxdLvN3ribuhhCVdl5rkpO1yHrF4GhCx
        hFoQcXlGaXJqoIghL92rv406GLkzVdAdzRZMm3alRKY7gkVM5ouYnIHaUZSPetSlKIIDfhv4
        umrkpSiSU/H1CCx/t8qkxyyCu2+tlPR4iaCtsVv2QXLJF2SlxFUEnu6O5aqnCBotvzKliONY
        Pg6czgNhQTS/AUaLfl4SULyfgYXqYSqcUPOJMFxWseRK8+vhwaMZNswRvBlCztASK/gvobC+
        CYV5Bb8dPP8E5VJcCf22CTrMFK8HW+BfFG4A/BgHo6/raGnURHjjql9mNUz6PHKJV8Fg5Tk6
        PCjweVBp/ULSnkPgdbxdrv8KHvrnWalmDzRbRAmj4I9nSqltFFi9P1FSWAHFZ1WScB00X+hY
        NomF85P1SGICT9orGOlUhQj6Q8VsOVpj/2gb+0fb2BdtqcXTudo3SeGNcKV2ipI4AZqbp+ka
        xDSgGMEs6tMEcYtBOB4navWi2ZAWd8Sod6PFTzv4v2/2OmpfONyDeA5pPlHEX+xMVjHabDFX
        34PWLTo9aWkcQrG0wWgQNNGK/a6bySpFqjb3hGAyHjKZdYLYg1ZytCZGsfWXUJKKT9NmCRmC
        kCmYPmRlXERsPqqaz4irGCqfmm1K7s3ea/imS1ZnbMgUCnX5rQWeDSlbB40JxcfnHp5MelBb
        3lmd8HX1/gXzionvNodOGe7YkqLdJkcG2zeubPmBqPz+P9XXZrRHvg+M997eNxYy7zj2+kxi
        8asf45UFO8la22c3clJPTCt3lU/nphTovD5vWfUbh4YW07WbP6VMovY96axssrwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUzMYRz33O/lLhxPV82z04yTiebqSu4pNBvjx8xsbTSlOvVbRXfH/e4a
        /lDTSJfizvJy0xTyUq6r63ZTLaUohEhlMZ2Xkq4cyxqJuOtm899nn7d9v9tHQIhKKbEgQ6Vl
        NSpFpoSeSXZMtfeveNzamBhmeAHxb2MbH9ect1DYXHifxJ351wn803WPj3OvWGhc4AzEpz6M
        ELizs5qPrR96Kezon+DhF/UXaXy+8w4Pl54ZoHCpvQjgwQu1NHZVDgBc3GEmcfuDfGKdHzP5
        0wgYk+MJzYx1d/OYOtMbPnPF2kQz9uYljLUin2aaSm7xmdqr2UyRrQIwRcPVgLHYekjm6KM8
        ivlmXbB9zi7pGo1ap2UXpqs57VpJvAyHS2VRWBq+Mkoqi5Dvjg6PlITGrEllMzOyWE1oTLI0
        /aIjj9o/Nu/go7IekANa/PTAR4DgSlTS7qD1YKZABMsBMnbXUHogcAtidLMkzevxQ7969bQH
        i+AgQG8LF3ksNJQisznOQ/vDZagn79J0DQHrKfS6oJfyCH5wA+oqMPC8WRkaLH5OejAJl6CX
        b75Od/pAHeoa6Jn2C6EcHbtxC3hwAIxCtk8Ovpf3RQ8vDExnCbgPjVcOEacBNP0nmf6TTO7z
        CPdNlvpQLx2CrpWNEF68FlVVfSFLAVUB/Fkdp0xTcuFSTqHkdKo0aYpaaQXuRdjbJmy3gd4V
        2wKgAEhmC8OKGxNFlCKLO6RsAUHumvfVlc+AmFSpVazEX7jN0pAoEqYqDh1mNeokjS6T5VpA
        pPtPAyEOSFG7t6bSJskiZXIcJZNHyCNWYck84Ql4N0EE0xRadh/L7mc1/3I8gY84B0S0OU2f
        C2fZjw/7FG0NWt/BG4VcnCv3T33doO/ZDsO7jxNVfbFnVmc/7fqh2PM6OlA+N1se//bL3gP2
        PlHr9l+bgxcXbopzpY4GZn2/d9m4zvQ0JqD76NKGGc3JfUPOqyenjsxw7FDvnH8ueOO4apIi
        ht/3v9KFlJv7tnBVTnO/PUFCcukK2XJCwyn+AksQd5szAwAA
X-CMS-MailID: 20200514221852eucas1p2bea169d0b4467b0ec9e195c6ac58a08a
X-Msg-Generator: CA
X-RootMTR: 20200514221852eucas1p2bea169d0b4467b0ec9e195c6ac58a08a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200514221852eucas1p2bea169d0b4467b0ec9e195c6ac58a08a
References: <4493123.C11H8YMYNy@tauon.chronox.de>
        <CGME20200514221852eucas1p2bea169d0b4467b0ec9e195c6ac58a08a@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-14 czw 22:20>, when Stephan Mueller wrote:
> Am Donnerstag, 14. Mai 2020, 21:07:33 CEST schrieb =C5=81ukasz Stelmach:
>
> Hi =C5=81ukasz,
>
>> The value has been estimaded by obtainig 1024 chunks of data 128 bytes
>> (1024 bits) each from the generator and finding chunk with minimal
>> entropy using the ent(1) tool. The value was 6.327820 bits of entropy
>> in each 8 bits of data.
>
> I am not sure we should use the ent tool to define the entropy
> level. Ent seems to use a very coarse entropy estimation.
>
> I would feel more comfortable when using other measures like SP800-90B
> which even provides a tool for the analysis.
>
> I understand that entropy estimates, well, are estimates. But the ent
> data is commonly not very conservative.
>
> [1] https://github.com/usnistgov/SP800-90B_EntropyAssessment

Thank you for pointing this out.

I am running tests using SP800-90B tools and the first issue I can see
is the warning that samples contain less than 1e6 bytes of data. I know
little about maths behind random number generators, but I have noticed
that the bigger chunk of data from an RNG I feed into either ent or ea_iid
the higher entropy they report. That is why I divided the data into 1024
bit chunks in the first place. To get worse results. With ea_iid they
get even worse (128 bytes of random data)


    Calculating baseline statistics...
    H_original: 4.107376
    H_bitstring: 0.795122
    min(H_original, 8 X H_bitstring): 4.107376

but I don't know how much I can trust it, when I get such warning

    *** Warning: data contains less than 1000000 samples ***

ea_non_iid refuses to run tests with less than 4096 bytes of input.

I may suspect that lack of any warnings from ent doesn't make its
results any more reliable.

Anyway. I collected 1024 files 1024 bits each once again and ran the
following tests

    for f in exynos-trng/random*; do ./ea_iid "$f" | grep ^min; done |  sor=
t | head -1
    for f in rng200/random*; do ./ea_iid "$f" | grep ^min; done | sort | he=
ad -1

For both RNGs I got the same

    min(H_original, 8 X H_bitstring): 3.393082

which, if I understand correctly, means I should set quality to no more
than 434. Do you think 400 is OK?

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl69w8EACgkQsK4enJil
gBAD8Af+LvZdn8Fw/X6/tSiafy71HqYR+D46Lw0UDAMhxa1NRzgqKrtKQGI0mz+8
Gb1qXS+z9vpyvTO0Ce0Gf6eWcB3kQodMqjvIgHsgIMuyMgkktU46YHvFf0jvDmj6
d0KEg26AOK9s5ddg3f55xkyqF7MF/DOBrZtD8qlRp5NEvkW7ck+124zuVuwhrytL
04pUg7t31/azHtgG+eGK90HphjFxztN0iEYEEGDMqwGmjPq5Q0tXN9s7nP+eeSBQ
T4F33Gm7YzZXJ6yVtc+EXJ4xCReJRy+7tbVXSWl46EemRYE4MmMoVtypKACYB9d9
6WQGMTydZNXsZOpyaSsQznVBhiZpCA==
=/qef
-----END PGP SIGNATURE-----
--=-=-=--
