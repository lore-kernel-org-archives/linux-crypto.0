Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C3138F65C;
	Mon,  2 Mar 2026 08:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438486; cv=none; b=bp8WGS2lsy88wGrvvPEMV06QWzOJxondNuZrbqJQvBw13st+eQbiIoL+QsOaNV4/wXe6LM27jSm6BTsTNQQ3CDJqvGqfz7FNG6aC73yj+SwCsWAKiuHuXza2RcOP8JTNC4i+9QQxxoNbob+stNvZoL5KnwOKExzV8EYKyfgXQOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438486; c=relaxed/simple;
	bh=Baj84wAItyGbuhZFMViAVPg9/GpQvbnC2i2OfoH9Krc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2xWuXRf82m2PJ0U9DTakXxLl9QW00sRmYEvxvs1b4DZc4RkeABJWw2OVZPsZ+FQNgj0rpfF2IguNXpI7IAlaTLPhO5WtpfwnMmqwc5FylZsckNQFFEu4fNjwZmqxmqu/UMH1fAptDcb4viOfJZ5j4nsjE8G5w8CfjXnDb9lo+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQwcaAKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQwcaAKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBDBC2BC87;
	Mon,  2 Mar 2026 08:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438485;
	bh=Baj84wAItyGbuhZFMViAVPg9/GpQvbnC2i2OfoH9Krc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQwcaAKCvB1wtwPYtEHFOsAqAeayy37/TnVqpkQNJ0wMWXgZuUPYkkGagbqKkp5yL
	 H77f5a6KGM8HS2GaIa4bjzG9LqvVHnHFapNwQ5kHQU5ErhQaUsMWO24tIjI5NomNs5
	 hm8f53xKu++sRwKf2OU7C5SO3TA6MNB716ELj/JulWCb6cDpFsWNRFjp6H4rsyJHIM
	 0PwUWG4ppC2pKgDFSRd1/DiMT4wslwiAxeAqmBnhKqhU7hA/nTrMzQMb8dT+TUxvZ9
	 iU6AgpdkX43qDPnGNbrQUC8iOahpxKY9+dLmZTYJh1bYfcYfxS+s1xV8VtmDiNhgti
	 WebrTMEK/98IA==
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
Subject: [PATCH 14/21] nvme-auth: host: use crypto library in nvme_auth_dhchap_setup_ctrl_response()
Date: Sun,  1 Mar 2026 23:59:52 -0800
Message-ID: <20260302075959.338638-15-ebiggers@kernel.org>
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

For the HMAC computation in nvme_auth_dhchap_setup_ctrl_response(), use
the crypto library instead of crypto_shash.  This is simpler, faster,
and more reliable.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/host/auth.c | 56 +++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index f22f17ad7e2f4..2f27f550a7442 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -502,11 +502,11 @@ static int nvme_auth_dhchap_setup_host_response(struct nvme_ctrl *ctrl,
 }
 
 static int nvme_auth_dhchap_setup_ctrl_response(struct nvme_ctrl *ctrl,
 		struct nvme_dhchap_queue_context *chap)
 {
-	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
+	struct nvme_auth_hmac_ctx hmac;
 	struct nvme_dhchap_key *transformed_key;
 	u8 buf[4], *challenge = chap->c2;
 	int ret;
 
 	transformed_key = nvme_auth_transform_key(ctrl->ctrl_key,
@@ -514,14 +514,14 @@ static int nvme_auth_dhchap_setup_ctrl_response(struct nvme_ctrl *ctrl,
 	if (IS_ERR(transformed_key)) {
 		ret = PTR_ERR(transformed_key);
 		return ret;
 	}
 
-	ret = crypto_shash_setkey(chap->shash_tfm,
-			transformed_key->key, transformed_key->len);
+	ret = nvme_auth_hmac_init(&hmac, chap->hash_id, transformed_key->key,
+				  transformed_key->len);
 	if (ret) {
-		dev_warn(ctrl->device, "qid %d: failed to set key, error %d\n",
+		dev_warn(ctrl->device, "qid %d: failed to init hmac, error %d\n",
 			 chap->qid, ret);
 		goto out;
 	}
 
 	if (chap->dh_tfm) {
@@ -544,47 +544,33 @@ static int nvme_auth_dhchap_setup_ctrl_response(struct nvme_ctrl *ctrl,
 		__func__, chap->qid, (int)chap->hash_len, challenge);
 	dev_dbg(ctrl->device, "%s: qid %d subsysnqn %s\n",
 		__func__, chap->qid, ctrl->opts->subsysnqn);
 	dev_dbg(ctrl->device, "%s: qid %d hostnqn %s\n",
 		__func__, chap->qid, ctrl->opts->host->nqn);
-	shash->tfm = chap->shash_tfm;
-	ret = crypto_shash_init(shash);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, challenge, chap->hash_len);
-	if (ret)
-		goto out;
+
+	nvme_auth_hmac_update(&hmac, challenge, chap->hash_len);
+
 	put_unaligned_le32(chap->s2, buf);
-	ret = crypto_shash_update(shash, buf, 4);
-	if (ret)
-		goto out;
+	nvme_auth_hmac_update(&hmac, buf, 4);
+
 	put_unaligned_le16(chap->transaction, buf);
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
-	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
-				  strlen(ctrl->opts->subsysnqn));
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, buf, 1);
-	if (ret)
-		goto out;
-	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
-				  strlen(ctrl->opts->host->nqn));
-	if (ret)
-		goto out;
-	ret = crypto_shash_final(shash, chap->response);
+	nvme_auth_hmac_update(&hmac, buf, 1);
+	nvme_auth_hmac_update(&hmac, "Controller", 10);
+	nvme_auth_hmac_update(&hmac, ctrl->opts->subsysnqn,
+			      strlen(ctrl->opts->subsysnqn));
+	nvme_auth_hmac_update(&hmac, buf, 1);
+	nvme_auth_hmac_update(&hmac, ctrl->opts->host->nqn,
+			      strlen(ctrl->opts->host->nqn));
+	nvme_auth_hmac_final(&hmac, chap->response);
+	ret = 0;
 out:
 	if (challenge != chap->c2)
 		kfree(challenge);
+	memzero_explicit(&hmac, sizeof(hmac));
 	nvme_auth_free_key(transformed_key);
 	return ret;
 }
 
 static int nvme_auth_dhchap_exponential(struct nvme_ctrl *ctrl,
-- 
2.53.0

