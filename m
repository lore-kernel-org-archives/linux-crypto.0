From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v2] dt/bindings: exynos-rng: Move dt binding documentation to bindings/crypto
Date: Wed, 23 Aug 2017 20:34:43 +0530
Message-ID: <20170823150443.8399-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mchehab@kernel.org, kgene@kernel.org,
        linux-samsung-soc@vger.kernel.org, krzk@kernel.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33769 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754130AbdHWPFw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 11:05:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Samsung exynos PRNG driver is using crypto framework instead of
hw_random framework. So move the devicetree binding to crypto folder.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
Changes in v2:
* Modify MAINTAINERS file to reflect file rename

 .../devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt         | 0
 MAINTAINERS                                                             | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt (100%)

diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
similarity index 100%
rename from Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
rename to Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
diff --git a/MAINTAINERS b/MAINTAINERS
index 4d284c7..3e0b822 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11500,7 +11500,7 @@ L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/exynos-rng.c
-F:	Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
+F:	Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
 
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jingoohan1@gmail.com>
-- 
2.10.0
