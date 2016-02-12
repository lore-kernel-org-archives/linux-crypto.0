From: Roman Drahtmueller <draht@schaltsekun.de>
Subject: [PATCH] crypto: prevent 112bit key for 3DES
Date: Fri, 12 Feb 2016 17:45:24 +0100 (CET)
Message-ID: <alpine.LNX.2.02.1602121744210.2898@i8.fpunygfrxha.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from schaltsekun.de ([144.76.28.11]:42325 "EHLO mail.schaltsekun.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbcBLQxD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2016 11:53:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.schaltsekun.de (Postfix) with ESMTP id 39407258E5B
	for <linux-crypto@vger.kernel.org>; Fri, 12 Feb 2016 17:45:24 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


56 bit keys are already prevented from being used, which conforms to rfc2451.
As of 2016, 112 bit 3DES should be prevented, too, if the expectation
is that the algorithm uses 168 bit.

Signed-off-by: Roman Drahtmueller <draht@schaltsekun.de>
---
 crypto/des_generic.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index a717205..5810643 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -854,9 +854,25 @@ static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
  *   multiple keys.
  *
  *   However, if the first two or last two independent 64-bit keys are
- *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
+ *   equal (k1 == k2 or k2 == k3), then the 3DES operation is simply the
  *   same as DES.  Implementers MUST reject keys that exhibit this
  *   property.
+ *   -- end of RFC quote --
+ *
+ *
+ *   Keying options are:
+ *   1) 168 bit 3DES: All three 64bit keys are different.
+ *   2) 112 bit 3DES: k1 != k2, but k3 == k1.
+ *   3)  56 bit 3DES (single DES): If two successive operations use the
+ *      same key, they cancel out, leaving only one effective operation.
+ *      Having three identical keys is only a special case.
+ *      k1 == k2 or k2 == k3 (or even k1 == k2 == k3)
+ *
+ *   Option 3) MUST be rejected, this is mandated by RFC2451.
+ *   Option 2) is a bad choice as of 2016, too. The expectation is
+ *   that if 168 bit key material is provided, the implementation should
+ *   guarantee that the algorithm behaves as strongly as expected,
+ *   intercepting weak keys.
  *
  */
 int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
@@ -865,7 +881,8 @@ int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 	const u32 *K = (const u32 *)key;
 
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+		     !((K[2] ^ K[4]) | (K[3] ^ K[5])) ||
+		     !((K[0] ^ K[4]) | (K[1] ^ K[5]))) &&
 		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
-- 
1.7.3.4
