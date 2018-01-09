From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 1/2] crypto: exynos-rng - Add SPDX license identifier and correct module license
Date: Tue,  9 Jan 2018 18:57:35 +0100
Message-ID: <20180109175736.6885-1-krzk@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace GPL license statement with SPDX GPL-2.0 license identifier and
correct the module license to GPLv2.

The license itself was a generic GPL because of copy-and-paste from old
drivers/char/hw_random/exynos-rng.c driver (on which this was based on).
However the module license indicated GPL-2.0 or later.  GPL-2.0 was
intended by author so fix up this mess.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/exynos-rng.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 451620b475a0..a2e91f94096f 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * exynos-rng.c - Random Number Generator driver for the Exynos
  *
@@ -6,15 +7,6 @@
  * Loosely based on old driver from drivers/char/hw_random/exynos-rng.c:
  * Copyright (C) 2012 Samsung Electronics
  * Jonghwa Lee <jonghwa3.lee@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation;
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #include <linux/clk.h>
@@ -386,4 +378,4 @@ module_platform_driver(exynos_rng_driver);
 
 MODULE_DESCRIPTION("Exynos H/W Random Number Generator driver");
 MODULE_AUTHOR("Krzysztof Kozlowski <krzk@kernel.org>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.11.0
