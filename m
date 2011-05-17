From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] crypto: fix aesni build on i386
Date: Tue, 17 May 2011 11:52:45 -0700
Message-ID: <20110517115245.5544a0d0.randy.dunlap@oracle.com>
References: <20110517142749.8927b65b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.hengli.com.au>, davem@davemloft.net,
	Huang Ying <ying.huang@intel.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110517142749.8927b65b.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error on i386 by moving function prototypes:

arch/x86/crypto/aesni-intel_glue.c: In function 'aesni_init':
arch/x86/crypto/aesni-intel_glue.c:1263: error: implicit declaration of function 'crypto_fpu_init'
arch/x86/crypto/aesni-intel_glue.c: In function 'aesni_exit':
arch/x86/crypto/aesni-intel_glue.c:1373: error: implicit declaration of function 'crypto_fpu_exit'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

These function prototypes should preferably be in a header file somewhere.

--- linux-next-20110517.orig/arch/x86/crypto/aesni-intel_glue.c
+++ linux-next-20110517/arch/x86/crypto/aesni-intel_glue.c
@@ -94,6 +94,10 @@ asmlinkage void aesni_cbc_enc(struct cry
 			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+
+int crypto_fpu_init(void);
+void crypto_fpu_exit(void);
+
 #ifdef CONFIG_X86_64
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
@@ -140,9 +144,6 @@ asmlinkage void aesni_gcm_dec(void *ctx,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-int crypto_fpu_init(void);
-void crypto_fpu_exit(void);
-
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
 {
