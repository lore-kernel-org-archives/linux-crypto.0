From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 1/5] crypto: DRBG - externalize DRBG functions for LRNG
Date: Thu, 11 Aug 2016 14:24:53 +0200
Message-ID: <13755614.BUcme8tBrn@positron.chronox.de>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4723196.TTQvcXsLCG@positron.chronox.de>
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
index f752da3..42084c2 100644
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
@@ -1128,7 +1128,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 }
 
 /* Free all substructures in a DRBG state without the DRBG state structure */
-static inline void drbg_dealloc_state(struct drbg_state *drbg)
+void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
@@ -1147,7 +1147,7 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
  * Allocate all sub-structures for a DRBG state.
  * The DRBG state structure must already be allocated.
  */
-static inline int drbg_alloc_state(struct drbg_state *drbg)
+int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret = -ENOMEM;
 	unsigned int sb_size = 0;
@@ -1781,8 +1781,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
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
index 61580b1..1755d07 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -280,4 +280,11 @@ enum drbg_prefixes {
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
2.7.4
