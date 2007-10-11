From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 3/6] [crypto] geode: relax in busy loop and care about return value
Date: Thu, 11 Oct 2007 17:00:34 +0200
Message-ID: <E1IgMP4-0002kx-1R@Chamillionaire.breakpoint.cc>
References: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.2.5"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50915 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbXJLP0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Oct 2007 11:26:19 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc authenticated by bigeasy with local
	(easymta 1.00 BETA 1)
	id 1IgMP4-0002kx-1R
	for linux-crypto@vger.kernel.org; Fri, 12 Oct 2007 17:26:18 +0200
In-Reply-To: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.2.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


The code waits in a busy loop until the hardware finishes the encryption
or decryption process. This wants a cpu_relax() :)
The busy loop finishes either if the encryption is done or if the counter
is zero. If the latter is true than the hardware failed. Since this
should not happen, leave a BUG() statement to notice this.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)
--------------1.5.2.5
Content-Type: text/x-patch; name="d1f8c3225b221c7a3efd0fd07ce6a7a3ff09f8e6.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="d1f8c3225b221c7a3efd0fd07ce6a7a3ff09f8e6.diff"

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

--------------1.5.2.5--
