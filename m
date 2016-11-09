From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 12/14] crypto: caam - move sec4_sg_entry to sg_sw_sec4.h
Date: Wed, 9 Nov 2016 10:46:22 +0200
Message-ID: <1478681184-9442-13-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0052.outbound.protection.outlook.com ([104.47.34.52]:37472
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751745AbcKIJDf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 04:03:35 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sec4_sg_entry structure is used only by helper functions in sg_sw_sec4.h.
Since SEC HW S/G entries are to be manipulated only indirectly, via these
functions, move sec4_sg_entry to the corresponding header.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/desc.h       | 6 ------
 drivers/crypto/caam/sg_sw_sec4.h | 6 +++++-
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 61059abef737..2e6766a1573f 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -22,12 +22,6 @@
 #define SEC4_SG_LEN_MASK	0x3fffffff	/* Excludes EXT and FINAL */
 #define SEC4_SG_OFFSET_MASK	0x00001fff
 
-struct sec4_sg_entry {
-	u64 ptr;
-	u32 len;
-	u32 bpid_offset;
-};
-
 /* Max size of any CAAM descriptor in 32-bit words, inclusive of header */
 #define MAX_CAAM_DESCSIZE	64
 
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 41cd5a356d05..6afa20c4a013 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -7,7 +7,11 @@
 
 #include "regs.h"
 
-struct sec4_sg_entry;
+struct sec4_sg_entry {
+	u64 ptr;
+	u32 len;
+	u32 bpid_offset;
+};
 
 /*
  * convert single dma address to h/w link table format
-- 
2.4.4
