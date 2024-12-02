Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F0F2040A8
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733149817; cv=none; b=QAZhlEdOmhxBxEdHCIPRnl6durmscL8zpF0Ew3FzBXTTZW6kVpwthZCf84yZ6D9/crTrWb7UHZYaN5P6UBew2mZboTY35peMJthzKN8vxU004LNWIQ4GoDhQRskBzvyWm521eUXC99DvPu+Tl6tNr8dwtmbceFv2yLZ28dymFv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733149817; c=relaxed/simple;
	bh=jwlr/5+5ZVXdbOrphmnRpwYJ3n9luVUs28OrzimGc1k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HXCaQegYyqg7mGeSdKM73qmiGRs7yib3q5zTvnrgGCxs83zm/+fgZGQ7ESLzT+/YRUXLUwnuw+pCxXi/MJNtiAAMFfEc2waW0UWoOWb2u2u1H/JwjhdbX5eYqhqKs9ChptuQzldl4BZfvtNGNUFuxLpl3QXs2fPomKVyhOy+8SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHklCzvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHklCzvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EFEC4CED1;
	Mon,  2 Dec 2024 14:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733149817;
	bh=jwlr/5+5ZVXdbOrphmnRpwYJ3n9luVUs28OrzimGc1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHklCzvT/ex1PTaxdriA5eSXpgrEstnGe1chcNrbwr9/yMXuwuPSWXQ7+bStyKjdQ
	 WB4O//V1tVTL4NKENnnyznSqVr8/CgFot/nd4CmLDlAm6aUPo3Bw28PW4vvB/DMxjB
	 BqGWl7O3XZOw6RHoSoYK0EoZ3dezAO4xHLAdtOho3wyLZJuMYZ7dwvjp323PPMxerd
	 IC77lwZZpAMd1fPsr+xAA8X37lNz7bxNTKqHM0NsTAIReun5zxyUf2cb04bavm+bTg
	 5qgKJLNy6rpfQpaOG4uJiiTJAm3BoBgojKf9In/H7Py9EcXSplj0ddAtenljuWO1YW
	 19YoK3F7rDcFA==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 03/10] nvme: add nvme_auth_generate_digest()
Date: Mon,  2 Dec 2024 15:29:52 +0100
Message-Id: <20241202142959.81321-4-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241202142959.81321-1-hare@kernel.org>
References: <20241202142959.81321-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a function to calculate the PSK digest as specified in TP8018.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/common/auth.c | 139 +++++++++++++++++++++++++++++++++++++
 include/linux/nvme-auth.h  |   2 +
 2 files changed, 141 insertions(+)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 32a12899d0ce..12ce9125693f 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -569,5 +569,144 @@ int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_psk);
 
+/**
+ * nvme_auth_generate_digest - Generate TLS PSK digest
+ * @hmac_id: Hash function identifier
+ * @psk: Generated input PSK
+ * @psk_len: Lenght of @psk
+ * @subsysnqn: NQN of the subsystem
+ * @hostnqn: NQN of the host
+ * @ret_digest: Pointer to the returned digest
+ *
+ * Generate a TLS PSK digest as specified in TP8018 Section 3.6.1.3:
+ *   TLS PSK and PSK identity Derivation
+ *
+ * The PSK digest shall be computed by encoding in Base64 (refer to RFC 4648)
+ * the result of the application of the HMAC function using the hash function
+ * specified in item 4 above (ie the hash function of the cipher suite associated
+ * with the PSK identity) with the PSK as HMAC key to the concatenation of:
+ * - the NQN of the host (i.e., NQNh) not including the null terminator;
+ * - a space character;
+ * - the NQN of the NVM subsystem (i.e., NQNc) not including the null terminator;
+ * - a space character; and
+ * - the seventeen ASCII characters "NVMe-over-Fabrics"
+ * (i.e., <PSK digest> = Base64(HMAC(PSK, NQNh || " " || NQNc || " " || "NVMe-over-Fabrics"))).
+ * The length of the PSK digest depends on the hash function used to compute
+ * it as follows:
+ * - If the SHA-256 hash function is used, the resulting PSK digest is 44 characters long; or
+ * - If the SHA-384 hash function is used, the resulting PSK digest is 64 characters long.
+ *
+ * Returns 0 on success with a valid digest pointer in @ret_digest, or a negative
+ * error number on failure.
+ */
+int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
+		char *subsysnqn, char *hostnqn, u8 **ret_digest)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *shash;
+	u8 *digest, *enc;
+	const char *hmac_name;
+	size_t digest_len, hmac_len;
+	int ret;
+
+	if (WARN_ON(!subsysnqn || !hostnqn))
+		return -EINVAL;
+
+	hmac_name = nvme_auth_hmac_name(hmac_id);
+	if (!hmac_name) {
+		pr_warn("%s: invalid hash algorithm %d\n",
+			__func__, hmac_id);
+		return -EINVAL;
+	}
+
+	switch (nvme_auth_hmac_hash_len(hmac_id)) {
+	case 32:
+		hmac_len = 44;
+		break;
+	case 48:
+		hmac_len = 64;
+		break;
+	default:
+		pr_warn("%s: invalid hash algorithm '%s'\n",
+			__func__, hmac_name);
+		return -EINVAL;
+	}
+
+	enc = kzalloc(hmac_len + 1, GFP_KERNEL);
+	if (!enc)
+		return -ENOMEM;
+
+	tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out_free_enc;
+	}
+
+	digest_len = crypto_shash_digestsize(tfm);
+	digest = kzalloc(digest_len, GFP_KERNEL);
+	if (!digest) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	shash = kmalloc(sizeof(struct shash_desc) +
+			crypto_shash_descsize(tfm),
+			GFP_KERNEL);
+	if (!shash) {
+		ret = -ENOMEM;
+		goto out_free_digest;
+	}
+
+	shash->tfm = tfm;
+	ret = crypto_shash_setkey(tfm, psk, psk_len);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_init(shash);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_update(shash, hostnqn, strlen(hostnqn));
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_update(shash, " ", 1);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_update(shash, subsysnqn, strlen(subsysnqn));
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_update(shash, " NVMe-over-Fabrics", 18);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_final(shash, digest);
+	if (ret)
+		goto out_free_shash;
+
+	ret = base64_encode(digest, digest_len, enc);
+	if (ret < hmac_len)
+		ret = -ENOKEY;
+	else {
+	    *ret_digest = enc;
+	    ret = 0;
+	}
+
+out_free_shash:
+	kfree_sensitive(shash);
+out_free_digest:
+	kfree_sensitive(digest);
+out_free_tfm:
+	crypto_free_shash(tfm);
+out_free_enc:
+	if (ret)
+		kfree_sensitive(enc);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_generate_digest);
+
 MODULE_DESCRIPTION("NVMe Authentication framework");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index b13884b04dfd..998f06bf10fd 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -43,5 +43,7 @@ int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
 int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
 			   u8 *c1, u8 *c2, size_t hash_len,
 			   u8 **ret_psk, size_t *ret_len);
+int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
+		char *subsysnqn, char *hostnqn, u8 **ret_digest);
 
 #endif /* _NVME_AUTH_H */
-- 
2.35.3

