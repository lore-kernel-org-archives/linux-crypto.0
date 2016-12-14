From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2] wusbcore: Fix one more crypto-on-the-stack bug
Date: Tue, 13 Dec 2016 18:50:13 -0800
Message-ID: <274e968135f3376766e979d11091715889cdb492.1481683797.git.luto@kernel.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753016AbcLNC7L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 21:59:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver put a constant buffer of all zeros on the stack and
pointed a scatterlist entry at it.  This doesn't work with virtual
stacks.  Use ZERO_PAGE instead.

Cc: stable@vger.kernel.org # 4.9 only
Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/usb/wusbcore/crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 79451f7ef1b7..062c205f0046 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -216,7 +216,6 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 	struct scatterlist sg[4], sg_dst;
 	void *dst_buf;
 	size_t dst_size;
-	const u8 bzero[16] = { 0 };
 	u8 iv[crypto_skcipher_ivsize(tfm_cbc)];
 	size_t zero_padding;
 
@@ -261,7 +260,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 	sg_set_buf(&sg[1], &scratch->b1, sizeof(scratch->b1));
 	sg_set_buf(&sg[2], b, blen);
 	/* 0 if well behaved :) */
-	sg_set_buf(&sg[3], bzero, zero_padding);
+	sg_set_page(&sg[3], ZERO_PAGE(0), zero_padding, 0);
 	sg_init_one(&sg_dst, dst_buf, dst_size);
 
 	skcipher_request_set_tfm(req, tfm_cbc);
-- 
2.9.3
