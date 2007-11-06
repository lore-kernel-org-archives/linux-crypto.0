From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] geode: fix not inplace encryption
Date: Tue, 6 Nov 2007 21:01:55 +0100
Message-ID: <20071106200155.GA28183@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Jordan Crouse <jordan.crouse@amd.com>, stable@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34463 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292AbXKFUB5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 15:01:57 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently the Geode AES module fails to encrypt or decrypt if
the coherent bits are not set what is currently the case if the
encryption does not occur inplace. However, the encryption works 
on my Geode machine _only_ if the coherent bits are always set.

Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index f2d4fba..0ca92d4 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -81,8 +81,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 	 * we don't need to worry
 	 */
 
-	if (op->src == op->dst)
-		flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
+	flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
 
 	if (op->dir == AES_DIR_ENCRYPT)
 		flags |= AES_CTRL_ENCRYPT;
-- 
1.5.3.4
