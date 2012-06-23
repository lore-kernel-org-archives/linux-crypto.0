From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 01/20] crypto: caam - remove line continuations from ablkcipher_append_src_dst
Date: Fri, 22 Jun 2012 19:42:35 -0500
Message-ID: <1340412174-1784-2-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:43303
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756648Ab2FWApC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:45:02 -0400
In-Reply-To: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

presumably leftovers from possible macro development.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4eec389..5c10dc5 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -143,11 +143,11 @@ static inline void aead_append_ld_iv(u32 *desc, int ivsize)
  */
 static inline void ablkcipher_append_src_dst(u32 *desc)
 {
-	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ); \
-	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ); \
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | \
-			     KEY_VLF | FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1); \
-	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF); \
+	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 |
+			     KEY_VLF | FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
 }
 
 /*
-- 
1.7.11.1
