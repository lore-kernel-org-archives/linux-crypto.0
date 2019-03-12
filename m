Return-Path: <SRS0=5sM8=RP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46999C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Mar 2019 04:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF505214AE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Mar 2019 04:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelci-org.20150623.gappssmtp.com header.i=@kernelci-org.20150623.gappssmtp.com header.b="WQcZu+Zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfCLECT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:02:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32990 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfCLECS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Mar 2019 00:02:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id i8so1115329wrm.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Mar 2019 21:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from:cc;
        bh=XgnFbmTiGMBOiFR7bdf6JFofqh4zrwzGSYk+aT0CfhI=;
        b=WQcZu+ZiWJz18/dKENCpNUG0HFX4M6gN1u3qY1+lY8bgDiN9O2whzGoWLsLvXNmiK3
         Euyy96AqcpbE01NCYxpOr/iblYKwqFSNaviKfYFJv5j1bOu/5tDiI2qboX0UP9KJUtGQ
         QLR8oF54W3sVeI/MtW76kUP3y3vbJuvx/s1VtRY4TTahmSdD15PRinGorVzw+Vsj06N/
         r+4lUyO+9z2tQ7EZIqHAnXzmrjd5GobskICuudTttDTxQZEMrod4zgbfF4oIhrG4O6NI
         cqxM7BHu5+ittuNj8um0OfoIhSiZrZY/5FkM57Kjza4MAjahtUp92nXqUETBtRblCaAx
         dLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from:cc;
        bh=XgnFbmTiGMBOiFR7bdf6JFofqh4zrwzGSYk+aT0CfhI=;
        b=p5yCNw/gQ7TFDhJg8pbx5ed5DVkYqGX9H1e4rF0GMNVougySMuTJ5ss0pHBH+1RM1B
         4IQ96XxJBig7yMEtpEyF69dSx+t+ZCzwms+LKhfUeHQcQxFLjS0zHlOYdN3RYzdvleqE
         v1YVoxHgclIiWI4raLZJ4W0G9z7nWwinPjJ1PN1ogfQpTwD4h/PV7eQPsFqpV9Pl/RRn
         bAEqFcyl/c8iGQydb/7uVhNMbU3AE/0aaGDE8k0DEjoD+cEye8hHKj0x1VXb3EZkOLoV
         i0hPlEm9oqqeGkVKL8VG+Kbn/RyoVv8oMirwiqdqOg6clg5yiGrr3KNNtQTKKq2/JTAj
         KLiA==
X-Gm-Message-State: APjAAAWf2n4SSxZPmCgkc8D8BAEH0UaOEDbkt5sJaVQNn9u8DeLhZbpY
        DyGk5Rt2DQmJ4I5j5Ta9KAogHQ==
X-Google-Smtp-Source: APXvYqyCg/ueVEJC+kTkNvImCswRnFms54ZuSWPr1hJdU3qEDnmyDt3bmiXCmYErpIPvHVSzYMU2cA==
X-Received: by 2002:a5d:6387:: with SMTP id p7mr3700028wru.206.1552363336709;
        Mon, 11 Mar 2019 21:02:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f68sm3687167wmg.5.2019.03.11.21.02.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 21:02:16 -0700 (PDT)
Message-ID: <5c872f48.1c69fb81.985c2.1e26@mx.google.com>
Date:   Mon, 11 Mar 2019 21:02:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0-10530-g6bc3fe8e7e17
X-Kernelci-Report-Type: bisect
X-Kernelci-Tree: mainline
X-Kernelci-Lab-Name: lab-collabora
X-Kernelci-Branch: master
Subject: mainline/master boot bisection: v5.0-10530-g6bc3fe8e7e17 on peach-pi
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

mainline/master boot bisection: v5.0-10530-g6bc3fe8e7e17 on peach-pi

Summary:
  Start:      6bc3fe8e7e17 tools: mark 'test_vmalloc.sh' executable
  Details:    https://kernelci.org/boot/id/5c86c90059b5149c7bfe60e7
  Plain log:  https://storage.kernelci.org//mainline/master/v5.0-10530-g6bc=
3fe8e7e17/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5800-peach-pi=
.txt
  HTML log:   https://storage.kernelci.org//mainline/master/v5.0-10530-g6bc=
3fe8e7e17/arm/exynos_defconfig/gcc-7/lab-collabora/boot-exynos5800-peach-pi=
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
  Target:     peach-pi
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
# good: [cd2a3bf02625ffad02a6b9f7df758ee36cf12769] Merge tag 'leds-for-5.1-=
rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/j.anaszewski/linux-le=
ds
git bisect good cd2a3bf02625ffad02a6b9f7df758ee36cf12769
# bad: [6bc3fe8e7e172d5584e529a04cf9eec946428768] tools: mark 'test_vmalloc=
.sh' executable
git bisect bad 6bc3fe8e7e172d5584e529a04cf9eec946428768
# bad: [da2577fe63f865cd9dc785a42c29c0071f567a35] Merge tag 'sound-5.1-rc1'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect bad da2577fe63f865cd9dc785a42c29c0071f567a35
# good: [6456300356433873309a1cae6aa05e77d6b59153] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/davem/net-next
git bisect good 6456300356433873309a1cae6aa05e77d6b59153
# bad: [6ad63dec9c2c80710896edd1996e56c54a230870] Merge tag 'armsoc-dt' of =
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 6ad63dec9c2c80710896edd1996e56c54a230870
# bad: [203b6609e0ede49eb0b97008b1150c69e9d2ffd3] Merge branch 'perf-core-f=
or-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 203b6609e0ede49eb0b97008b1150c69e9d2ffd3
# bad: [edaed168e135f8ec87b27b567a367cbb041f2243] Merge branch 'x86-pti-for=
-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad edaed168e135f8ec87b27b567a367cbb041f2243
# bad: [45f5532a2f65afeda9e8a02bf1aca15c2b4c9be8] Merge tag 'm68k-for-v5.1-=
tag1' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
git bisect bad 45f5532a2f65afeda9e8a02bf1aca15c2b4c9be8
# good: [eb5e6730db98fcc4b51148b4a819fa4bf864ae54] crypto: testmgr - skip c=
rc32c context test for ahash algorithms
git bisect good eb5e6730db98fcc4b51148b4a819fa4bf864ae54
# good: [9dd24d4ef3e81683b3c73299f95dce5ef34881d0] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/leo/linux next
git bisect good 9dd24d4ef3e81683b3c73299f95dce5ef34881d0
# good: [8e731ee5e2a5aa37b736c05ee2562e1169af866e] crypto: caam - fix DMA m=
apping xcbc key twice
git bisect good 8e731ee5e2a5aa37b736c05ee2562e1169af866e
# bad: [eac616557050737a8d6ef6fe0322d0980ff0ffde] x86: Deprecate a.out supp=
ort
git bisect bad eac616557050737a8d6ef6fe0322d0980ff0ffde
# good: [41798036430015ad45137db2d4c213cd77fd0251] crypto: cavium/zip - fix=
 collision with generic cra_driver_name
git bisect good 41798036430015ad45137db2d4c213cd77fd0251
# bad: [0918f18c7179e8cdf718d01531a81b28130b4217] crypto: s5p - add AES sup=
port for Exynos5433
git bisect bad 0918f18c7179e8cdf718d01531a81b28130b4217
# good: [d3ff9f851b7ad892df8dc168f0d589308fb42ac3] dt-bindings: crypto: doc=
ument Exynos5433 SlimSSS
git bisect good d3ff9f851b7ad892df8dc168f0d589308fb42ac3
# first bad commit: [0918f18c7179e8cdf718d01531a81b28130b4217] crypto: s5p =
- add AES support for Exynos5433
---------------------------------------------------------------------------=
----
