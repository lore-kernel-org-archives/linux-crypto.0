Return-Path: <SRS0=VFM7=7E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1073CC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 09:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C957E207FB
	for <linux-crypto@archiver.kernel.org>; Fri, 22 May 2020 09:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pDqHzZ2N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgEVJHk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 May 2020 05:07:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49890 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgEVJHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 May 2020 05:07:39 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200522090737euoutp02fcebc4052c828f10adfaae263e9083eb~RToCAmEDm3252632526euoutp02d;
        Fri, 22 May 2020 09:07:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200522090737euoutp02fcebc4052c828f10adfaae263e9083eb~RToCAmEDm3252632526euoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590138457;
        bh=LAJlAB+Cl4QZToEXloGJT78LJ66J5myMnOOW1nh9Qhc=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=pDqHzZ2NDNTjaklpjSTBfU3XfCScZa2fXfsVH/Pc2664IlhWOH1JsRFI3QsCiBq5l
         kNuEBXuUu0bW0McSY1RMSng7Vy8wzGnjjBeSnp87PnhOemjePd18OXaXwG49IcXXrY
         DyA6rSNSafwsrgJq7GaWEzOaVTwfo3qT0VzvTICQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200522090737eucas1p163e418a4d66ff2b5eb8f7f071ca46d89~RToByECRN2903729037eucas1p1F;
        Fri, 22 May 2020 09:07:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 6B.36.60679.85697CE5; Fri, 22
        May 2020 10:07:36 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200522090736eucas1p1ad308b9b37d50d9243f0fbeeeb3eab0a~RToBeOF0B0435204352eucas1p1N;
        Fri, 22 May 2020 09:07:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200522090736eusmtrp1121791b9d914631c03aaf13a893bde84~RToBdcSaz1310913109eusmtrp1U;
        Fri, 22 May 2020 09:07:36 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-02-5ec79658ba3d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 90.46.08375.85697CE5; Fri, 22
        May 2020 10:07:36 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200522090736eusmtip269ccc5281a270cb5335b0ae711f262b7~RToBSCf9a1808618086eusmtip2X;
        Fri, 22 May 2020 09:07:36 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] [v2] hwrng: exynos - Fix runtime PM imbalance on error
In-Reply-To: <20200522011659.26727-1-dinghao.liu@zju.edu.cn> (Dinghao Liu's
        message of "Fri, 22 May 2020 09:16:59 +0800")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 22 May 2020 11:07:11 +0200
Message-ID: <dleftj1rncz6bk.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTQRiAM93t7lIsDgXlDyIxDRqPiGd0CXglPqz64iOaiFbdAJEW0gUU
        CQGPEC5Bi3IFD44oR4GCtZpqUGoEBWzrhUZRpCByWE0QUwVBKVsT377/+uafyTCEwiUNZGI1
        ibxWo4pTUjLS1P7LtjqyqCNq7a3BcHZa106zzSVNUva26xTJnqlqotjc0SC2YGCMYB9feUqz
        NpuBZlsGeqRs34dfEvaFuZxiS2ytEvaaKR9tl3NTkzrEmR4s5Vrqsinu/mU9zd2sTufyjXWI
        yx8xIO5VxWma+94SzGWbndRe2X5ZxFE+LjaZ167ZekgWk/lymEwYU5zIsmZJMtBZnIO8GMAb
        oWfiGZ2DZIwC1yAw2nM9wQSC6UmrJ/iOYHC6gfg3kj3+DImFGwj0w31SMfiMoDO3XpKDGIbC
        odDQEOke8MfL4e6n03MmArcR4LxqmTP54T2gsw9K3eyFU8H8egi5eQEOA+NwH+32kHgptFb7
        u9NyvBnOVBZKRPaFJ6WDpJsJrIZS25e5hQCXMmD6Ou7ZdCd0l9R62A9GO4y0yEHQVZhHuv2A
        06FQt0mczUNgKv9Jij3h0GudpETeAWUOIyH2+8Abp694rg/oTMWetByyMhVidwg0FtzzWALh
        3GgNEpmD5k6X56kKEHy88JY+j5aU/Xedsv+uUzarJfAKaDKvEdOr4HrFGCHyFmhs/EZeQ9I6
        FMAnCepoXliv4Y+HCiq1kKSJDj0Sr25Bs1+wa6Zj4g4y/z5sQZhBynnyj0faoxRSVbKQorag
        kFmTw1BvR4GkJl7DK/3lFfMfRSnkR1UpJ3lt/EFtUhwvWNAihlQGyDdUjhxQ4GhVIn+M5xN4
        7b+qhPEKzEAXVbt3D/Rus0tGpoIeGnwuDdVIq7am67vsSfuyau1h3vpkRwDrndG/yjGTZk3r
        K4g9+yjjcnxC+HyXEKzt77eSC7ctswgR27udcRfIIf3hVGVu9nuq/vafjm86g5DqLHY0bNiV
        aXGlPn6ODxb9aAv9TIQtfqAceuntNFLvbJVKUohRrVtJaAXVX9WfYm2KAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xe7oR047HGbz5omLxd9IxdouNM9az
        Wmz/3shi0bx4PZtF9ysZi/7Hr5ktTsw7y25x/vwGdotNj6+xWty/95PJ4vKuOWwWM87vY7JY
        sK2P0YHX4/evSYwe2w6oemxa1cnmsX/uGnaPzUvqPfq2rGL06Hu5gdHj6sImdo/Pm+Q8One9
        ZQvgitKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DL
        aLvygqXgtVBFx7kOpgbGFoEuRk4OCQETic5PFxm7GLk4hASWMkpcnruVuYuRAyghJbFybjpE
        jbDEn2tdbBA1Txkltv/8CFbDJqAnsXZtBEiNiICGxO6nTewgNcwCW5kl3n74yQqSEBbwlph0
        4QmYzSlQLbHr+jNGEFtIwFrizfHrzCC2qIClxJYX99lBZrIIqErsWyICEuYVMJdoXjSZCcIW
        lDg58wkLiM0skC3xdfVz5gmMArOQpGYhSc0CmsQsoCmxfpc+RFhbYtnC18wQtq3EunXvWRYw
        sq5iFEktLc5Nzy021CtOzC0uzUvXS87P3cQIjN9tx35u3sF4aWPwIUYBDkYlHt4HycfihFgT
        y4orcw8xqgCNebRh9QVGKZa8/LxUJRHehfxH44R4UxIrq1KL8uOLSnNSiw8xmgK9M5FZSjQ5
        H5hy8kriDU0NzS0sDc2NzY3NLJTEeTsEDsYICaQnlqRmp6YWpBbB9DFxcEo1MKZv/el+h6lV
        VmQLV9n0xlcb1ubKXi56OneChkGp3sUtNift5Ze6C+XEREW98/6TmzSZxevR0fStJ2odO2tz
        P6sE/bGRv7I/lOtwkOavnCk59gyhGe1patGLWnZo7ra69mdbYZsQo1iy4mVXBr+wx8ckHsyM
        YtJJPfKz30fy1Ya+i4tqQx8eU2Ipzkg01GIuKk4EAGVzO/UBAwAA
X-CMS-MailID: 20200522090736eucas1p1ad308b9b37d50d9243f0fbeeeb3eab0a
X-Msg-Generator: CA
X-RootMTR: 20200522090736eucas1p1ad308b9b37d50d9243f0fbeeeb3eab0a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200522090736eucas1p1ad308b9b37d50d9243f0fbeeeb3eab0a
References: <20200522011659.26727-1-dinghao.liu@zju.edu.cn>
        <CGME20200522090736eucas1p1ad308b9b37d50d9243f0fbeeeb3eab0a@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-05-22 pi=C4=85 09:16>, when Dinghao Liu wrote:
> pm_runtime_get_sync() increments the runtime PM usage counter even
> when it returns an error code. Thus a pairing decrement is needed on
> the error handling path to keep the counter balanced.
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>
> Changelog:
>
> v2: -- Remove unnecessary 'err_clock' label
> ---
>  drivers/char/hw_random/exynos-trng.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>

Reviewed-by: Lukasz Stelmach <l.stelmach@samsung.com>


Thank you.

> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 8e1fe3f8dd2d..8393b898a50e 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -142,13 +142,13 @@ static int exynos_trng_probe(struct platform_device=
 *pdev)
>  	if (IS_ERR(trng->clk)) {
>  		ret =3D PTR_ERR(trng->clk);
>  		dev_err(&pdev->dev, "Could not get clock.\n");
> -		goto err_clock;
> +		goto err_pm_get;
>  	}
>=20=20
>  	ret =3D clk_prepare_enable(trng->clk);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Could not enable the clk.\n");
> -		goto err_clock;
> +		goto err_pm_get;
>  	}
>=20=20
>  	ret =3D devm_hwrng_register(&pdev->dev, &trng->rng);
> @@ -164,10 +164,8 @@ static int exynos_trng_probe(struct platform_device =
*pdev)
>  err_register:
>  	clk_disable_unprepare(trng->clk);
>=20=20
> -err_clock:
> -	pm_runtime_put_sync(&pdev->dev);
> -
>  err_pm_get:
> +	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>=20=20
>  	return ret;

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl7Hlj8ACgkQsK4enJil
gBDRDgf/QL0m9IpHrTs4brf2dXxQomAaGUw4FEMmyibxtjTI29tkohcH6FEiXj6f
rsGopDupsB84vj4FRgBSTmOff68IzK754VUKTUO7PQIKO/nqnjcI6SnqJW0BcmQ5
7ufw3mcrIYdKzjHZJjepq71BWcxBe3rYhKO78Hi9QuMojn9M42bp/54EwYJ36ODR
Thvt66oRP3ktSqqjBBrsd+suPYn/Zr4eW553GsA/08EsV6PONcRx34NPdLwEd8oB
z/5TBNIdOHBwWLHjc+AOPhsPEQ+OZLw06++C4PnFKlkBX/RU7HZy5CTVQS3eyak/
0Rah/S9PSELxLUl6kBvYX/D5HrPpZA==
=9roz
-----END PGP SIGNATURE-----
--=-=-=--
