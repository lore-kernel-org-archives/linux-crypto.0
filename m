From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 2/5] KEYS: DH: don't feed uninitialized "otherinfo" into KDF
Date: Wed, 19 Apr 2017 22:46:30 -0700
Message-ID: <20170420054633.14572-3-ebiggers3@gmail.com>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33445 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939618AbdDTFsV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:48:21 -0400
In-Reply-To: <20170420054633.14572-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If userspace called KEYCTL_DH_COMPUTE with kdf_params containing NULL
otherinfo but nonzero otherinfolen, the kernel would allocate a buffer
for the otherinfo, then feed it into the KDF without initializing it.
Fix this by always doing the copy from userspace (which will fail with
EFAULT in this scenario).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/keys/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index 8abc70ebe22d..1c1cac677041 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -317,7 +317,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	 * Concatenate SP800-56A otherinfo past DH shared secret -- the
 	 * input to the KDF is (DH shared secret || otherinfo)
 	 */
-	if (kdfcopy && kdfcopy->otherinfo &&
+	if (kdfcopy &&
 	    copy_from_user(kbuf + resultlen, kdfcopy->otherinfo,
 			   kdfcopy->otherinfolen) != 0) {
 		ret = -EFAULT;
-- 
2.12.2
