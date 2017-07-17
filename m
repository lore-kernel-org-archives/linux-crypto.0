From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Update copyright dates for 2017.
Date: Mon, 17 Jul 2017 15:00:49 -0500
Message-ID: <150032164930.102823.3343010570529952742.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:64480
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751316AbdGQUAy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 16:00:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some updates this year have not had copyright dates changed in modified
files. Correct this for 2017.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |    2 +-
 drivers/crypto/ccp/ccp-crypto-des3.c       |    2 +-
 drivers/crypto/ccp/ccp-crypto-main.c       |    2 +-
 drivers/crypto/ccp/ccp-crypto-sha.c        |    2 +-
 drivers/crypto/ccp/ccp-crypto.h            |    2 +-
 drivers/crypto/ccp/ccp-dev-v3.c            |    2 +-
 drivers/crypto/ccp/ccp-dev-v5.c            |    2 +-
 drivers/crypto/ccp/ccp-dev.c               |    2 +-
 drivers/crypto/ccp/ccp-dev.h               |    2 +-
 drivers/crypto/ccp/ccp-dmaengine.c         |    2 +-
 drivers/crypto/ccp/ccp-ops.c               |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index 38ee6f348ea9..52313524a4dd 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) AES GCM crypto API support
  *
- * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2016,2017 Advanced Micro Devices, Inc.
  *
  * Author: Gary R Hook <gary.hook@amd.com>
  *
diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 5af7347ae03c..ae87b741f9d5 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) DES3 crypto API support
  *
- * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2016,2017 Advanced Micro Devices, Inc.
  *
  * Author: Gary R Hook <ghook@amd.com>
  *
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 8dccbddabef1..78b9d26a381f 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) crypto API support
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index ce97b3868f4a..8b9b16d433f7 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) SHA crypto API support
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index dd5bf15f06e5..156b8233853f 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) crypto API support
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 695fde887c11..c2861749e2ad 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index b0391f03b0fe..b3526336d608 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2016,2017 Advanced Micro Devices, Inc.
  *
  * Author: Gary R Hook <gary.hook@amd.com>
  *
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index b2d176164402..52eb3ed25a26 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index b959e2402aa2..9320931d89da 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index e00be01fbf5a..901343dd513e 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2016,2017 Advanced Micro Devices, Inc.
  *
  * Author: Gary R Hook <gary.hook@amd.com>
  *
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 78f29d459df8..e23d138fc1ce 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  * Author: Gary R Hook <gary.hook@amd.com>
