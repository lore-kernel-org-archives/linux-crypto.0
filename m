From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v2] crypto: Add myself as co-maintainer for s5p-sss.c
Date: Fri, 01 Dec 2017 17:51:02 +0100
Message-ID: <acd334d8-987e-c161-bb4b-d43c7336a0df@partner.samsung.com>
References: <CGME20171201165104eucas1p1bb39f164ff03b3c335a8e2dd4a91cff8@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, k.konieczny@partner.samsung.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-language: en-US
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add myself as co-maintainer for Samsung Security SubSystem driver.
I have added major functionality to the driver [hash acceleration],
I have access to documentation and to hardware for testing, I can
also dedicate some of my paid time for reviewing and verifying changes
to the driver.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
Changes:
 v2: clarify reasons for co-maintenance.

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
