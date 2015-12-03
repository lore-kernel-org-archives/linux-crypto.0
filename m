From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] crypto: fix kernel-doc warnings in crypto/aead.h
Date: Thu, 3 Dec 2015 12:00:41 -0800
Message-ID: <56609F69.1080203@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix 21 occurrences of this kernel-doc warning in <crypto/aead.h>:

..//include/crypto/aead.h:149: warning: No description found for parameter 'base'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/crypto/aead.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-44-rc3.orig/include/crypto/aead.h
+++ lnx-44-rc3/include/crypto/aead.h
@@ -128,6 +128,7 @@ struct aead_request {
  * @exit: Deinitialize the cryptographic transformation object. This is a
  *	  counterpart to @init, used to remove various changes set in
  *	  @init.
+ * @base: Definition of a generic crypto cipher algorithm.
  *
  * All fields except @ivsize is mandatory and must be filled.
  */
