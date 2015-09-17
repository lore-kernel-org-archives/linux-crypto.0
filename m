From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 7/7] MAINTAINERS: Add ST's Random Number Generator to the ST entry
Date: Thu, 17 Sep 2015 14:45:57 +0100
Message-ID: <1442497557-9271-8-git-send-email-lee.jones@linaro.org>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37966 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbIQNqR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2015 09:46:17 -0400
Received: by wiclk2 with SMTP id lk2so28138862wic.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2015 06:46:16 -0700 (PDT)
In-Reply-To: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd60784..b084d69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1502,6 +1502,7 @@ W:	http://www.stlinux.com
 S:	Maintained
 F:	arch/arm/mach-sti/
 F:	arch/arm/boot/dts/sti*
+F:	drivers/char/hw_random/st-rng.c
 F:	drivers/clocksource/arm_global_timer.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/media/rc/st_rc.c
-- 
1.9.1
