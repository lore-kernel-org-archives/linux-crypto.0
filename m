Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0D3C83F01
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Aug 2023 11:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjHZL3u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Aug 2023 07:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjHZL3c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Aug 2023 07:29:32 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4128D1BF2
        for <linux-crypto@vger.kernel.org>; Sat, 26 Aug 2023 04:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1693049347; x=1693654147; i=wahrenst@gmx.net;
 bh=rPNVIq+eiEBeeUY1NCey4A6+NK7K5p71Kf2k0g5gw+M=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
 b=RleJzVedYE3/dHrDI1xRjqYhRiktqLwYExai6EmsnTrwoE99FX7BkWCTuX/mU1Dx/Hsx8+J
 vRXgY0MLMSQKe2LWGBMidX4Q86r+H4L1M5OYikVXaJoROq7+kPX0kGxWcwyx3s8wG7/MlebiX
 A0fxk/oWFLWu39DTN11yYt38sI81gwwLWkXe+90oswHpPRs6i3t4OX/h7HKUTeQFq9iHr04Js
 W4yQXYBjVqW7DkWv/yoJX+TPC1IhIg3wFRfQZfzQRzPQZ+DAkNZ8JyNgTkZYRHeGhvv9YaTC9
 R5NP2tWA01eQSNNQ7x5LtywWJqFpupRWtrs+Nls/KvUnTUXLNCdA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from stefanw-SCHENKER ([37.4.248.43]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MqJqN-1pwNs00U55-00nUXT; Sat, 26
 Aug 2023 13:29:07 +0200
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
Subject: [PATCH] hwrng: bcm2835: Fix hwrng throughput regression
Date:   Sat, 26 Aug 2023 13:28:28 +0200
Message-Id: <20230826112828.58046-1-wahrenst@gmx.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kqpr+9dJcQrDIhh/bO6mypwC9b8arJqYymbe/xO7CxS8U4OmV4t
 qc1fjA78boX0Wr0PHMmJddws2b+71QBacs6pitWWb6EX+E1Dkg4/4k9jsGGYyCcH5hjtwzb
 OmIuAUuaZkU7oc8S08KDWIH7j1nzZVT6vTk1Ne+yWA4vpDE3LA5RptgR+88CxYBoplPhxUJ
 ZOrn4g0Fn2tLCM3TwLOcg==
UI-OutboundReport: notjunk:1;M01:P0:+VJbH5XzvYY=;mGOT4IZLYs7jNNQ2wMvfi+y1drJ
 qM9WMuuJL8wqSSA6z8bzQa8TX/3ZxZMCXJW/G8BJ1LQC9oKlG9MMLs7gOf+VrXcnXWZybpkJN
 fjlvn9NoUI1/CUs9jIl7cFrFLfhNIUVNnk/S8kHt7ZcROxl9qE3PPS/6kSR4iser9q7riBJE9
 EV3/kmFbi1z53PmFQStUJteryCSl/3IFnRJPcUt5v4wDp0PxahDOD6s2xb8FD127B20d5KG1g
 S+x/iAvs9maebVHnGcWfag5MBX3vVSDs90/PIoQcN8IHgfrLGddzoPKQ5YNCQtijgpMS/mvX4
 X2gt+G3uqwOhm4Bdk0kPDctvZoKFkngHqHA+PibDgkiR7Um8eIDWnO5Zd0bm/qPPyAU2ukRff
 w882Ro4AQ8jgzgD/ii3qucCKWh6KEnf2vbeXNebDP51V5Z9SdkUPG0pydi5xJCrhS+B//AnSv
 n8tDdXw1mrzgVNG09hi/Crca8iNFB5PKs97ubEvW7fjVo/DMPLci8a+TTVC99VrNboHZ27p6P
 6yzg/IM/2GUMO+0IpXlJAzNynUrNXK/TEQtmliSaF80Ml4EQmYnGsT5VLJODDqFeyEhLskIh2
 p/BEU6Wz1wFD15Aj76D0ITSVUjN9A3QAuX+0aUTAGrsnyUf03J1IQWGA6GbjTJDfh0EdFS7f6
 z+kp5PvuiwqT/4OOPOEY86KOG6K3llUEcFuPNX7GxrrgN51cDewMjr3V3/hGynu1IsEhOc90x
 bEivI7etZO8C8JVdc0jnBQR8EdCcJakdIfh5i78x/BH0OPn6E9WfT5Q7iBoIWTGE3ibY/Xnkr
 s3hdQwv76ew1aO4RSPx5SpnBG/mVs6n6HWhf+IoS3ytocpU+FC00s6znjPtKV12p5+qDiL7e4
 DsZ5DBKMmAq1Aw5qnDP+VhScfLLBTnybS5k/5Qwlegn55nGxKMr6NONAQy4KX/85HYmnnf4GI
 Nk2UdQ==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The recent RCU stall fix caused a massive throughput regression of the
hwrng on Raspberry Pi 0 - 3. So try to restore a similiar throughput
as before the RCU stall fix.

Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):

sudo dd if=3D/dev/hwrng of=3D/dev/null count=3D1 bs=3D10000

cpu_relax              ~138025 Bytes / sec
hwrng_msleep(1000)         ~13 Bytes / sec
usleep_range(100,200)   ~92141 Bytes / sec

Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_r=
elax()")
Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db=
3eb66b128@gmx.net/
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/char/hw_random/bcm2835-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random=
/bcm2835-rng.c
index e98fcac578d6..3f1b6aaa98ee 100644
=2D-- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -14,6 +14,7 @@
 #include <linux/printk.h>
 #include <linux/clk.h>
 #include <linux/reset.h>
+#include <linux/delay.h>

 #define RNG_CTRL	0x0
 #define RNG_STATUS	0x4
@@ -71,7 +72,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf=
, size_t max,
 	while ((rng_readl(priv, RNG_STATUS) >> 24) =3D=3D 0) {
 		if (!wait)
 			return 0;
-		hwrng_msleep(rng, 1000);
+		usleep_range(100, 200);
 	}

 	num_words =3D rng_readl(priv, RNG_STATUS) >> 24;
=2D-
2.34.1

