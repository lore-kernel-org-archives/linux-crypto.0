Return-Path: <SRS0=SeGX=IG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E938C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 05:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15AF64FAE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 05:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbhCHFmD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 00:42:03 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:47200 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhCHFlq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 00:41:46 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lJ8e4-00015E-AL; Mon, 08 Mar 2021 16:41:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Mar 2021 16:41:32 +1100
Date:   Mon, 8 Mar 2021 16:41:32 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: aegis128 - Move simd prototypes into aegis.h
Message-ID: <20210308054132.GA14854@gondor.apana.org.au>
References: <202102280353.5krQC7aq-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202102280353.5krQC7aq-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 28, 2021 at 03:14:55AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   5695e51619745d4fe3ec2506a2f0cd982c5e27a4
> commit: a4397635afea5d127548d64e0055ed471ef2d5be crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
> date:   1 year, 6 months ago
> config: arm64-randconfig-r035-20210226 (attached as .config)
> compiler: aarch64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a4397635afea5d127548d64e0055ed471ef2d5be
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout a4397635afea5d127548d64e0055ed471ef2d5be
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> crypto/aegis128-neon.c:17:6: warning: no previous prototype for 'crypto_aegis128_have_simd' [-Wmissing-prototypes]
>       17 | bool crypto_aegis128_have_simd(void)
>          |      ^~~~~~~~~~~~~~~~~~~~~~~~~

---8<---
This patch fixes missing prototype warnings in crypto/aegis128-neon.c.

Fixes: a4397635afea ("crypto: aegis128 - provide a SIMD...")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/aegis.h b/crypto/aegis.h
index 6920ebe77679..6ef9c174c973 100644
--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -21,9 +21,28 @@ union aegis_block {
 	u8 bytes[AEGIS_BLOCK_SIZE];
 };
 
+struct aegis_state;
+
+extern int aegis128_have_aes_insn;
+
 #define AEGIS_BLOCK_ALIGN (__alignof__(union aegis_block))
 #define AEGIS_ALIGNED(p) IS_ALIGNED((uintptr_t)p, AEGIS_BLOCK_ALIGN)
 
+bool crypto_aegis128_have_simd(void);
+void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
+void crypto_aegis128_init_simd(struct aegis_state *state,
+			       const union aegis_block *key,
+			       const u8 *iv);
+void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size);
+void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size);
+int crypto_aegis128_final_simd(struct aegis_state *state,
+			       union aegis_block *tag_xor,
+			       unsigned int assoclen,
+			       unsigned int cryptlen,
+			       unsigned int authsize);
+
 static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,
 						   const union aegis_block *src)
 {
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 89dc1c559689..c4f1bfa1d04f 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -58,21 +58,6 @@ static bool aegis128_do_simd(void)
 	return false;
 }
 
-bool crypto_aegis128_have_simd(void);
-void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
-void crypto_aegis128_init_simd(struct aegis_state *state,
-			       const union aegis_block *key,
-			       const u8 *iv);
-void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size);
-void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size);
-int crypto_aegis128_final_simd(struct aegis_state *state,
-			       union aegis_block *tag_xor,
-			       unsigned int assoclen,
-			       unsigned int cryptlen,
-			       unsigned int authsize);
-
 static void crypto_aegis128_update(struct aegis_state *state)
 {
 	union aegis_block tmp;
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
index 94d591a002a4..a7856915ec85 100644
--- a/crypto/aegis128-neon.c
+++ b/crypto/aegis128-neon.c
@@ -30,7 +30,7 @@ bool crypto_aegis128_have_simd(void)
 	return IS_ENABLED(CONFIG_ARM64);
 }
 
-void crypto_aegis128_init_simd(union aegis_block *state,
+void crypto_aegis128_init_simd(struct aegis_state *state,
 			       const union aegis_block *key,
 			       const u8 *iv)
 {
@@ -39,14 +39,14 @@ void crypto_aegis128_init_simd(union aegis_block *state,
 	kernel_neon_end();
 }
 
-void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
+void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg)
 {
 	kernel_neon_begin();
 	crypto_aegis128_update_neon(state, msg);
 	kernel_neon_end();
 }
 
-void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
+void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
 					const u8 *src, unsigned int size)
 {
 	kernel_neon_begin();
@@ -54,7 +54,7 @@ void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
 	kernel_neon_end();
 }
 
-void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
+void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
 					const u8 *src, unsigned int size)
 {
 	kernel_neon_begin();
@@ -62,7 +62,7 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
 	kernel_neon_end();
 }
 
-int crypto_aegis128_final_simd(union aegis_block *state,
+int crypto_aegis128_final_simd(struct aegis_state *state,
 			       union aegis_block *tag_xor,
 			       unsigned int assoclen,
 			       unsigned int cryptlen,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
