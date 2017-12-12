From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - limit mask and type
Date: Tue, 12 Dec 2017 07:09:08 +0100
Message-ID: <4450500.tGvsruIfR8@positron.chronox.de>
References: <001a1141c43ad30ccf055efb76ed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a1141c43ad30ccf055efb76ed@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

you see the reported problem by simply using

sa.salg_mask = 0xffffffff;

Note, I am not fully sure about whether CRYPTO_AF_ALG_ALLOWED_MASK and
CRYPTO_AF_ALG_ALLOWED_TYPE have the correct value. But I think that all
that user space should reach is potentially the ASYNC flag and the
cipher types flags.

---8<---

The user space interface allows specifying the type and the mask field
used to allocate the cipher. Only a subset of the type and mask is
considered relevant to be set by user space if needed at all.

This fixes a bug where user space is able to cause one cipher to be
registered multiple times potentially exhausting kernel memory.

Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 7 +++++++
 crypto/algif_aead.c     | 2 ++
 crypto/algif_hash.c     | 2 ++
 crypto/algif_rng.c      | 2 ++
 crypto/algif_skcipher.c | 2 ++
 include/crypto/if_alg.h | 1 +
 include/linux/crypto.h  | 3 +++
 7 files changed, 19 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1e5353f62067..16cfbde64048 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1172,6 +1172,13 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 }
 EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
 
+void af_alg_restrict_type_mask(u32 *type, u32 *mask)
+{
+	*type &= CRYPTO_AF_ALG_ALLOWED_TYPE;
+	*mask &= CRYPTO_AF_ALG_ALLOWED_MASK;
+}
+EXPORT_SYMBOL_GPL(af_alg_restrict_type_mask);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 9d73be28cf01..5d21db83bdfd 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -463,6 +463,8 @@ static void *aead_bind(const char *name, u32 type, u32 mask)
 	if (!tfm)
 		return ERR_PTR(-ENOMEM);
 
+	af_alg_restrict_type_mask(&type, &mask);
+
 	aead = crypto_alloc_aead(name, type, mask);
 	if (IS_ERR(aead)) {
 		kfree(tfm);
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 76d2e716c792..f7660e80cd05 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -419,6 +419,8 @@ static void *hash_bind(const char *name, u32 type, u32 mask)
 	if (!tfm)
 		return ERR_PTR(-ENOMEM);
 
+	af_alg_restrict_type_mask(&type, &mask);
+
 	hash = crypto_alloc_ahash(name, type, mask);
 	if (IS_ERR(hash)) {
 		kfree(tfm);
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 150c2b6480ed..33a7064996f2 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -116,6 +116,8 @@ static struct proto_ops algif_rng_ops = {
 
 static void *rng_bind(const char *name, u32 type, u32 mask)
 {
+	af_alg_restrict_type_mask(&type, &mask);
+
 	return crypto_alloc_rng(name, type, mask);
 }
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 9954b078f0b9..0a4987aa9d5c 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -314,6 +314,8 @@ static void *skcipher_bind(const char *name, u32 type, u32 mask)
 	if (!tfm)
 		return ERR_PTR(-ENOMEM);
 
+	af_alg_restrict_type_mask(&type, &mask);
+
 	skcipher = crypto_alloc_skcipher(name, type, mask);
 	if (IS_ERR(skcipher)) {
 		kfree(tfm);
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 6abf0a3604dc..8ade69d46025 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -250,5 +250,6 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 		    struct af_alg_async_req *areq, size_t maxsize,
 		    size_t *outlen);
+void af_alg_restrict_type_mask(u32 *type, u32 *mask);
 
 #endif	/* _CRYPTO_IF_ALG_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 78508ca4b108..0d7694673fff 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -70,6 +70,9 @@
 #define CRYPTO_ALG_DYING		0x00000040
 #define CRYPTO_ALG_ASYNC		0x00000080
 
+#define CRYPTO_AF_ALG_ALLOWED_MASK	0x000000ff
+#define CRYPTO_AF_ALG_ALLOWED_TYPE	0x000000ff
+
 /*
  * Set this bit if and only if the algorithm requires another algorithm of
  * the same type to handle corner cases.
-- 
2.14.3
