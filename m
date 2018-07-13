From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH] crypto: inside-secure - switch to SPDX identifiers
Date: Fri, 13 Jul 2018 16:51:37 +0200
Message-ID: <20180713145138.987-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use the appropriate SPDX license identifiers and drop the license text.
This patch is only cosmetic.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c        | 5 +----
 drivers/crypto/inside-secure/safexcel.h        | 5 +----
 drivers/crypto/inside-secure/safexcel_cipher.c | 5 +----
 drivers/crypto/inside-secure/safexcel_hash.c   | 5 +----
 drivers/crypto/inside-secure/safexcel_ring.c   | 5 +----
 5 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4e86f864a952..d34ee5097739 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1,11 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Marvell
  *
  * Antoine Tenart <antoine.tenart@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 8b3ee9b59f53..4121479a3b32 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -1,11 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2017 Marvell
  *
  * Antoine Tenart <antoine.tenart@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #ifndef __SAFEXCEL_H__
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 6bb60fda2043..f20bc14e3454 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1,11 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Marvell
  *
  * Antoine Tenart <antoine.tenart@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/device.h>
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index c77b0e1655a8..7ddd540fc1fd 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -1,11 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Marvell
  *
  * Antoine Tenart <antoine.tenart@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <crypto/hmac.h>
diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index c9d2a8716b5b..471355a9c5b8 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -1,11 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Marvell
  *
  * Antoine Tenart <antoine.tenart@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/dma-mapping.h>
-- 
2.17.1
