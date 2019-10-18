Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD945CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 15:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD59E222C6
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 15:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CJiEmw1n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442265AbfJRPFs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:05:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53293 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407595AbfJRPFs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 11:05:48 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20191018150545euoutp029cd55298ef2ac63c4c1e7b8f91e440dd~Oxhx14KIf2015020150euoutp02W
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2019 15:05:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20191018150545euoutp029cd55298ef2ac63c4c1e7b8f91e440dd~Oxhx14KIf2015020150euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571411145;
        bh=YSf90oubbg4unQOpAuECCf40F0OM9F8QucJcCB/f+dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJiEmw1nNkjcAPXStcym14pCxyhtdgwqnesvEGJUBEs+I0YO7obNnDxWPBLJVgYE7
         Ofa7hIbwLXaBuw00pBHbuGVt2tQaBFW9Hit0xogx3CzfLjw09NPUVZfwPxYpF8YGrl
         4x48bcrOVCchqGBT3OW58tbyDIt/eGlCvXgCcznM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191018150544eucas1p1c918ba86091f4c9117d11a9b1ae0391b~Oxhw4nJfk1657216572eucas1p1D;
        Fri, 18 Oct 2019 15:05:44 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 9D.27.04469.8C4D9AD5; Fri, 18
        Oct 2019 16:05:44 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191018150543eucas1p1cf4312467597ad7c76f258e924d8184a~OxhwWFemf1657216572eucas1p1C;
        Fri, 18 Oct 2019 15:05:43 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191018150543eusmtrp12c4596ecf9923ad48a9b0d6ecae06277~OxhwVHo-E3006030060eusmtrp1d;
        Fri, 18 Oct 2019 15:05:43 +0000 (GMT)
X-AuditID: cbfec7f2-54fff70000001175-92-5da9d4c81cca
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id B6.31.04166.7C4D9AD5; Fri, 18
        Oct 2019 16:05:43 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20191018150543eusmtip256c26151370cc6b0f534f783d16fa5fa~OxhwKE-eZ1582815828eusmtip2f;
        Fri, 18 Oct 2019 15:05:43 +0000 (GMT)
From:   =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <herbert@gondor.apana.org.au>, <mpm@selenic.com>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        <f.fainelli@gmail.com>, <rjui@broadcom.com>,
        <sbranden@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        <eric@anholt.net>, <wahrenst@gmx.net>, <kgene@kernel.org>,
        <krzk@kernel.org>, <khilman@baylibre.com>, <dsaxena@plexity.net>,
        <patrice.chotard@st.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-amlogic@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH -next 03/13] hwrng: exynos - use
 devm_platform_ioremap_resource() to simplify code
Date:   Fri, 18 Oct 2019 17:05:41 +0200
In-Reply-To: <20191016104621.26056-4-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 16 Oct 2019 18:46:11 +0800")
Message-ID: <87v9smdrga.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTVxj29N7ee0FLjgXiu9rF2AwTMcrIyHIUo2zReRJ+aNw/jR9XuSlE
        iqQV/MDETosoKmgxUQpurUARFKoUi19BrUAZZOuYU8lEq6LicKIiIlglo72Y+e85z/s8z/uR
        IzDqek4jZGRtkYxZYqaOi2Q9baO/z23/q2bN1/mdQAoGnDz5aG3jSd2hVpYUlAwryLWfbiLy
        fqCFJ3sqXBw50K8lxb3PGTJa0Kggfv9ZntjLJpOG3ttKErg/qiA3L5Vz5Mjdcf64v1lBgu/G
        lORZ3R0lsXuKEGlyOxhS3n4LkSelbo4MnH6MiK99P0N63vaxKRq6+2UbR4PvrYi+7M7n6c9n
        8qgt8BtHL9ru8bSi4SpHPdfiqKXlhZI21O7n6NUTZ3jqrtxF/ccdiPaMVCHaa8lnaNE/Z9EK
        9arIhWlSZkauZExYtD4y3XUuOjsYte0X+xHGjNqiClGEADgJ+ipH+EIUKajxKQQP9l1g5ccQ
        goDzCRNSqfEbBGUW9SfH+Y6aCVE1gibXMSSL+hC4Ts4IYQ4vhuKWZjaEY/AssHQ0MiEDgweV
        sLuzhwsVonE63HYeVRYiQWBxHFw+Gh/SRGDLeE59eThUhb+BD47+cFAsng/3i+5xMj8Vfi19
        HOYZPAecjufhBoCHBHD/Ua2UR10C515VKGQcDf2+Rl7GWugsOciGGgPeBSXWb2XvQQSe8hFW
        1iTDDV9XeDgGzwbXpQSZ/g4Ct4o42RoF3S+myiNEgdVzjJFpFezbO3Grr6C++MpEoAYO9Z9C
        MqZQ1mTmD6OZts+WsX22jO3/vnbE1KJpUo7JoJdMiVnS1nkm0WDKydLP27jZ0IDGf3HnmG/w
        Anr75wYvwgLSTVE9c9asUSvFXNN2gxeBwOhiVD8mj1OqNHH7Dsm4eZ0xJ1MyedF0gdVNU+VN
        erBajfXiFmmTJGVLxk9VhRChMaPYnV1VmsXuKT76dPjLqhWzxUmZgQivfm1GPA3U6eLmGpa1
        Liepr1PtrwfnvAvG1Cr8d9N8Y+lJcQsegdaabHuYnKD9e/ngntgfWpuTSs19S13DuRsPp17v
        WFDjKP238Y5+a3DTjrxuSbMyZafPjD5qi78Y8n7PdB2AaGdK9VNRx5rSxcR4xmgS/wOh4dg/
        wQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRiGeXfOzjmzVm9T6WX4I04YZHjWnOa7vgx/vRFRUP2oFBt50sg5
        29miDyK1mWlkZUW6LJ2WNK2mm85SSFs2LSkzy4JMC42+yD6gD82sTYn6d3M/13M/PHBzlKpB
        rua2Z1pEc6Yhg2dC6K6JjoHojkfO5IV2dxzOH6lm8a9iP4uvHL1N4/yT32S4LacX4LGRdhYf
        rHIx+Mi7CHxs6D2FR/MbZLi7u47FFWenYfdQnxwPDozKcG9zGYNPPAv4Jd03ZPjn9wk5fnPl
        iRxXeIsAbvI4KFzW+RjgV6UeBo/UDgPc0VlA4f6vr+kVapL70c+Qn2PFgHx8mseS85f3Efvg
        PYZctz9nSZW7lSHetkhia/8gJ+6aAoa0nrvMEs+FA6S7xAFI/4+LgAzZ8ihS9LYOrFVtEpaa
        TVaLOCfdJFmW8Zu1OEbQ6rEQE6sXtLr45MUxcbxm+dJUMWP7LtGsWb5FSM+95GKzRkN25/R8
        YrJBuaIQKDgEY1HjXSddCEI4FbwI0ETPb7YQcIGBGjnPpU0xoWi8r5CZYl4BdKHyDBUcMDAB
        HWu/QQd1GJyHbHcbJn0KDsrR67HVQR0Kt6Hrg3lMUKvgYnQ6+zMdzKdhJGo5FRXMVEAbQK6r
        ZSDIKKEOjTveTWaGQz0aKHrOTPmz0J3S4cldCs5HrmbN1KkFqNrxnjoOZtn/o+z/KPt/VAWg
        akCYaJWMaUZJK0gGo2TNTBO2moxuEGiM1z/quQYe1q/zAcgBfrryTbUzWSU37JL2GH0AcRQf
        ply3JGApUw179opmU4rZmiFKPhAXeOcEpQ7fagr0L9OSoo3TxmO9Nl4Xr1uE+dnKw/Bmkgqm
        GSziDlHMEs1/92ScQp0NSsqZhHK9TXgSnnC/gHU21Pu2sD6jJqZnVdjwetvnvk2kqJWvrYw2
        +hPL9s+4lQrTHxgT5yYeXEN4YcOttSRl5SrvzHaN64tVsSK6t6omqbzY09W1YyeHvH3+lo35
        UuyPhYfMbXtfRLxs2kxXPmrzr36adXVOv5QCzzTudmCeltIN2ijKLBn+AN7zgpJHAwAA
X-CMS-MailID: 20191018150543eucas1p1cf4312467597ad7c76f258e924d8184a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191018150543eucas1p1cf4312467597ad7c76f258e924d8184a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191018150543eucas1p1cf4312467597ad7c76f258e924d8184a
References: <20191016104621.26056-4-yuehaibing@huawei.com>
        <CGME20191018150543eucas1p1cf4312467597ad7c76f258e924d8184a@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It was <2019-10-16 =C5=9Bro=2012:46>,=20when=20YueHaibing=20wrote:=0D=0A>=
=20Use=20devm_platform_ioremap_resource()=20to=20simplify=20the=20code=20a=
=20bit.=0D=0A>=20This=20is=20detected=20by=20coccinelle.=0D=0A>=0D=0A>=20Si=
gned-off-by:=20YueHaibing=20<yuehaibing=40huawei.com>=0D=0A>=20---=0D=0A>=
=20=20drivers/char/hw_random/exynos-trng.c=20=7C=204=20+---=0D=0A>=20=201=
=20file=20changed,=201=20insertion(+),=203=20deletions(-)=0D=0A>=0D=0A=0D=
=0AAcked-by:=20=C5=81ukasz=20Stelmach=20<l.stelmach=40samsung.com>=0D=0A=0D=
=0A>=20diff=20--git=20a/drivers/char/hw_random/exynos-trng.c=20b/drivers/ch=
ar/hw_random/exynos-trng.c=0D=0A>=20index=20b4b52ab..8e1fe3f=20100644=0D=0A=
>=20---=20a/drivers/char/hw_random/exynos-trng.c=0D=0A>=20+++=20b/drivers/c=
har/hw_random/exynos-trng.c=0D=0A>=20=40=40=20-109,7=20+109,6=20=40=40=20st=
atic=20int=20exynos_trng_init(struct=20hwrng=20*rng)=0D=0A>=20=20static=20i=
nt=20exynos_trng_probe(struct=20platform_device=20*pdev)=0D=0A>=20=20=7B=0D=
=0A>=20=20=09struct=20exynos_trng_dev=20*trng;=0D=0A>=20-=09struct=20resour=
ce=20*res;=0D=0A>=20=20=09int=20ret=20=3D=20-ENOMEM;=0D=0A>=20=20=0D=0A>=20=
=20=09trng=20=3D=20devm_kzalloc(&pdev->dev,=20sizeof(*trng),=20GFP_KERNEL);=
=0D=0A>=20=40=40=20-128,8=20+127,7=20=40=40=20static=20int=20exynos_trng_pr=
obe(struct=20platform_device=20*pdev)=0D=0A>=20=20=09platform_set_drvdata(p=
dev,=20trng);=0D=0A>=20=20=09trng->dev=20=3D=20&pdev->dev;=0D=0A>=20=20=0D=
=0A>=20-=09res=20=3D=20platform_get_resource(pdev,=20IORESOURCE_MEM,=200);=
=0D=0A>=20-=09trng->mem=20=3D=20devm_ioremap_resource(&pdev->dev,=20res);=
=0D=0A>=20+=09trng->mem=20=3D=20devm_platform_ioremap_resource(pdev,=200);=
=0D=0A>=20=20=09if=20(IS_ERR(trng->mem))=0D=0A>=20=20=09=09return=20PTR_ERR=
(trng->mem);=0D=0A=0D=0A--=20=0D=0A=C5=81ukasz=20Stelmach=0D=0ASamsung=20R&=
D=20Institute=20Poland=0D=0ASamsung=20Electronics=0D=0A
