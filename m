Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1187CCF9E8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 23:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjIEX2u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjIEX2u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2023 19:28:50 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5C59E
        for <linux-crypto@vger.kernel.org>; Tue,  5 Sep 2023 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1693956502; x=1694561302; i=wahrenst@gmx.net;
 bh=GY+cKU9ZqUyJgDRu4Y/gsgI1xUTfX+iEeHDS9Zf7BZk=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
 b=ZqGSu1W6FS9RIsoJ+oa6rHJbQukBFXZomkdTj/gzJgMh7myuxLLl2v+5ncrZgKY6fHtmL5F
 /uSLOkcjgjzYUKFnY6t9X1eLqXzsGFQ6risU1gZ+hW9bZwVohVdQokupkvvNFG/brZyNOfNLl
 /rBPU68fTqsal+b29FMa90CLkkUMZM+oBCScmNr8AgXA0bMBBGUvcwkMOW6sMGVxWrZ3BX8/p
 aRehpiBTg4syOPN5Yw9aZ655EEScKxwGyzKO9vbc190KJrQOSKI4vUNMrTiYF1UbLOp0+/6Ym
 RrApSXYo7Bb9lIL1rG4i/V7ZTJnrWlyeS5r79ewoYYbUNerqFNhw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from stefanw-SCHENKER ([37.4.248.43]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MTzf6-1qCkxo2U42-00R2rh; Wed, 06
 Sep 2023 01:28:22 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V2] hwrng: bcm2835: Fix hwrng throughput regression
Date:   Wed,  6 Sep 2023 01:27:57 +0200
Message-Id: <20230905232757.36459-1-wahrenst@gmx.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PN+1I8AC+BmOLLuSKVSIMR5owJvnEYSRbHlwT7DLRg+pkbPVCYl
 9OQEjbhXHMgVeBFSiIstVfiiFpGkxncyeF+MaHnz5biVmCv3Drcs8Ksn1RROhcYX9mNXVeh
 aOXUEMbEy0zoIVFn8zxuJrt+O3IzHZ8WLjDUSK94fCaTIQ7G6Bu1tQXedm8SWPZtL7VdMxE
 BdRIN8JPn21wB5Gu3uqWg==
UI-OutboundReport: notjunk:1;M01:P0:0DPy7gFzeOo=;CqUeXnEDfQBdqmK8N2x6XvUbPBo
 TL7TobCWBQPKl/IBZjEWBINdbd5K47cocJ5rjLQmrTjKqGUu811fj8WlMP6KznccwluDo3s+y
 ovXw7m5QgSA2qaDizUVuknCJMiZKVOSsIfSftHrqcPLbAqYwfyyVkEHXB6qSeENlmE4qUv2gz
 6XJgyiTzpTMNL0B0FUYBCn7V0P/hZU10rVOZZ2Zqs3ByDMmlGj62rNnMO5tVLOs4gXerEZr2z
 UNdapVA32kQIScXBaxARXUPMIqcsGAYFmx+JDkv05p0gujQ0PcrBJoTk/zzhnOByJ8s5lWSht
 mD7/r4AC1M9DpS9Lr1KlEuqQyzRs4pLqvKm3DBZTblkPytpN66KtV28T6h56/5oUqxvlbtTkV
 ZaA4ybqG9OjiMiJJLPcY9KJRIQIbmTrHGPaMDj/oowHnfJNmhMRuJQqvVxVlsXyQK39/99EjQ
 0P5J0c5k8stWWGijlHhAfJOFf5jKm49+7Dm+Wuaei7v54DOOuPFPzeueRFKJAl+jvXTtigjOX
 ojIG93sbV+CkA8439gcdM5AyjlYYODM8731499tHfMvROd0v1UOLJHMQIGEGd2rDSXkw1QL2v
 eHyhJIcKZIrjBFFvNkxc4lrG8rF2+Of+qklbqP6qh6KNgcKprXs48cRpa3aDZDXhYYI0XPG8x
 gsUEawe65qfxUPZQD1nEUWqtiyj5mAVy8FY/Ovq6k981Np4GINUb0XnqSiCi8ptVaqq6xMbmR
 gah+ha3EZl2GMhPVVFlCuq2AP3ccF29udrdGH+tRV1sEcS5sU16vUD1Db1pH30wsr8rn5DlQQ
 s3zRl1fouMwsdJcK5TH/jDIREJWy45RVKmpm6dwP8/CsVX44AkIkBVXnTwVn+w//P2ZPTsB/l
 2n6s8DYcPDeDYmyESfi5/WHlAsBLlnqhO4Owz0O2/4GCbdisl+/jwUW1vKPXVizSwbo0YDU+3
 7aEX9A==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The last RCU stall fix caused a massive throughput regression of the
hwrng on Raspberry Pi 0 - 3. hwrng_msleep doesn't sleep precisely enough
and usleep_range doesn't allow scheduling. So try to restore the
best possible throughput by introducing hwrng_yield which interruptable
sleeps for one jiffy.

Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):

sudo dd if=3D/dev/hwrng of=3D/dev/null count=3D1 bs=3D10000

cpu_relax              ~138025 Bytes / sec
hwrng_msleep(1000)         ~13 Bytes / sec
hwrng_yield              ~2510 Bytes / sec

Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_r=
elax()")
Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db=
3eb66b128@gmx.net/
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--

Changes in V2:
- introduce hwrng_yield and use it

 drivers/char/hw_random/bcm2835-rng.c | 2 +-
 drivers/char/hw_random/core.c        | 6 ++++++
 include/linux/hw_random.h            | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random=
/bcm2835-rng.c
index e98fcac578d6..634eab4776f3 100644
=2D-- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -71,7 +71,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf=
, size_t max,
 	while ((rng_readl(priv, RNG_STATUS) >> 24) =3D=3D 0) {
 		if (!wait)
 			return 0;
-		hwrng_msleep(rng, 1000);
+		hwrng_yield(rng);
 	}

 	num_words =3D rng_readl(priv, RNG_STATUS) >> 24;
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index f34d356fe2c0..599a4bc2c548 100644
=2D-- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -679,6 +679,12 @@ long hwrng_msleep(struct hwrng *rng, unsigned int mse=
cs)
 }
 EXPORT_SYMBOL_GPL(hwrng_msleep);

+long hwrng_yield(struct hwrng *rng)
+{
+	return wait_for_completion_interruptible_timeout(&rng->dying, 1);
+}
+EXPORT_SYMBOL_GPL(hwrng_yield);
+
 static int __init hwrng_modinit(void)
 {
 	int ret;
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 8a3115516a1b..136e9842120e 100644
=2D-- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -63,5 +63,6 @@ extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);

 extern long hwrng_msleep(struct hwrng *rng, unsigned int msecs);
+extern long hwrng_yield(struct hwrng *rng);

 #endif /* LINUX_HWRANDOM_H_ */
=2D-
2.34.1

