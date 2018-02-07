From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 7/9] X.509: remove never-set ->unsupported_key flag
Date: Tue,  6 Feb 2018 17:10:10 -0800
Message-ID: <20180207011012.5928-8-ebiggers3@gmail.com>
References: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34586 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932311AbeBGBQK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 20:16:10 -0500
In-Reply-To: <20180207011012.5928-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The X.509 parser is guaranteed to set cert->pub->pkey_algo, since
x509_extract_key_data() is a mandatory action in the X.509 ASN.1
grammar, and it returns an error code if an unrecognized
AlgorithmIdentifier is given rather than leaving the algorithm as NULL.

Therefore, remove the dead code which handled this algorithm being NULL.
This results in the ->unsupported_key flag never being set at all, so
remove that too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c    | 3 ---
 crypto/asymmetric_keys/x509_parser.h     | 1 -
 crypto/asymmetric_keys/x509_public_key.c | 9 ---------
 3 files changed, 13 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index a9e03f5c52e7..beb47fd2fca5 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -196,9 +196,6 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			return 0;
 		}
 
-		if (x509->unsupported_key)
-			goto unsupported_crypto_in_x509;
-
 		pr_debug("- issuer %s\n", x509->issuer);
 		sig = x509->sig;
 		if (sig->auth_ids[0])
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index e373e7483812..217341276ae0 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -40,7 +40,6 @@ struct x509_certificate {
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
 	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
-	bool		unsupported_key;	/* T if key uses unsupported crypto */
 	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
 	bool		blacklisted;
 };
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 9338b4558cdc..514007932ec9 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -34,9 +34,6 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	pr_devel("==>%s()\n", __func__);
 
-	if (!cert->pub->pkey_algo)
-		cert->unsupported_key = true;
-
 	if (!sig->pkey_algo)
 		cert->unsupported_sig = true;
 
@@ -173,12 +170,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
-
-	if (cert->unsupported_key) {
-		ret = -ENOPKG;
-		goto error_free_cert;
-	}
-
 	pr_devel("Cert Key Algo: %s\n", cert->pub->pkey_algo);
 	pr_devel("Cert Valid period: %lld-%lld\n", cert->valid_from, cert->valid_to);
 
-- 
2.16.0.rc1.238.g530d649a79-goog
