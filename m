From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] KEYS: be careful with error codes in public_key_verify_signature()
Date: Sun, 26 Nov 2017 23:20:22 -0800
Message-ID: <20171127072022.26398-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:41927 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdK0HUe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:20:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In public_key_verify_signature(), if akcipher_request_alloc() fails, we
return -ENOMEM.  But that error code was set 25 lines above, and by
accident someone could easily insert new code in between that assigns to
'ret', which would introduce a signature verification bypass.  Make the
code clearer by moving the -ENOMEM down to where it is used.

Additionally, the callers of public_key_verify_signature() only consider
a negative return value to be an error.  This means that if any positive
return value is accidentally introduced deeper in the call stack (e.g.
'return EBADMSG' instead of 'return -EBADMSG' somewhere in RSA),
signature verification will be bypassed.  Make things more robust by
having public_key_verify_signature() warn about positive errors and
translate them into -EINVAL.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/public_key.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index bc3035ef27a2..de996586762a 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -73,7 +73,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	char alg_name_buf[CRYPTO_MAX_ALG_NAME];
 	void *output;
 	unsigned int outlen;
-	int ret = -ENOMEM;
+	int ret;
 
 	pr_devel("==>%s()\n", __func__);
 
@@ -99,6 +99,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
+	ret = -ENOMEM;
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
 		goto error_free_tfm;
@@ -127,7 +128,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	 * signature and returns that to us.
 	 */
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
-	if (ret < 0)
+	if (ret)
 		goto out_free_output;
 
 	/* Do the actual verification step. */
@@ -142,6 +143,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 error_free_tfm:
 	crypto_free_akcipher(tfm);
 	pr_devel("<==%s() = %d\n", __func__, ret);
+	if (WARN_ON_ONCE(ret > 0))
+		ret = -EINVAL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(public_key_verify_signature);
-- 
2.15.0
