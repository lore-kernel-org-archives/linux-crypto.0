Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A39C83019
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 10:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636AE22202
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 10:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgLBKPS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:15:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56581 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbgLBKPR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 05:15:17 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201202101425euoutp02b70d6009f25ac7399b144b96418db465~M3rvZdphc1121611216euoutp025;
        Wed,  2 Dec 2020 10:14:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201202101425euoutp02b70d6009f25ac7399b144b96418db465~M3rvZdphc1121611216euoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606904065;
        bh=Mhxdc+RzUSvcSCv//OZka0Ay0RwlIDIhuS+44sjTf7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5tTCk+bwGR4HPBAm1p1ps0hLEYME5vyTt39oc2Vr8q99JGDnGmZ1NCRZmTDcBy5n
         3IAHXtqPeA2RACpf2NuqwbNW16lwaTVZlA36T1yCgEYa4YEAbWSLcQ0piQJteQpGl/
         7T6EfcdiLbpKT4WeTsVOxFcAwUrtIY+BBcoyj7EI=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201202101425eucas1p1e1e9584730137c6dcfec9b6dde55239d~M3rvIyUP71416114161eucas1p1_;
        Wed,  2 Dec 2020 10:14:25 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 34.79.44805.10967CF5; Wed,  2
        Dec 2020 10:14:25 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201202101424eucas1p103b713a5fe6faae36ce32180570c46c4~M3rujVEJd2988729887eucas1p1e;
        Wed,  2 Dec 2020 10:14:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201202101424eusmtrp105fbc6ba246abf42114737ed8e163b0d~M3ruirw6H1847018470eusmtrp1S;
        Wed,  2 Dec 2020 10:14:24 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-bd-5fc7690142d6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 24.62.16282.00967CF5; Wed,  2
        Dec 2020 10:14:24 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202101424eusmtip1a77e8cad8f71f5e611c47bcda6822d67~M3ruSbrc11249712497eusmtip1S;
        Wed,  2 Dec 2020 10:14:24 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     "Krzysztof Kozlowski" <krzk@kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hwrng: exynos - fix reference leak in
 exynos_trng_probe
Date:   Wed, 02 Dec 2020 11:14:10 +0100
In-Reply-To: <20201130130118.51339-1-miaoqinglang@huawei.com> (Qinglang
        Miao's message of "Mon, 30 Nov 2020 21:01:18 +0800")
Message-ID: <dleftjczzsecr1.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsWy7djPc7qMmcfjDY7cYbE4f34Du8Wmx9dY
        Le7f+8lkcXnXHDaLGef3MVkcbPV0YPNoOfKW1WPTqk42j81L6j0+b5ILYInisklJzcksSy3S
        t0vgyuiZtZm9YIN4xeKpvewNjG+Euxg5OSQETCTOrPjI3sXIxSEksIJR4sC0OawQzhcg5+ZZ
        qMxnRolbtx6zwbT833GKBSKxnFFiWetzKOc5o8SmPTOB+jk42AT0JNaujQBpEBHQlmi52Q02
        iVlgP6NE94t/YJOEBQIllpy/zgpiswioSqzbd5sJpJdToE5i9mFfkDCvgLnEz/XLwUpEBSwl
        try4zw4RF5Q4OfMJC4jNLJArMfP8G0aQ+RICLzgk/n1/DTZHQsBFYs4tPoijhSVeHd/CDmHL
        SJye3MMCUVIvMXmSGURrD6PEtjk/WCBqrCXunPsF9bCjxJe1EG9JCPBJ3HgrCLGWT2LStunM
        EGFeiY42IYhqFYl1/XugpkhJ9L5awQhR4iGxd3Y6JKAmMEo8PTqFdQKjwiwkz8xC8swsoBZm
        AU2J9bv0IcLaEssWvmaGsG0l1q17z7KAkXUVo3hqaXFuemqxUV5quV5xYm5xaV66XnJ+7iZG
        YAI6/e/4lx2My1991DvEyMTBeIhRBaj50YbVFxilWPLy81KVRHhZ/h2JF+JNSaysSi3Kjy8q
        zUktPsQozcGiJM6btGVNvJBAemJJanZqakFqEUyWiYNTqoFJRGTxLvfdXIZaUvcYT2ZdlOU+
        pLaX5bqd4QstPq5KVvcXK67Lx0yJyD6kZ8jiUCkYxR5x/LZPcPjHqQs4dszuaDDk6LKe0l9z
        ZAND8a965TqljpebbqYrZe099WzPgr9XfDtPlbOdaA/k3GuYeHLRPTcn2Tsvbk9mSu6Y+y/r
        YLRylufVVw7vpm2YPuvyXuP/R2brPgoyjNfSsGt3UVBoPbj7UnfAk30vdExXKeQLTjm75F2d
        5Vtllm9LHx85el1x7y7xRV+vLSl45dRd3+aqLXpjG0ebe9nplh1v4yb/Zp9XtcHqd6fSry+/
        GcSNZlw6XWAa9kz8yv3O2JXzDl/s+shQnGDygCdr4v3FljpdSizFGYmGWsxFxYkAlWwmz7sD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t/xu7oMmcfjDS6cl7A4f34Du8Wmx9dY
        Le7f+8lkcXnXHDaLGef3MVkcbPV0YPNoOfKW1WPTqk42j81L6j0+b5ILYInSsynKLy1JVcjI
        Ly6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy+iZtZm9YIN4xeKpvewN
        jG+Euxg5OSQETCT+7zjF0sXIxSEksJRRYtmuWYxdjBxACSmJlXPTIWqEJf5c62KDqHnKKHH0
        /H92kBo2AT2JtWsjQGpEBLQlWm52s4PUMAvsYZToXvOIGaRGWMBf4u1mT5AaIQEbiTkXpjKC
        2CwCqhLr9t1mAinhFKiT2PeAHSTMK2Au8XP9clYQW1TAUmLLi/tQcUGJkzOfsIDYzALZEl9X
        P2eewCgwC0lqFpLULKCpzAKaEut36UOEtSWWLXzNDGHbSqxb955lASPrKkaR1NLi3PTcYiO9
        4sTc4tK8dL3k/NxNjMDo2Xbs55YdjCtffdQ7xMjEwXiIUQWo89GG1RcYpVjy8vNSlUR4Wf4d
        iRfiTUmsrEotyo8vKs1JLT7EaAr02URmKdHkfGBc55XEG5oZmBqamFkamFqaGSuJ85ocWRMv
        JJCeWJKanZpakFoE08fEwSnVwJRkWLL0qWzuMr5P8yU+F3Avcs8qv/OcXeJfi1nsu90XmIK/
        /P0e9sZ52yG9c0orPFamyHj+kepaejzA+MavxCOPDtzSO9944Z2W0YyMa9q2okwzEg09NllW
        XVxw8LNV3Bve/LN8e7pyPl25uPOr4d87fevtG0uvcJX/ydq714134enFdxmUC+sDxe+YZ7N8
        ec7+7Ojn7T4eh7b1TZ12UDqF+2ihy0KjnYeuxr5M37NuWs7uw8yy2XLhIkVp29oT2G2lPof1
        /bhmKC/vMTez4eo+hvOCnFNa9yiI2mVZ8CwUNum02Nb08s1z6wn135muctfHcmZqmBmta3M5
        ePfh6VaXox36DbW9s/dqsrwTL1NiKc5INNRiLipOBAAwKvXBMwMAAA==
X-CMS-MailID: 20201202101424eucas1p103b713a5fe6faae36ce32180570c46c4
X-Msg-Generator: CA
X-RootMTR: 20201202101424eucas1p103b713a5fe6faae36ce32180570c46c4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201202101424eucas1p103b713a5fe6faae36ce32180570c46c4
References: <20201130130118.51339-1-miaoqinglang@huawei.com>
        <CGME20201202101424eucas1p103b713a5fe6faae36ce32180570c46c4@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-11-30 pon 21:01>, when Qinglang Miao wrote:
> pm_runtime_get_sync will increment pm usage counter even
> failed. Forgetting to putting operation will result in a
> reference leak here.
>
> Replace it with pm_runtime_resume_and_get to keep usage
> counter balanced. I remove err_clock label at the same.
>
> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Suggested-by: Lukasz Stelmach <l.stelmach@samsung.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  v2: remobe useless label as Lukasz suggested.

That is good too, but I meant using pm_runtime_resume_and_get() in
exynos_trng_resume() too. Please take a look at that function.

>
>  drivers/char/hw_random/exynos-trng.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 8e1fe3f8d..ffebb72e4 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -132,7 +132,7 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>  		return PTR_ERR(trng->mem);
>=20=20
>  	pm_runtime_enable(&pdev->dev);
> -	ret =3D pm_runtime_get_sync(&pdev->dev);
> +	ret =3D pm_runtime_resume_and_get(&pdev->dev);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Could not get runtime PM.\n");
>  		goto err_pm_get;
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
> @@ -164,9 +164,6 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>  err_register:
>  	clk_disable_unprepare(trng->clk);
>=20=20
> -err_clock:
> -	pm_runtime_put_sync(&pdev->dev);
> -
>  err_pm_get:
>  	pm_runtime_disable(&pdev->dev);

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/HaPIACgkQsK4enJil
gBD+uQf8D9x1XK5zm+GHPDtFS0L7rBggFvKmJhqXqVoDhLFX4QFJZO9M7MsDwUPT
FqPOYA5nmHr0m/YfqEFGhKnF89eJv9us+PkBGfm0YjAHUmbwBeb5Mp1TH6zJ2v2n
FWsHenglG6gRY6I4V1p1caRBtbtzgxadequIluMDBlZqM7bdbhGD1WDZ+P+y92wP
nBO/FECD2S6S5m0St7pUEsK+ZpXtvn2bo9UgvNx2ZCKe9T4yNwJCpdLyeQSKxdnZ
RYesge7F9MeJiex6/BrUMYlYXmWSu+SzDHBgGJdHUm3egHN86SR0NkWxRwSxcyux
uRWLL7UcmConTpEac3QaCN1mlB0pYw==
=IU3L
-----END PGP SIGNATURE-----
--=-=-=--
