From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] crypto/mcryptd: Check mcryptd algorithm compatability
Date: Fri,  2 Dec 2016 16:15:21 -0800
Message-ID: <deb5f529a0ff9b454fcc62b849ac3aff96c3e684.1480724043.git.tim.c.chen@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, megha.dey@linux.intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Algorithms not compatible with mcryptd could be spawned by mcryptd
with a direct crypto_alloc_tfm invocation using a "mcryptd(alg)"
name construct.  This causes mcryptd to crash the kernel if
"alg" is incompatible and not intended to be used with mcryptd.

A flag CRYPTO_ALG_MCRYPT is being added to mcryptd compatible
algorithms' cra_flags. The compatability is checked when mcryptd spawn
off an algorithm.

Link: http://marc.info/?l=linux-crypto-vger&m=148063683310477&w=2
Cc: stable@vger.kernel.org
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha1-mb/sha1_mb.c     | 3 ++-
 arch/x86/crypto/sha256-mb/sha256_mb.c | 3 ++-
 arch/x86/crypto/sha512-mb/sha512_mb.c | 3 ++-
 crypto/mcryptd.c                      | 6 ++++++
 include/linux/crypto.h                | 6 ++++++
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha1-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
index acf9fdf..475959db 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -770,7 +770,8 @@ static struct ahash_alg sha1_mb_areq_alg = {
 			 */
 			.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
 						CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_INTERNAL,
+						CRYPTO_ALG_INTERNAL |
+						CRYPTO_ALG_MCRYPT,
 			.cra_blocksize	= SHA1_BLOCK_SIZE,
 			.cra_module	= THIS_MODULE,
 			.cra_list	= LIST_HEAD_INIT
diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypto/sha256-mb/sha256_mb.c
index 7926a22..f33b592 100644
--- a/arch/x86/crypto/sha256-mb/sha256_mb.c
+++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
@@ -768,7 +768,8 @@ static struct ahash_alg sha256_mb_areq_alg = {
 			 */
 			.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
 						CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_INTERNAL,
+						CRYPTO_ALG_INTERNAL |
+						CRYPTO_ALG_MCRYPT,
 			.cra_blocksize	= SHA256_BLOCK_SIZE,
 			.cra_module	= THIS_MODULE,
 			.cra_list	= LIST_HEAD_INIT
diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
index 9c1bb6d..13aa2e6 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
@@ -783,7 +783,8 @@ static struct ahash_alg sha512_mb_areq_alg = {
 			 */
 			.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
 						CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_INTERNAL,
+						CRYPTO_ALG_INTERNAL |
+						CRYPTO_ALG_MCRYPT,
 			.cra_blocksize	= SHA512_BLOCK_SIZE,
 			.cra_module	= THIS_MODULE,
 			.cra_list	= LIST_HEAD_INIT
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 94ee44a..5c40e13 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -500,6 +500,12 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 
 	alg = &halg->base;
 	pr_debug("crypto: mcryptd hash alg: %s\n", alg->cra_name);
+
+	if (!(alg->cra_flags & CRYPTO_ALG_MCRYPT)) {
+		err = -EINVAL;
+		goto out_put_alg;
+	}
+
 	inst = mcryptd_alloc_instance(alg, ahash_instance_headroom(),
 					sizeof(*ctx));
 	err = PTR_ERR(inst);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 167aea2..e47d5a8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -106,6 +106,12 @@
 #define CRYPTO_ALG_INTERNAL		0x00002000
 
 /*
+ * Mark cipher as compatible with mcryptd
+ * for multi-buffer processing
+ */
+#define CRYPTO_ALG_MCRYPT		0x00004000
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-- 
2.5.5
