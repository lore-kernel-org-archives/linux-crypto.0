From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] Update the links to the white papers on CRC32C
 calculations with PCLMULQDQ instructions.
Date: Thu, 21 Feb 2013 11:04:22 -0800
Message-ID: <1361473462.17632.202.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>,
	James Guilford <james.guilford@intel.com>,
	David Cote <david.m.cote@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert,

The following patch update the stale link to the CRC32C white paper 
that was referenced.

Tim


Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 93c6d39..f3f1e42 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -1,9 +1,10 @@
 /*
  * Implement fast CRC32C with PCLMULQDQ instructions. (x86_64)
  *
- * The white paper on CRC32C calculations with PCLMULQDQ instruction can be
+ * The white papers on CRC32C calculations with PCLMULQDQ instruction can be
  * downloaded from:
- * http://download.intel.com/design/intarch/papers/323405.pdf
+ * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/crc-iscsi-polynomial-crc32-instruction-paper.pdf
+ * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-crc-computation-paper.pdf
  *
  * Copyright (C) 2012 Intel Corporation.
  *
-- 
1.7.6.5
