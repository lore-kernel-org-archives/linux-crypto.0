From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 6/9] PKCS#7: remove unnecessary check for NULL sinfo->sig->hash_algo
Date: Tue,  6 Feb 2018 17:10:09 -0800
Message-ID: <20180207011012.5928-7-ebiggers3@gmail.com>
References: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34584 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbeBGBQI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 20:16:08 -0500
In-Reply-To: <20180207011012.5928-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The PKCS#7 parser is guaranteed to set ->sig->hash_algo for every
SignerInfo, since pkcs7_sig_note_digest_algo() is a mandatory action in
the PKCS#7 ASN.1 grammar, and it returns an error code if an
unrecognized DigestAlgorithmIdentifier is given rather than leaving the
algorithm as NULL.  Therefore, remove the unnecessary NULL check.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 97c77f66b20d..a9e03f5c52e7 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -33,9 +33,6 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 
 	kenter(",%u,%s", sinfo->index, sinfo->sig->hash_algo);
 
-	if (!sinfo->sig->hash_algo)
-		return -ENOPKG;
-
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-- 
2.16.0.rc1.238.g530d649a79-goog
