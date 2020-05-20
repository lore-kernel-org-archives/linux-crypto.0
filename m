Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F18C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1254207D8
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 14:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="S8Cue+Vt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETOcP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 10:32:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47907 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgETOcO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 10:32:14 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200520143212euoutp0146d8734bdfb0951c00f3a830e80d90be~Qww3ZJoND2147721477euoutp01O;
        Wed, 20 May 2020 14:32:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200520143212euoutp0146d8734bdfb0951c00f3a830e80d90be~Qww3ZJoND2147721477euoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589985132;
        bh=OwUS0cq1oLEsjMCxXLMi+rfk4oqHeZVhLszgl/xO6oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8Cue+VtnXohCYgmbAB3vTJHl8wcHLpHgk0O8deQZZ4s1ao9OTmJsbp6uePrLPa7a
         Jb/bE8pa+/r2QBF1x4yXEy/YA82gFKG2JeX6Kd3E72iCfzSdX3PqvKLuevsWizxy8I
         JN9TRkal0XTHAlTZZx2MOYUqaKWWIL7T4zK8MG0k=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200520143212eucas1p1a5ad990bee7a07434384a79b7ac84891~Qww3FyCvP1912419124eucas1p1J;
        Wed, 20 May 2020 14:32:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 0C.26.61286.C6F35CE5; Wed, 20
        May 2020 15:32:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200520143211eucas1p21bd93be5c62726aa715db05bb6e7119b~Qww2ton0l1383613836eucas1p2J;
        Wed, 20 May 2020 14:32:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200520143211eusmtrp118b198357d909262b6250f67cd27f0f7~Qww2snWjC2728727287eusmtrp1V;
        Wed, 20 May 2020 14:32:11 +0000 (GMT)
X-AuditID: cbfec7f2-f0bff7000001ef66-d3-5ec53f6ce3e8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id B8.C9.07950.B6F35CE5; Wed, 20
        May 2020 15:32:11 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200520143211eusmtip165dc045c53f2e4711a914c093660cf52~Qww2hq-EB0678406784eusmtip1B;
        Wed, 20 May 2020 14:32:11 +0000 (GMT)
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
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Wed, 20 May 2020 16:31:59 +0200
In-Reply-To: <2041475.ybOAuNAZB8@tauon.chronox.de> (Stephan Mueller's
        message of "Wed, 20 May 2020 13:53:04 +0200")
Message-ID: <dleftj4ksa3cf4.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa1BMYRieb89lT42t01bTq2LMDjMu08Vo+NyZcTnufjAZIotTLu1mdtuI
        H6WwSio1xrZCkcrSxcoiSiKLJktiVrShTLVEcm1ddzuZ8e953+d53u953/kYQlpE+zNblHG8
        SimPkdHupOlOvyUoZmb9utBemxT/yr4jxhd05RQuPVRPYktqMYEd72+LccrpchoftAfizPa3
        BLZYKsTY2P6Uwm22fhF+XJVHY52lRoTzczoonG/KQPhN7kUavz/XgfCRhlISm++mErO8uR+O
        bMTp2xpprq+5WcRd1beKudPGGzRnqh3FGQ2pNHfj+Hkxd7EwkcuoNCAuo7sCceWVT0gu+b6W
        4j4Zhy/3WO0+bRMfsyWeV4XMWO++2f7xGb29RbaztqWLSELWwDTkxgAbBl+sZjoNuTNStgRB
        7617g8VnBGU3syih+ITA3N9O/7MkpxhEAlGMoCfvDBKKTgRV9nQiDTEMzQZDaekql8GHHQNP
        tCcHxhLsAwp+HmsiXIQ3Ox8KrEWkC5PsKLAdzqdc2I3VQIvlOHJhCTsJ9iaXDOh92clQ2dUm
        FvpecC+3Y8BLsArItbxDQrqXDLxzRLgyADsHrl+OENreYDdXigUcCA056aQgSYSc7ImuaMCm
        IzDlfScFzVR48cDhzCx24tnwcYGg9gBrj5fwpgdkm44SQlsCB/ZLBd9IKMu8PjjDHw7ZSwZj
        cVDcaxu85j4EWu15IguN0P+3iv6/VfTOsYTzbuVVIUJ7HBQVvCUEPB3Kyj6Q+YgyID9eo1ZE
        8+rxSn5HsFquUGuU0cEbYxVG5PyxDb/NfVfQl6YNdYhlkGyIhGHr10kpebw6QVGHRjonva44
        9xD5k8pYJS/zkRR4OmnJJnnCLl4VG6nSxPDqOhTAkDI/yYRT3WulbLQ8jt/G89t51T9WxLj5
        J6GE+tXhjWdbd0clhwVF2g1e6c3mlMzC554eFfebCmKrq0/Ghdb82cp0Lkn8ZWgM950Xop2d
        uX6bbljUiWvL+hboXlGjm301J4Z6xvtUdx9cEfqop2mKpbbGd6HX8jWP+i4tWmqV8UkPzXsW
        z9Vdcmju2iKTvrUX8xNXfqXqnmvCVgVkyUj1Zvn4sYRKLf8LfVnr27kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t/xu7rZ9kfjDF7NsLD4O+kYu8XGGetZ
        Ldb2HmWxON+5nNni17sj7BbNi9ezWXS/krHof/ya2eL8+Q3sFpseX2O1uH/vJ5PF5V1z2Cxm
        nN/HZLFg8hNWiwXb+hgtns7czGbxbvUTRoupp9eyWBw/0cnsIOzx+9ckRo9Z98+yeXy6coXJ
        Y+esu+weizftZ/PYdkDVY9OqTjaP/XPXsHtsXlLv0bdlFaNH38sNjB7rt1xl8Wg61c7q8XmT
        XABflJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7G
        q4832QpuKVUcuPWCuYHxhkwXIyeHhICJRFPzKqYuRi4OIYGljBIXrlwAcjiAElISK+emQ9QI
        S/y51sUGUfOUUWL2jzlgNWwCehJr10aA1IgIaEpcbZ8PVsMssItV4nb3NVaQhLCAu8TCG8tY
        QGwhAUOJs2t72EFsFgFViXsTF4DVcAqUSnz73s4EYvMKmEu0NK1gBrFFBSwltry4zw4RF5Q4
        OfMJ2BxmgWyJr6ufM09gFJiFJDULSWoW0HnMQDet36UPEdaWWLbwNTOEbSuxbt17lgWMrKsY
        RVJLi3PTc4uN9IoTc4tL89L1kvNzNzECk8S2Yz+37GDsehd8iFGAg1GJh5dD4GicEGtiWXFl
        7iFGFaAxjzasvsAoxZKXn5eqJMK7kB8ozZuSWFmVWpQfX1Sak1p8iNEU6M+JzFKiyfnAxJZX
        Em9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoHxGFdo58OHzJLOfzWk
        RWt2bJwZNm+/57k5ETM5uNXVRazcd65iTDbytfePMXsY+Z3LLVrvTkPFVaFtDOu7nZWzmeSe
        7Vhq5Far1Fdmee9EZrel51R5EZv/XYf6G5Q/BInwrluXIX/+7oS0ozee+D9fMeOSjuSl/zqy
        e37P3N6dP1XMK2FjTJ4SS3FGoqEWc1FxIgB9qUtkNAMAAA==
X-CMS-MailID: 20200520143211eucas1p21bd93be5c62726aa715db05bb6e7119b
X-Msg-Generator: CA
X-RootMTR: 20200520143211eucas1p21bd93be5c62726aa715db05bb6e7119b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200520143211eucas1p21bd93be5c62726aa715db05bb6e7119b
References: <2041475.ybOAuNAZB8@tauon.chronox.de>
        <CGME20200520143211eucas1p21bd93be5c62726aa715db05bb6e7119b@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-20 =C5=9Bro 13:53>, when Stephan Mueller wrote:
> Am Mittwoch, 20. Mai 2020, 12:44:33 CEST schrieb Lukasz Stelmach:
>> It was <2020-05-20 =C5=9Bro 11:18>, when Stephan Mueller wrote:
>>> Am Mittwoch, 20. Mai 2020, 11:10:32 CEST schrieb Lukasz Stelmach:
>>>> It was <2020-05-20 =C5=9Bro 08:23>, when Stephan Mueller wrote:
>>>>> Am Dienstag, 19. Mai 2020, 23:25:51 CEST schrieb =C5=81ukasz Stelmach:
>>>>>
>>>>>> The value was estimaded with ea_iid[1] using on 10485760 bytes
>>>>>> read from the RNG via /dev/hwrng. The min-entropy value
>>>>>> calculated using the most common value estimate (NIST SP
>>>>>> 800-90P[2], section 6.3.1) was 7.964464.
>>>>>=20
>>>>> I am sorry, but I think I did not make myself clear: testing
>>>>> random numbers post-processing with the statistical tools does NOT
>>>>> give any idea about the entropy rate. Thus, all that was
>>>>> calculated is the proper implementation of the post-processing
>>>>> operation and not the actual noise source.
>>>>>=20
>>>>> What needs to happen is that we need access to raw, unconditioned
>>>>> data from the noise source that is analyzed with the statistical
>>>>> methods.
>>>>=20
>>>> I did understand you and I assure you the data I tested were
>>>> obtained directly from RNGs. As I pointed before[1], that is how
>>>> /dev/hwrng works[2].
>>>=20
>>> I understand that /dev/hwrng pulls the data straight from the
>>> hardware. But the data from the hardware usually is not obtained
>>> straight from the noise source.
>>>=20
>>> Typically you have a noise source (e.g. a ring oscillator) whose data
>>> is digitized then fed into a compression function like an LFSR or a
>>> hash. Then a cryptographic operation like a CBC-MAC, hash or even a
>>> DRBG is applied to that data when the caller wants to have random
>>> numbers.

[...]

>>> In order to estimate entropy, we need the raw unconditioned data from
>>> the, say, ring oscillator and not from the (cryptographic) output
>>> operation.
>>=20
>> Can you tell, why it matters in this case? If I understand correctly,
>> the quality field describes not the randomness created by the noise
>> generator but the one delivered by the driver to other software
>> components.
>
> The quality field is used by add_hwgenerator_randomness to increase
> the Linux RNG entropy estimator accordingly. This is the issue.
>
> And giving an entropy rate based on post-processed data is
> meaningless.
>
> The concern is, for example, that you use a DRBG that you seeded with,
> say, a zero buffer. You get perfect random data from it that no
> statistical test can disprove. Yet we know this data stream has zero
> entropy. Thus, we need to get to the source and assess its entropy.

Of course, this makes sense.

>>> That said, the illustrated example is typical for hardware RNGs. Yet
>>> it is never guaranteed to work that way. Thus, if you can point to
>>> architecture documentation of your specific hardware RNGs showing
>>> that the data read from the hardware is pure unconditioned noise
>>> data, then I have no objections to the patch.
>>=20
>> I can tell for sure that this is the case for exynos-trng[1].
>
> So you are saying that the output for the exynos-trng is straight from
> a ring oscillator without any post-processing of any kind?
>
> If this is the case, I would like to suggest you add that statement to
> the git commit message with that reference. If so, then I would
> withdraw my objection.

Done. I will do some reaserch on iproc-rng200 and I will send v3 with
the altered commit message.


Thank you *very* much for your patience.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7FP18ACgkQsK4enJil
gBCRAgf+J9WxfSzraFFchLmdRn7xYXcLCU8fETKwyjVn8RuVgy2D4/5/wTlZkq4O
VA3mRSXTQp3fEUycd6boLFiyuv04760MnZqtLeTidosMTYlST38sPfQtCbb5jHlo
e38K3LRyBwvj63bVcUfNo75peiEd5Xk5xuSKBgi26r/vqjKGgMEUTymrmIdQncgU
DarqcJ1ZWdaLKKrQdlodneLOD+MhF/hRrFR4DSbM3ncmkrUV3foiVwcmyeo4w2E8
sULMXa2+j6hbiTSsciB0EJj1WR1nZxUnfXprGjDvVrrzgNwZdTaqc0aAYfohiSvi
tNmgrCY7BEQpS8o6/rVGQgEEdg/Bmg==
=5VuY
-----END PGP SIGNATURE-----
--=-=-=--
