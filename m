Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1ADC43140
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8D5214DE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394734AbfIFPXL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:23:11 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:32893 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387557AbfIFPXL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:23:11 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MQ5aw-1hkAou31pA-00M5hb; Fri, 06 Sep 2019 17:22:52 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable warning
Date:   Fri,  6 Sep 2019 17:22:29 +0200
Message-Id: <20190906152250.1450649-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:u547Yb77RHO15kDZX4JTrsBGpb64BliQTLpiUK93UQdkYW08oE8
 U2DBhk8auGRevbg3P7wWD0SvYnA8yvjFpmlj0dnVypm38xB4q6uqiIEsjLJnkvV+VfWZ/nG
 LPPHP0ygT2s0dSdaqNz/YpdCERJ7sgtZOCAIKM3ojYAVvInaQdG3F5KSVWed2QCoolHsgG1
 4zpc9UGWFRvw2bjETOBug==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bnjJzuxwR8o=:zTI8B7lwfhDUvN6/jeDt8r
 43CebgMnsG/r6n0jVItqrGmSlJngNg2Mu8B/x5Jk7ejXZta/KEFf7dRmQRb4Y4KwGE0WSRFEb
 lzTvnFaIz/cR9hSewht/+KDHys+jMtTfVDKDQivgrR6cRNSSDAD7cPowgfXQd5RiVWF2V8zHu
 U07yvxCeoCtozv+OyBc7ugWnFuH7cAsvJlg4sAh4muUYRrP3seK8QSzbxzE8TYyLjNnBou3uC
 b40jeQSkGyw2lQ9Mk1CNgGROHw4RD5dBlFq2wgucjaO8zOfMxIKNMnb9YlruQttyvUj7ZN2Dt
 JOh3RebyFHNpvIO5dILhbmL+OtMhENWhxurStERv++LxeCHuQASNKp2qlOMt6tMnDmreMOl2s
 9SqMB5g61bgkeZzwa5MHC11yz9Td4mvowUXSMPVV/jpYG9tFqBvLOIvM1+CoBBpCCy1qXuqM4
 N+/Eue3u9uiDFJS7u8ZZ/isl8IBMC8DBuLmBBUpSI1mhQf4RBBvx1Cm6fIiHVg5GqGZ8fy+vk
 XHTq7YDzgT0LvfCvdR0+i7wzTQ1ExFwteFg0BnQ0Y9B767GgDccSAPWeyc01q8zR+alvOqumx
 tjrMuDKgRMdAJ+NgT5ys4qyI2vpaqUca/nTJFikmYKpNMVRdOQanqzJiurafJEa+laYjbskGx
 rwI2Y6dGTIQx7bxQcrLsbh4z917uhgDZ/cm3r23BwCJExQQbN+C+5GRxxjkfl9iWj11vRixkO
 Hzo9Jivr0r9yiX2y4CmX98SVv19nqUSEDE6XNKLPWEU048MY/pKfPxsOW/YCvCYP4rH5BXoOt
 RNl+6LGj/Mb9+BSR0MCo0gag9xYlCsSVtDHAWeMu5SXEq4QyPY=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The addition of PCI support introduced multiple randconfig issues.

- When PCI is disabled, some external functions are undeclared:
drivers/crypto/inside-secure/safexcel.c:944:9: error: implicit declaration of function 'pci_irq_vector' [-Werror,-Wimplicit-function-declaration]

- Also, in the same configuration, there is an uninitialized variable:
drivers/crypto/inside-secure/safexcel.c:940:6: error: variable 'irq' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]

- Finally, the driver fails to completely if both PCI and OF
  are disabled.

Take care of all of the above by adding more checks for CONFIG_PCI
and CONFIG_OF.

Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based FPGA development board")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig                  | 2 +-
 drivers/crypto/inside-secure/safexcel.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3c4361947f8d..048bc4b393ac 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -719,7 +719,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF || PCI || COMPILE_TEST
+	depends on OF || PCI
 	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3a5422..9c0bce77de14 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -938,6 +938,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	struct device *dev;
 
 	if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
+#ifdef CONFIG_PCI
 		struct pci_dev *pci_pdev = pdev;
 
 		dev = &pci_pdev->dev;
@@ -947,6 +948,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irqid, irq);
 			return irq;
 		}
+#endif
 	} else if (IS_ENABLED(CONFIG_OF)) {
 		struct platform_device *plf_pdev = pdev;
 		char irq_name[6] = {0}; /* "ringX\0" */
@@ -960,6 +962,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irq_name, irq);
 			return irq;
 		}
+	} else {
+		return -ENXIO;
 	}
 
 	ret = devm_request_threaded_irq(dev, irq, handler,
@@ -1138,6 +1142,7 @@ static int safexcel_probe_generic(void *pdev,
 	safexcel_configure(priv);
 
 	if (IS_ENABLED(CONFIG_PCI) && priv->version == EIP197_DEVBRD) {
+#ifdef CONFIG_PCI
 		/*
 		 * Request MSI vectors for global + 1 per ring -
 		 * or just 1 for older dev images
@@ -1152,6 +1157,7 @@ static int safexcel_probe_generic(void *pdev,
 			dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
 			return ret;
 		}
+#endif
 	}
 
 	/* Register the ring IRQ handlers and configure the rings */
@@ -1503,7 +1509,9 @@ static struct pci_driver safexcel_pci_driver = {
 
 static int __init safexcel_init(void)
 {
+#ifdef CONFIG_PCI
 	int rc;
+#endif
 
 #if IS_ENABLED(CONFIG_OF)
 		/* Register platform driver */
-- 
2.20.0

