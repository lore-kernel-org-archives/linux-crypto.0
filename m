Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D038CFFE;
	Mon,  2 Mar 2026 08:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438483; cv=none; b=Hwicx5BbiF2jgETZwAHKETtPpX+rd26LXy0dwAJknwOrkdpySGaQBC9NKTyHRoLJpGbzNFkRpYBcV7bhQdmaZjQ7FW+rn99iA8x6K+ZK7JoLnvj9GvsLLeFAMCpbX52TYhwa5tfb4H69msNghXWArtxs5sOnFipDb2I4k9RnSvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438483; c=relaxed/simple;
	bh=5/axZn97VN14i0ECtfuuOtnlWLVE2t/3hoi4aTeGtQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5j1AwP1q38IvPkvuWnZarcDR7YoFVqiBZM4k5sNOfru77GSxodlyouja0m2Yvpk4Gl4yX5OmBjhXztHVPoTXTV8lT+bDAYtD8cgN05AtxpOcIjptPPtx9sKDkY1U8aBodVGdILDq+Tq9oelPM24DOQrp+jIVUdMvONGTLWbXSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLW0TKaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLW0TKaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A5AC2BC87;
	Mon,  2 Mar 2026 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438483;
	bh=5/axZn97VN14i0ECtfuuOtnlWLVE2t/3hoi4aTeGtQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLW0TKaF/ttr/9aUX7QLxRTmYBWfr9QLaJdd+lL1REj+LxIJS/yTE9bsOcxwaiJZt
	 9zHyFA4qjxFg8nx3fQZLVW5h2tcdHzz4H47fHl29445XFzbVNM4rdyr5TPMNaDhtQr
	 1Ibr8nTuaxuv2M7XoXKNV8Ad3nsHqphOQwoH8OukwU29Toz4mrozBwDjTfdmjRrJQu
	 nBTU6uyXEzX3f2ndEgPut56N7PS+FaxeyUpv1ik1GkPvlPIyzbJ/P2YOkzQKQ82j8a
	 u8YO0D7ri4EdWmWwOlqP2SSEOkO6J32kOemAbBeNxuak5FKEbEKBiWYi5sc8V4cM7B
	 Xwo/8dsB1+TmA==
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
Subject: [PATCH 08/21] nvme-auth: common: use crypto library in nvme_auth_transform_key()
Date: Sun,  1 Mar 2026 23:59:46 -0800
Message-ID: <20260302075959.338638-9-ebiggers@kernel.org>
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

For the HMAC computation in nvme_auth_transform_key(), use the crypto
library instead of crypto_shash.  This is simpler, faster, and more
reliable.  Notably, this eliminates the transformation object allocation
for every call, which was very slow.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 53 +++++++-------------------------------
 1 file changed, 10 insertions(+), 43 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 00f21176181f6..321d6e11c2751 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -301,13 +301,11 @@ void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out)
 EXPORT_SYMBOL_GPL(nvme_auth_hmac_final);
 
 struct nvme_dhchap_key *nvme_auth_transform_key(
 		const struct nvme_dhchap_key *key, const char *nqn)
 {
-	const char *hmac_name;
-	struct crypto_shash *key_tfm;
-	SHASH_DESC_ON_STACK(shash, key_tfm);
+	struct nvme_auth_hmac_ctx hmac;
 	struct nvme_dhchap_key *transformed_key;
 	int ret, key_len;
 
 	if (!key) {
 		pr_warn("No key specified\n");
@@ -318,54 +316,23 @@ struct nvme_dhchap_key *nvme_auth_transform_key(
 		transformed_key = kmemdup(key, key_len, GFP_KERNEL);
 		if (!transformed_key)
 			return ERR_PTR(-ENOMEM);
 		return transformed_key;
 	}
-	hmac_name = nvme_auth_hmac_name(key->hash);
-	if (!hmac_name) {
-		pr_warn("Invalid key hash id %d\n", key->hash);
-		return ERR_PTR(-EINVAL);
-	}
-
-	key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
-	if (IS_ERR(key_tfm))
-		return ERR_CAST(key_tfm);
-
-	key_len = crypto_shash_digestsize(key_tfm);
+	ret = nvme_auth_hmac_init(&hmac, key->hash, key->key, key->len);
+	if (ret)
+		return ERR_PTR(ret);
+	key_len = nvme_auth_hmac_hash_len(key->hash);
 	transformed_key = nvme_auth_alloc_key(key_len, key->hash);
 	if (!transformed_key) {
-		ret = -ENOMEM;
-		goto out_free_key;
+		memzero_explicit(&hmac, sizeof(hmac));
+		return ERR_PTR(-ENOMEM);
 	}
-
-	shash->tfm = key_tfm;
-	ret = crypto_shash_setkey(key_tfm, key->key, key->len);
-	if (ret < 0)
-		goto out_free_transformed_key;
-	ret = crypto_shash_init(shash);
-	if (ret < 0)
-		goto out_free_transformed_key;
-	ret = crypto_shash_update(shash, nqn, strlen(nqn));
-	if (ret < 0)
-		goto out_free_transformed_key;
-	ret = crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
-	if (ret < 0)
-		goto out_free_transformed_key;
-	ret = crypto_shash_final(shash, transformed_key->key);
-	if (ret < 0)
-		goto out_free_transformed_key;
-
-	crypto_free_shash(key_tfm);
-
+	nvme_auth_hmac_update(&hmac, nqn, strlen(nqn));
+	nvme_auth_hmac_update(&hmac, "NVMe-over-Fabrics", 17);
+	nvme_auth_hmac_final(&hmac, transformed_key->key);
 	return transformed_key;
-
-out_free_transformed_key:
-	nvme_auth_free_key(transformed_key);
-out_free_key:
-	crypto_free_shash(key_tfm);
-
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
 
 static int nvme_auth_hash_skey(int hmac_id, const u8 *skey, size_t skey_len,
 			       u8 *hkey)
-- 
2.53.0

