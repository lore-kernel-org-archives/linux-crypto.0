Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5555418027
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088090; cv=none; b=bDkPDaXNJtXmCw18k9HhHkYlkumP+BtYtj5Z3ULGhWE34txU2BjC4xcEdfN0vgUnQBk7AMkpaAFKt2pYdmNOEiJoMctuzF9J0jTNjgwTzUc3YBRLZJ/CLGWx+D+AoOWqMI+T/1L4FftWmF7hZdtHHVA7Pn5ycMqSW0XmM2me6hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088090; c=relaxed/simple;
	bh=QG+puc8D3gTzqauUigbltgyvZ0EvO6IKCUMKIWqS4E4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=lRMINzolvvU44lPVER1zW256U93hc/Eybm4bn9nY6r2Sm/+0PbGPH5/m1CJ0lkOQawc7gkuaDgFKEkPFZICQl2FTu7dM6R8mqq+s3nvO0igGr9jmzquiA+jX62RXOLCfF3TzF9Y7Tz/wz9fVSRN+QAZ5BoxtU1vjhGiVlq7Ckf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BgRRMwY2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BgRRMwY2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3qlnFZohAQ5IB0SGE5uiS+cgPlV5KEui5/Rli+8eAwU=; b=BgRRMwY2UF6omXUPTJ5BhM/T4r
	tr5ALsm2uPdYCs1iotbDgk1ApEuNKYj8YwBzNMc2STSQzmnjbMATzOywrQtuVDFY74cUnt3cXYRCn
	NIrwKgMzyzC0VPMPPUckwHllyh8UYRzKMmi31wixbQ8VpZozJAyRatiFXlSW4CvpBwvhx+mbghF4v
	9fPmPBcQ6evNyf5k131BOj1GiVCkWUu7Bpsn5rhQhpT89VIqN/u4x8Mjb81S7IA1UFj++APO5ZqzH
	MewWG7aUG0a63JfiVMIBb7n9ergRZjFo1Sg6xTW8FewEpnBtk6uRTEroMTchBm0Fcl/P93ts16Xik
	WJK8GztA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgu-006xat-2W;
	Sun, 16 Mar 2025 09:21:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:24 +0800
Date: Sun, 16 Mar 2025 09:21:24 +0800
Message-Id: <3731d4e5160d8231fa90f2f70c4fb51d5fd9c769.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/11] crypto: compress_null - drop obsolete 'comp'
 implementation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

The 'comp' API is obsolete and will be removed, so remove this comp
implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/crypto_null.c | 31 +++++--------------------------
 crypto/testmgr.c     |  3 ---
 2 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 337867028653..ced90f88ee07 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -24,16 +24,6 @@ static DEFINE_SPINLOCK(crypto_default_null_skcipher_lock);
 static struct crypto_sync_skcipher *crypto_default_null_skcipher;
 static int crypto_default_null_skcipher_refcnt;
 
-static int null_compress(struct crypto_tfm *tfm, const u8 *src,
-			 unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	if (slen > *dlen)
-		return -EINVAL;
-	memcpy(dst, src, slen);
-	*dlen = slen;
-	return 0;
-}
-
 static int null_init(struct shash_desc *desc)
 {
 	return 0;
@@ -121,7 +111,7 @@ static struct skcipher_alg skcipher_null = {
 	.decrypt		=	null_skcipher_crypt,
 };
 
-static struct crypto_alg null_algs[] = { {
+static struct crypto_alg cipher_null = {
 	.cra_name		=	"cipher_null",
 	.cra_driver_name	=	"cipher_null-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
@@ -134,19 +124,8 @@ static struct crypto_alg null_algs[] = { {
 	.cia_setkey		= 	null_setkey,
 	.cia_encrypt		=	null_crypt,
 	.cia_decrypt		=	null_crypt } }
-}, {
-	.cra_name		=	"compress_null",
-	.cra_driver_name	=	"compress_null-generic",
-	.cra_flags		=	CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_blocksize		=	NULL_BLOCK_SIZE,
-	.cra_ctxsize		=	0,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{ .compress = {
-	.coa_compress		=	null_compress,
-	.coa_decompress		=	null_compress } }
-} };
+};
 
-MODULE_ALIAS_CRYPTO("compress_null");
 MODULE_ALIAS_CRYPTO("digest_null");
 MODULE_ALIAS_CRYPTO("cipher_null");
 
@@ -202,7 +181,7 @@ static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
 
-	ret = crypto_register_algs(null_algs, ARRAY_SIZE(null_algs));
+	ret = crypto_register_alg(&cipher_null);
 	if (ret < 0)
 		goto out;
 
@@ -219,14 +198,14 @@ static int __init crypto_null_mod_init(void)
 out_unregister_shash:
 	crypto_unregister_shash(&digest_null);
 out_unregister_algs:
-	crypto_unregister_algs(null_algs, ARRAY_SIZE(null_algs));
+	crypto_unregister_alg(&cipher_null);
 out:
 	return ret;
 }
 
 static void __exit crypto_null_mod_fini(void)
 {
-	crypto_unregister_algs(null_algs, ARRAY_SIZE(null_algs));
+	crypto_unregister_alg(&cipher_null);
 	crypto_unregister_shash(&digest_null);
 	crypto_unregister_skcipher(&skcipher_null);
 }
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 140872765dcd..9c5648c45ff0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4726,9 +4726,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(sm4_cmac128_tv_template)
 		}
-	}, {
-		.alg = "compress_null",
-		.test = alg_test_null,
 	}, {
 		.alg = "crc32",
 		.test = alg_test_hash,
-- 
2.39.5

