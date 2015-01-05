From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: AEAD: add check for presence of auth tag
Date: Mon, 05 Jan 2015 12:21:45 +0100
Message-ID: <2529951.NL2CVhi6xs@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59386 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbbAELVv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 06:21:51 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SE20D> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 5 Jan 2015 12:21:48 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AEAD decryption operation requires the authentication tag to be
present as part of the cipher text buffer. The added check verifies that
the caller provides a cipher text with at least the authentication tag.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/crypto.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 9c8776d..9099834 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -1412,6 +1412,9 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
  */
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
+	if (req->cryptlen < crypto_aead_authsize(crypto_aead_reqtfm(req)))
+		return -EINVAL;
+
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
 }
 
-- 
2.1.0
