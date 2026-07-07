Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59FC3921F0;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402643; cv=none; b=RJe5Exay92Pcr9T9hwy2nKhqqp2LnxNVVNN0rh7wOxQeJJ3fWfUfX6BNfzykZW1WuFda/3zcwB0+GqB3dHAM5Hq+xeBJVHaNYgVMpRdTVyAJ9bHJmNGY4LxI4AzBp40PIvy/9bKaEyrdIg/98bjeKJVWoc81vlZPFnvGf+0+mHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402643; c=relaxed/simple;
	bh=Y506qYP1nJjf5VCd52qeUpmPjAYlEBrasmvjxFp7Z2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2ZmOYb1sj0MXp+wPjy/ASDQKWH9WPDPEWQp1Rt0PWnUcnT98lhmORCkhNoUqG8XERJk99QnX1sj+PTnc+okjGB/24deFX1Z2gJFttkPeXoYlQv8wPQfE+DC0ku630zl+wGw4ciW90MAaLTWr/Bi7ZM5yD98EcsMcW30Z23GJT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XchPIdr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XchPIdr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EAE1F00A3D;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402641;
	bh=DJ4rm7m9eF2Eg4nx7XWa0AHSuv5kDOX3I9CUtOoXvOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XchPIdr/uZYLFhhhlsz9URURiokIDY/rgl+dDbeVv8Q2iYgV9nfdPwzz/Wyax10LI
	 m3pfBpWM7jie3uOZRgQyBt04TRiP7Py4S3iua2DKG8yE+ZLqhhPkv2a+1c5/Fj6BNB
	 R4wcCproS1kpRr+z0Btfkicj+DOkY+OwjB8vizUF3c7aFLGv3FPloi6uZhxcENETpX
	 VvJSpZw8mKsnpsLZ1kdMwZqURlFJvJdEDJEpdJV+vkCaQMhfmNCwkwAeZcmJDcA22D
	 FrWsajqTm8/0PDDHxVxp9C/FvOyK5zFW0le82z/LI1GPwWXXk+FXpeVwl+kxAHCeiF
	 jwzz3zDoLLaWg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 20/33] KEYS: trusted: dcp: Use AES-GCM library instead of crypto_aead
Date: Mon,  6 Jul 2026 22:34:50 -0700
Message-ID: <20260707053503.209874-21-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there's a library API for AES-GCM, use it instead of a
"gcm(aes)" crypto_aead.  This significantly simplifies the code.

Note, I've left unchanged two pre-existing issues with this code:

- trusted_key_unseal() doesn't validate that the decrypted key actually
  fits in the buffer to which it's written.

- dcp_blob_fmt::nonce is unnecessarily long, at 16 bytes rather than the
  12 bytes that are actually used by the AES-GCM operations.  Probably
  unfixable since it's part of the blob format.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 security/keys/trusted-keys/Kconfig       |  1 +
 security/keys/trusted-keys/trusted_dcp.c | 69 +++++-------------------
 2 files changed, 15 insertions(+), 55 deletions(-)

diff --git a/security/keys/trusted-keys/Kconfig b/security/keys/trusted-keys/Kconfig
index e5a4a53aeab2..361882191ff9 100644
--- a/security/keys/trusted-keys/Kconfig
+++ b/security/keys/trusted-keys/Kconfig
@@ -63,6 +63,7 @@ config TRUSTED_KEYS_DCP
 	bool "DCP-based trusted keys"
 	depends on CRYPTO_DEV_MXS_DCP >= TRUSTED_KEYS
 	default y
+	select CRYPTO_LIB_AES_GCM
 	select HAVE_TRUSTED_KEYS_DEBUG
 	select HAVE_TRUSTED_KEYS
 	help
diff --git a/security/keys/trusted-keys/trusted_dcp.c b/security/keys/trusted-keys/trusted_dcp.c
index 7b6eb655df0c..f9b2e0ad162d 100644
--- a/security/keys/trusted-keys/trusted_dcp.c
+++ b/security/keys/trusted-keys/trusted_dcp.c
@@ -3,10 +3,8 @@
  * Copyright (C) 2021 sigma star gmbh
  */
 
-#include <crypto/aead.h>
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
-#include <crypto/gcm.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/skcipher.h>
 #include <keys/trusted-type.h>
 #include <linux/key-type.h>
@@ -126,64 +124,25 @@ static int do_dcp_crypto(u8 *in, u8 *out, bool do_encrypt)
 	return res;
 }
 
-static int do_aead_crypto(u8 *in, u8 *out, size_t len, u8 *key, u8 *nonce,
+static int do_aead_crypto(u8 *in, u8 *out, size_t len,
+			  const u8 key[AES_KEYSIZE_128], const u8 nonce[12],
 			  bool do_encrypt)
 {
-	struct aead_request *aead_req = NULL;
-	struct scatterlist src_sg, dst_sg;
-	struct crypto_aead *aead;
+	struct aes_gcm_key gcm;
 	int ret;
-	DECLARE_CRYPTO_WAIT(wait);
-
-	aead = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(aead)) {
-		ret = PTR_ERR(aead);
-		goto out;
-	}
 
-	ret = crypto_aead_setauthsize(aead, DCP_BLOB_AUTHLEN);
-	if (ret < 0) {
-		pr_err("Can't set crypto auth tag len: %d\n", ret);
-		goto free_aead;
-	}
-
-	aead_req = aead_request_alloc(aead, GFP_KERNEL);
-	if (!aead_req) {
-		ret = -ENOMEM;
-		goto free_aead;
-	}
+	ret = aes_gcm_preparekey(&gcm, key, AES_KEYSIZE_128, DCP_BLOB_AUTHLEN);
+	if (ret) /* Should never fail here, since valid lengths were used. */
+		return ret;
 
-	sg_init_one(&src_sg, in, len);
 	if (do_encrypt) {
-		/*
-		 * If we encrypt our buffer has extra space for the auth tag.
-		 */
-		sg_init_one(&dst_sg, out, len + DCP_BLOB_AUTHLEN);
+		aes_gcm_encrypt(out, out + len, in, len, NULL, 0, nonce, &gcm);
+		ret = 0;
 	} else {
-		sg_init_one(&dst_sg, out, len);
+		ret = aes_gcm_decrypt(out, in, in + len, len, NULL, 0, nonce,
+				      &gcm);
 	}
-
-	aead_request_set_crypt(aead_req, &src_sg, &dst_sg, len, nonce);
-	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_SLEEP,
-				  crypto_req_done, &wait);
-	aead_request_set_ad(aead_req, 0);
-
-	if (crypto_aead_setkey(aead, key, AES_KEYSIZE_128)) {
-		pr_err("Can't set crypto AEAD key\n");
-		ret = -EINVAL;
-		goto free_req;
-	}
-
-	if (do_encrypt)
-		ret = crypto_wait_req(crypto_aead_encrypt(aead_req), &wait);
-	else
-		ret = crypto_wait_req(crypto_aead_decrypt(aead_req), &wait);
-
-free_req:
-	aead_request_free(aead_req);
-free_aead:
-	crypto_free_aead(aead);
-out:
+	memzero_explicit(&gcm, sizeof(gcm));
 	return ret;
 }
 
@@ -273,8 +232,8 @@ static int trusted_dcp_unseal(struct trusted_key_payload *p, char *datablob)
 		goto out;
 	}
 
-	ret = do_aead_crypto(b->payload, p->key, p->key_len + DCP_BLOB_AUTHLEN,
-			     plain_blob_key, b->nonce, false);
+	ret = do_aead_crypto(b->payload, p->key, p->key_len, plain_blob_key,
+			     b->nonce, false);
 	if (ret) {
 		pr_err("Unwrap of DCP payload failed: %i\n", ret);
 		goto out;
-- 
2.54.0

