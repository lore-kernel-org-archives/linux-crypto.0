From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/9] PKCS#7: fix direct verification of SignerInfo signature
Date: Tue,  6 Feb 2018 17:10:06 -0800
Message-ID: <20180207011012.5928-4-ebiggers3@gmail.com>
References: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34574 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeBGBQB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 20:16:01 -0500
In-Reply-To: <20180207011012.5928-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If none of the certificates in a SignerInfo's certificate chain match a
trusted key, nor is the last certificate signed by a trusted key, then
pkcs7_validate_trust_one() tries to check whether the SignerInfo's
signature was made directly by a trusted key.  But, it actually fails to
set the 'sig' variable correctly, so it actually verifies the last
signature seen.  That will only be the SignerInfo's signature if the
certificate chain is empty; otherwise it will actually be the last
certificate's signature.

This is not by itself a security problem, since verifying any of the
certificates in the chain should be sufficient to verify the SignerInfo.
Still, it's not working as intended so it should be fixed.

Fix it by setting 'sig' correctly for the direct verification case.

Fixes: 757932e6da6d ("PKCS#7: Handle PKCS#7 messages that contain no X.509 certs")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_trust.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 1f4e25f10049..598906b1e28d 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -106,6 +106,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		pr_devel("sinfo %u: Direct signer is key %x\n",
 			 sinfo->index, key_serial(key));
 		x509 = NULL;
+		sig = sinfo->sig;
 		goto matched;
 	}
 	if (PTR_ERR(key) != -ENOKEY)
-- 
2.16.0.rc1.238.g530d649a79-goog
