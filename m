From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/8] KEYS: Make the X.509 and PKCS7 parsers supply the sig
 encoding type [ver #2]
Date: Thu, 23 Jun 2016 14:48:05 +0100
Message-ID: <146668968517.2977.1963948032838432499.stgit@warthog.procyon.org.uk>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
	tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Make the X.509 and PKCS7 parsers fill in the signature encoding type field
recently added to the public_key_signature struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.c     |    1 +
 crypto/asymmetric_keys/x509_cert_parser.c |   21 +++++++++------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index af4cd8649117..5f0c6755a55b 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -261,6 +261,7 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 	switch (ctx->last_oid) {
 	case OID_rsaEncryption:
 		ctx->sinfo->sig->pkey_algo = "rsa";
+		ctx->sinfo->sig->encoding = "pkcs1";
 		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 865f46ea724f..1f1899d5ab43 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -199,35 +199,32 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 
 	case OID_md4WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "md4";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha1WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha1";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha256WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha256";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha384WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha384";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha512WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha512";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 
 	case OID_sha224WithRSAEncryption:
 		ctx->cert->sig->hash_algo = "sha224";
-		ctx->cert->sig->pkey_algo = "rsa";
-		break;
+		goto rsa_pkcs1;
 	}
 
+rsa_pkcs1:
+	ctx->cert->sig->pkey_algo = "rsa";
+	ctx->cert->sig->encoding = "pkcs1";
 	ctx->algo_oid = ctx->last_oid;
 	return 0;
 }
