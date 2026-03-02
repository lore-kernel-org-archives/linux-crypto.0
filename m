Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F32138BF81;
	Mon,  2 Mar 2026 08:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438482; cv=none; b=c+CExQdz2W7nBaZlb5p0HjvC/NhzWIac/SXtpyCAFCng/jHyXbBvOsZtJCuln84aaMg+SyZ0noHeQCf9cyxkEyGsxzlNLH+bx4K4Ya9nbWq0XqKbq+Dp7cBD2gjOQqN35RvSWN/aN/tFzyKpiiOh/dWHnCpxvhH5qA4kZ16C9yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438482; c=relaxed/simple;
	bh=+MgGltZuKruBJzReBKBPlONks/5vv3TFbWQGTFvSRBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT6oc9QNtneDKmZx/nS4oRgBmOe6NC7QQyKf3VhgWB/w837iqELPbd/5tmZlWclrpbPGNvtY3Ks862AGv44zr4WG2dDAHCjQRKZLioevZGVUqZFX+RqAy1jePmkenGagw9csOYuvT5FPt8NHEmHxQoqzvJ8ytihmyFrRmHXpGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BBr3Iw6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BBr3Iw6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804DDC2BCAF;
	Mon,  2 Mar 2026 08:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438481;
	bh=+MgGltZuKruBJzReBKBPlONks/5vv3TFbWQGTFvSRBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBr3Iw6KTkjVsnBQ9Jm7dDZ/wH0gbW8979lLCv8uEOcXMRP635RLiHaPsb8yhvsQ0
	 p7GCVQg2EYaEhshHTHRUrPhrD2GCQYVHnl/FStaMZIU55v6aFnxD7uT5rTtD//AZ6g
	 cHBis7heIpSYzfiZbHqU2us0APDUV6Yy5T7Lev+mYcJLvG6v6so/P3vJ79qniN80Vl
	 VcWeFUZv4WtHwkljxfjlcq8GAol+SzKPHMAxYLDiE4Tqf9mF4DwC2Svvbc2AHe6AaK
	 OPtJxENXIHoNewuWYOcz1CW7uKlwclShzU9ZhgFJez5Z9ldwfFVffkeH72Zgnq6AV9
	 +DX74xNeaH12Q==
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
Subject: [PATCH 05/21] nvme-auth: rename nvme_auth_generate_key() to nvme_auth_parse_key()
Date: Sun,  1 Mar 2026 23:59:43 -0800
Message-ID: <20260302075959.338638-6-ebiggers@kernel.org>
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

This function does not generate a key.  It parses the key from the
string that the caller passes in.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 4 ++--
 drivers/nvme/host/auth.c   | 7 +++----
 drivers/nvme/host/sysfs.c  | 4 ++--
 include/linux/nvme-auth.h  | 2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index d35523d0a017b..2f83c9ddea5ec 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -434,11 +434,11 @@ int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
 	kpp_request_free(req);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_gen_shared_secret);
 
-int nvme_auth_generate_key(const char *secret, struct nvme_dhchap_key **ret_key)
+int nvme_auth_parse_key(const char *secret, struct nvme_dhchap_key **ret_key)
 {
 	struct nvme_dhchap_key *key;
 	u8 key_hash;
 
 	if (!secret) {
@@ -457,11 +457,11 @@ int nvme_auth_generate_key(const char *secret, struct nvme_dhchap_key **ret_key)
 	}
 
 	*ret_key = key;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
+EXPORT_SYMBOL_GPL(nvme_auth_parse_key);
 
 /**
  * nvme_auth_generate_psk - Generate a PSK for TLS
  * @hmac_id: Hash function identifier
  * @skey: Session key
diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index d0d0a9d5a8717..47a1525e876e0 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -1070,16 +1070,15 @@ int nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
 
 	mutex_init(&ctrl->dhchap_auth_mutex);
 	INIT_WORK(&ctrl->dhchap_auth_work, nvme_ctrl_auth_work);
 	if (!ctrl->opts)
 		return 0;
-	ret = nvme_auth_generate_key(ctrl->opts->dhchap_secret,
-			&ctrl->host_key);
+	ret = nvme_auth_parse_key(ctrl->opts->dhchap_secret, &ctrl->host_key);
 	if (ret)
 		return ret;
-	ret = nvme_auth_generate_key(ctrl->opts->dhchap_ctrl_secret,
-			&ctrl->ctrl_key);
+	ret = nvme_auth_parse_key(ctrl->opts->dhchap_ctrl_secret,
+				  &ctrl->ctrl_key);
 	if (ret)
 		goto err_free_dhchap_secret;
 
 	if (!ctrl->opts->dhchap_secret && !ctrl->opts->dhchap_ctrl_secret)
 		return 0;
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 29430949ce2f0..e3b5c75d2ebb7 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -634,11 +634,11 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_secret)) {
 		struct nvme_dhchap_key *key, *host_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &key);
+		ret = nvme_auth_parse_key(dhchap_secret, &key);
 		if (ret) {
 			kfree(dhchap_secret);
 			return ret;
 		}
 		kfree(opts->dhchap_secret);
@@ -692,11 +692,11 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_ctrl_secret)) {
 		struct nvme_dhchap_key *key, *ctrl_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &key);
+		ret = nvme_auth_parse_key(dhchap_secret, &key);
 		if (ret) {
 			kfree(dhchap_secret);
 			return ret;
 		}
 		kfree(opts->dhchap_ctrl_secret);
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index a4b248c24ccf6..02ca9a7162565 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -28,11 +28,11 @@ u32 nvme_auth_key_struct_size(u32 key_len);
 struct nvme_dhchap_key *nvme_auth_extract_key(const char *secret, u8 key_hash);
 void nvme_auth_free_key(struct nvme_dhchap_key *key);
 struct nvme_dhchap_key *nvme_auth_alloc_key(u32 len, u8 hash);
 struct nvme_dhchap_key *nvme_auth_transform_key(
 		const struct nvme_dhchap_key *key, const char *nqn);
-int nvme_auth_generate_key(const char *secret, struct nvme_dhchap_key **ret_key);
+int nvme_auth_parse_key(const char *secret, struct nvme_dhchap_key **ret_key);
 int nvme_auth_augmented_challenge(u8 hmac_id, const u8 *skey, size_t skey_len,
 				  const u8 *challenge, u8 *aug, size_t hlen);
 int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, u8 dh_gid);
 int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
 			 u8 *host_key, size_t host_key_len);
-- 
2.53.0

