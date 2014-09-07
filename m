From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] crypto: memzero_explicit - make sure to clear out sensitive data
Date: Sun,  7 Sep 2014 18:46:00 +0200
Message-ID: <1410108360-15363-1-git-send-email-dborkman@redhat.com>
Cc: tytso@mit.edu, hannes@stressinduktion.org,
	linux-crypto@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaIGQqs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Sep 2014 12:46:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Recently, in commit 13aa93c70e71 ("random: add and use memzero_explicit()
for clearing data"), we have found that GCC may optimize some memset()
cases away when it detects a stack variable is not being used anymore
and going out of scope. This can happen, for example, in cases when we
are clearing out sensitive information such as keying material or any
e.g. intermediate results from crypto computations, etc.

With the help of Coccinelle, we can figure out and fix such occurences
in the crypto subsytem as well. Julia Lawall provided the following
Coccinelle program:

  @@
  type T;
  identifier s;
  @@

  T s[...];
  ... when any
  memset(s,...);
  ... when != s

Therefore, make use of the drop-in replacement memzero_explicit() for
exactly such cases instead of using memset().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 Herbert, Ted, I have posted my original patch that introduces
 memzero_explicit() infrastructure along with its first users
 that fixes such occurences to Ted's random tree [1]. That means,
 this one last patch on that regard would be on top of it as an
 outcome of an audit in the crypto subsystem. Would the two of
 you be okay, if Ted takes it to random as well? Changes are
 minimal and uncomplicated, but I think it would be quite
 important to get fixed. Thanks!

 [1] https://git.kernel.org/cgit/linux/kernel/git/tytso/random.git/commit/?h=dev&id=13aa93c70e716b597d2451abee5e9f0b140b831c

 crypto/cts.c            | 3 ++-
 crypto/sha1_generic.c   | 2 +-
 crypto/sha256_generic.c | 5 ++---
 crypto/sha512_generic.c | 2 +-
 crypto/tgr192.c         | 4 ++--
 crypto/wp512.c          | 8 ++++----
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 042223f..133f087 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -202,7 +202,8 @@ static int cts_cbc_decrypt(struct crypto_cts_ctx *ctx,
 	/* 5. Append the tail (BB - Ln) bytes of Xn (tmp) to Cn to create En */
 	memcpy(s + bsize + lastn, tmp + lastn, bsize - lastn);
 	/* 6. Decrypt En to create Pn-1 */
-	memset(iv, 0, sizeof(iv));
+	memzero_explicit(iv, sizeof(iv));
+
 	sg_set_buf(&sgsrc[0], s + bsize, bsize);
 	sg_set_buf(&sgdst[0], d, bsize);
 	err = crypto_blkcipher_decrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 4279480..7bb0474 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -64,7 +64,7 @@ int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			src = data + done;
 		} while (done + SHA1_BLOCK_SIZE <= len);
 
-		memset(temp, 0, sizeof(temp));
+		memzero_explicit(temp, sizeof(temp));
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 5433667..32c5e5e 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -210,10 +210,9 @@ static void sha256_transform(u32 *state, const u8 *input)
 
 	/* clear any sensitive info... */
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
-	memset(W, 0, 64 * sizeof(u32));
+	memzero_explicit(W, 64 * sizeof(u32));
 }
 
-
 static int sha224_init(struct shash_desc *desc)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
@@ -316,7 +315,7 @@ static int sha224_final(struct shash_desc *desc, u8 *hash)
 	sha256_final(desc, D);
 
 	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memset(D, 0, SHA256_DIGEST_SIZE);
+	memzero_explicit(D, SHA256_DIGEST_SIZE);
 
 	return 0;
 }
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 6ed124f..04d295a 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -238,7 +238,7 @@ static int sha384_final(struct shash_desc *desc, u8 *hash)
 	sha512_final(desc, D);
 
 	memcpy(hash, D, 48);
-	memset(D, 0, 64);
+	memzero_explicit(D, 64);
 
 	return 0;
 }
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 8740355..3c7af0d 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -612,7 +612,7 @@ static int tgr160_final(struct shash_desc *desc, u8 * out)
 
 	tgr192_final(desc, D);
 	memcpy(out, D, TGR160_DIGEST_SIZE);
-	memset(D, 0, TGR192_DIGEST_SIZE);
+	memzero_explicit(D, TGR192_DIGEST_SIZE);
 
 	return 0;
 }
@@ -623,7 +623,7 @@ static int tgr128_final(struct shash_desc *desc, u8 * out)
 
 	tgr192_final(desc, D);
 	memcpy(out, D, TGR128_DIGEST_SIZE);
-	memset(D, 0, TGR192_DIGEST_SIZE);
+	memzero_explicit(D, TGR192_DIGEST_SIZE);
 
 	return 0;
 }
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 180f1d6..ec64e77 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1102,8 +1102,8 @@ static int wp384_final(struct shash_desc *desc, u8 *out)
 	u8 D[64];
 
 	wp512_final(desc, D);
-	memcpy (out, D, WP384_DIGEST_SIZE);
-	memset (D, 0, WP512_DIGEST_SIZE);
+	memcpy(out, D, WP384_DIGEST_SIZE);
+	memzero_explicit(D, WP512_DIGEST_SIZE);
 
 	return 0;
 }
@@ -1113,8 +1113,8 @@ static int wp256_final(struct shash_desc *desc, u8 *out)
 	u8 D[64];
 
 	wp512_final(desc, D);
-	memcpy (out, D, WP256_DIGEST_SIZE);
-	memset (D, 0, WP512_DIGEST_SIZE);
+	memcpy(out, D, WP256_DIGEST_SIZE);
+	memzero_explicit(D, WP512_DIGEST_SIZE);
 
 	return 0;
 }
-- 
1.9.0
