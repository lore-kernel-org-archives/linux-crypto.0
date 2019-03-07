Return-Path: <SRS0=O2m6=RK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7411FC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 07:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2845E20835
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Mar 2019 07:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelci-org.20150623.gappssmtp.com header.i=@kernelci-org.20150623.gappssmtp.com header.b="BU8ukJtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfCGHRE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Mar 2019 02:17:04 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35341 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfCGHRE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Mar 2019 02:17:04 -0500
Received: by mail-wr1-f68.google.com with SMTP id t18so16128522wrx.2
        for <linux-crypto@vger.kernel.org>; Wed, 06 Mar 2019 23:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from:cc;
        bh=4R1khhukNgWrtC/jRBi9XwptUxQQEPtnXJOGboaJmjo=;
        b=BU8ukJtPLobr4YXnFqet2lElM0UzQHVafCKBwPKHObzWDLlBdGnUaNdStsUnc+bGNj
         JIbtw7goqjy6n4OpBQNiaus8Aaog1rFka7ulebXmalO2W2CrkXKu6Gd0BKMbng4ncKNW
         IkavpkDnEh7ZFqQgc+RTiv+DJ1d+AfaXXXwvTUZbxxlEgVi68YGFZlJigk6UgeGb7Jx2
         QjLA5/1Bv3CkHCKVWJcUvFDyxMFvDibPhPagW7yuoXT0Xh9NqwHHexIiYLCkQ5oIbq+S
         LS4t6mcU0nUW1WRxNagQ5dlIxWooV3kX4PBenp4kEeXUy1D50yK/ahsr3eSsJnvn6ikq
         jG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from:cc;
        bh=4R1khhukNgWrtC/jRBi9XwptUxQQEPtnXJOGboaJmjo=;
        b=fZLSJ2XgjhkgAlSRYyiQuHqWEjT2AJjqLVTIjlk1TyCu3pt5huA5WWYvtpY+2LhxGR
         45Awr097Shj5w7PFPwMKpjGZ4IBhIkTfcQvq6nKxYmwm9VSmaOnAPcJnHw4+Y7guFXSB
         La+x/2PWIgZhocE1xT1ibqzf6X4K8g1z9sdgCbuW6VzzYO9UUIgABMnylc9/mx5+FwqZ
         YJF0YKgm42CSFeRD9snmYfW8fBzruhu8a9VI28N+zTXTRLhUa75OWumIExbZZ9EqUzB1
         sa4E9i23l9JllwNoOw0LZdBzOYWQWKv9rTr3G4BOx21uPIV5WmP9pKe0LAmuI88bGyAt
         APvg==
X-Gm-Message-State: APjAAAX/Ld1soGrP3MVi6JvBCECVP6TBpa/t11zEEMMrs57A1fEbge71
        5+jfaQq7VZoQ35Aw+xgo/hH+eQ==
X-Google-Smtp-Source: APXvYqxIO0z6xnb/aoIa/Z9aKhmDGMySmxz9Gabph6x65F2VCPcRdvDDc8Yv24sKoGKoewTgIRd21A==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr5358571wrs.212.1551943021712;
        Wed, 06 Mar 2019 23:17:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y5sm9265335wrd.97.2019.03.06.23.17.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 23:17:01 -0800 (PST)
Message-ID: <5c80c56d.1c69fb81.e3d9f.d73a@mx.google.com>
Date:   Wed, 06 Mar 2019 23:17:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0-5022-g542d0e583b7b
X-Kernelci-Report-Type: bisect
X-Kernelci-Tree: mainline
X-Kernelci-Lab-Name: lab-collabora
X-Kernelci-Branch: master
Subject: mainline/master boot bisection: v5.0-5022-g542d0e583b7b on odroid-xu3
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

mainline/master boot bisection: v5.0-5022-g542d0e583b7b on odroid-xu3

Summary:
  Start:      542d0e583b7b Merge tag 'devprop-5.1-rc1' of git://git.kernel.=
org/pub/scm/linux/kernel/git/rafael/linux-pm
  Details:    https://kernelci.org/boot/id/5c806c1d59b5148945fe6019
  Plain log:  https://storage.kernelci.org//mainline/master/v5.0-5022-g542d=
0e583b7b/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5422-odroidxu3=
.txt
  HTML log:   https://storage.kernelci.org//mainline/master/v5.0-5022-g542d=
0e583b7b/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5422-odroidxu3=
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
# bad: [542d0e583b7b366527175b2b5fc0aad262fa33b0] Merge tag 'devprop-5.1-rc=
1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad 542d0e583b7b366527175b2b5fc0aad262fa33b0
# good: [18a4d8bf250a33c015955f0dec27259780ef6448] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/davem/net
git bisect good 18a4d8bf250a33c015955f0dec27259780ef6448
# bad: [203b6609e0ede49eb0b97008b1150c69e9d2ffd3] Merge branch 'perf-core-f=
or-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 203b6609e0ede49eb0b97008b1150c69e9d2ffd3
# bad: [63bdf4284c38a48af21745ceb148a087b190cd21] Merge branch 'linus' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect bad 63bdf4284c38a48af21745ceb148a087b190cd21
# good: [32c0ac3af49d0cfa05c5d9d77db94e240502b5ef] Merge tag 'regulator-v5.=
1' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good 32c0ac3af49d0cfa05c5d9d77db94e240502b5ef
# good: [7629bac64204ff256d3b2415767a7acb1401047b] Merge tag 'hwmon-for-v5.=
1' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
git bisect good 7629bac64204ff256d3b2415767a7acb1401047b
# good: [48ef0908b81cc6b92ec8b157bb78ce2c4eddd7c7] crypto: axis - support v=
ariable AEAD tag length
git bisect good 48ef0908b81cc6b92ec8b157bb78ce2c4eddd7c7
# good: [cf64e495fe221479866c1ea7c6f5cd9698d8a3af] crypto: caam - weak key =
checking for cbc des, 3des
git bisect good cf64e495fe221479866c1ea7c6f5cd9698d8a3af
# good: [7df5218d66750ff5f84413ea307391bf9bbace1e] crypto: ccp - Update dri=
ver messages to remove some confusion
git bisect good 7df5218d66750ff5f84413ea307391bf9bbace1e
# good: [91e14842f8ea8dc35669bad3c3dcd72d4614e4d1] crypto: af_alg - use str=
uct_size() in sock_kfree_s()
git bisect good 91e14842f8ea8dc35669bad3c3dcd72d4614e4d1
# good: [5ddb0869bfc1bca6cfc592c74c64a026f936638c] leds: lp55xx: fix null d=
eref on firmware load failure
git bisect good 5ddb0869bfc1bca6cfc592c74c64a026f936638c
# good: [d3ff9f851b7ad892df8dc168f0d589308fb42ac3] dt-bindings: crypto: doc=
ument Exynos5433 SlimSSS
git bisect good d3ff9f851b7ad892df8dc168f0d589308fb42ac3
# good: [6456300356433873309a1cae6aa05e77d6b59153] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/davem/net-next
git bisect good 6456300356433873309a1cae6aa05e77d6b59153
# bad: [0918f18c7179e8cdf718d01531a81b28130b4217] crypto: s5p - add AES sup=
port for Exynos5433
git bisect bad 0918f18c7179e8cdf718d01531a81b28130b4217
# first bad commit: [0918f18c7179e8cdf718d01531a81b28130b4217] crypto: s5p =
- add AES support for Exynos5433
---------------------------------------------------------------------------=
----
