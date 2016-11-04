From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 5/9] crypto: Move RSA+MPI constructs into an #include file
Date: Fri, 4 Nov 2016 11:04:17 -0500
Message-ID: <20161104160417.18155.32963.stgit@taos>
References: <20161104160140.18155.75618.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0040.outbound.protection.outlook.com ([104.47.34.40]:29632
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935059AbcKDQEb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2016 12:04:31 -0400
In-Reply-To: <20161104160140.18155.75618.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RSA support of general use, but dependent upon MPI,
should go into internal/rsa.h

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
@@ -240,16 +234,6 @@ static int rsa_verify(struct akcipher_request *req)
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
 
