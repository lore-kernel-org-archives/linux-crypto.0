Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FB2C2B9F8
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 14:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA76B6141C
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 14:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhEYOpK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 10:45:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46599 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhEYOpK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 10:45:10 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210525144338euoutp011d6b7a6d82612d777410f59b0c8104ae~CVmemTAIm2598525985euoutp017;
        Tue, 25 May 2021 14:43:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210525144338euoutp011d6b7a6d82612d777410f59b0c8104ae~CVmemTAIm2598525985euoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621953819;
        bh=kkc9ysLxGEi7UUM2hnd6yUQI+SCcM7OWBC4u6IwjEyQ=;
        h=From:To:Cc:Subject:In-Reply-To:Date:References:From;
        b=e7B2p2tueNhqrP+S1WWM9gyayPaZ66s7qrc5r8qktZLxnmn2EY0pt/zwMIFY/Z8av
         Icb7RPBIuIDPo+fv/mQCTYyzPoA4wj1oXVIbEWj54HALRq5HIO6YTkyr9IIVOX95Vs
         rIbcWa9YkemOJzxl5hgouI+KxSaQusempJTNb2Dk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210525144338eucas1p2f3d5df8f13f1a3b64239eee8e7039997~CVmeXhp0G0287602876eucas1p2D;
        Tue, 25 May 2021 14:43:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 2F.60.09452.A1D0DA06; Tue, 25
        May 2021 15:43:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210525144338eucas1p1ffe21ffce47146203dd1f6211a0e5408~CVmdyXqQM0831608316eucas1p1R;
        Tue, 25 May 2021 14:43:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210525144338eusmtrp2483d72c24f7ea365f86ed6b795fcc82c~CVmdxrd5i0598205982eusmtrp2P;
        Tue, 25 May 2021 14:43:38 +0000 (GMT)
X-AuditID: cbfec7f2-ab7ff700000024ec-99-60ad0d1a5f7a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F9.29.08696.91D0DA06; Tue, 25
        May 2021 15:43:37 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210525144337eusmtip2d521a81cdbd361753dcdffd05decd948~CVmdi1Q921124611246eusmtip2N;
        Tue, 25 May 2021 14:43:37 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     <krzysztof.kozlowski@canonical.com>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] hwrng: exynos: Use pm_runtime_resume_and_get() to
 replace open coding
In-Reply-To: <1621857218-28590-1-git-send-email-tiantao6@hisilicon.com>
        (Tian Tao's message of "Mon, 24 May 2021 19:53:38 +0800")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 25 May 2021 16:43:28 +0200
Message-ID: <dleftjcztezxf3.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsWy7djPc7pSvGsTDL41aFhsfPuDyWLT42us
        Fvfv/WSymHF+H5PF6tf72B1YPWY19LJ5PJ67kd1j85J6j8+b5AJYorhsUlJzMstSi/TtErgy
        9q7rZy9YwVfRM62qgXETTxcjJ4eEgInEnCdfWLoYuTiEBFYwSny6958RwvnCKDFrxQImCOcz
        o0T7vRlsXYwcYC3vXvBCxJczShxb+p4dwnnOKPH+7gRmkCI2AT2JtWsjQFaICKhKLGlazgpS
        wywwi1HizLGnrCAJYYF4ifXT3oA1cwo0M0p0PZ7EDJIQFbCU2PLiPjuIzQLUPaFnPthQXgFz
        iWPbwO7mFRCUODnzCQuIzSyQKzHz/BtGiH8ecEh83OkGcaiLxJcv1hBhYYlXx7ewQ9gyEv93
        zmeCKKmXmDzJDOQCCYEeRoltc36wQNRYS9w594sNwnaUaPk9nRmink/ixltBiK18EpO2wYR5
        JTrahCCqVSTW9e+BmiIl0ftqBdRhHhKPPlyGhhQwFN43TmSdwKgwC8kzs5A8MwtoLLOApsT6
        XfoQYW2JZQtfM0PYthLr1r1nWcDIuopRPLW0ODc9tdgwL7Vcrzgxt7g0L10vOT93EyMw7Zz+
        d/zTDsa5rz7qHWJk4mA8xKgC1Pxow+oLjFIsefl5qUoivH/7ViYI8aYkVlalFuXHF5XmpBYf
        YpTmYFES5101e028kEB6YklqdmpqQWoRTJaJg1OqgUnnsoBoxv+Fk5TqTcwmHP9mdMZ+09sK
        KZmVKm+idR+/8t9xb82bcga2+3NPJy7l0PHafvKCUrhpz7Vn9yZExn+bueVNxLRCZk95TaUl
        nRaz016dmNv5NdM7buHNtPVeUUJ2m406nhpPuqrZn/Qic51lSkNgkF7EAk2P/J6HCX1xt+/V
        SX37w2onVG1idDhsgp/ar9j9v2TWxjt9mXrGIvfC/UdvdhwK6cud9KjoxNHlv4MeFi0OPprE
        ufqWt+j/qXMMHi0L/1VoML/Zq2zy9VbhrQ/DOSbd2dDLs0Vj47qooikPDWeazRNf9MtupkbR
        ZPuWz72uH/6t3PrnFIu0lmvz37Dr29fsXzH/UdjJE/k+SizFGYmGWsxFxYkAhPxSMbYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t/xe7qSvGsTDJY3WVtsfPuDyWLT42us
        Fvfv/WSymHF+H5PF6tf72B1YPWY19LJ5PJ67kd1j85J6j8+b5AJYovRsivJLS1IVMvKLS2yV
        og0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQy9q7rZy9YwVfRM62qgXETTxcj
        B4eEgInEuxe8XYxcHEICSxkl3i5vYYWIS0msnJvexcgJZApL/LnWxQZR85RR4uDtbywgNWwC
        ehJr10aA1IgIqEosaVrOClLDLDCdUaL771xWkISwQKzExt33mUASnALNjBIbJ85gBEkICbhJ
        NH+YyAxiiwpYSmx5cZ8dxGYBmjShZz4zyAJeAXOJY9t4QMK8AoISJ2c+YQGxmQWyJb6ufs48
        gVFgFpLULCSpWUDdzAKaEut36UOEtSWWLXzNDGHbSqxb955lASPrKkaR1NLi3PTcYiO94sTc
        4tK8dL3k/NxNjMCo2Xbs55YdjCtffdQ7xMjEwXiIUQWo89GG1RcYpVjy8vNSlUR4//atTBDi
        TUmsrEotyo8vKs1JLT7EaAr0wURmKdHkfGA855XEG5oZmBqamFkamFqaGSuJ85ocWRMvJJCe
        WJKanZpakFoE08fEwSnVwCTN6B62eVrlEZFOTumYGK/nzFzXxMpZ/225+KTOv8D9Slv0p23s
        10MucD712+HKtOv7pyPrN6pyFAhqPSoL5O/R41R6FbNDQOnPPcOHRScqGvaIrnecLH7d6Iu3
        YaH0nwUF1g45xbp2d7u81Nd5iJioc31YcC36+13LPQveBqg77Hnzare4dH7j2yMR1ZPkRF7m
        tZdUMHfdv7rXQP4iz8aXNw5selbWvvRr4Yei893trJv314oYFG1qmvJjx749/ou8dhV8V2BZ
        fJL/SE3JDccwxriEDQarj6u3/Uyc/n6TfFQja+/JFP6thzcoRnHmypy703z8R2bFnkqWSbkd
        WUlSP6J/fdwV9Sht7a85M5VYijMSDbWYi4oTAYK6BeUvAwAA
X-CMS-MailID: 20210525144338eucas1p1ffe21ffce47146203dd1f6211a0e5408
X-Msg-Generator: CA
X-RootMTR: 20210525144338eucas1p1ffe21ffce47146203dd1f6211a0e5408
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210525144338eucas1p1ffe21ffce47146203dd1f6211a0e5408
References: <1621857218-28590-1-git-send-email-tiantao6@hisilicon.com>
        <CGME20210525144338eucas1p1ffe21ffce47146203dd1f6211a0e5408@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-05-24 pon 19:53>, when Tian Tao wrote:
> use pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. this change is just to simplify the code, no
> actual functional changes.
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
> v2: drop unnecessary change about if condition.
> ---
>  drivers/char/hw_random/exynos-trng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index c8db62b..9cc3d54 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -196,10 +196,9 @@ static int __maybe_unused exynos_trng_resume(struct =
device *dev)
>  {
>  	int ret;
>=20=20
> -	ret =3D pm_runtime_get_sync(dev);
> +	ret =3D pm_runtime_resume_and_get(dev);
>  	if (ret < 0) {
>  		dev_err(dev, "Could not get runtime PM.\n");
> -		pm_runtime_put_noidle(dev);
>  		return ret;
>  	}

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmCtDRAACgkQsK4enJil
gBCuvggAoayVKezXZk6q4SVacoUpczzrC9WgjDg8HVQ3kf4FgV8k4SKfm7T4nJQg
TElby85VrGFssGPk58IrZVK9OkfYg+ATUI+YYnS2HUKny1JeDuh4nIZXKNZvDJOD
A92k+fZl9hh9jSuFpF1cyKOsB9M2ZC2oGiwkrMIKVLC4IC8Mctj3CSYb58zTajmT
ScQb1vGl+swv1F2ty78DQ173Ul9+QV4fJMljxZ6JWvS0yDTNbx5ar6VhHeJyXZXJ
Qo7qWi8R/LJE4H3iciiZePivcTZa3UtSJmy5EzRbDb1cTBESi5jCvBqu74gmVsT0
8W7IhZrlO8zuU4uGUtKkdZfSXx1RmQ==
=hxUW
-----END PGP SIGNATURE-----
--=-=-=--
