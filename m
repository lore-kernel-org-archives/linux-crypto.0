From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] wusbcore: Fix one more crypto-on-the-stack bug
Date: Mon, 12 Dec 2016 12:52:45 -0800
Message-ID: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753247AbcLLUwv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 15:52:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver put a constant buffer of all zeros on the stack and
pointed a scatterlist entry at it.  This doesn't work with virtual
stacks.  Make the buffer static to fix it.

Cc: stable@vger.kernel.org # 4.9 only
Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/usb/wusbcore/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 79451f7ef1b7..a7e007a0cd49 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -216,7 +216,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 	struct scatterlist sg[4], sg_dst;
 	void *dst_buf;
 	size_t dst_size;
-	const u8 bzero[16] = { 0 };
+	static const u8 bzero[16] = { 0 };
 	u8 iv[crypto_skcipher_ivsize(tfm_cbc)];
 	size_t zero_padding;
 
-- 
2.9.3
