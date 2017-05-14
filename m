From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v11 1/5] crypto: DRBG - externalize DRBG functions for LRNG
Date: Sun, 14 May 2017 16:27:29 +0200
Message-ID: <1718059.lItsl9qoly@positron.chronox.de>
References: <7746835.7W6fIIgSam@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7746835.7W6fIIgSam@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch allows several DRBG functions to be called by the LRNG kernel
code paths outside the drbg.c file.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 11 +++++------
 include/crypto/drbg.h |  7 +++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index fa749f4..2ab8721 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -113,7 +113,7 @@
  * the SHA256 / AES 256 over other ciphers. Thus, the favored
  * DRBGs are the latest entries in this array.
  */
-static const struct drbg_core drbg_cores[] = {
+const struct drbg_core drbg_cores[] = {
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 	{
 		.flags = DRBG_CTR | DRBG_STRENGTH128,
@@ -205,7 +205,7 @@ static int drbg_uninstantiate(struct drbg_state *drbg);
  * Return: normalized strength in *bytes* value or 32 as default
  *	   to counter programming errors
  */
-static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
+unsigned short drbg_sec_strength(drbg_flag_t flags)
 {
 	switch (flags & DRBG_STRENGTH_MASK) {
 	case DRBG_STRENGTH128:
@@ -1129,7 +1129,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 }
 
 /* Free all substructures in a DRBG state without the DRBG state structure */
-static inline void drbg_dealloc_state(struct drbg_state *drbg)
+void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
@@ -1148,7 +1148,7 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
  * Allocate all sub-structures for a DRBG state.
  * The DRBG state structure must already be allocated.
  */
-static inline int drbg_alloc_state(struct drbg_state *drbg)
+int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret = -ENOMEM;
 	unsigned int sb_size = 0;
@@ -1806,8 +1806,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
  *
  * return: flags
  */
-static inline void drbg_convert_tfm_core(const char *cra_driver_name,
-					 int *coreref, bool *pr)
+void drbg_convert_tfm_core(const char *cra_driver_name, int *coreref, bool *pr)
 {
 	int i = 0;
 	size_t start = 0;
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 22f884c..eaedeb78 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -282,4 +282,11 @@ enum drbg_prefixes {
 	DRBG_PREFIX3
 };
 
+extern int drbg_alloc_state(struct drbg_state *drbg);
+extern void drbg_dealloc_state(struct drbg_state *drbg);
+extern void drbg_convert_tfm_core(const char *cra_driver_name, int *coreref,
+				  bool *pr);
+extern const struct drbg_core drbg_cores[];
+extern unsigned short drbg_sec_strength(drbg_flag_t flags);
+
 #endif /* _DRBG_H */
-- 
2.9.3
