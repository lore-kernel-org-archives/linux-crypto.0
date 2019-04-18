Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C270CC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8790E20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbfDRNlG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:41:06 -0400
Received: from foss.arm.com ([217.140.101.70]:33636 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389055AbfDRNlF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:41:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B30C80D;
        Thu, 18 Apr 2019 06:41:04 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F20E03F5AF;
        Thu, 18 Apr 2019 06:41:02 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/35] crypto: ccree: copyright header update
Date:   Thu, 18 Apr 2019 16:38:53 +0300
Message-Id: <20190418133913.9122-19-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This sacrificial copyright header update is offered to the legal department
as atonement for any changes made in this driver files in the course of
the current year which have not been duly recorded as such.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/Makefile           | 1 +
 drivers/crypto/ccree/cc_aead.c          | 2 +-
 drivers/crypto/ccree/cc_aead.h          | 2 +-
 drivers/crypto/ccree/cc_buffer_mgr.c    | 2 +-
 drivers/crypto/ccree/cc_buffer_mgr.h    | 2 +-
 drivers/crypto/ccree/cc_cipher.c        | 2 +-
 drivers/crypto/ccree/cc_cipher.h        | 2 +-
 drivers/crypto/ccree/cc_crypto_ctx.h    | 2 +-
 drivers/crypto/ccree/cc_debugfs.h       | 2 +-
 drivers/crypto/ccree/cc_driver.h        | 2 +-
 drivers/crypto/ccree/cc_fips.c          | 2 +-
 drivers/crypto/ccree/cc_fips.h          | 2 +-
 drivers/crypto/ccree/cc_hash.c          | 2 +-
 drivers/crypto/ccree/cc_hash.h          | 2 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h | 2 +-
 drivers/crypto/ccree/cc_ivgen.c         | 2 +-
 drivers/crypto/ccree/cc_ivgen.h         | 2 +-
 drivers/crypto/ccree/cc_kernel_regs.h   | 2 +-
 drivers/crypto/ccree/cc_lli_defs.h      | 2 +-
 drivers/crypto/ccree/cc_pm.c            | 2 +-
 drivers/crypto/ccree/cc_pm.h            | 2 +-
 drivers/crypto/ccree/cc_request_mgr.c   | 2 +-
 drivers/crypto/ccree/cc_request_mgr.h   | 2 +-
 drivers/crypto/ccree/cc_sram_mgr.c      | 2 +-
 drivers/crypto/ccree/cc_sram_mgr.h      | 2 +-
 25 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccree/Makefile b/drivers/crypto/ccree/Makefile
index bdc27970f95f..145e50bdbf16 100644
--- a/drivers/crypto/ccree/Makefile
+++ b/drivers/crypto/ccree/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2012-2019 ARM Limited (or its affiliates).
 
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
 ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_cipher.o cc_hash.o cc_aead.o cc_ivgen.o cc_sram_mgr.o
diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 8c08a50a4008..ed306a612c0f 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/crypto/ccree/cc_aead.h b/drivers/crypto/ccree/cc_aead.h
index 5edf3b351fa4..6cfae15f85e5 100644
--- a/drivers/crypto/ccree/cc_aead.h
+++ b/drivers/crypto/ccree/cc_aead.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_aead.h
  * ARM CryptoCell AEAD Crypto API
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index ccb0257bdc58..09d352591a30 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.h b/drivers/crypto/ccree/cc_buffer_mgr.h
index 3ec4b4db5247..a726016bdbc1 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.h
+++ b/drivers/crypto/ccree/cc_buffer_mgr.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_buffer_mgr.h
  * Buffer Manager
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 1ba7c8a7bd52..d9f8cd543ee3 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/crypto/ccree/cc_cipher.h b/drivers/crypto/ccree/cc_cipher.h
index 312d67f88414..da3a38707fae 100644
--- a/drivers/crypto/ccree/cc_cipher.h
+++ b/drivers/crypto/ccree/cc_cipher.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_cipher.h
  * ARM CryptoCell Cipher Crypto API
diff --git a/drivers/crypto/ccree/cc_crypto_ctx.h b/drivers/crypto/ccree/cc_crypto_ctx.h
index 97e56e9af01e..ccf960a0d989 100644
--- a/drivers/crypto/ccree/cc_crypto_ctx.h
+++ b/drivers/crypto/ccree/cc_crypto_ctx.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef _CC_CRYPTO_CTX_H_
 #define _CC_CRYPTO_CTX_H_
diff --git a/drivers/crypto/ccree/cc_debugfs.h b/drivers/crypto/ccree/cc_debugfs.h
index 01cbd9a95659..664ff402e0e9 100644
--- a/drivers/crypto/ccree/cc_debugfs.h
+++ b/drivers/crypto/ccree/cc_debugfs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef __CC_DEBUGFS_H__
 #define __CC_DEBUGFS_H__
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 10439ce27b3b..d21e0f0b5218 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_driver.h
  * ARM CryptoCell Linux Crypto Driver
diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 9c03ab238a75..4a67248f5625 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <linux/kernel.h>
 #include <linux/fips.h>
diff --git a/drivers/crypto/ccree/cc_fips.h b/drivers/crypto/ccree/cc_fips.h
index 645e096a7a82..2c287faf10ff 100644
--- a/drivers/crypto/ccree/cc_fips.h
+++ b/drivers/crypto/ccree/cc_fips.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef __CC_FIPS_H__
 #define __CC_FIPS_H__
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 8f15ce3deecd..940101fee68e 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/crypto/ccree/cc_hash.h b/drivers/crypto/ccree/cc_hash.h
index 2e5bf8b0bbb6..0d6dc61484d7 100644
--- a/drivers/crypto/ccree/cc_hash.h
+++ b/drivers/crypto/ccree/cc_hash.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_hash.h
  * ARM CryptoCell Hash Crypto API
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index fd693681808e..9f4db9956e91 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef __CC_HW_QUEUE_DEFS_H__
 #define __CC_HW_QUEUE_DEFS_H__
diff --git a/drivers/crypto/ccree/cc_ivgen.c b/drivers/crypto/ccree/cc_ivgen.c
index 1abec3896a78..99dc69383e20 100644
--- a/drivers/crypto/ccree/cc_ivgen.c
+++ b/drivers/crypto/ccree/cc_ivgen.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <crypto/ctr.h>
 #include "cc_driver.h"
diff --git a/drivers/crypto/ccree/cc_ivgen.h b/drivers/crypto/ccree/cc_ivgen.h
index b6ac16903dda..a9f5e8bba4f1 100644
--- a/drivers/crypto/ccree/cc_ivgen.h
+++ b/drivers/crypto/ccree/cc_ivgen.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef __CC_IVGEN_H__
 #define __CC_IVGEN_H__
diff --git a/drivers/crypto/ccree/cc_kernel_regs.h b/drivers/crypto/ccree/cc_kernel_regs.h
index 8d7262a35156..582bae450596 100644
--- a/drivers/crypto/ccree/cc_kernel_regs.h
+++ b/drivers/crypto/ccree/cc_kernel_regs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef __CC_CRYS_KERNEL_H__
 #define __CC_CRYS_KERNEL_H__
diff --git a/drivers/crypto/ccree/cc_lli_defs.h b/drivers/crypto/ccree/cc_lli_defs.h
index 64b15ac9f1d3..43aca6b79b9b 100644
--- a/drivers/crypto/ccree/cc_lli_defs.h
+++ b/drivers/crypto/ccree/cc_lli_defs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef _CC_LLI_DEFS_H_
 #define _CC_LLI_DEFS_H_
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 6ff7e75ad90e..6f278a0d8ee6 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index 907a6db4d6c0..6190cdba5dad 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_pm.h
  */
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index c2e8190bb067..0bc6ccb0b899 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include <linux/kernel.h>
 #include <linux/nospec.h>
diff --git a/drivers/crypto/ccree/cc_request_mgr.h b/drivers/crypto/ccree/cc_request_mgr.h
index 573cb97af085..f46cf766fe4d 100644
--- a/drivers/crypto/ccree/cc_request_mgr.h
+++ b/drivers/crypto/ccree/cc_request_mgr.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 /* \file cc_request_mgr.h
  * Request Manager
diff --git a/drivers/crypto/ccree/cc_sram_mgr.c b/drivers/crypto/ccree/cc_sram_mgr.c
index 86319788e390..62c885e6e791 100644
--- a/drivers/crypto/ccree/cc_sram_mgr.c
+++ b/drivers/crypto/ccree/cc_sram_mgr.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #include "cc_driver.h"
 #include "cc_sram_mgr.h"
diff --git a/drivers/crypto/ccree/cc_sram_mgr.h b/drivers/crypto/ccree/cc_sram_mgr.h
index d48649fb3323..1d14de9ee8c3 100644
--- a/drivers/crypto/ccree/cc_sram_mgr.h
+++ b/drivers/crypto/ccree/cc_sram_mgr.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+/* Copyright (C) 2012-2019 ARM Limited (or its affiliates). */
 
 #ifndef __CC_SRAM_MGR_H__
 #define __CC_SRAM_MGR_H__
-- 
2.21.0

