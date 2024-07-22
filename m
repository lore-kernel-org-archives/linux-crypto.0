Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB9A16D4DF
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2024 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658130; cv=none; b=jwsu+qwTIclhdJPbPasFuOQ8vDli07B5rRjOAfc1yqIHgTDLtc2lTlwf/GJ2LfLtNqRRNrP1Ze9+qNYA+LnKKQ5XPT6SlMXk1nFlt9ooO6l8Wo24AFb4sdY/ambpy7hGcLw90Nq9bgdXGo1B6WQBBk+qgbu5wNPYlPAxzLsa3t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658130; c=relaxed/simple;
	bh=28iWTpGgJQZACHrKP438Mo3qa8pSKYOIzwL8Ms+F4hQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rY7DDBp5scqb77+WIPgPcm3mX3NfGf96vGYR9h2Cag6GJfm6bVgq/ix3sQJecnFzHV/938U5RvMHokVcwJQk20rJXb1DuiQAQa5PE8gO4vQ/HkTuAqfnDwK8pJKqgERf4RIDUK83gxJAgArj40W8htcj7S4cPFxqJpPlUcAfOrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q1sq4xzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1sq4xzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE59C4AF0E;
	Mon, 22 Jul 2024 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721658129;
	bh=28iWTpGgJQZACHrKP438Mo3qa8pSKYOIzwL8Ms+F4hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1sq4xzigjqUrzySdY9Uhqbak5NOxXW7ye7gRuzZq8Ng4aU8jqNgiLvD1WHp7x/Gl
	 X6o/MtbJs5E6kH0Ebxe/QAIwXzGpMikEtLC87RJvvc7ks06gjusoQmhfTYFy+AxdBE
	 JOvfkcz1Vdg7mBIxbPtr9QPOSrikkUyGOOSv5heizdh/irQrcQSEvu+pYxfaMha1ww
	 1khkMwRUFg+54denOqicUXi82guw+1KX93lMDuSLKzJFOb3U+34Yj7G1iAgYXlQyv+
	 lWt493bLfR5orjn3gPsvmmq8KVLWPiDVLBp+k6mBbMqI3rs/4E7SFpLKvbFBQz8NXf
	 bvh+RZKUfduyQ==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 4/9] nvme: add nvme_auth_derive_tls_psk()
Date: Mon, 22 Jul 2024 16:21:17 +0200
Message-Id: <20240722142122.128258-5-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240722142122.128258-1-hare@kernel.org>
References: <20240722142122.128258-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a function to derive the TLS PSK as specified TP8018.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/common/auth.c | 90 ++++++++++++++++++++++++++++++++++++++
 include/linux/nvme-auth.h  |  2 +
 2 files changed, 92 insertions(+)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 7e40f205d3e4..0b000a562c0f 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -684,5 +684,95 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_digest);
 
+/*
+ * Derive a TLS PSK as specified in TP8018 Section 3.6.1.3:
+ *   TLS PSK and PSK identity Derivation
+ *
+ * The TLS PSK shall be derived as follows from an input PSK
+ * (i.e., either a retained PSK or a generated PSK) and a PSK
+ * identity using the HKDF-Extract and HKDF-Expand-Label operations
+ * (refer to RFC 5869 and RFC 8446) where the hash function is the
+ * one specified by the hash specifier of the PSK identity:
+ * 1. PRK = HKDF-Extract(0, Input PSK); and
+ * 2. TLS PSK = HKDF-Expand-Label(PRK, "nvme-tls-psk", PskIdentityContext, L),
+ * where PskIdentityContext is the hash identifier indicated in
+ * the PSK identity concatenated to a space character and to the
+ * Base64 PSK digest (i.e., "<hash> <PSK digest>") and L is the
+ * output size in bytes of the hash function (i.e., 32 for SHA-256
+ * and 48 for SHA-384).
+ */
+int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
+		u8 *psk_digest, u8 **ret_psk)
+{
+	struct crypto_shash *hmac_tfm;
+	const char *hmac_name;
+	const char *psk_prefix = "tls13 nvme-tls-psk";
+	size_t info_len, prk_len;
+	char *info;
+	unsigned char *prk, *tls_key;
+	int ret;
+
+	hmac_name = nvme_auth_hmac_name(hmac_id);
+	if (!hmac_name) {
+		pr_warn("%s: invalid hash algoritm %d\n",
+			__func__, hmac_id);
+		return -EINVAL;
+	}
+	if (hmac_id == NVME_AUTH_HASH_SHA512) {
+		pr_warn("%s: unsupported hash algorithm %s\n",
+			__func__, hmac_name);
+		return -EINVAL;
+	}
+
+	hmac_tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(hmac_tfm))
+		return PTR_ERR(hmac_tfm);
+
+	prk_len = crypto_shash_digestsize(hmac_tfm);
+	prk = kzalloc(prk_len, GFP_KERNEL);
+	if (!prk) {
+		ret = -ENOMEM;
+		goto out_free_shash;
+	}
+
+	ret = hkdf_extract(hmac_tfm, psk, psk_len, prk);
+	if (ret)
+		goto out_free_prk;
+
+	ret = crypto_shash_setkey(hmac_tfm, prk, prk_len);
+	if (ret)
+		goto out_free_prk;
+
+	info_len = strlen(psk_digest) + strlen(psk_prefix) + 1;
+	info = kzalloc(info_len, GFP_KERNEL);
+	if (!info)
+		goto out_free_prk;
+
+	memcpy(info, psk_prefix, strlen(psk_prefix));
+	memcpy(info + strlen(psk_prefix), psk_digest, strlen(psk_digest));
+
+	tls_key = kzalloc(psk_len, GFP_KERNEL);
+	if (!tls_key) {
+		ret = -ENOMEM;
+		goto out_free_info;
+	}
+	ret = hkdf_expand(hmac_tfm, info, strlen(info), tls_key, psk_len);
+	if (ret) {
+		kfree(tls_key);
+		goto out_free_info;
+	}
+	*ret_psk = tls_key;
+
+out_free_info:
+	kfree(info);
+out_free_prk:
+	kfree(prk);
+out_free_shash:
+	crypto_free_shash(hmac_tfm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_derive_tls_psk);
+
 MODULE_DESCRIPTION("NVMe Authentication framework");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index 998f06bf10fd..60e069a6757f 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -45,5 +45,7 @@ int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
 			   u8 **ret_psk, size_t *ret_len);
 int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 		char *subsysnqn, char *hostnqn, u8 **ret_digest);
+int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
+		u8 *psk_digest, u8 **ret_psk);
 
 #endif /* _NVME_AUTH_H */
-- 
2.35.3

