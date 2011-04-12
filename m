From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/4] crypto: caam - remove WAIT-FOR-COMPLETIONs from
 givencrypt descriptor
Date: Mon, 11 Apr 2011 19:15:24 -0500
Message-ID: <20110411191524.c825a8bf.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24349 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab1DLAQO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Apr 2011 20:16:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

remains from descriptor debugging - not required for normal operation.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 20e1215..8eb84d3 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -828,15 +828,13 @@ static int aead_authenc_givencrypt(struct aead_givcrypt_request *req)
 	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
 
 	/* MOVE DECO Alignment -> C1 Context 16 bytes */
-	append_move(desc, MOVE_WAITCOMP | MOVE_SRC_INFIFO |
-		    MOVE_DEST_CLASS1CTX | ivsize);
+	append_move(desc, MOVE_SRC_INFIFO | MOVE_DEST_CLASS1CTX | ivsize);
 
 	/* re-enable info fifo entries */
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
 	/* MOVE C1 Context -> OFIFO 16 bytes */
-	append_move(desc, MOVE_WAITCOMP | MOVE_SRC_CLASS1CTX |
-		    MOVE_DEST_OUTFIFO | ivsize);
+	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_OUTFIFO | ivsize);
 
 	append_fifo_store(desc, iv_dma, ivsize, FIFOST_TYPE_MESSAGE_DATA);
 
-- 
1.7.4.3.dirty
