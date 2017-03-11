From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2] MAINTAINERS: Add maintianer entry for crypto/s5p-sss
Date: Sat, 11 Mar 2017 08:11:00 +0200
Message-ID: <20170311061100.4659-1-krzk@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdCKGL1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2017 01:11:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Krzysztof Kozlowski and Vladimir Zapolskiy as maintainers of s5p-sss
driver for handling reviews, testing and getting bug reports from the
users.

Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Add also Vladimir
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57634d0f3486..94b221714fa8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10985,6 +10985,14 @@ F:	Documentation/devicetree/bindings/regulator/samsung,s2m*.txt
 F:	Documentation/devicetree/bindings/regulator/samsung,s5m*.txt
 F:	Documentation/devicetree/bindings/clock/samsung,s2mps11.txt
 
+SAMSUNG S5P Security SubSystem (SSS) DRIVER
+M:	Krzysztof Kozlowski <krzk@kernel.org>
+M:	Vladimir Zapolskiy <vz@mleia.com>
+L:	linux-crypto@vger.kernel.org
+L:	linux-samsung-soc@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/s5p-sss.c
+
 SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
-- 
2.9.3
