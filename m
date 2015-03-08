From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: AES-NI: fix memory usage in GCM decryption
Date: Sun, 08 Mar 2015 19:49:58 +0100
Message-ID: <22281096.OZkxDCz0xu@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:45965 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbCHSuC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 14:50:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The RFC4106 GCM decryption operation tries to overwrite cryptlen memory
in req->dst. As the destination buffer for decryption only needs to hold
the plaintext memory but cryptlen references the input buffer holding
(ciphertext || authentication tag), the assumption of the destination
buffer length in RFC4106 GCM operation leads to a too large size.

This patch simply subtracts the authentication tag size from cryptlen.
The kernel crypto API logic requires the caller to provide the
length of (ciphertext || authentication tag) as cryptlen for the
AEAD decryption operation. Thus, the cipher implementation must
caculate the size of the plaintext output itself and cannot simply use
cryptlen.

Note, this fixes a kernel crash that can be triggered from user space
via AF_ALG(aead)  without it (simply use the libkcapi test application
from [1] and update it to use rfc4106-gcm-aes).

[1] http://www.chronox.de/libkcapi.html

CC: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 6893f49..8f7900e8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1160,7 +1160,8 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 		scatterwalk_done(&src_sg_walk, 0, 0);
 		scatterwalk_done(&assoc_sg_walk, 0, 0);
 	} else {
-		scatterwalk_map_and_copy(dst, req->dst, 0, req->cryptlen, 1);
+		scatterwalk_map_and_copy(dst, req->dst, 0,
+					 (req->cryptlen - auth_tag_len), 1);
 		kfree(src);
 	}
 	return retval;
-- 
2.1.0
