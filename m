From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] MAINTAINERS: Add Krzysztof Kozlowski as maintainer of crypto/s5p-sss
Date: Fri, 10 Mar 2017 21:10:38 +0200
Message-ID: <20170310191038.7726-1-krzk@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755427AbdCJTKx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2017 14:10:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Beside developing of this driver recently, I handle also reviews and
bug reports from users so having a maintainer entry will ensure that I
will be CC-ed on important emails.

Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57634d0f3486..5dcd65e98b51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10985,6 +10985,13 @@ F:	Documentation/devicetree/bindings/regulator/samsung,s2m*.txt
 F:	Documentation/devicetree/bindings/regulator/samsung,s5m*.txt
 F:	Documentation/devicetree/bindings/clock/samsung,s2mps11.txt
 
+SAMSUNG S5P Security SubSystem (SSS) DRIVER
+M:	Krzysztof Kozlowski <krzk@kernel.org>
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
