From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 2/9] PKCS#7: fix certificate blacklisting
Date: Tue,  6 Feb 2018 17:10:05 -0800
Message-ID: <20180207011012.5928-3-ebiggers3@gmail.com>
References: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:42912 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeBGBP7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 20:15:59 -0500
In-Reply-To: <20180207011012.5928-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If there is a blacklisted certificate in a SignerInfo's certificate
chain, then pkcs7_verify_sig_chain() sets sinfo->blacklisted and returns
0.  But, pkcs7_verify() fails to handle this case appropriately, as it
actually continues on to the line 'actual_ret = 0;', indicating that the
SignerInfo has passed verification.  Consequently, PKCS#7 signature
verification ignores the certificate blacklist.

Fix this by not considering blacklisted SignerInfos to have passed
verification.

Also fix the function comment with regards to when 0 is returned.

Fixes: 03bb79315ddc ("PKCS#7: Handle blacklisted certificates")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 2f6a768b91d7..97c77f66b20d 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -366,8 +366,7 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
  *
  *  (*) -EBADMSG if some part of the message was invalid, or:
  *
- *  (*) 0 if no signature chains were found to be blacklisted or to contain
- *	unsupported crypto, or:
+ *  (*) 0 if a signature chain passed verification, or:
  *
  *  (*) -EKEYREJECTED if a blacklisted key was encountered, or:
  *
@@ -423,8 +422,11 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
 		ret = pkcs7_verify_one(pkcs7, sinfo);
-		if (sinfo->blacklisted && actual_ret == -ENOPKG)
-			actual_ret = -EKEYREJECTED;
+		if (sinfo->blacklisted) {
+			if (actual_ret == -ENOPKG)
+				actual_ret = -EKEYREJECTED;
+			continue;
+		}
 		if (ret < 0) {
 			if (ret == -ENOPKG) {
 				sinfo->unsupported_crypto = true;
-- 
2.16.0.rc1.238.g530d649a79-goog
