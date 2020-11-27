Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4E8C64E75
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 14:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C35C32222C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 14:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sAh65u2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgK0O0z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 09:26:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36936 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730914AbgK0O0z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 09:26:55 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201127142643euoutp015eb2180f2a8015212b9379c4f4238220~LY5mAY2FV2449724497euoutp01k;
        Fri, 27 Nov 2020 14:26:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201127142643euoutp015eb2180f2a8015212b9379c4f4238220~LY5mAY2FV2449724497euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606487203;
        bh=GT6bHkH5AM/b8d1DPTQwWuOMDxDsIG+Mr1C8jD8cPCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAh65u2FY/oWU5LrF4IxdRAqxf+h+s7V96mh9P5ZL1wLc2obeJi7kPvclpodsvJJY
         sM8qcUjbRAiQoqj3gP/8vseMEMEq+JW/xeyPuHnnpD32NEWUjsFqx3mM6n1qIW7W1z
         +t5IVtSnC2phuC1ji3bj/rTVmQN2IpnEs5sGh/ig=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201127142637eucas1p16940dd8a579af9c5e3d002ca2d765532~LY5hMwiCD2889228892eucas1p1h;
        Fri, 27 Nov 2020 14:26:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 63.8A.27958.D9C01CF5; Fri, 27
        Nov 2020 14:26:37 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201127142637eucas1p1746be156c43e789b48b5b78b9b212a33~LY5gzF-bq0674006740eucas1p10;
        Fri, 27 Nov 2020 14:26:37 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201127142637eusmtrp1fc2240712fba58aaf7b0c1db722bc8e0~LY5gygMdA0570605706eusmtrp1L;
        Fri, 27 Nov 2020 14:26:37 +0000 (GMT)
X-AuditID: cbfec7f2-f15ff70000006d36-d7-5fc10c9dac2b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 12.E3.21957.D9C01CF5; Fri, 27
        Nov 2020 14:26:37 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201127142637eusmtip148f876af9de4814e87a1c345e3da8491~LY5gmQeWQ0868708687eusmtip1D;
        Fri, 27 Nov 2020 14:26:37 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     "Krzysztof Kozlowski" <krzk@kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwrng: exynos - fix reference leak in exynos_trng_probe
Date:   Fri, 27 Nov 2020 15:26:22 +0100
In-Reply-To: <20201127094446.121277-1-miaoqinglang@huawei.com> (Qinglang
        Miao's message of "Fri, 27 Nov 2020 17:44:46 +0800")
Message-ID: <dleftjlfemg9kh.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWy7djPc7pzeQ7GGxz+r21x/vwGdotNj6+x
        Wty/95PJ4vKuOWwWM87vY7I42OrpwObRcuQtq8emVZ1sHpuX1Ht83iQXwBLFZZOSmpNZllqk
        b5fAlXHwzEG2gqeCFXvXPWFsYFzH38XIySEhYCKx5EcjUxcjF4eQwApGif2b5rFDOF8YJT5c
        3soK4XxmlPi+ZwEjTMvBXduhWpYzSkw/dRfKec4osWTNZ7YuRg4ONgE9ibVrI0AaRAS0JVpu
        doONZRbYzyjR/eIfG0hCWMBHYvP5L2BTWQRUJWa/e8MOYnMK1Es0b2xmBpnDK2Ausf8M2BxR
        AUuJLS/ug5XwCghKnJz5hAXEZhbIlZh5/g0jyHwJgRccEveWz4O61EWifd08FghbWOLV8S3s
        ELaMxOnJPSwg8yWAdk2eZAbR28MosW3OD6h6a4k7536xQdiOEptvt7NC1PNJ3HgrCLGXT2LS
        tunMEGFeiY42IYhqFYl1/XugpkhJ9L5awQhR4iHxpRsauBMZJTpnP2GfwKgwC8k3s5B8Mwuo
        hVlAU2L9Ln2IsLbEsoWvmSFsW4l1696zLGBkXcUonlpanJueWmyYl1quV5yYW1yal66XnJ+7
        iRGYgk7/O/5pB+PcVx/1DjEycTAeYlQBan60YfUFRimWvPy8VCUR3gyOg/FCvCmJlVWpRfnx
        RaU5qcWHGKU5WJTEeVfNXhMvJJCeWJKanZpakFoEk2Xi4JRqYBItPcOwNN3P9OC3wLUhvd4e
        x9a8NnFVrez5KeW+f9p8ee+XomrHTgst2H/i6ol17ls/3yhne2R3Us3ncIn5V/5dW45+M0lf
        ZJAlvjvG2zBbzfJZqZFtpOmhDvHdh1LyZ/JPP/mkK6Pti1aum1hN5crmOVKMfA+2XHjZdr2s
        2iZ9ze0dZ4VOrgo8t0DGpm7qdNlY52cBEaf/ykR1Pg4puMokt4XhTOunTv7fR/bMaHzmtV2h
        XTRiway3lT2JBnGtecd/6RflsbzaYT77/6l5K4JOMBsv+CT3qzDH7Uncr12r3a8zlxzdKNSq
        tzF0Q/iSSSqTeRQfvry3eraanYWRdInpZ44VP69x3ptusnZ7X5sSS3FGoqEWc1FxIgB6qqGo
        vAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t/xu7pzeQ7GG9y8LWpx/vwGdotNj6+x
        Wty/95PJ4vKuOWwWM87vY7I42OrpwObRcuQtq8emVZ1sHpuX1Ht83iQXwBKlZ1OUX1qSqpCR
        X1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3HwzEG2gqeCFXvXPWFs
        YFzH38XIySEhYCJxcNd2pi5GLg4hgaWMEpOv3ANyOIASUhIr56ZD1AhL/LnWxQZR85RR4sT0
        zYwgNWwCehJr10aA1IgIaEu03OxmB6lhFtjDKNG95hEzSEJYwEdi8/kvjCC2kICtxMGZH9lB
        bBYBVYnZ796A2ZwC9RLNG5uZQWbyCphL7D8DNlNUwFJiy4v7YCW8AoISJ2c+YQGxmQWyJb6u
        fs48gVFgFpLULCSpWUCTmAU0Jdbv0ocIa0ssW/iaGcK2lVi37j3LAkbWVYwiqaXFuem5xYZ6
        xYm5xaV56XrJ+bmbGIHxs+3Yz807GOe9+qh3iJGJg/EQowpQ56MNqy8wSrHk5eelKonwZnAc
        jBfiTUmsrEotyo8vKs1JLT7EaAr02URmKdHkfGBk55XEG5oZmBqamFkamFqaGSuJ826duyZe
        SCA9sSQ1OzW1ILUIpo+Jg1OqganUzF3Z1ufjg8252bNMfBbmP3xvwrZyWVj85s1TpXSP6L4R
        cbphWmgpEt5yO+hx8nXZzY+ufDph2/3zspm+kk/7ktdZd89PWbH6Q7VGtpvG4+vZ9089sF/7
        1+8Re4PI+gf3571kYCj/zDPb/OaUTP3os6ufeLyoO3lZLeGCStSt4/9+HQ7+4G4mZ5R9q4x1
        7w3zDWeazssa37++8srzvE2fWNLvRnNU8L/u2dh65sMNLku9vM5f67wsHk1KsDzblto0sav0
        1qz8ZyfWKG140nnqcPiqH43VmQFpORnytUs3M1ke7ja2q31lPfeXWIn8y3k7FbP/XHU+oiZ1
        Yc7bQh2Vw5/4rgTEvty4dwPnnXtFSizFGYmGWsxFxYkAS47K8DQDAAA=
X-CMS-MailID: 20201127142637eucas1p1746be156c43e789b48b5b78b9b212a33
X-Msg-Generator: CA
X-RootMTR: 20201127142637eucas1p1746be156c43e789b48b5b78b9b212a33
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201127142637eucas1p1746be156c43e789b48b5b78b9b212a33
References: <20201127094446.121277-1-miaoqinglang@huawei.com>
        <CGME20201127142637eucas1p1746be156c43e789b48b5b78b9b212a33@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-11-27 pi=C4=85 17:44>, when Qinglang Miao wrote:
> pm_runtime_get_sync will increment pm usage counter even it
> failed. Forgetting to putting operation will result in a
> reference leak here.
>
> A new function pm_runtime_resume_and_get is introduced in
> [0] to keep usage counter balanced. So We fix the reference
> leak by replacing it with new funtion.
>
> [0] dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal wi=
th usage counter")
>
> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/char/hw_random/exynos-trng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 8e1fe3f8d..666246bc8 100644
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

Thanks. I suppose you may use the new function exynos_trng_resume(),
remove everything and leave only

return pm_runtime_resume_and_get(dev);

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/BDI4ACgkQsK4enJil
gBC84gf/RQRlC16akSq8M1l6MzThboXOhm8hf0nf1eIQQEJAzjURHJHDaSZNe7cn
M8Mi5zZ88C/MJ8on3YAQLTiS2i2Qpo8CZmFkKwMJT8TKYAeagn8noM6b72A1TROO
Ph0TxTTguS1i0p8dI2JjnF+yQ7Yt82HqfF0hGEUujkHqnI+PuAICRE9GBEoHOlDj
1hBXKMntWIUt6uhrKmaeZUN8FMaSMb75FckWyqImxtFGR590hfElOzxbTV7JQOkQ
WEASOak/L0qvvl7CWB/QTOjdlI2I/HfzfNCARiUaT5oah65joBCs6cYKKRA4jDXQ
rsf1EmUv1wEjI3zQfhJzILCWJ0YKuQ==
=mR4q
-----END PGP SIGNATURE-----
--=-=-=--
