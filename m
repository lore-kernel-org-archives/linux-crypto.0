Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DB4C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 11:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C4261435
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 11:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhDVLXB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 07:23:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44107 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbhDVLXB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 07:23:01 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210422112225euoutp02427c8890c1aba27d8b4efa770551ef51~4KkXqEemK1041110411euoutp02N;
        Thu, 22 Apr 2021 11:22:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210422112225euoutp02427c8890c1aba27d8b4efa770551ef51~4KkXqEemK1041110411euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619090545;
        bh=RCk1c5nb42Yq1gBpLLt/4jM+gh8BHprbEbMGJXNMcE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObVyxZ4o74LLIUJKcZ3IucQ2i8V5EF5NrytYeyjQi7NkcZNE0E+6GKWr3qowqfxdL
         QfChP1JMsWCtVWz2w/DezobzpWmT/sRVcHxlSHORgZxda4fpFSv7fqUQGJy/nRqm4e
         Lz9/ohxAnuX7IH3FcQnb61Tyfvu1jD7e1kZshcH0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210422112225eucas1p150a9b8a1313a3b1c8af0977505fb3ae7~4KkXWvk510065600656eucas1p1j;
        Thu, 22 Apr 2021 11:22:25 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id FE.9E.09439.17C51806; Thu, 22
        Apr 2021 12:22:25 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210422112224eucas1p283ca7aeaa25ab514b9743a11e63a76e0~4KkWUNTTJ2841528415eucas1p2L;
        Thu, 22 Apr 2021 11:22:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210422112224eusmtrp29969c9fb814fdec203d72ff0076a98bf~4KkWTX0OP2526525265eusmtrp2m;
        Thu, 22 Apr 2021 11:22:24 +0000 (GMT)
X-AuditID: cbfec7f5-c03ff700000024df-3b-60815c71c257
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 96.4D.08705.07C51806; Thu, 22
        Apr 2021 12:22:24 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210422112224eusmtip16d4de17ccd0641dc71958986bd0756be~4KkWGSUZ61838218382eusmtip1e;
        Thu, 22 Apr 2021 11:22:24 +0000 (GMT)
From:   =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkie?= =?utf-8?Q?wicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Thu, 22 Apr 2021 13:22:15 +0200
In-Reply-To: <bc20ae4c-3e62-7b07-506c-ce8d90f65754@canonical.com> (Krzysztof
        Kozlowski's message of "Thu, 22 Apr 2021 12:46:42 +0200")
Message-ID: <dleftj35vi7ee0.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7djP87qFMY0JBuvfilpsnLGe1aL7lYzF
        xrc/mCw2Pb7GanH/3k8mi8u75rBZzDi/j8li7ZG77BYLtvUxOnB6zGroZfPYdkDVY/OSeo++
        LasYPfpebmD0+LxJLoAtissmJTUnsyy1SN8ugStj2vnljAVX+SoenVzP3MDYxNvFyMkhIWAi
        caF/IlMXIxeHkMAKRonmJ+uZIZwvjBLTO1exQzifGSUmnz3NCNPS9+gaI0RiOaPEzym9UC3P
        GSUWf97CAlLFJmAv0X9kH5gtImAtcXTrfLAiZoFnTBKv3u9gAkkIC3hKzG4+xApiswioSlza
        dQCsiFOgg1Hi88ceNpAEr4C5xN6Ff8AmiQpYSmx5cZ8dIi4ocXLmE7A4s0CuxMzzb8BukhDo
        5pTY/bORGeJYF4kn51pZIWxhiVfHt7BD2DIS/3fOB7qCA8iul5g8yQyit4dRYtucHywQNdYS
        d879YoOwHSV2tz5mh6jnk7jxVhBiL5/EpG3TmSHCvBIdbUIQ1SoS6/r3QE2Rkuh9tQIadB4S
        v+8cYoGE1hRGiQVLNrNPYFSYheSdWUjemQU0lllAU2L9Ln2IsLbEsoWvmSFsW4l1696zLGBk
        XcUonlpanJueWmycl1quV5yYW1yal66XnJ+7iRGYuk7/O/51B+OKVx/1DjEycTAeYlQBan60
        YfUFRimWvPy8VCUR3rXFDQlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeXdtXRMvJJCeWJKanZpa
        kFoEk2Xi4JRqYNLdfLjuYF3wrCcPbMyezdMxeSj2KPHZ7uS0vdn7PooXFYSf+eXH+XXpxC0B
        K4uV/tw1zp0rc08pJH9LL++0HqX4GX2CfOvV779SjX5nYTqpPaXjx5l7R/ZPOMbydbuMIsNO
        S8a+2UJzsqyVqn95dLGtbRXk9L76V6yy2l1d3PPBLmbR0AU7PDLNFl/ua+cQlpl93HXf56uv
        Vnoar1dpvb2cc2av2XzXtJsP2OwErWZPumDLtC1k4pmYI/s6rj9ayyGnXPUs+Oj26zdDBO/O
        2nTijF997avU6TNPX26aLRt548XfK6Jrcj7zCamxrBFd+G7pbLVZppqz/tSzGs06v9G2zYq5
        fvfW5rnl/xPXTUtUYinOSDTUYi4qTgQAdBdfAdgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t/xu7oFMY0JBqtnClhsnLGe1aL7lYzF
        xrc/mCw2Pb7GanH/3k8mi8u75rBZzDi/j8li7ZG77BYLtvUxOnB6zGroZfPYdkDVY/OSeo++
        LasYPfpebmD0+LxJLoAtSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384m
        JTUnsyy1SN8uQS9j2vnljAVX+SoenVzP3MDYxNvFyMkhIWAi0ffoGmMXIxeHkMBSRokFryay
        dzFyACWkJFbOTYeoEZb4c62LDaLmKaPEx3Nz2UESbAL2Ev1H9rGA2CIC1hJHt85nBiliFnjB
        JHH/2S1WkISwgKfE7OZDYLaQgIPEhAubmEBsFgFViUu7DoA1cAp0MEp8/tjDBpLgFTCX2Lvw
        D9hUUQFLiS0v7rNDxAUlTs58AhZnFsiW+Lr6OfMERoFZSFKzkKRmAT3BLKApsX6XPkRYW2LZ
        wtfMELatxLp171kWMLKuYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIy6bcd+bt7BOO/VR71D
        jEwcjIcYVYA6H21YfYFRiiUvPy9VSYR3bXFDghBvSmJlVWpRfnxRaU5q8SFGU6DfJjJLiSbn
        A9NBXkm8oZmBqaGJmaWBqaWZsZI479a5a+KFBNITS1KzU1MLUotg+pg4OKUamAwucwdHnfHN
        OMH2aA232q250UUxjWZ3xcPPiK2tkyxcFWb8RfxQzroVms0VV/PTZsv+Lf/H91KvvEkr9E62
        y0fZ5x9udNluTJGsfZzYxrfH1YOf/e+e518Es44L7mFuXf/qpivzi5QVO2efT7+3JcJckH/b
        Vsnn26f+lZUsen7R7IX0+XV7FJ/GJ/z2P/D4y2udCzqR97v3l1kJZGTEnjk2+/pM69OCnpvD
        fB/eelkZGtdnvPsWy+FnL0QklM+8+WN9+Ej9mueS5v3zVjwQbrE+YcC5K1Bu3Zd1DRUTnCWf
        tzZ1qFw8qcFrLsoqrs56RY/Z8ueZl1cTT/gaTraUWKJU8HOt14sSM/HIRWfLSpRYijMSDbWY
        i4oTAVutjQhPAwAA
X-CMS-MailID: 20210422112224eucas1p283ca7aeaa25ab514b9743a11e63a76e0
X-Msg-Generator: CA
X-RootMTR: 20210422112224eucas1p283ca7aeaa25ab514b9743a11e63a76e0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210422112224eucas1p283ca7aeaa25ab514b9743a11e63a76e0
References: <bc20ae4c-3e62-7b07-506c-ce8d90f65754@canonical.com>
        <CGME20210422112224eucas1p283ca7aeaa25ab514b9743a11e63a76e0@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-04-22 czw 12:46>, when Krzysztof Kozlowski wrote:
> On 22/04/2021 12:41, =C5=81ukasz Stelmach wrote:
>> pm_runtime_get_sync() increments the runtime PM usage counter even
>> the call returns an error code. Thus a pairing decrement is needed
>> on the error handling path to keep the counter balanced.
>
> It's exactly the same as Dinghao's patch:
> https://lore.kernel.org/linux-samsung-soc/20200522011659.26727-1-dinghao.=
liu@zju.edu.cn/
> which you reviewed. It has even the same commit msg
> (although it's difficult to be creative here).
>
> I think it's better to resend his patch instead.

It isn't the same because it uses pm_runtime_put_noidle() as discussed
here[1], applied here[2] and advised here[2]. Dinghao didn't prepare
v3[4] for exynos.

[1] https://lore.kernel.org/lkml/20200528065519.GA26960@gondor.apana.org.au/
[2] https://lore.kernel.org/lkml/20200528072106.5191-1-dinghao.liu@zju.edu.=
cn/
[3] https://lore.kernel.org/lkml/20200616073142.GA30519@gondor.apana.org.au/
[4] https://lore.kernel.org/lkml/20200522011659.26727-1-dinghao.liu@zju.edu=
.cn/
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmCBXGcACgkQsK4enJil
gBC41wf+I2Ag6/aoSYFbS2TtgUWe6hv82FUuQNh+9N3E1lPAGI0qh5cw5v+8/tt1
bzBh8rbyt4d/fr596hjueX2rZJwr98GCb8JRAvPczqXRysEnFlspW/GoeOaDVy8l
tTPJq6PgNtqTVIx/C5xPoJXG9C8dO3Ozhvkb7CTIbVRTRvLAhm4B7307pv0rKobX
+Ho4RCh+FtmpuIuTvwoUMG//I6cO+Oa5rbDjxK0YpEVc5vwVABYKo/JlvyyDp2pe
vrSfuvVJ60ASoXysTfWax6FHa4hX2/1w86JT7CDQVH5JSI7yW9V/8Rg/dYxTpdee
j5TXdZqMkGkVGUrhJ32USAj2EWvAzA==
=ajv9
-----END PGP SIGNATURE-----
--=-=-=--
