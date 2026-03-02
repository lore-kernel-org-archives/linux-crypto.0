Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D15396D2F;
	Mon,  2 Mar 2026 08:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438487; cv=none; b=E4F2LQxrGzYpNdxKnPxNVDX+hp/d/kfeqdVDSi05oKuoBVG8Q6kO8EMIkESsTiaEl1kbY8X2XxlNbjts4/0ibSZgsOLSC5xQbQKLxXOSyFRlgPKO3WA44pbQTu+zrZofnR/Z4db9ZDrh3le7Rja/IicDxZ+dzH9P5P7VaeERL8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438487; c=relaxed/simple;
	bh=EphkCeCJIyGTWVOIVPgO3qYZz8GssaBeEOsUJcGFHUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQiB6QuJwpXcNG7ZpPG16IhBjK0qavJFjipYBzaFZaeJm2rRM91cvwf/LvSHXtUNIjbIgW0cwskorqXlHT8S9j9I2b8T7cf84QYuBeBixK3v8d3d1TG/jTaa3gHyDQeUCap18pA2D+7ZrdQi4yiZveTgf9qeI6q2vln67+/rR5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EorW8N4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EorW8N4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9388C2BCB4;
	Mon,  2 Mar 2026 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438487;
	bh=EphkCeCJIyGTWVOIVPgO3qYZz8GssaBeEOsUJcGFHUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EorW8N4kb81mYsTzRp1oPl8dfmsmuD3AKM4aZPBtNo6Eke8l4xAl8Zc62GER1z60I
	 DFFRDi5cTIDnHASxk19eadYoSOPxCW2gk9NH/EgAaGoxJDcOp0aQ9zPyKrk0eC8Qk7
	 2wmNR+HpUfVAn6B9JsBln0J8YhXAV4BkUfaBRS+mqbL/JfTMRgX9uDytbNdiQlkV2H
	 +n/n8Af/i5GKK/5PZKhc2zrGdqUnJ+u+LtCQt4VUAkOShmF2XrPl8Yk1eiMOA8OW61
	 MvIu28oOKvjJJyrYF4f1czze0NitkBf4GHzv47oZo/pV305Oy5wbRO9M1mXSQIXnAk
	 rqg5jMyxr5iTA==
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
Subject: [PATCH 17/21] nvme-auth: target: use crypto library in nvmet_auth_host_hash()
Date: Sun,  1 Mar 2026 23:59:55 -0800
Message-ID: <20260302075959.338638-18-ebiggers@kernel.org>
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

For the HMAC computation in nvmet_auth_host_hash(), use the crypto
library instead of crypto_shash.  This is simpler, faster, and more
reliable.  Notably, this eliminates the crypto transformation object
allocation for every call, which was very slow.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/target/auth.c | 90 ++++++++++++--------------------------
 1 file changed, 28 insertions(+), 62 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 08c1783d70fc4..fc56ce74d20f2 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -281,51 +281,34 @@ bool nvmet_check_auth_status(struct nvmet_req *req)
 }
 
 int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 			 unsigned int shash_len)
 {
-	struct crypto_shash *shash_tfm;
-	SHASH_DESC_ON_STACK(shash, shash_tfm);
+	struct nvme_auth_hmac_ctx hmac;
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
-	const char *hash_name;
 	u8 *challenge = req->sq->dhchap_c1;
 	struct nvme_dhchap_key *transformed_key;
 	u8 buf[4];
 	int ret;
 
-	hash_name = nvme_auth_hmac_name(ctrl->shash_id);
-	if (!hash_name) {
-		pr_warn("Hash ID %d invalid\n", ctrl->shash_id);
-		return -EINVAL;
-	}
-
-	shash_tfm = crypto_alloc_shash(hash_name, 0, 0);
-	if (IS_ERR(shash_tfm)) {
-		pr_err("failed to allocate shash %s\n", hash_name);
-		return PTR_ERR(shash_tfm);
-	}
-
-	if (shash_len != crypto_shash_digestsize(shash_tfm)) {
-		pr_err("%s: hash len mismatch (len %d digest %d)\n",
-			__func__, shash_len,
-			crypto_shash_digestsize(shash_tfm));
-		ret = -EINVAL;
-		goto out_free_tfm;
-	}
-
 	transformed_key = nvme_auth_transform_key(ctrl->host_key,
 						  ctrl->hostnqn);
-	if (IS_ERR(transformed_key)) {
-		ret = PTR_ERR(transformed_key);
-		goto out_free_tfm;
-	}
+	if (IS_ERR(transformed_key))
+		return PTR_ERR(transformed_key);
 
-	ret = crypto_shash_setkey(shash_tfm, transformed_key->key,
+	ret = nvme_auth_hmac_init(&hmac, ctrl->shash_id, transformed_key->key,
 				  transformed_key->len);
 	if (ret)
 		goto out_free_response;
 
+	if (shash_len != nvme_auth_hmac_hash_len(ctrl->shash_id)) {
+		pr_err("%s: hash len mismatch (len %u digest %zu)\n", __func__,
+		       shash_len, nvme_auth_hmac_hash_len(ctrl->shash_id));
+		ret = -EINVAL;
+		goto out_free_response;
+	}
+
 	if (ctrl->dh_gid != NVME_AUTH_DHGROUP_NULL) {
 		challenge = kmalloc(shash_len, GFP_KERNEL);
 		if (!challenge) {
 			ret = -ENOMEM;
 			goto out_free_response;
@@ -334,58 +317,41 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 						    req->sq->dhchap_skey,
 						    req->sq->dhchap_skey_len,
 						    req->sq->dhchap_c1,
 						    challenge, shash_len);
 		if (ret)
-			goto out;
+			goto out_free_challenge;
 	}
 
 	pr_debug("ctrl %d qid %d host response seq %u transaction %d\n",
 		 ctrl->cntlid, req->sq->qid, req->sq->dhchap_s1,
 		 req->sq->dhchap_tid);
 
-	shash->tfm = shash_tfm;
-	ret = crypto_shash_init(shash);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, challenge, shash_len);
-	if (ret)
-		goto out;
+	nvme_auth_hmac_update(&hmac, challenge, shash_len);
+
 	put_unaligned_le32(req->sq->dhchap_s1, buf);
-	ret = crypto_shash_update(shash, buf, 4);
-	if (ret)
-		goto out;
+	nvme_auth_hmac_update(&hmac, buf, 4);
+
 	put_unaligned_le16(req->sq->dhchap_tid, buf);
-	ret = crypto_shash_update(shash, buf, 2);
-	if (ret)
-		goto out;
+	nvme_auth_hmac_update(&hmac, buf, 2);
+
 	*buf = req->sq->sc_c;
-	ret = crypto_shash_update(shash, buf, 1);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, "HostHost", 8);
-	if (ret)
-		goto out;
+	nvme_auth_hmac_update(&hmac, buf, 1);
+	nvme_auth_hmac_update(&hmac, "HostHost", 8);
 	memset(buf, 0, 4);
-	ret = crypto_shash_update(shash, ctrl->hostnqn, strlen(ctrl->hostnqn));
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, buf, 1);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, ctrl->subsys->subsysnqn,
-				  strlen(ctrl->subsys->subsysnqn));
-	if (ret)
-		goto out;
-	ret = crypto_shash_final(shash, response);
-out:
+	nvme_auth_hmac_update(&hmac, ctrl->hostnqn, strlen(ctrl->hostnqn));
+	nvme_auth_hmac_update(&hmac, buf, 1);
+	nvme_auth_hmac_update(&hmac, ctrl->subsys->subsysnqn,
+			      strlen(ctrl->subsys->subsysnqn));
+	nvme_auth_hmac_final(&hmac, response);
+	ret = 0;
+out_free_challenge:
 	if (challenge != req->sq->dhchap_c1)
 		kfree(challenge);
 out_free_response:
+	memzero_explicit(&hmac, sizeof(hmac));
 	nvme_auth_free_key(transformed_key);
-out_free_tfm:
-	crypto_free_shash(shash_tfm);
 	return ret;
 }
 
 int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 			 unsigned int shash_len)
-- 
2.53.0

