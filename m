Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE992388E7C
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 09:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776678085; cv=none; b=Tvm2hawWEPgfGaVfh4vH+xFUGV/llJpitKUjg9L6CIRd//dQ9zsSQAZI/eMEhG6BAkmqYWGI8U35GY5lPMGrCZPZNUsIZSvpmPhfz28+po49KIaZm4lB38CMOsa1zEsxtyO/X4VpsFly0Ixo7bSzLQGHOU+DhJbIM/SSHkaOYyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776678085; c=relaxed/simple;
	bh=0DvGiiEs8OI/X7irNxThAWZBGsnscbLkbsOruNavFRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QX/rgYsrC9bp39svpqvoEcrlP+FOu6Y7K4ZBaWG83ouKFgs9VjD+MJwBYWV86sFASWM6taO+mJHSUocxfXwBy9ZoaaGOzHfP+R3Qmuhy8uwZeaP6z9/1qRYiQ/4ro8K7TlEcFEsKvl8S2poMxRvVn4cwSNhceW82kqo2MEVRpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmXjT99/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmXjT99/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94029C19425;
	Mon, 20 Apr 2026 09:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776678085;
	bh=0DvGiiEs8OI/X7irNxThAWZBGsnscbLkbsOruNavFRM=;
	h=From:To:Cc:Subject:Date:From;
	b=lmXjT99/WqznzWGGnTOVdCDeOKYQzXmz2OGLCkTEupPNb53dIqn2oaNkOmUoPCMl7
	 IH++6XvsKxT8psiKUfPJJXxaXUWU4zbDIInWLnHQ8MqIlGdmo2dfRn4gYLDOorD0Ia
	 jPvFAHORwhUTp0neJn4J0t2NiTT/efnKF2v05LOQT08ORIwgLj6zLjuBDkq75mNzdF
	 5NEbFT0PzvNEX9y9WDyySr3ni9O8TssR/rrlsdFRtZaz7UB3+h7YhlaeuJY4CkEbGv
	 RMhBreHHTVkSU48JUzJq5g50GIFR2KcDgVqKUcPJ+i1EMEi+u6WHs9DMHn91cXNtRv
	 5zqnLXEivahQw==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: Drop unused cipher_null crypto_alg
Date: Mon, 20 Apr 2026 11:41:20 +0200
Message-ID: <20260420094120.5167-1-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cipher_null crypto_alg cipher is never used in a meaningful way,
given that it is always wrapped in ecb(), which has its own dedicated
implementation. IOW, the cipher_null crypto_alg should never be used to
implement the ecb(cipher_null) skcipher, and using it for other things
is bogus.

However, it is accessible from user space, and due to the nature of the
AF_ALG interface, it may be wrapped in arbitrary ways, exposing issues
in template code that wasn't written with block ciphers with a block
size of '1' in mind.

So drop this code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/crypto_null.c | 35 ++------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 34588f39fdfc..fea151df1648 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -50,15 +50,6 @@ static int null_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				unsigned int keylen)
 { return 0; }
 
-static int null_setkey(struct crypto_tfm *tfm, const u8 *key,
-		       unsigned int keylen)
-{ return 0; }
-
-static void null_crypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	memcpy(dst, src, NULL_BLOCK_SIZE);
-}
-
 static int null_skcipher_crypt(struct skcipher_request *req)
 {
 	if (req->src != req->dst)
@@ -97,35 +88,16 @@ static struct skcipher_alg skcipher_null = {
 	.decrypt		=	null_skcipher_crypt,
 };
 
-static struct crypto_alg cipher_null = {
-	.cra_name		=	"cipher_null",
-	.cra_driver_name	=	"cipher_null-generic",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	NULL_BLOCK_SIZE,
-	.cra_ctxsize		=	0,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	NULL_KEY_SIZE,
-	.cia_max_keysize	=	NULL_KEY_SIZE,
-	.cia_setkey		= 	null_setkey,
-	.cia_encrypt		=	null_crypt,
-	.cia_decrypt		=	null_crypt } }
-};
-
 MODULE_ALIAS_CRYPTO("digest_null");
-MODULE_ALIAS_CRYPTO("cipher_null");
+MODULE_ALIAS_CRYPTO("ecb(cipher_null)");
 
 static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
 
-	ret = crypto_register_alg(&cipher_null);
-	if (ret < 0)
-		goto out;
-
 	ret = crypto_register_shash(&digest_null);
 	if (ret < 0)
-		goto out_unregister_algs;
+		goto out;
 
 	ret = crypto_register_skcipher(&skcipher_null);
 	if (ret < 0)
@@ -135,15 +107,12 @@ static int __init crypto_null_mod_init(void)
 
 out_unregister_shash:
 	crypto_unregister_shash(&digest_null);
-out_unregister_algs:
-	crypto_unregister_alg(&cipher_null);
 out:
 	return ret;
 }
 
 static void __exit crypto_null_mod_fini(void)
 {
-	crypto_unregister_alg(&cipher_null);
 	crypto_unregister_shash(&digest_null);
 	crypto_unregister_skcipher(&skcipher_null);
 }
-- 
2.54.0.rc1.555.g9c883467ad-goog

