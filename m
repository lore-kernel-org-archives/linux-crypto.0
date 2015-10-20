From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 7/8] crypto: testmgr: Constify tested key/iv/plaintext/digest
Date: Tue, 20 Oct 2015 09:34:03 +0200
Message-ID: <1445326444-11019-8-git-send-email-clabbe.montjoie@gmail.com>
References: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

All key/iv/plaintext/digest in testmgr are constant data.
Furthermore the testmgr will never modify thoses data.
This patch set all members of xxx_testvec as pointer to const.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/testmgr.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 64b8a80..03b2f19 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -37,9 +37,9 @@
 
 struct hash_testvec {
 	/* only used with keyed hash algorithms */
-	char *key;
-	char *plaintext;
-	char *digest;
+	const char *key;
+	const char *plaintext;
+	const char *digest;
 	unsigned char tap[MAX_TAP];
 	unsigned short psize;
 	unsigned char np;
@@ -65,10 +65,10 @@ struct hash_testvec {
  */
 
 struct cipher_testvec {
-	char *key;
-	char *iv;
-	char *input;
-	char *result;
+	const char *key;
+	const char *iv;
+	const char *input;
+	const char *result;
 	unsigned short tap[MAX_TAP];
 	int np;
 	unsigned char also_non_np;
@@ -80,11 +80,11 @@ struct cipher_testvec {
 };
 
 struct aead_testvec {
-	char *key;
-	char *iv;
-	char *input;
-	char *assoc;
-	char *result;
+	const char *key;
+	const char *iv;
+	const char *input;
+	const char *assoc;
+	const char *result;
 	unsigned char tap[MAX_TAP];
 	unsigned char atap[MAX_TAP];
 	int np;
@@ -99,10 +99,10 @@ struct aead_testvec {
 };
 
 struct cprng_testvec {
-	char *key;
-	char *dt;
-	char *v;
-	char *result;
+	const char *key;
+	const char *dt;
+	const char *v;
+	const char *result;
 	unsigned char klen;
 	unsigned short dtlen;
 	unsigned short vlen;
@@ -126,7 +126,7 @@ struct drbg_testvec {
 };
 
 struct akcipher_testvec {
-	unsigned char *key;
+	const unsigned char *key;
 	unsigned char *m;
 	unsigned char *c;
 	unsigned int key_len;
-- 
2.4.10
