Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A995926C3A5
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=nN/uRFf/PmV8E222D8MlEMeDSMSvfKLwAKlRSGJmnwS5oPitGdc0V6FKGuIaTysraGZ1NDwukzeuLw/cexq7LrjGhGOA+XTWyauiLxEpIlkFOQD1x0f2xUUTn7UT4Z1lB0Yh+Uh0bu30MXQ5CXanw6CnoWRWhDGgp/FmFBfSTGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=NqOPML6jSJcXyXyFGmWequwI2EaJipm7zIcb3OtbBak=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCXim+pTIatK9GKXLNZ3wf9BRA8a14OJ0OCNNPfhwHHtgu2LVTouH+fLB2oMDIG2NwaKvnh2TnP2Iakzc6VhhQOnwXpHbK+b5evhhtKGhaGeVLsRF4QrFXnQAd03cMoRByGEREugnrOvPe/jGzUKV0xYCePy44Q8lu65ciy5CuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BS6KdRc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BS6KdRc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81499C4CEE9
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472297;
	bh=NqOPML6jSJcXyXyFGmWequwI2EaJipm7zIcb3OtbBak=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BS6KdRc6Irl1b80HgT+hC8xEyfOg21xMb8Ce4/gReHG74Pty7RjziWb2BRKhanE+r
	 wALlS2M/PExGGsI7SLSPBnQ65vYZPNGKyJaMpIxPJ286ci4xSBvtMBHxMqHJMt4vC5
	 ver+zP8LOeOk8tgH1AdFhmoaMGTGrX0lHYofS3GG/N1ZnAgSOjMjH+xKn8vxvQUXFe
	 iTDIyi/mq17LMvebU/rkGRBAy6HSMPNzgz0v/sejm/mVV7ba4pQJejYxmkRU7vNgp5
	 LKFZF717+sZfk3Btb0OLoCquqoltD/nO9GJnFqsOb42e446Ko016ni7nTqXiOu3np5
	 c8P0Nx9L/rjJA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 6/8] crypto: null - remove the default null skcipher
Date: Mon,  5 May 2025 12:10:43 -0700
Message-ID: <20250505191045.763835-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
References: <20250505191045.763835-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

crypto_get_default_null_skcipher() and
crypto_put_default_null_skcipher() are no longer used, so remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_null.c  | 53 -------------------------------------------
 include/crypto/null.h |  3 ---
 2 files changed, 56 deletions(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 5822753b0995..48c71b925f37 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -15,17 +15,12 @@
 #include <crypto/null.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
 #include <linux/string.h>
 
-static DEFINE_SPINLOCK(crypto_default_null_skcipher_lock);
-static struct crypto_sync_skcipher *crypto_default_null_skcipher;
-static int crypto_default_null_skcipher_refcnt;
-
 static int null_init(struct shash_desc *desc)
 {
 	return 0;
 }
 
@@ -127,58 +122,10 @@ static struct crypto_alg cipher_null = {
 };
 
 MODULE_ALIAS_CRYPTO("digest_null");
 MODULE_ALIAS_CRYPTO("cipher_null");
 
-struct crypto_sync_skcipher *crypto_get_default_null_skcipher(void)
-{
-	struct crypto_sync_skcipher *ntfm = NULL;
-	struct crypto_sync_skcipher *tfm;
-
-	spin_lock_bh(&crypto_default_null_skcipher_lock);
-	tfm = crypto_default_null_skcipher;
-
-	if (!tfm) {
-		spin_unlock_bh(&crypto_default_null_skcipher_lock);
-
-		ntfm = crypto_alloc_sync_skcipher("ecb(cipher_null)", 0, 0);
-		if (IS_ERR(ntfm))
-			return ntfm;
-
-		spin_lock_bh(&crypto_default_null_skcipher_lock);
-		tfm = crypto_default_null_skcipher;
-		if (!tfm) {
-			tfm = ntfm;
-			ntfm = NULL;
-			crypto_default_null_skcipher = tfm;
-		}
-	}
-
-	crypto_default_null_skcipher_refcnt++;
-	spin_unlock_bh(&crypto_default_null_skcipher_lock);
-
-	crypto_free_sync_skcipher(ntfm);
-
-	return tfm;
-}
-EXPORT_SYMBOL_GPL(crypto_get_default_null_skcipher);
-
-void crypto_put_default_null_skcipher(void)
-{
-	struct crypto_sync_skcipher *tfm = NULL;
-
-	spin_lock_bh(&crypto_default_null_skcipher_lock);
-	if (!--crypto_default_null_skcipher_refcnt) {
-		tfm = crypto_default_null_skcipher;
-		crypto_default_null_skcipher = NULL;
-	}
-	spin_unlock_bh(&crypto_default_null_skcipher_lock);
-
-	crypto_free_sync_skcipher(tfm);
-}
-EXPORT_SYMBOL_GPL(crypto_put_default_null_skcipher);
-
 static int __init crypto_null_mod_init(void)
 {
 	int ret = 0;
 
 	ret = crypto_register_alg(&cipher_null);
diff --git a/include/crypto/null.h b/include/crypto/null.h
index 0ef577cc00e3..1c66abf9de3b 100644
--- a/include/crypto/null.h
+++ b/include/crypto/null.h
@@ -7,9 +7,6 @@
 #define NULL_KEY_SIZE		0
 #define NULL_BLOCK_SIZE		1
 #define NULL_DIGEST_SIZE	0
 #define NULL_IV_SIZE		0
 
-struct crypto_sync_skcipher *crypto_get_default_null_skcipher(void);
-void crypto_put_default_null_skcipher(void);
-
 #endif
-- 
2.49.0

