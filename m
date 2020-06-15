Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1554AC433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 13:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3F22074D
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 13:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N8PBRNBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgFONTV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:19:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49302 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730241AbgFONTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 09:19:18 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200615131916euoutp011d38515942b39713ac1d2dc174e6aaed~YuimTRvJm1674416744euoutp01a;
        Mon, 15 Jun 2020 13:19:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200615131916euoutp011d38515942b39713ac1d2dc174e6aaed~YuimTRvJm1674416744euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592227156;
        bh=00ri6SjJ/Rg0Aq+3qPbzYS+SXvTUwFNZD2ZH7+gh94E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8PBRNBYjNMTegmSoc8kZy+p8dMQ83Y6g66tLj2fS+X3gd1QRzH//38ZCuyimf11y
         9dnTdyMqImSGISkG3pNzkhAyvvdJJi4VsUJSjdbI7H2ZGnWxIztOuXdt84Gm0nfh+c
         7UAYB9SGMpgBgIQwpDQSVLSdh6ENQpe65U/4S8tA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200615131915eucas1p1796b65e90b8a159402861ec28b7337ab~YuimC0hnP3201032010eucas1p1K;
        Mon, 15 Jun 2020 13:19:15 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 56.27.60679.35577EE5; Mon, 15
        Jun 2020 14:19:15 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200615131915eucas1p2b8f3fa0ceb757e36aa888a4476de034f~YuilpaNVb1888918889eucas1p24;
        Mon, 15 Jun 2020 13:19:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200615131915eusmtrp172486c8255f4901a8088cd62f8f10c53~YuilooOqc1483814838eusmtrp1-;
        Mon, 15 Jun 2020 13:19:15 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-f8-5ee77553f2b3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D9.DE.07950.35577EE5; Mon, 15
        Jun 2020 14:19:15 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200615131915eusmtip2d89aa304f9db47fdd67564bdbdeeea88~YuilfCWxZ0995509955eusmtip2L;
        Mon, 15 Jun 2020 13:19:15 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     wu000273@umn.edu, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: hw_random: Fix a reference count leak.
Date:   Mon, 15 Jun 2020 15:18:54 +0200
In-Reply-To: <20200613214128.32665-1-wu000273@umn.edu> (wu's message of
        "Sat, 13 Jun 2020 16:41:28 -0500")
Message-ID: <dleftjr1uglb5t.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH/e3ebdfVjV/XpINFyHJRRlr2ulJKSsT9I8JeYFLWqotK25TN
        WQahKWSaOlNCXQ8fhTPNaatGLbEwH5XoKlF7WFIa062HpVRqWc5r4H+fc873nPM9P34UwQyL
        fag4TSKv1ShVcomMtLaMdazarXdEr7Z1L2f/5LdI2fSrtRL2nHMxa+h3EezjK+1S1m6vk7KW
        /m4x2/duTMR22i5J2CJ7g4gtteYi9u9Eh5jNaT4t2UJzE+P5iLM+VHCWqkwJ9+DyDSl361oK
        Z7q3jssdqkNcV1malBuxLInwjJJtPsqr4pJ4bWDoIVlsXnNEwmfmRLUhXZKKinAW8qQAr4Oh
        zDQiC8koBlciqDUMiIRgFMHri4VICEYQFL8vkfxvMVkHkJsZbELw7MYpQeRAUFNfK85CFCXB
        AVBTE+nWLMChYDFZp1cQ+BwBBdkOwl3wwmHw5OkX0s0kVkDf1Sapmz2xCsx1FSI303gjfP94
        f3qZNw6G24N9UiE/H54UD0z3ElgNxfZP004Bn6cgp+oVEpxuBUPziEhgL3C23pYKvBjaCrJJ
        t1HAKVCQv0HozUZgvfSLFDSboLdjfObiMCjpuSUW9PPg5ef5wt55kG8tJIQ0DWfPMILaD8yG
        +pkpPpDjrJxxw8FP13NSeKtMBC/S2kV5yNc46xzjrHOMU2MJvAJqbYFCeiVUlLkIgUPAbP5K
        liJxFVrI63XqGF4XpOGPB+iUap1eExNwJF5tQVN/r22ydfQusv0+3IgwheRz6chdjmhGrEzS
        Jasbkd/UpA911c+QD6mJ1/DyBXR4e1s0Qx9VJp/ktfEHtXoVr2tEiyhSvpBeWz50gMExykT+
        GM8n8Nr/VRHl6ZOKjgPNeIQEz9k219qT2rvHa9kbxU4Xk/foZcX9I7GqkPD23r101ElFbtDK
        fREJ6RmjY+WTkya5Sz5Y8davadAY8620IepRZ9z4j0j/iO1v3jqMQRf879Qbu5PWd8l+NAx5
        3PXdoUiyk5szCp1gLPJ+UZASsD+7a/fw0psdRu+wP9flpC5Wucaf0OqU/wAgRq1BgwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xe7rBpc/jDI6t47f4O+kYu0Xz4vVs
        Ft2vZCz6H79mtjgx7yy7xfnzG9gtNj2+xmpx/95PJovLu+awWcw4v4/JYsG2PkaL/7/PsVr0
        Hm1kc+D1+P1rEqPHtgOqHptWdbJ57J+7ht1j85J6j+U7TTz6Xm5g9Li6sInd4/MmuQDOKD2b
        ovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2MCUcDCt4K
        Vazub2ZrYJwh0MXIySEhYCKxfNsTxi5GLg4hgaWMEuvudbN3MXIAJaQkVs5Nh6gRlvhzrYsN
        ouYpo8SU+3cYQWrYBPQk1q6NAKkREbCT2LR8GzNIDbNAI7PEwdl/WEASwgKOEidPvQOzhQRM
        JVYf2sIEYrMIqErcX3yEHcTmFMiReDPvNSOIzStgLvHp6W4wW1TAUmLLi/vsEHFBiZMzn4DN
        YRbIlvi6+jnzBEaBWUhSs5CkZgGdxyygKbF+lz5EWFti2cLXzBC2rcS6de9ZFjCyrmIUSS0t
        zk3PLTbSK07MLS7NS9dLzs/dxAiM2W3Hfm7Zwdj1LvgQowAHoxIPb0TQ8zgh1sSy4srcQ4wq
        QGMebVh9gVGKJS8/L1VJhNfp7Ok4Id6UxMqq1KL8+KLSnNTiQ4ymQH9OZJYSTc4Hppm8knhD
        U0NzC0tDc2NzYzMLJXHeDoGDMUIC6YklqdmpqQWpRTB9TBycUg2MZXNEG6+FtO1yUr3qabvs
        mEnuTZ/v53UqWKr6n1xdrlj36cjpZ0mrbVQ+2bpXvZ17aNp5OcNznYwelxZzfJvnnO4k/rZt
        X1iXhYTR1tln80KDetc3LE8+P0F544qq89t3mYrN/+EaoSC+OMPzzuczx2JP60isrV50fbHk
        JY/0l2kPlx9/9dhSTomlOCPRUIu5qDgRAAhbSw37AgAA
X-CMS-MailID: 20200615131915eucas1p2b8f3fa0ceb757e36aa888a4476de034f
X-Msg-Generator: CA
X-RootMTR: 20200615131915eucas1p2b8f3fa0ceb757e36aa888a4476de034f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200615131915eucas1p2b8f3fa0ceb757e36aa888a4476de034f
References: <20200613214128.32665-1-wu000273@umn.edu>
        <CGME20200615131915eucas1p2b8f3fa0ceb757e36aa888a4476de034f@eucas1p2.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-06-13 sob 16:41>, when wu000273@umn.edu wrote:
> From: Qiushi Wu <wu000273@umn.edu>
>
> Calling pm_runtime_get_sync increments the counter even in case of
> failure, causing incorrect ref count if pm_runtime_put_sync is not
> called in error handling paths. Thus replace the jump target
> "err_pm_get" by "err_clock".
>
> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>
> ---
>  drivers/char/hw_random/exynos-trng.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 8e1fe3f8dd2d..ffa7e0f061f0 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -135,7 +135,7 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>  	ret =3D pm_runtime_get_sync(&pdev->dev);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Could not get runtime PM.\n");
> -		goto err_pm_get;
> +		goto err_clock;
>  	}
>=20=20
>  	trng->clk =3D devm_clk_get(&pdev->dev, "secss");
> @@ -166,8 +166,6 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>=20=20
>  err_clock:
>  	pm_runtime_put_sync(&pdev->dev);
> -
> -err_pm_get:
>  	pm_runtime_disable(&pdev->dev);
>=20=20
>  	return ret;

I believe this fix has already been submitted

    https://lore.kernel.org/linux-arm-kernel/20200522011659.26727-1-dinghao=
.liu@zju.edu.cn/T/#u

It hasn't been applied though. Anyway, thank you for your work.

Herbert, could you take a look at the Dinghao's patch, please?
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7ndT4ACgkQsK4enJil
gBD/fgf+PrssB4H9APSVtgC1hd9Nwwi8U9rocQl1m7+V1pb7Vu9MFM4Hx1MRDHRr
mJZ5eW5fOHRVsU2z6ryFP1b7SjzPOjzvP+hItfGjwcbKXtCwwanaGxnHAbLsgYya
PS232AaRE6TShah294Y4LKyRK1b9rlebdrltcznt4ENzSPAadjOq/I1mqHBpz8My
yI45lWlJ7tFOokRtfwEWvUka4T/omtUbH27m7a2yVwGjmF45OAcqnxtqKNFlRPrS
j3+hIMwrNHq68s8o4YpPkj/K3OHFeFxgHLA+AUTvJrW3ZnKaPCstXoUCNMAPZJwV
aoev1fOx6RaRfte97fSLbNIi2m3sFw==
=UOtD
-----END PGP SIGNATURE-----
--=-=-=--
