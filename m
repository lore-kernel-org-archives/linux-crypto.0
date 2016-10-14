From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: Move RSA+MPI constructs into an #include file
Date: Fri, 14 Oct 2016 14:36:00 -0500
Message-ID: <20161014193559.4342.74036.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0040.outbound.protection.outlook.com ([104.47.32.40]:44688
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755821AbcJNTgH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2016 15:36:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move RSA support of general use into internal/rsa.h.
This allows reuse of, e.g. RSA MPI keys and support
functions.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 crypto/rsa.c                  |   16 ----------------
 include/crypto/internal/rsa.h |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4c280b6..15e9220 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -16,12 +16,6 @@
 #include <crypto/akcipher.h>
 #include <crypto/algapi.h>
 
-struct rsa_mpi_key {
-	MPI n;
-	MPI e;
-	MPI d;
-};
-
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
  * c = m^e mod n;
@@ -240,16 +234,6 @@ err_free_m:
 	return ret;
 }
 
-static void rsa_free_mpi_key(struct rsa_mpi_key *key)
-{
-	mpi_free(key->d);
-	mpi_free(key->e);
-	mpi_free(key->n);
-	key->d = NULL;
-	key->e = NULL;
-	key->n = NULL;
-}
-
 static int rsa_check_key_length(unsigned int len)
 {
 	switch (len) {
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index 9e8f159..253b275 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -13,6 +13,7 @@
 #ifndef _RSA_HELPER_
 #define _RSA_HELPER_
 #include <linux/types.h>
+#include <linux/mpi.h>
 
 /**
  * rsa_key - RSA key structure
@@ -52,6 +53,22 @@ struct rsa_key {
 	size_t qinv_sz;
 };
 
+struct rsa_mpi_key {
+	MPI n;
+	MPI e;
+	MPI d;
+};
+
+static inline void rsa_free_mpi_key(struct rsa_mpi_key *key)
+{
+	mpi_free(key->d);
+	mpi_free(key->e);
+	mpi_free(key->n);
+	key->d = NULL;
+	key->e = NULL;
+	key->n = NULL;
+}
+
 int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 		      unsigned int key_len);
 
