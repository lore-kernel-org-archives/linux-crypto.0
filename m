From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] crypto: Constify (de)compression parameters
Date: Tue, 28 Apr 2015 15:36:30 +0100
Message-ID: <20150428143630.7186.86312.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In testmgr, struct pcomp_testvec takes a non-const 'params' field, which is
pointed to a const deflate_comp_params or deflate_decomp_params object.  With
gcc-5 this incurs the following warnings:

In file included from ../crypto/testmgr.c:44:0:
../crypto/testmgr.h:28736:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
   .params = &deflate_comp_params,
             ^
../crypto/testmgr.h:28748:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
   .params = &deflate_comp_params,
             ^
../crypto/testmgr.h:28776:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
   .params = &deflate_decomp_params,
             ^
../crypto/testmgr.h:28800:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
   .params = &deflate_decomp_params,
             ^

Fix this by making the parameters pointer const and constifying the things
that use it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/testmgr.h          |    2 +-
 crypto/zlib.c             |    4 ++--
 include/crypto/compress.h |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 62e2485bb428..1f5a31f23a59 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -28591,7 +28591,7 @@ struct comp_testvec {
 };
 
 struct pcomp_testvec {
-	void *params;
+	const void *params;
 	unsigned int paramsize;
 	int inlen, outlen;
 	char input[COMP_BUF_SIZE];
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 0eefa9d237ac..d51a30a29e42 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -78,7 +78,7 @@ static void zlib_exit(struct crypto_tfm *tfm)
 }
 
 
-static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
+static int zlib_compress_setup(struct crypto_pcomp *tfm, const void *params,
 			       unsigned int len)
 {
 	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
@@ -209,7 +209,7 @@ static int zlib_compress_final(struct crypto_pcomp *tfm,
 }
 
 
-static int zlib_decompress_setup(struct crypto_pcomp *tfm, void *params,
+static int zlib_decompress_setup(struct crypto_pcomp *tfm, const void *params,
 				 unsigned int len)
 {
 	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 86163ef24219..5b67af834d83 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -55,14 +55,14 @@ struct crypto_pcomp {
 };
 
 struct pcomp_alg {
-	int (*compress_setup)(struct crypto_pcomp *tfm, void *params,
+	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params,
 			      unsigned int len);
 	int (*compress_init)(struct crypto_pcomp *tfm);
 	int (*compress_update)(struct crypto_pcomp *tfm,
 			       struct comp_request *req);
 	int (*compress_final)(struct crypto_pcomp *tfm,
 			      struct comp_request *req);
-	int (*decompress_setup)(struct crypto_pcomp *tfm, void *params,
+	int (*decompress_setup)(struct crypto_pcomp *tfm, const void *params,
 				unsigned int len);
 	int (*decompress_init)(struct crypto_pcomp *tfm);
 	int (*decompress_update)(struct crypto_pcomp *tfm,
@@ -97,7 +97,7 @@ static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
 }
 
 static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
-					void *params, unsigned int len)
+					const void *params, unsigned int len)
 {
 	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
 }
@@ -120,7 +120,7 @@ static inline int crypto_compress_final(struct crypto_pcomp *tfm,
 }
 
 static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
-					  void *params, unsigned int len)
+					  const void *params, unsigned int len)
 {
 	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
 }
