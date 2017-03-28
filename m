From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] crypto: ccp - Reduce stack frame size with KASAN
Date: Tue, 28 Mar 2017 11:58:04 +0200
Message-ID: <20170328095814.3734615-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:64008 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753702AbdC1KBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 06:01:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The newly added AES GCM implementation uses one of the largest stack frames
in the kernel, around 1KB on normal 64-bit kernels, and 1.6KB when CONFIG_KASAN
is enabled:

drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
drivers/crypto/ccp/ccp-ops.c:851:1: error: the frame size of 1632 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

This is problematic for multiple reasons:

 - The crypto functions are often used in deep call chains, e.g. behind
   mm, fs and dm layers, making it more likely to run into an actual stack
   overflow

 - Using this much stack space is an indicator that the code is not
   written to be as efficient as it could be.

 - While this goes unnoticed at the moment in mainline with the frame size
   warning being disabled when KASAN is in use, I would like to enable
   the warning again, and the current code is slightly above my arbitrary
   pick for a limit of 1536 bytes (I already did patches for every other
   driver exceeding this).

A more drastic refactoring of the driver might be needed to reduce the
stack usage more substantially, but this patch is fairly simple and
at least addresses the third one of the problems I mentioned, reducing the
stack size by about 150 bytes and bringing it below the warning limit
I picked.

Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccp/ccp-dev.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 3a45c2af2fbd..c5ea0796a891 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -432,24 +432,24 @@ struct ccp_dma_info {
 	unsigned int offset;
 	unsigned int length;
 	enum dma_data_direction dir;
-};
+} __packed __aligned(4);
 
 struct ccp_dm_workarea {
 	struct device *dev;
 	struct dma_pool *dma_pool;
-	unsigned int length;
 
 	u8 *address;
 	struct ccp_dma_info dma;
+	unsigned int length;
 };
 
 struct ccp_sg_workarea {
 	struct scatterlist *sg;
 	int nents;
+	unsigned int dma_count;
 
 	struct scatterlist *dma_sg;
 	struct device *dma_dev;
-	unsigned int dma_count;
 	enum dma_data_direction dma_dir;
 
 	unsigned int sg_used;
-- 
2.9.0
