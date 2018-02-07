From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 9/9] X.509: self_signed implies !unsupported_sig
Date: Tue,  6 Feb 2018 17:10:12 -0800
Message-ID: <20180207011012.5928-10-ebiggers3@gmail.com>
References: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35361 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932311AbeBGBQN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 20:16:13 -0500
In-Reply-To: <20180207011012.5928-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The self_signed flag on a certificate implies we verified its signature.
Hence, the signature cannot have been unsupported.

Remove the dead code that resulted from this oversight.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 18 +++---------------
 crypto/asymmetric_keys/x509_parser.h  |  2 +-
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index beb47fd2fca5..c23255240b93 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -206,13 +206,10 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				 sig->auth_ids[1]->len, sig->auth_ids[1]->data);
 
 		if (x509->self_signed) {
-			/* If there's no authority certificate specified, then
-			 * the certificate must be self-signed and is the root
-			 * of the chain.  Likewise if the cert is its own
-			 * authority.
+			/*
+			 * If the certificate is self-signed, then it is the
+			 * root of the chain.
 			 */
-			if (x509->unsupported_sig)
-				goto unsupported_crypto_in_x509;
 			x509->signer = x509;
 			pr_debug("- self-signed\n");
 			return 0;
@@ -275,15 +272,6 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		x509 = p;
 		might_sleep();
 	}
-
-unsupported_crypto_in_x509:
-	/* Just prune the certificate chain at this point if we lack some
-	 * crypto module to go further.  Note, however, we don't want to set
-	 * sinfo->unsupported_crypto as the signed info block may still be
-	 * validatable against an X.509 cert lower in the chain that we have a
-	 * trusted copy of.
-	 */
-	return 0;
 }
 
 /*
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 217341276ae0..1294cc2c855d 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -39,7 +39,7 @@ struct x509_certificate {
 	unsigned	index;
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
-	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
+	bool		self_signed;		/* T if self-signed */
 	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
 	bool		blacklisted;
 };
-- 
2.16.0.rc1.238.g530d649a79-goog
