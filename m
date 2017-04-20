From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/5] KEYS: DH: don't feed uninitialized result memory into KDF
Date: Wed, 19 Apr 2017 22:46:31 -0700
Message-ID: <20170420054633.14572-4-ebiggers3@gmail.com>
References: <20170420054633.14572-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33455 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938756AbdDTFsW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:48:22 -0400
In-Reply-To: <20170420054633.14572-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The result of the Diffie-Hellman computation may be shorter than the
input prime number.  Only calculate the KDF over the actual result;
don't include additional uninitialized memory.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/keys/dh.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index 1c1cac677041..a3a8607107f5 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -313,17 +313,6 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto error4;
 	}
 
-	/*
-	 * Concatenate SP800-56A otherinfo past DH shared secret -- the
-	 * input to the KDF is (DH shared secret || otherinfo)
-	 */
-	if (kdfcopy &&
-	    copy_from_user(kbuf + resultlen, kdfcopy->otherinfo,
-			   kdfcopy->otherinfolen) != 0) {
-		ret = -EFAULT;
-		goto error5;
-	}
-
 	ret = do_dh(result, base, private, prime);
 	if (ret)
 		goto error5;
@@ -333,8 +322,17 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		goto error5;
 
 	if (kdfcopy) {
+		/*
+		 * Concatenate SP800-56A otherinfo past DH shared secret -- the
+		 * input to the KDF is (DH shared secret || otherinfo)
+		 */
+		if (copy_from_user(kbuf + nbytes, kdfcopy->otherinfo,
+				   kdfcopy->otherinfolen) != 0) {
+			ret = -EFAULT;
+			goto error5;
+		}
 		ret = keyctl_dh_compute_kdf(sdesc, buffer, buflen, kbuf,
-					    resultlen + kdfcopy->otherinfolen);
+					    nbytes + kdfcopy->otherinfolen);
 	} else {
 		ret = nbytes;
 		if (copy_to_user(buffer, kbuf, nbytes) != 0)
-- 
2.12.2
