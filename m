From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 2/2] crypto: s5p-sss - Add SPDX license identifier
Date: Tue,  9 Jan 2018 18:57:36 +0100
Message-ID: <20180109175736.6885-2-krzk@kernel.org>
References: <20180109175736.6885-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <krzk@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Kukjin Kim <kgene@kernel.org>,
 Vladimir Zapolskiy <vz@mleia.com>,
 Kamil Konieczny <k.konieczny@partner.samsung.com>,
 linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180109175736.6885-1-krzk@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Replace GPL license statement with SPDX GPL-2.0 license identifier.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 62830a43d959..188f44b7eb27 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1,17 +1,13 @@
-/*
- * Cryptographic API.
- *
- * Support for Samsung S5PV210 and Exynos HW acceleration.
- *
- * Copyright (C) 2011 NetUP Inc. All rights reserved.
- * Copyright (c) 2017 Samsung Electronics Co., Ltd. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * Hash part based on omap-sham.c driver.
- */
+// SPDX-License-Identifier: GPL-2.0
+//
+// Cryptographic API.
+//
+// Support for Samsung S5PV210 and Exynos HW acceleration.
+//
+// Copyright (C) 2011 NetUP Inc. All rights reserved.
+// Copyright (c) 2017 Samsung Electronics Co., Ltd. All rights reserved.
+//
+// Hash part based on omap-sham.c driver.
 
 #include <linux/clk.h>
 #include <linux/crypto.h>
-- 
2.11.0
