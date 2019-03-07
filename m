Return-Path: <SRS0=O2m6=RK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF20C43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 07:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860AF20835
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 07:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelci-org.20150623.gappssmtp.com header.i=@kernelci-org.20150623.gappssmtp.com header.b="lvqCzY4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfCGHNe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Mar 2019 02:13:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33343 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCGHNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Mar 2019 02:13:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so16099164wrw.0
        for <linux-crypto@vger.kernel.org>; Wed, 06 Mar 2019 23:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from:cc;
        bh=sayuyPupiA3rjZBNEtk4HbXcZcRHfhMukjQTApU0hl4=;
        b=lvqCzY4bF9MHP887P/FdvwlI4R1Sq7344uTDJfS56fi5uS3NmAQDxmy5VbvxWhjtL7
         FE5p2f+/hwd59VkjKgXiNaE/sy/BzKrbj7U2hagx2unkbsnbgprvWX5yzwFn4S7ckKEB
         zX3e4GnTzMhfwde8NVygS9bMtRTC9wSUEweVcG4W38lxe2lvQEyAVU6qtqrC5dG8rAGo
         S2v1kBpjBAxNkcyw1GSiEXme6PZnfGSK9MX17uyrnKs1rnJvc7AXrU0qciXPqC1Cmw1+
         LBBvPR8Jv76UmZtlrxEeuGCUJT/6cTCMMA0OyBxF03KAZwzkHxYN1I7J5BdZvBoBxkpb
         i4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from:cc;
        bh=sayuyPupiA3rjZBNEtk4HbXcZcRHfhMukjQTApU0hl4=;
        b=jT1jo5Hr+zWZ9HGIHHTkJR4GybCXEUIlSaFG8zUXM11ad94ZRF38kNHhjq+Ug8mej4
         DohhtiQUAd59pbt5fZEfF32E/gfnQLjqkztcuNu6s+9aARi9zt1gbYIs3QZ2Ip0nJBE8
         AXxU194RA9H+MktG0xt6hJDzcKgem9QT5CcrCxAP//FfZV0x1HhAyfjRrmAGKTJF32HJ
         3u5Xgmr1FYgk1HPo81yHvAFKOO4aZ4b2byKQ/LCxPgEUP75kfY98vF0m+gu3wLJjCm50
         OboQpjYFFn+KFAVlRDNvhWyTF3l65JEeCGI50Z77oGP8/2aBLNjqgGEHS3J0HRof6obB
         9HIQ==
X-Gm-Message-State: APjAAAULB4cy91n5P1UN0Xpbmh5wJdMezHVtqpmoSul1bZ9bFpkKiHio
        rpeky8MKzuSi6RUHqek9VtcfRg==
X-Google-Smtp-Source: APXvYqwrcsuZkVA3EJLxEcM2ufKx9kiJ+TAK0dj88WIVfYWqAUYvUknxW+Bc0Gm5qaXakOPPij9Zbg==
X-Received: by 2002:a5d:6682:: with SMTP id l2mr5422817wru.271.1551942811946;
        Wed, 06 Mar 2019 23:13:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m16sm6730680wro.78.2019.03.06.23.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 23:13:31 -0800 (PST)
Message-ID: <5c80c49b.1c69fb81.605bf.26ea@mx.google.com>
Date:   Wed, 06 Mar 2019 23:13:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0-4854-g8dcd175bc3d5
X-Kernelci-Report-Type: bisect
X-Kernelci-Tree: mainline
X-Kernelci-Lab-Name: lab-collabora
X-Kernelci-Branch: master
Subject: mainline/master boot bisection: v5.0-4854-g8dcd175bc3d5 on odroid-xu3
To:     tomeu.vizoso@collabora.com, guillaume.tucker@collabora.com,
        broonie@kernel.org, matthew.hart@linaro.org,
        Herbert Xu <herbert@gondor.apana.org.au>, khilman@baylibre.com,
        enric.balletbo@collabora.com,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* This automated bisection report was sent to you on the basis  *
* that you may be involved with the breaking commit it has      *
* found.  No manual investigation has been done to verify it,   *
* and the root cause of the problem may be somewhere else.      *
* Hope this helps!                                              *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

mainline/master boot bisection: v5.0-4854-g8dcd175bc3d5 on odroid-xu3

Summary:
  Start:      8dcd175bc3d5 Merge branch 'akpm' (patches from Andrew)
  Details:    https://kernelci.org/boot/id/5c8052c159b5146b7bfe6018
  Plain log:  https://storage.kernelci.org//mainline/master/v5.0-4854-g8dcd=
175bc3d5/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5422-odroidxu3=
.txt
  HTML log:   https://storage.kernelci.org//mainline/master/v5.0-4854-g8dcd=
175bc3d5/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5422-odroidxu3=
.html
  Result:     0918f18c7179 crypto: s5p - add AES support for Exynos5433

Checks:
  revert:     PASS
  verify:     PASS

Parameters:
  Tree:       mainline
  URL:        git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.=
git
  Branch:     master
  Target:     odroid-xu3
  CPU arch:   arm
  Lab:        lab-collabora
  Compiler:   gcc-7
  Config:     exynos_defconfig
  Test suite: boot

Breaking commit found:

---------------------------------------------------------------------------=
----
commit 0918f18c7179e8cdf718d01531a81b28130b4217
Author: Kamil Konieczny <k.konieczny@partner.samsung.com>
Date:   Fri Feb 22 13:21:44 2019 +0100

    crypto: s5p - add AES support for Exynos5433
    =

    Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS=
 IP.
    =

    Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
    Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 8d0afdc220ff..f4e625cf53ca 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -232,6 +232,7 @@
  * struct samsung_aes_variant - platform specific SSS driver data
  * @aes_offset: AES register offset from SSS module's base.
  * @hash_offset: HASH register offset from SSS module's base.
+ * @clk_names: names of clocks needed to run SSS IP
  *
  * Specifies platform specific configuration of SSS module.
  * Note: A structure for driver specific platform data is used for future
@@ -240,6 +241,7 @@
 struct samsung_aes_variant {
 	unsigned int			aes_offset;
 	unsigned int			hash_offset;
+	const char			*clk_names[];
 };
 =

 struct s5p_aes_reqctx {
@@ -296,6 +298,7 @@ struct s5p_aes_ctx {
 struct s5p_aes_dev {
 	struct device			*dev;
 	struct clk			*clk;
+	struct clk			*pclk;
 	void __iomem			*ioaddr;
 	void __iomem			*aes_ioaddr;
 	int				irq_fc;
@@ -384,11 +387,19 @@ struct s5p_hash_ctx {
 static const struct samsung_aes_variant s5p_aes_data =3D {
 	.aes_offset	=3D 0x4000,
 	.hash_offset	=3D 0x6000,
+	.clk_names	=3D { "secss", },
 };
 =

 static const struct samsung_aes_variant exynos_aes_data =3D {
 	.aes_offset	=3D 0x200,
 	.hash_offset	=3D 0x400,
+	.clk_names	=3D { "secss", },
+};
+
+static const struct samsung_aes_variant exynos5433_slim_aes_data =3D {
+	.aes_offset	=3D 0x400,
+	.hash_offset	=3D 0x800,
+	.clk_names	=3D { "pclk", "aclk", },
 };
 =

 static const struct of_device_id s5p_sss_dt_match[] =3D {
@@ -400,6 +411,10 @@ static const struct of_device_id s5p_sss_dt_match[] =
=3D {
 		.compatible =3D "samsung,exynos4210-secss",
 		.data =3D &exynos_aes_data,
 	},
+	{
+		.compatible =3D "samsung,exynos5433-slim-sss",
+		.data =3D &exynos5433_slim_aes_data,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
@@ -2218,18 +2233,39 @@ static int s5p_aes_probe(struct platform_device *pd=
ev)
 			return PTR_ERR(pdata->ioaddr);
 	}
 =

-	pdata->clk =3D devm_clk_get(dev, "secss");
+	pdata->clk =3D devm_clk_get(dev, variant->clk_names[0]);
 	if (IS_ERR(pdata->clk)) {
-		dev_err(dev, "failed to find secss clock source\n");
+		dev_err(dev, "failed to find secss clock %s\n",
+			variant->clk_names[0]);
 		return -ENOENT;
 	}
 =

 	err =3D clk_prepare_enable(pdata->clk);
 	if (err < 0) {
-		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
+		dev_err(dev, "Enabling clock %s failed, err %d\n",
+			variant->clk_names[0], err);
 		return err;
 	}
 =

+	if (variant->clk_names[1]) {
+		pdata->pclk =3D devm_clk_get(dev, variant->clk_names[1]);
+		if (IS_ERR(pdata->pclk)) {
+			dev_err(dev, "failed to find clock %s\n",
+				variant->clk_names[1]);
+			err =3D -ENOENT;
+			goto err_clk;
+		}
+
+		err =3D clk_prepare_enable(pdata->pclk);
+		if (err < 0) {
+			dev_err(dev, "Enabling clock %s failed, err %d\n",
+				variant->clk_names[0], err);
+			goto err_clk;
+		}
+	} else {
+		pdata->pclk =3D NULL;
+	}
+
 	spin_lock_init(&pdata->lock);
 	spin_lock_init(&pdata->hash_lock);
 =

@@ -2305,8 +2341,11 @@ static int s5p_aes_probe(struct platform_device *pde=
v)
 	tasklet_kill(&pdata->tasklet);
 =

 err_irq:
-	clk_disable_unprepare(pdata->clk);
+	if (pdata->pclk)
+		clk_disable_unprepare(pdata->pclk);
 =

+err_clk:
+	clk_disable_unprepare(pdata->clk);
 	s5p_dev =3D NULL;
 =

 	return err;
@@ -2333,6 +2372,9 @@ static int s5p_aes_remove(struct platform_device *pde=
v)
 		pdata->use_hash =3D false;
 	}
 =

+	if (pdata->pclk)
+		clk_disable_unprepare(pdata->pclk);
+
 	clk_disable_unprepare(pdata->clk);
 	s5p_dev =3D NULL;
---------------------------------------------------------------------------=
----


Git bisection log:

---------------------------------------------------------------------------=
----
git bisect start
# good: [a215ce8f0e00c2d707080236f1aafec337371043] Merge tag 'iommu-fix-v5.=
0-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu
git bisect good a215ce8f0e00c2d707080236f1aafec337371043
# bad: [8dcd175bc3d50b78413c56d5b17d4bddd77412ef] Merge branch 'akpm' (patc=
hes from Andrew)
git bisect bad 8dcd175bc3d50b78413c56d5b17d4bddd77412ef
# good: [096461de96a94c856190ba892ebf62dfba5a38f1] net/sched: avoid unused-=
label warning
git bisect good 096461de96a94c856190ba892ebf62dfba5a38f1
# bad: [3478588b5136966c80c571cf0006f08e9e5b8f04] Merge branch 'locking-cor=
e-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 3478588b5136966c80c571cf0006f08e9e5b8f04
# good: [6456300356433873309a1cae6aa05e77d6b59153] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/davem/net-next
git bisect good 6456300356433873309a1cae6aa05e77d6b59153
# bad: [8feed3efa8022107bcb3432ac3ec9917e078ae70] Merge branch 'parisc-5.1-=
1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
git bisect bad 8feed3efa8022107bcb3432ac3ec9917e078ae70
# good: [cf64e495fe221479866c1ea7c6f5cd9698d8a3af] crypto: caam - weak key =
checking for cbc des, 3des
git bisect good cf64e495fe221479866c1ea7c6f5cd9698d8a3af
# good: [fcc082f35c6d565d351b5b89bb03a82333e9ffe8] Revert "s390/cpum_cf: Ad=
d kernel message exaplanations"
git bisect good fcc082f35c6d565d351b5b89bb03a82333e9ffe8
# good: [d3ff9f851b7ad892df8dc168f0d589308fb42ac3] dt-bindings: crypto: doc=
ument Exynos5433 SlimSSS
git bisect good d3ff9f851b7ad892df8dc168f0d589308fb42ac3
# good: [d578bf28cfc40375b4fc9f7571a3faf17bd2373c] parisc: Add constant for=
 PDC_PAT_COMPLEX firmware call
git bisect good d578bf28cfc40375b4fc9f7571a3faf17bd2373c
# good: [bf6341664ad16070bed675bec659aa54b161ed82] m68k/apollo: Fix comment=
 in Makefile
git bisect good bf6341664ad16070bed675bec659aa54b161ed82
# bad: [eac616557050737a8d6ef6fe0322d0980ff0ffde] x86: Deprecate a.out supp=
ort
git bisect bad eac616557050737a8d6ef6fe0322d0980ff0ffde
# bad: [63bdf4284c38a48af21745ceb148a087b190cd21] Merge branch 'linus' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect bad 63bdf4284c38a48af21745ceb148a087b190cd21
# bad: [0918f18c7179e8cdf718d01531a81b28130b4217] crypto: s5p - add AES sup=
port for Exynos5433
git bisect bad 0918f18c7179e8cdf718d01531a81b28130b4217
# first bad commit: [0918f18c7179e8cdf718d01531a81b28130b4217] crypto: s5p =
- add AES support for Exynos5433
---------------------------------------------------------------------------=
----
