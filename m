From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 2/5] [crypto] geode: relax in busy loop and care about return value
Date: Fri, 19 Oct 2007 12:03:50 +0200
Message-ID: <1192788233-14968-3-git-send-email-linux-crypto@ml.breakpoint.cc>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60851 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755960AbXJSKDy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Oct 2007 06:03:54 -0400
In-Reply-To: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

The code waits in a busy loop until the hardware finishes the encryption
or decryption process. This wants a cpu_relax() :)
The busy loop finishes either if the encryption is done or if the counter
is zero. If the latter is true than the hardware failed. Since this
should not happen, leave sith a BUG().

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 8bcd6d5..99ea594 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -88,9 +88,10 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 	/* Start the operation */
 	iowrite32(AES_CTRL_START | flags, _iobase + AES_CTRLA_REG);
 
-	do
+	do {
 		status = ioread32(_iobase + AES_INTR_REG);
-	while(!(status & AES_INTRA_PENDING) && --counter);
+		cpu_relax();
+	} while(!(status & AES_INTRA_PENDING) && --counter);
 
 	/* Clear the event */
 	iowrite32((status & 0xFF) | AES_INTRA_PENDING, _iobase + AES_INTR_REG);
@@ -102,6 +103,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 {
 	u32 flags = 0;
 	unsigned long iflags;
+	int ret;
 
 	if (op->len == 0)
 		return 0;
@@ -131,7 +133,8 @@ geode_aes_crypt(struct geode_aes_op *op)
 		_writefield(AES_WRITEKEY0_REG, op->key);
 	}
 
-	do_crypt(op->src, op->dst, op->len, flags);
+	ret = do_crypt(op->src, op->dst, op->len, flags);
+	BUG_ON(ret);
 
 	if (op->mode == AES_MODE_CBC)
 		_readfield(AES_WRITEIV0_REG, op->iv);
-- 
1.5.3.4
