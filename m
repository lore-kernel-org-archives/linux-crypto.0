From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH 3/3] crypto: Add AES-NI support for more modes
Date: Thu, 05 Mar 2009 10:25:49 +0800
Message-ID: <1236219949.24215.39.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aYElaYDaFlxxM+bgLHBx"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756174AbZCEC03@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-aYElaYDaFlxxM+bgLHBx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Because kernel_fpu_begin() and kernel_fpu_end() operations are too
slow, the performance gain of general mode implementation + aes-aesni
is almost all compensated.

The AES-NI support for more modes are implemented as follow:

- Add a new AES algorithm implementation named __aes-aesni without
  kernel_fpu_begin/end()

- Use fpu(<mode>(AES)) to provide kenrel_fpu_begin/end() invoking

- Add <mode>(AES) ablkcipher, which uses cryptd(fpu(<mode>(AES))) to
  defer cryption to cryptd context in soft_irq context.

Now the ctr, lrw, pcbc and xts support are added.

Performance testing based on dm-crypt shows that cryption time can be
reduced to 50% of general mode implementation + aes-aesni implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aesni-intel_glue.c |  256 ++++++++++++++++++++++++++++++++=
+++++
 crypto/Kconfig                     |    1=20
 2 files changed, 257 insertions(+)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -21,6 +21,22 @@
 #include <asm/i387.h>
 #include <asm/aes.h>
=20
+#if defined(CONFIG_CRYPTO_CTR) || defined(CONFIG_CRYPTO_CTR_MODULE)
+#define HAS_CTR
+#endif
+
+#if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
+#define HAS_LRW
+#endif
+
+#if defined(CONFIG_CRYPTO_PCBC) || defined(CONFIG_CRYPTO_PCBC_MODULE)
+#define HAS_PCBC
+#endif
+
+#if defined(CONFIG_CRYPTO_XTS) || defined(CONFIG_CRYPTO_XTS_MODULE)
+#define HAS_XTS
+#endif
+
 struct async_aes_ctx {
 	struct cryptd_ablkcipher *cryptd_tfm;
 };
@@ -137,6 +153,41 @@ static struct crypto_alg aesni_alg =3D {
 	}
 };
=20
+static void __aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_tfm_ctx(tfm));
+
+	aesni_enc(ctx, dst, src);
+}
+
+static void __aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_aes_ctx *ctx =3D aes_ctx(crypto_tfm_ctx(tfm));
+
+	aesni_dec(ctx, dst, src);
+}
+
+static struct crypto_alg __aesni_alg =3D {
+	.cra_name		=3D "__aes-aesni",
+	.cra_driver_name	=3D "__driver-aes-aesni",
+	.cra_priority		=3D 0,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct crypto_aes_ctx)+AESNI_ALIGN-1,
+	.cra_alignmask		=3D 0,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(__aesni_alg.cra_list),
+	.cra_u	=3D {
+		.cipher	=3D {
+			.cia_min_keysize	=3D AES_MIN_KEY_SIZE,
+			.cia_max_keysize	=3D AES_MAX_KEY_SIZE,
+			.cia_setkey		=3D aes_set_key,
+			.cia_encrypt		=3D __aes_encrypt,
+			.cia_decrypt		=3D __aes_decrypt
+		}
+	}
+};
+
 static int ecb_encrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -411,6 +462,162 @@ static struct crypto_alg ablk_cbc_alg =3D=20
 	},
 };
=20
+#ifdef HAS_CTR
+static int ablk_ctr_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm =3D cryptd_alloc_ablkcipher("fpu(ctr(__driver-aes-aesni))",
+					     0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_ctr_alg =3D {
+	.cra_name		=3D "ctr(aes)",
+	.cra_driver_name	=3D "ctr-aes-aesni",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_aes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(ablk_ctr_alg.cra_list),
+	.cra_init		=3D ablk_ctr_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.ivsize		=3D AES_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+};
+#endif
+
+#ifdef HAS_LRW
+static int ablk_lrw_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm =3D cryptd_alloc_ablkcipher("fpu(lrw(__driver-aes-aesni))",
+					     0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_lrw_alg =3D {
+	.cra_name		=3D "lrw(aes)",
+	.cra_driver_name	=3D "lrw-aes-aesni",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_aes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(ablk_lrw_alg.cra_list),
+	.cra_init		=3D ablk_lrw_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.ivsize		=3D AES_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+};
+#endif
+
+#ifdef HAS_PCBC
+static int ablk_pcbc_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm =3D cryptd_alloc_ablkcipher("fpu(pcbc(__driver-aes-aesni))",
+					     0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_pcbc_alg =3D {
+	.cra_name		=3D "pcbc(aes)",
+	.cra_driver_name	=3D "pcbc-aes-aesni",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_aes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(ablk_pcbc_alg.cra_list),
+	.cra_init		=3D ablk_pcbc_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.ivsize		=3D AES_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+};
+#endif
+
+#ifdef HAS_XTS
+static int ablk_xts_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm =3D cryptd_alloc_ablkcipher("fpu(xts(__driver-aes-aesni))",
+					     0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_xts_alg =3D {
+	.cra_name		=3D "xts(aes)",
+	.cra_driver_name	=3D "xts-aes-aesni",
+	.cra_priority		=3D 400,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
+	.cra_blocksize		=3D AES_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct async_aes_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_ablkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_list		=3D LIST_HEAD_INIT(ablk_xts_alg.cra_list),
+	.cra_init		=3D ablk_xts_init,
+	.cra_exit		=3D ablk_exit,
+	.cra_u =3D {
+		.ablkcipher =3D {
+			.min_keysize	=3D AES_MIN_KEY_SIZE,
+			.max_keysize	=3D AES_MAX_KEY_SIZE,
+			.ivsize		=3D AES_BLOCK_SIZE,
+			.setkey		=3D ablk_set_key,
+			.encrypt	=3D ablk_encrypt,
+			.decrypt	=3D ablk_decrypt,
+		},
+	},
+};
+#endif
+
 static int __init aesni_init(void)
 {
 	int err;
@@ -421,6 +628,8 @@ static int __init aesni_init(void)
 	}
 	if ((err =3D crypto_register_alg(&aesni_alg)))
 		goto aes_err;
+	if ((err =3D crypto_register_alg(&__aesni_alg)))
+		goto __aes_err;
 	if ((err =3D crypto_register_alg(&blk_ecb_alg)))
 		goto blk_ecb_err;
 	if ((err =3D crypto_register_alg(&blk_cbc_alg)))
@@ -429,9 +638,41 @@ static int __init aesni_init(void)
 		goto ablk_ecb_err;
 	if ((err =3D crypto_register_alg(&ablk_cbc_alg)))
 		goto ablk_cbc_err;
+#ifdef HAS_CTR
+	if ((err =3D crypto_register_alg(&ablk_ctr_alg)))
+		goto ablk_ctr_err;
+#endif
+#ifdef HAS_LRW
+	if ((err =3D crypto_register_alg(&ablk_lrw_alg)))
+		goto ablk_lrw_err;
+#endif
+#ifdef HAS_PCBC
+	if ((err =3D crypto_register_alg(&ablk_pcbc_alg)))
+		goto ablk_pcbc_err;
+#endif
+#ifdef HAS_XTS
+	if ((err =3D crypto_register_alg(&ablk_xts_alg)))
+		goto ablk_xts_err;
+#endif
=20
 	return err;
=20
+#ifdef HAS_XTS
+ablk_xts_err:
+#endif
+#ifdef HAS_PCBC
+	crypto_unregister_alg(&ablk_pcbc_alg);
+ablk_pcbc_err:
+#endif
+#ifdef HAS_LRW
+	crypto_unregister_alg(&ablk_lrw_alg);
+ablk_lrw_err:
+#endif
+#ifdef HAS_CTR
+	crypto_unregister_alg(&ablk_ctr_alg);
+ablk_ctr_err:
+#endif
+	crypto_unregister_alg(&ablk_cbc_alg);
 ablk_cbc_err:
 	crypto_unregister_alg(&ablk_ecb_alg);
 ablk_ecb_err:
@@ -439,6 +680,8 @@ ablk_ecb_err:
 blk_cbc_err:
 	crypto_unregister_alg(&blk_ecb_alg);
 blk_ecb_err:
+	crypto_unregister_alg(&__aesni_alg);
+__aes_err:
 	crypto_unregister_alg(&aesni_alg);
 aes_err:
 	return err;
@@ -446,10 +689,23 @@ aes_err:
=20
 static void __exit aesni_exit(void)
 {
+#ifdef HAS_XTS
+	crypto_unregister_alg(&ablk_xts_alg);
+#endif
+#ifdef HAS_PCBC
+	crypto_unregister_alg(&ablk_pcbc_alg);
+#endif
+#ifdef HAS_LRW
+	crypto_unregister_alg(&ablk_lrw_alg);
+#endif
+#ifdef HAS_CTR
+	crypto_unregister_alg(&ablk_ctr_alg);
+#endif
 	crypto_unregister_alg(&ablk_cbc_alg);
 	crypto_unregister_alg(&ablk_ecb_alg);
 	crypto_unregister_alg(&blk_cbc_alg);
 	crypto_unregister_alg(&blk_ecb_alg);
+	crypto_unregister_alg(&__aesni_alg);
 	crypto_unregister_alg(&aesni_alg);
 }
=20
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -488,6 +488,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_AES_X86_64
 	select CRYPTO_CRYPTD
 	select CRYPTO_ALGAPI
+	select CRYPTO_FPU
 	help
 	  Use Intel AES-NI instructions for AES algorithm.
=20


--=-aYElaYDaFlxxM+bgLHBx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmvOCgACgkQKhFGF+eHlpiBKQCglaryqroSYuGJJwbFZh7Ec8H5
oQsAoKh9gNDCJA19ByVRUegxqVKBOn7b
=yocv
-----END PGP SIGNATURE-----

--=-aYElaYDaFlxxM+bgLHBx--
