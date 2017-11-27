From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] X.509: fix comparisons of ->pkey_algo
Date: Sun, 26 Nov 2017 23:17:24 -0800
Message-ID: <20171127071724.25874-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

->pkey_algo used to be an enum, but was changed to a string by commit
4e8ae72a75aa ("X.509: Make algo identifiers text instead of enum").  But
two comparisons were not updated.  Fix them to use strcmp().

This bug broke signature verification in certain configurations,
depending on whether the string constants were deduplicated or not.

Fixes: 4e8ae72a75aa ("X.509: Make algo identifiers text instead of enum")
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c    | 2 +-
 crypto/asymmetric_keys/x509_public_key.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 2d93d9eccb4d..063d6745c741 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -150,7 +150,7 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		pr_devel("Sig %u: Found cert serial match X.509[%u]\n",
 			 sinfo->index, certix);
 
-		if (x509->pub->pkey_algo != sinfo->sig->pkey_algo) {
+		if (strcmp(x509->pub->pkey_algo, sinfo->sig->pkey_algo)) {
 			pr_warn("Sig %u: X.509 algo and PKCS#7 sig algo don't match\n",
 				sinfo->index);
 			continue;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index c9013582c026..9db20abe78a0 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -135,7 +135,7 @@ int x509_check_for_self_signed(struct x509_certificate *cert)
 	}
 
 	ret = -EKEYREJECTED;
-	if (cert->pub->pkey_algo != cert->sig->pkey_algo)
+	if (strcmp(cert->pub->pkey_algo, cert->sig->pkey_algo))
 		goto out;
 
 	ret = public_key_verify_signature(cert->pub, cert->sig);
-- 
2.15.0
