Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F4C2233A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723547738; cv=none; b=Zr8ao/oGtdUV7nqryPS9kftqbkF1K+YdFsbVjW7IiJ5q4IMuWX4rOyqwhiqLBI0kIzSSFt+2C5K9Vb9FvKc7t2Nl7Xoe35NGezzjUG7Kf6RCOoppsozE0PRORcn0kEGGm5BQ5rjLfArDIqcnhruKwOPpjO6lrclOxLuVdAvvHyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723547738; c=relaxed/simple;
	bh=ZwMsd8NTC5/Sf7wF60QxCdkV/D5R6GsFF4w1vQNhams=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZDxdZ8en3Aoqgd18RVmPBLyyGXSeTdGueYO4dqCFbWxGYtM+OnIpn0BC3siBY/btKVxtKMGD0yjtjhp0wNcyedzeqMgFImQnK0NWyCVh3cUqzOvhk5heOr8txtHarEyu7ICNmHtNv4k3Yw/zlQ8OnQgrU4No1n/EsVm5IdsnXSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqWo7O3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqWo7O3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F886C4AF11;
	Tue, 13 Aug 2024 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723547738;
	bh=ZwMsd8NTC5/Sf7wF60QxCdkV/D5R6GsFF4w1vQNhams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqWo7O3RitIbK6NbQN5WgomLLM2GV62HmPuQDdZCfv7lp+WcatXKcZb/IMros4avA
	 VAsJksGS1d9Pz3WmvQxp4/scCju42ZiQQhR8xCZfkiLw0cKQ4HZY6F5+CgPiU6QimU
	 ZQyPn75emyHatmA+Bo955+9B8JrT01lcKWRygIOH9ef6C6TZRe0v9S8bQGYtj0yJUC
	 09pMWGYd8Qj03GnGPzuCSbtSBIHGcg2/FJLwUYsho9ljJ61HqY4Ci7g+4LEtDXXVs5
	 T9fvBhFw12tarjWJN5GHR4MgHXebUPO6oOTiU/8bf/PJaOWjmADXYm09Uty18TgrKn
	 pGH4Nr92X/kKw==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 4/9] nvme: add nvme_auth_derive_tls_psk()
Date: Tue, 13 Aug 2024 13:15:07 +0200
Message-Id: <20240813111512.135634-5-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240813111512.135634-1-hare@kernel.org>
References: <20240813111512.135634-1-hare@kernel.org>
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
 drivers/nvme/common/Kconfig |   1 +
 drivers/nvme/common/auth.c  | 109 ++++++++++++++++++++++++++++++++++++
 include/linux/nvme-auth.h   |   2 +
 3 files changed, 112 insertions(+)

diff --git a/drivers/nvme/common/Kconfig b/drivers/nvme/common/Kconfig
index 244432e0b73d..da963e4f3f1f 100644
--- a/drivers/nvme/common/Kconfig
+++ b/drivers/nvme/common/Kconfig
@@ -12,3 +12,4 @@ config NVME_AUTH
 	select CRYPTO_SHA512
 	select CRYPTO_DH
 	select CRYPTO_DH_RFC7919_GROUPS
+	select CRYPTO_HKDF
diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index d04d966fd19c..b0ee24f90683 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -15,6 +15,8 @@
 #include <linux/nvme.h>
 #include <linux/nvme-auth.h>
 
+#define HKDF_MAX_HASHLEN 64
+
 static u32 nvme_dhchap_seqnum;
 static DEFINE_MUTEX(nvme_dhchap_mutex);
 
@@ -706,5 +708,112 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_digest);
 
+/**
+ * nvme_auth_derive_tls_psk - Derive TLS PSK
+ * @hmac_id: Hash function identifier
+ * @psk: generated input PSK
+ * @psk_len: size of @psk
+ * @psk_digest: TLS PSK digest
+ * @ret_psk: Pointer to the resulting TLS PSK
+ *
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
+ *
+ * Returns 0 on success with a valid psk pointer in @ret_psk or a negative
+ * error number otherwise.
+ */
+int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
+		u8 *psk_digest, u8 **ret_psk)
+{
+	struct crypto_shash *hmac_tfm;
+	const char *hmac_name;
+	const char *psk_prefix = "tls13 nvme-tls-psk";
+	static const char default_salt[HKDF_MAX_HASHLEN];
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
+	if (WARN_ON(prk_len > HKDF_MAX_HASHLEN)) {
+		ret = -EINVAL;
+		goto out_free_prk;
+	}
+	ret = hkdf_extract(hmac_tfm, psk, psk_len,
+			   default_salt, prk_len, prk);
+	if (ret)
+		goto out_free_prk;
+
+	ret = crypto_shash_setkey(hmac_tfm, prk, prk_len);
+	if (ret)
+		goto out_free_prk;
+
+	info_len = strlen(psk_digest) + strlen(psk_prefix) + 5;
+	info = kzalloc(info_len, GFP_KERNEL);
+	if (!info)
+		goto out_free_prk;
+
+	put_unaligned_be16(psk_len, info);
+	memcpy(info + 2, psk_prefix, strlen(psk_prefix));
+	sprintf(info + 2 + strlen(psk_prefix), "%02d %s", hmac_id, psk_digest);
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

