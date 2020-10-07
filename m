Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545FCC4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 06:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED4B20B1F
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 06:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgJGGGA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 02:06:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36408 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgJGGGA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 02:06:00 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kQ2a9-00014r-HC; Wed, 07 Oct 2020 17:05:46 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Oct 2020 17:05:45 +1100
Date:   Wed, 7 Oct 2020 17:05:45 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] X.509: Fix modular build of public_key_sm2
Message-ID: <20201007060545.GA21989@gondor.apana.org.au>
References: <202010030936.EarAGqn6-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010030936.EarAGqn6-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 03, 2020 at 09:17:40AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   ed4424f2fb02497b0ea92bf58c533c598c0da1d3
> commit: 215525639631ade1d67e879fe2c3d7195daa9f59 [169/199] X.509: support OSCCA SM2-with-SM3 certificate verification
> config: nds32-randconfig-r003-20201002 (attached as .config)
> compiler: nds32le-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=215525639631ade1d67e879fe2c3d7195daa9f59
>         git remote add cryptodev https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>         git fetch --no-tags cryptodev master
>         git checkout 215525639631ade1d67e879fe2c3d7195daa9f59
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=nds32 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> WARNING: modpost: missing MODULE_LICENSE() in crypto/asymmetric_keys/public_key_sm2.o
> >> ERROR: modpost: "cert_sig_digest_update" [crypto/asymmetric_keys/public_key.ko] undefined!

What a mess.  I'm moving the sm2 code back into public_key.c.

---8<---
The sm2 code was split out of public_key.c in a way that breaks
modular builds.  This patch moves the code back into the same file
as the original motivation was to minimise ifdefs and that has
nothing to do with splitting the code out.

Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3...")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 1a99ea5acb6b..28b91adba2ae 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -11,7 +11,6 @@ asymmetric_keys-y := \
 	signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
-obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key_sm2.o
 obj-$(CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE) += asym_tpm.o
 
 #
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 1d0492098bbd..93236a5701cd 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -17,6 +17,8 @@
 #include <keys/asymmetric-subtype.h>
 #include <crypto/public_key.h>
 #include <crypto/akcipher.h>
+#include <crypto/sm2.h>
+#include <crypto/sm3_base.h>
 
 MODULE_DESCRIPTION("In-software asymmetric public-key subtype");
 MODULE_AUTHOR("Red Hat, Inc.");
@@ -246,6 +248,59 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	return ret;
 }
 
+#if IS_REACHABLE(CONFIG_CRYPTO_SM2)
+static int cert_sig_digest_update(const struct public_key_signature *sig,
+				  struct crypto_akcipher *tfm_pkey)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t desc_size;
+	unsigned char dgst[SM3_DIGEST_SIZE];
+	int ret;
+
+	BUG_ON(!sig->data);
+
+	ret = sm2_compute_z_digest(tfm_pkey, SM2_DEFAULT_USERID,
+					SM2_DEFAULT_USERID_LEN, dgst);
+	if (ret)
+		return ret;
+
+	tfm = crypto_alloc_shash(sig->hash_algo, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc)
+		goto error_free_tfm;
+
+	desc->tfm = tfm;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_free_desc;
+
+	ret = crypto_shash_update(desc, dgst, SM3_DIGEST_SIZE);
+	if (ret < 0)
+		goto error_free_desc;
+
+	ret = crypto_shash_finup(desc, sig->data, sig->data_size, sig->digest);
+
+error_free_desc:
+	kfree(desc);
+error_free_tfm:
+	crypto_free_shash(tfm);
+	return ret;
+}
+#else
+static inline int cert_sig_digest_update(
+	const struct public_key_signature *sig,
+	struct crypto_akcipher *tfm_pkey)
+{
+	return -ENOTSUPP;
+}
+#endif /* ! IS_REACHABLE(CONFIG_CRYPTO_SM2) */
+
 /*
  * Verify a signature using a public key.
  */
diff --git a/crypto/asymmetric_keys/public_key_sm2.c b/crypto/asymmetric_keys/public_key_sm2.c
deleted file mode 100644
index 7325cf21dbb4..000000000000
--- a/crypto/asymmetric_keys/public_key_sm2.c
+++ /dev/null
@@ -1,61 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * asymmetric public-key algorithm for SM2-with-SM3 certificate
- * as specified by OSCCA GM/T 0003.1-2012 -- 0003.5-2012 SM2 and
- * described at https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
- *
- * Copyright (c) 2020, Alibaba Group.
- * Authors: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
- */
-
-#include <crypto/sm3_base.h>
-#include <crypto/sm2.h>
-#include <crypto/public_key.h>
-
-#if IS_REACHABLE(CONFIG_CRYPTO_SM2)
-
-int cert_sig_digest_update(const struct public_key_signature *sig,
-				struct crypto_akcipher *tfm_pkey)
-{
-	struct crypto_shash *tfm;
-	struct shash_desc *desc;
-	size_t desc_size;
-	unsigned char dgst[SM3_DIGEST_SIZE];
-	int ret;
-
-	BUG_ON(!sig->data);
-
-	ret = sm2_compute_z_digest(tfm_pkey, SM2_DEFAULT_USERID,
-					SM2_DEFAULT_USERID_LEN, dgst);
-	if (ret)
-		return ret;
-
-	tfm = crypto_alloc_shash(sig->hash_algo, 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	desc = kzalloc(desc_size, GFP_KERNEL);
-	if (!desc)
-		goto error_free_tfm;
-
-	desc->tfm = tfm;
-
-	ret = crypto_shash_init(desc);
-	if (ret < 0)
-		goto error_free_desc;
-
-	ret = crypto_shash_update(desc, dgst, SM3_DIGEST_SIZE);
-	if (ret < 0)
-		goto error_free_desc;
-
-	ret = crypto_shash_finup(desc, sig->data, sig->data_size, sig->digest);
-
-error_free_desc:
-	kfree(desc);
-error_free_tfm:
-	crypto_free_shash(tfm);
-	return ret;
-}
-
-#endif /* ! IS_REACHABLE(CONFIG_CRYPTO_SM2) */
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 02a6dbe5c366..948c5203ca9c 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -84,16 +84,4 @@ extern int verify_signature(const struct key *,
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig);
 
-#if IS_REACHABLE(CONFIG_CRYPTO_SM2)
-int cert_sig_digest_update(const struct public_key_signature *sig,
-				struct crypto_akcipher *tfm_pkey);
-#else
-static inline
-int cert_sig_digest_update(const struct public_key_signature *sig,
-				struct crypto_akcipher *tfm_pkey)
-{
-	return -ENOTSUPP;
-}
-#endif
-
 #endif /* _LINUX_PUBLIC_KEY_H */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
