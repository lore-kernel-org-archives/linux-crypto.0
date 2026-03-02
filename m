Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E152C38A71C;
	Mon,  2 Mar 2026 08:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438485; cv=none; b=aiLIJ9/TyRNCLHPguB9oe6ct0lEXUQBs0qIiTZ7J/NX9/Vj/enxPqIkG2Yral00zXF/0btRt/HiDH/25Vh8w78Ca42MHViRyMmBLB4UKuNldSTL8NwIJOFjPpOVMUSRZkPyJ0RQZdNjwG6ligZsMzItTneOGmZxsqyFCJ/PUw78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438485; c=relaxed/simple;
	bh=xmKb53wJeSwb7NygGgziQp9Cpl0GKPkWIpXtxpOOeJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTlEbXSr+5VSAMgv/6PqjIzgfNmXKbn7KlPLWXqBbwnXOz8xYhllhoGgyvb968JNQZC5yhvdORstyzKzelBuJD5G8b1izYLrYJiEyjZcnG68+aFzkOD7DvGVsrnOsdpigmtOVKdrBNaIyVIbLId8hzXhdKTkZfNCpGkkaFgPzi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0uS1CHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0uS1CHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D32C4AF0D;
	Mon,  2 Mar 2026 08:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438484;
	bh=xmKb53wJeSwb7NygGgziQp9Cpl0GKPkWIpXtxpOOeJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0uS1CHn2DNbucuDCQqckqtJ3g+x5sH3snc8hgyAQyH651PBMCyRYPWTpXX7uZuhw
	 nIYN0rrNhwelqw20lQUEi2FjjVrr8eg+jRTjWe6ohCOImUKXhRdZChgsR9vMGcafqP
	 RlZByHbq/0nDQ/KVO5bH/WNwIm14AoT2VgrnOxYM2NQyN+VLEOUTz0r9EEcMDH0PBR
	 Cn/rNmg/9sdLhGTDcL3H07i5FbtY9zpPIq+KLJNDXo0pg+ddUzuNK//qGLoy9lQV2U
	 5FAU4yJ3L/OTvpDMCf44ElzXY72aKh6fL+2NkwAWiOKvgg1JsgfNCW6Fi3qiE3DxUj
	 iS4x356Y6L/Og==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/21] nvme-auth: common: use crypto library in nvme_auth_generate_digest()
Date: Sun,  1 Mar 2026 23:59:49 -0800
Message-ID: <20260302075959.338638-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the HMAC computation in nvme_auth_generate_digest(), use the crypto
library instead of crypto_shash.  This is simpler, faster, and more
reliable.  Notably, this eliminates the crypto transformation object
allocation for every call, which was very slow.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 87 +++++++++++---------------------------
 1 file changed, 25 insertions(+), 62 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 781d1d5d46dd3..f0b4e1c6ade7e 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -559,103 +559,66 @@ EXPORT_SYMBOL_GPL(nvme_auth_generate_psk);
  */
 int nvme_auth_generate_digest(u8 hmac_id, const u8 *psk, size_t psk_len,
 			      const char *subsysnqn, const char *hostnqn,
 			      char **ret_digest)
 {
-	struct crypto_shash *tfm;
-	SHASH_DESC_ON_STACK(shash, tfm);
-	u8 *digest;
+	struct nvme_auth_hmac_ctx hmac;
+	u8 digest[NVME_AUTH_MAX_DIGEST_SIZE];
+	size_t hash_len = nvme_auth_hmac_hash_len(hmac_id);
 	char *enc;
-	const char *hmac_name;
-	size_t digest_len, hmac_len;
+	size_t enc_len;
 	int ret;
 
 	if (WARN_ON(!subsysnqn || !hostnqn))
 		return -EINVAL;
 
-	hmac_name = nvme_auth_hmac_name(hmac_id);
-	if (!hmac_name) {
+	if (hash_len == 0) {
 		pr_warn("%s: invalid hash algorithm %d\n",
 			__func__, hmac_id);
 		return -EINVAL;
 	}
 
-	switch (nvme_auth_hmac_hash_len(hmac_id)) {
+	switch (hash_len) {
 	case 32:
-		hmac_len = 44;
+		enc_len = 44;
 		break;
 	case 48:
-		hmac_len = 64;
+		enc_len = 64;
 		break;
 	default:
 		pr_warn("%s: invalid hash algorithm '%s'\n",
-			__func__, hmac_name);
+			__func__, nvme_auth_hmac_name(hmac_id));
 		return -EINVAL;
 	}
 
-	enc = kzalloc(hmac_len + 1, GFP_KERNEL);
-	if (!enc)
-		return -ENOMEM;
-
-	tfm = crypto_alloc_shash(hmac_name, 0, 0);
-	if (IS_ERR(tfm)) {
-		ret = PTR_ERR(tfm);
-		goto out_free_enc;
-	}
-
-	digest_len = crypto_shash_digestsize(tfm);
-	digest = kzalloc(digest_len, GFP_KERNEL);
-	if (!digest) {
+	enc = kzalloc(enc_len + 1, GFP_KERNEL);
+	if (!enc) {
 		ret = -ENOMEM;
-		goto out_free_tfm;
+		goto out;
 	}
 
-	shash->tfm = tfm;
-	ret = crypto_shash_setkey(tfm, psk, psk_len);
+	ret = nvme_auth_hmac_init(&hmac, hmac_id, psk, psk_len);
 	if (ret)
-		goto out_free_digest;
-
-	ret = crypto_shash_init(shash);
-	if (ret)
-		goto out_free_digest;
-
-	ret = crypto_shash_update(shash, hostnqn, strlen(hostnqn));
-	if (ret)
-		goto out_free_digest;
-
-	ret = crypto_shash_update(shash, " ", 1);
-	if (ret)
-		goto out_free_digest;
-
-	ret = crypto_shash_update(shash, subsysnqn, strlen(subsysnqn));
-	if (ret)
-		goto out_free_digest;
-
-	ret = crypto_shash_update(shash, " NVMe-over-Fabrics", 18);
-	if (ret)
-		goto out_free_digest;
-
-	ret = crypto_shash_final(shash, digest);
-	if (ret)
-		goto out_free_digest;
-
-	ret = base64_encode(digest, digest_len, enc, true, BASE64_STD);
-	if (ret < hmac_len) {
+		goto out;
+	nvme_auth_hmac_update(&hmac, hostnqn, strlen(hostnqn));
+	nvme_auth_hmac_update(&hmac, " ", 1);
+	nvme_auth_hmac_update(&hmac, subsysnqn, strlen(subsysnqn));
+	nvme_auth_hmac_update(&hmac, " NVMe-over-Fabrics", 18);
+	nvme_auth_hmac_final(&hmac, digest);
+
+	ret = base64_encode(digest, hash_len, enc, true, BASE64_STD);
+	if (ret < enc_len) {
 		ret = -ENOKEY;
-		goto out_free_digest;
+		goto out;
 	}
 	*ret_digest = enc;
 	ret = 0;
 
-out_free_digest:
-	kfree_sensitive(digest);
-out_free_tfm:
-	crypto_free_shash(tfm);
-out_free_enc:
+out:
 	if (ret)
 		kfree_sensitive(enc);
-
+	memzero_explicit(digest, sizeof(digest));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_digest);
 
 /**
-- 
2.53.0

