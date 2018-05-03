From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 1/2] crypto: vmx - Remove overly verbose printk from AES init routines
Date: Thu,  3 May 2018 22:29:29 +1000
Message-ID: <20180503122930.17448-1-mpe@ellerman.id.au>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, mhcerri@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the vmx AES init routines we do a printk(KERN_INFO ...) to report
the fallback implementation we're using.

However with a slow console this can significantly affect the speed of
crypto operations. Using 'cryptsetup benchmark' the removal of the
printk() leads to a ~5x speedup for aes-cbc decryption.

So remove them.

Fixes: 8676590a1593 ("crypto: vmx - Adding AES routines for VMX module")
Fixes: 8c755ace357c ("crypto: vmx - Adding CBC routines for VMX module")
Fixes: 4f7f60d312b3 ("crypto: vmx - Adding CTR routines for VMX module")
Fixes: cc333cd68dfa ("crypto: vmx - Adding GHASH routines for VMX module")
Cc: stable@vger.kernel.org # v4.1+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/crypto/vmx/aes.c     | 2 --
 drivers/crypto/vmx/aes_cbc.c | 3 ---
 drivers/crypto/vmx/aes_ctr.c | 2 --
 drivers/crypto/vmx/ghash.c   | 2 --
 4 files changed, 9 deletions(-)


If this is the wrong fix please let me know, I'm not a crypto expert.

What we see is 'cryptsetup benchmark' causing thousands of these printks() to
happen. The call trace is something like:

[c000001e47867a60] [c0000000009cf6b4] p8_aes_cbc_init+0x74/0xf0
[c000001e47867ae0] [c000000000551a80] __crypto_alloc_tfm+0x1d0/0x2c0
[c000001e47867b20] [c00000000055aea4] crypto_skcipher_init_tfm+0x124/0x280
[c000001e47867b60] [c00000000055138c] crypto_create_tfm+0x9c/0x1a0
[c000001e47867ba0] [c000000000552220] crypto_alloc_tfm+0xa0/0x140
[c000001e47867c00] [c00000000055b168] crypto_alloc_skcipher+0x48/0x70
[c000001e47867c40] [c00000000057af28] skcipher_bind+0x38/0x50
[c000001e47867c80] [c00000000057a07c] alg_bind+0xbc/0x220
[c000001e47867d10] [c000000000a016a0] __sys_bind+0x90/0x100
[c000001e47867df0] [c000000000a01750] sys_bind+0x40/0x60
[c000001e47867e30] [c00000000000b320] system_call+0x58/0x6c


Is it normal for init to be called on every system call?

cheers


diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index 96072b9b55c4..d7316f7a3a69 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -48,8 +48,6 @@ static int p8_aes_init(struct crypto_tfm *tfm)
 		       alg, PTR_ERR(fallback));
 		return PTR_ERR(fallback);
 	}
-	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
-	       crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
 
 	crypto_cipher_set_flags(fallback,
 				crypto_cipher_get_flags((struct
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index 7394d35d5936..5285ece4f33a 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -52,9 +52,6 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 		       alg, PTR_ERR(fallback));
 		return PTR_ERR(fallback);
 	}
-	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
-		crypto_skcipher_driver_name(fallback));
-
 
 	crypto_skcipher_set_flags(
 		fallback,
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index fc60d00a2e84..cd777c75291d 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -50,8 +50,6 @@ static int p8_aes_ctr_init(struct crypto_tfm *tfm)
 		       alg, PTR_ERR(fallback));
 		return PTR_ERR(fallback);
 	}
-	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
-		crypto_skcipher_driver_name(fallback));
 
 	crypto_skcipher_set_flags(
 		fallback,
diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 27a94a119009..1c4b5b889fba 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -64,8 +64,6 @@ static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
 		       alg, PTR_ERR(fallback));
 		return PTR_ERR(fallback);
 	}
-	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
-	       crypto_tfm_alg_driver_name(crypto_shash_tfm(fallback)));
 
 	crypto_shash_set_flags(fallback,
 			       crypto_shash_get_flags((struct crypto_shash
-- 
2.14.1
