From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH] crypto: Add myself as co-maintainer for s5p-sss.c
Date: Tue, 28 Nov 2017 11:07:05 +0100
Message-ID: <f2871875-a4ed-6c5e-5a67-1051e44c6dd9@partner.samsung.com>
References: <CGME20171128100706eucas1p1aa80a6c7eb4f1f4facbde258dfe9ceda@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        k.konieczny@partner.samsung.com, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60017 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdK1KHK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 05:07:10 -0500
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add myself as co-maintainer for Samsung Security SubSystem driver.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa71ab52fd76..3f6cadf2e087 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11982,6 +11982,7 @@ F:	drivers/media/i2c/s5k5baf.c
 SAMSUNG S5P Security SubSystem (SSS) DRIVER
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Vladimir Zapolskiy <vz@mleia.com>
+M:	Kamil Konieczny <k.konieczny@partner.samsung.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
-- 
2.15.0
