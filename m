Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B7139B96C;
	Mon,  2 Mar 2026 08:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438488; cv=none; b=QyxfE4mw0ONnIYHJaR6lYp1/wjY5s0OLRVc2aAcqE9BccZh0xdpu82cW6YDdcGHP+ag/4Wb3N4UI8GhJ6XOiqEvg9aZ/R1C3wsFCQN7jhf8J2MSs7C3U09XuBZnSBajS0blSRlfxrw4Uvj1bQ821yflikyL6YiWr10E8+AbjslM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438488; c=relaxed/simple;
	bh=W9H2LPxBxHj30YbFlkwn9HuR3K0Ej7ZCT6eTTeVS5QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJKNDRm26DKiqZtt2yV8UsriStjJrFB8qMbrkxWJ9lZlRW5XlTaf9wfPleKGNrfd3mBYoUAq3Ve9iSdMP77tPul5gt4QlKowdcLVgtzjxzct3Iv7KUoj7DXFWFu/QQVlq0WpZ2ygL2xb4ZeJXehtIBr/ivKu2YkAOqyP6buc1UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn2O7+Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn2O7+Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2FEC2BCC7;
	Mon,  2 Mar 2026 08:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438487;
	bh=W9H2LPxBxHj30YbFlkwn9HuR3K0Ej7ZCT6eTTeVS5QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hn2O7+MbmRIEWUexO3ReOLCk6SrJje4UHyJ4o5mMr8kkUnBklg/QM6EEt9plIMvbd
	 SePZnRxSElmr6D1p5wrYz0wMJXQVJwhrDfUeHyLG/Fubvve2glqQ8b+x/2XMqUjSC1
	 r3x2V6vv3yaDX2d+ivZgOgtCZidMWIdZPn7W8pUh0a8mpIFnDLSbFw02MPcYnqCcIE
	 29cX7Vf/JX0isM37BbwSgrKL5XU9QkNaR6zJuXK6bPDCnUa3qS4YTJUaw8YaHqyJiK
	 53AmKr8SoJ1mSqwVQVRooKBXYYW1zbSRtnEMVrGu81riWpsllO8WXyNUkIL7xwu+eN
	 +h+M+j6VaYBxQ==
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
Subject: [PATCH 18/21] nvme-auth: target: use crypto library in nvmet_auth_ctrl_hash()
Date: Sun,  1 Mar 2026 23:59:56 -0800
Message-ID: <20260302075959.338638-19-ebiggers@kernel.org>
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

For the HMAC computation in nvmet_auth_ctrl_hash(), use the crypto
library instead of crypto_shash.  This is simpler, faster, and more
reliable.  Notably, this eliminates the crypto transformation object
allocation for every call, which was very slow.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/target/auth.c | 94 ++++++++++----------------------------
 1 file changed, 25 insertions(+), 69 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index fc56ce74d20f2..b7417ab6b035f 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -7,11 +7,10 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <crypto/hash.h>
 #include <linux/crc32.h>
 #include <linux/base64.h>
 #include <linux/ctype.h>
 #include <linux/random.h>
 #include <linux/nvme-auth.h>
@@ -354,51 +353,34 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 }
 
 int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 			 unsigned int shash_len)
 {
-	struct crypto_shash *shash_tfm;
-	struct shash_desc *shash;
+	struct nvme_auth_hmac_ctx hmac;
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
-	const char *hash_name;
 	u8 *challenge = req->sq->dhchap_c2;
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
-		pr_debug("%s: hash len mismatch (len %d digest %d)\n",
-			 __func__, shash_len,
-			 crypto_shash_digestsize(shash_tfm));
-		ret = -EINVAL;
-		goto out_free_tfm;
-	}
-
 	transformed_key = nvme_auth_transform_key(ctrl->ctrl_key,
 						ctrl->subsys->subsysnqn);
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
@@ -410,59 +392,33 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 						    challenge, shash_len);
 		if (ret)
 			goto out_free_challenge;
 	}
 
-	shash = kzalloc(sizeof(*shash) + crypto_shash_descsize(shash_tfm),
-			GFP_KERNEL);
-	if (!shash) {
-		ret = -ENOMEM;
-		goto out_free_challenge;
-	}
-	shash->tfm = shash_tfm;
+	nvme_auth_hmac_update(&hmac, challenge, shash_len);
 
-	ret = crypto_shash_init(shash);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, challenge, shash_len);
-	if (ret)
-		goto out;
 	put_unaligned_le32(req->sq->dhchap_s2, buf);
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
 	memset(buf, 0, 4);
-	ret = crypto_shash_update(shash, buf, 1);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, "Controller", 10);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, ctrl->subsys->subsysnqn,
-			    strlen(ctrl->subsys->subsysnqn));
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, buf, 1);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, ctrl->hostnqn, strlen(ctrl->hostnqn));
-	if (ret)
-		goto out;
-	ret = crypto_shash_final(shash, response);
-out:
-	kfree(shash);
+	nvme_auth_hmac_update(&hmac, buf, 1);
+	nvme_auth_hmac_update(&hmac, "Controller", 10);
+	nvme_auth_hmac_update(&hmac, ctrl->subsys->subsysnqn,
+			      strlen(ctrl->subsys->subsysnqn));
+	nvme_auth_hmac_update(&hmac, buf, 1);
+	nvme_auth_hmac_update(&hmac, ctrl->hostnqn, strlen(ctrl->hostnqn));
+	nvme_auth_hmac_final(&hmac, response);
+	ret = 0;
 out_free_challenge:
 	if (challenge != req->sq->dhchap_c2)
 		kfree(challenge);
 out_free_response:
+	memzero_explicit(&hmac, sizeof(hmac));
 	nvme_auth_free_key(transformed_key);
-out_free_tfm:
-	crypto_free_shash(shash_tfm);
 	return ret;
 }
 
 int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
 				u8 *buf, int buf_size)
-- 
2.53.0

