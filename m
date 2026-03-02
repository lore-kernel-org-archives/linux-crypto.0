Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E825738D007;
	Mon,  2 Mar 2026 08:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438484; cv=none; b=cj+9TpGZYg02jHatleYRgI9jeTN9zEbsV6KC0qkvb8gTm55klDy9OX+5iHo7ZDLXESxXgQqpHtaOY99LbvMo7Ry3pHbcWFkHnTy7dWgIWaHbE2coPqNqxPuM1MikDFiWIQ5qrTnQ7RAcyJx1wZtmK/cFrozXc6x8CCICJsaxSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438484; c=relaxed/simple;
	bh=bjsE/c+5TFoj0rL/sw+wLvSH57oqh6wELi161NQyhDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To42eozKjEsuL2SuT5nfRZLeNn4W8oLvqCsD139/qeFhuXUxn4n3YpiKM+juJVngyTCW5sa/NHz0/qlaP3hPsacjbf/lmew1EAJU7hSmnRw+evFxmnAQMC+birWlO2blRQ5SbE3awZe2eU336K9hS0XAcZYoQsQ0uXEj9Mf3pZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJI0vx94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJI0vx94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB6EC2BCB5;
	Mon,  2 Mar 2026 08:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438483;
	bh=bjsE/c+5TFoj0rL/sw+wLvSH57oqh6wELi161NQyhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJI0vx94fIn/70pLXINnQh8QSCxhSj9loE/ehLjrwWuaqhugNNn3uzQXOj+9kStn+
	 zkrTRAzWRXsxFQZrKHIx9Mu7R2CygtQ2/s5EBEKBMwcj3R4BoA7ilu2R9AdprhQTzO
	 GDUsnbH63zeE/uKvOjmxK9nybpE27IKF3kJQanr4pmVOj3G7EpXgraDD6Qyggwa3t/
	 omj0V0aUM+7ZKfXFLVGKE3KiQn42mKJw3oE+gFQmgWFUGoGJo+3vK8M8JUk4solmHY
	 43xQ7NRsyeASF0T/9oj4SenrgxaG0M1X3jHFJHcGU7ARwc2ylkKpk1t18Psfcc8zCM
	 z+PPTj5qNjWRg==
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
Subject: [PATCH 09/21] nvme-auth: common: use crypto library in nvme_auth_augmented_challenge()
Date: Sun,  1 Mar 2026 23:59:47 -0800
Message-ID: <20260302075959.338638-10-ebiggers@kernel.org>
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

For the hash and HMAC computations in nvme_auth_augmented_challenge(),
use the crypto library instead of crypto_shash.  This is simpler,
faster, and more reliable.  Notably, this eliminates two crypto
transformation object allocations for every call, which was very slow.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 96 ++++++++++++++------------------------
 1 file changed, 36 insertions(+), 60 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 321d6e11c2751..be5bc5fcafc63 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -298,10 +298,41 @@ void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out)
 	/* Unreachable because nvme_auth_hmac_init() validated hmac_id */
 	WARN_ON_ONCE(1);
 }
 EXPORT_SYMBOL_GPL(nvme_auth_hmac_final);
 
+static int nvme_auth_hmac(u8 hmac_id, const u8 *key, size_t key_len,
+			  const u8 *data, size_t data_len, u8 *out)
+{
+	struct nvme_auth_hmac_ctx hmac;
+	int ret;
+
+	ret = nvme_auth_hmac_init(&hmac, hmac_id, key, key_len);
+	if (ret == 0) {
+		nvme_auth_hmac_update(&hmac, data, data_len);
+		nvme_auth_hmac_final(&hmac, out);
+	}
+	return ret;
+}
+
+static int nvme_auth_hash(u8 hmac_id, const u8 *data, size_t data_len, u8 *out)
+{
+	switch (hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		sha256(data, data_len, out);
+		return 0;
+	case NVME_AUTH_HASH_SHA384:
+		sha384(data, data_len, out);
+		return 0;
+	case NVME_AUTH_HASH_SHA512:
+		sha512(data, data_len, out);
+		return 0;
+	}
+	pr_warn("%s: invalid hash algorithm %d\n", __func__, hmac_id);
+	return -EINVAL;
+}
+
 struct nvme_dhchap_key *nvme_auth_transform_key(
 		const struct nvme_dhchap_key *key, const char *nqn)
 {
 	struct nvme_auth_hmac_ctx hmac;
 	struct nvme_dhchap_key *transformed_key;
@@ -332,76 +363,21 @@ struct nvme_dhchap_key *nvme_auth_transform_key(
 	nvme_auth_hmac_final(&hmac, transformed_key->key);
 	return transformed_key;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
 
-static int nvme_auth_hash_skey(int hmac_id, const u8 *skey, size_t skey_len,
-			       u8 *hkey)
-{
-	const char *digest_name;
-	struct crypto_shash *tfm;
-	int ret;
-
-	digest_name = nvme_auth_digest_name(hmac_id);
-	if (!digest_name) {
-		pr_debug("%s: failed to get digest for %d\n", __func__,
-			 hmac_id);
-		return -EINVAL;
-	}
-	tfm = crypto_alloc_shash(digest_name, 0, 0);
-	if (IS_ERR(tfm))
-		return -ENOMEM;
-
-	ret = crypto_shash_tfm_digest(tfm, skey, skey_len, hkey);
-	if (ret < 0)
-		pr_debug("%s: Failed to hash digest len %zu\n", __func__,
-			 skey_len);
-
-	crypto_free_shash(tfm);
-	return ret;
-}
-
 int nvme_auth_augmented_challenge(u8 hmac_id, const u8 *skey, size_t skey_len,
 				  const u8 *challenge, u8 *aug, size_t hlen)
 {
-	struct crypto_shash *tfm;
-	u8 *hashed_key;
-	const char *hmac_name;
+	u8 hashed_key[NVME_AUTH_MAX_DIGEST_SIZE];
 	int ret;
 
-	hashed_key = kmalloc(hlen, GFP_KERNEL);
-	if (!hashed_key)
-		return -ENOMEM;
-
-	ret = nvme_auth_hash_skey(hmac_id, skey,
-				  skey_len, hashed_key);
-	if (ret < 0)
-		goto out_free_key;
-
-	hmac_name = nvme_auth_hmac_name(hmac_id);
-	if (!hmac_name) {
-		pr_warn("%s: invalid hash algorithm %d\n",
-			__func__, hmac_id);
-		ret = -EINVAL;
-		goto out_free_key;
-	}
-
-	tfm = crypto_alloc_shash(hmac_name, 0, 0);
-	if (IS_ERR(tfm)) {
-		ret = PTR_ERR(tfm);
-		goto out_free_key;
-	}
-
-	ret = crypto_shash_setkey(tfm, hashed_key, hlen);
+	ret = nvme_auth_hash(hmac_id, skey, skey_len, hashed_key);
 	if (ret)
-		goto out_free_hash;
-
-	ret = crypto_shash_tfm_digest(tfm, challenge, hlen, aug);
-out_free_hash:
-	crypto_free_shash(tfm);
-out_free_key:
-	kfree_sensitive(hashed_key);
+		return ret;
+	ret = nvme_auth_hmac(hmac_id, hashed_key, hlen, challenge, hlen, aug);
+	memzero_explicit(hashed_key, sizeof(hashed_key));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_augmented_challenge);
 
 int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, u8 dh_gid)
-- 
2.53.0

