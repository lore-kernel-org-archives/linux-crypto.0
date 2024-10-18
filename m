Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD0715FD13
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 06:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729233241; cv=none; b=pznV+oFgB7DLosPfc5XXPcvxlasKr4tM/kg8P4LolOZwb8ahqLrVYI8B+oTnt8eIbiEZwrnpayXmXN4BjO64jMS7/9DlFl/hMTqI57M7Rm8Ido9Tu3KB67nimK8ZeM/jZFAB9ddnw6jJqf8WRvF8KlK59bh4zEfmOGwLfKz7f0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729233241; c=relaxed/simple;
	bh=NQ/FL8/1bPXTvZi+dECQ5MFtHxFkdmLqMD736guOG64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D+pYXxlQgqkbjUl78//IQoVseyP5ypV4posdZR+gMXuJVzTjUGf2f6hE/izJZ2rw0H+5bRElb6g74SaKcROJHt+btubnX7XCRhJdkYdWbsEIdCiCktqVXLI0P/K+QjDsNh8QMiU/N+odTRsfjDRWsWMSiKJL95JZ5G3M9Fk4FLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loeI2BZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loeI2BZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DA2C4CED1;
	Fri, 18 Oct 2024 06:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729233241;
	bh=NQ/FL8/1bPXTvZi+dECQ5MFtHxFkdmLqMD736guOG64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loeI2BZwSziNcR6DrgTk8FrvEve/RlFfdv2fEnL7GtpEsOxQcSGjoPQa9OAFaYLQY
	 d2r2MJbNlf1P+j7v+1vyiUMgkA4se4lvBg8+ppBgpm4+gxyr30qDZ1S0kyZQY+U67C
	 1fN6n5Q8Lh/RPDJFtkdG4JnkoGtvriASXKtzUAr19s3n8HLLpi3DQF3wWazQ/nfPhM
	 UYNax0lQZIC0jEMi2VdVqfCoXnaJPbuQ6cv4x6ky9fzFpM6ICxMrtfmmt1DD1W+QRR
	 t/V9clfN6cnX2hge4eLlv57tLYylMe6A7fJJx8c1WwcjY0iFz9RelQnsL+a64v1iTf
	 8wJlqN7X+11XA==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 2/9] nvme: add nvme_auth_generate_psk()
Date: Fri, 18 Oct 2024 08:33:36 +0200
Message-Id: <20241018063343.39798-3-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241018063343.39798-1-hare@kernel.org>
References: <20241018063343.39798-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a function to generate a NVMe PSK from the shared credentials
negotiated by DH-HMAC-CHAP.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/common/auth.c | 98 ++++++++++++++++++++++++++++++++++++++
 include/linux/nvme-auth.h  |  3 ++
 2 files changed, 101 insertions(+)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index a3455f1d67fa..32a12899d0ce 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -11,6 +11,7 @@
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/dh.h>
+#include <crypto/hkdf.h>
 #include <linux/nvme.h>
 #include <linux/nvme-auth.h>
 
@@ -471,5 +472,102 @@ int nvme_auth_generate_key(u8 *secret, struct nvme_dhchap_key **ret_key)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
 
+/**
+ * nvme_auth_generate_psk - Generate a PSK for TLS
+ * @hmac_id: Hash function identifier
+ * @skey: Session key
+ * @skey_len: Length of @skey
+ * @c1: Value of challenge C1
+ * @c2: Value of challenge C2
+ * @hash_len: Hash length of the hash algorithm
+ * @ret_psk: Pointer too the resulting generated PSK
+ * @ret_len: length of @ret_psk
+ *
+ * Generate a PSK for TLS as specified in NVMe base specification, section 8.13.5.9:
+ *    Generated PSK for TLS
+ *
+ * The generated PSK for TLS shall be computed applying the HMAC function using the
+ * hash function H( ) selected by the HashID parameter in the DH-HMAC-CHAP_Challenge
+ * message with the session key KS as key to the concatenation of the two challenges
+ * C1 and C2 (i.e., generated PSK = HMAC(KS, C1 || C2)).
+ *
+ * Returns 0 on success with a valid generated PSK pointer in @ret_psk and the length
+ * of @ret_psk in @ret_len, or a negative error number otherwise.
+ */
+int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
+		u8 *c1, u8 *c2, size_t hash_len, u8 **ret_psk,size_t *ret_len)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *shash;
+	u8 *psk;
+	const char *hmac_name;
+	int ret, psk_len;
+
+	if (!c1 || !c2) {
+		pr_warn("%s: invalid parameter\n", __func__);
+		return -EINVAL;
+	}
+
+	hmac_name = nvme_auth_hmac_name(hmac_id);
+	if (!hmac_name) {
+		pr_warn("%s: invalid hash algorithm %d\n",
+			__func__, hmac_id);
+		return -EINVAL;
+	}
+
+	tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	psk_len = crypto_shash_digestsize(tfm);
+	psk = kzalloc(psk_len, GFP_KERNEL);
+	if (!psk) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	shash = kmalloc(sizeof(struct shash_desc) +
+			crypto_shash_descsize(tfm),
+			GFP_KERNEL);
+	if (!shash) {
+		ret = -ENOMEM;
+		goto out_free_psk;
+	}
+
+	shash->tfm = tfm;
+	ret = crypto_shash_setkey(tfm, skey, skey_len);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_init(shash);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_update(shash, c1, hash_len);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_update(shash, c2, hash_len);
+	if (ret)
+		goto out_free_shash;
+
+	ret = crypto_shash_final(shash, psk);
+	if (!ret) {
+		*ret_psk = psk;
+		*ret_len = psk_len;
+	}
+
+out_free_shash:
+	kfree_sensitive(shash);
+out_free_psk:
+	if (ret)
+		kfree_sensitive(psk);
+out_free_tfm:
+	crypto_free_shash(tfm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_generate_psk);
+
 MODULE_DESCRIPTION("NVMe Authentication framework");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index c1d0bc5d9624..b13884b04dfd 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -40,5 +40,8 @@ int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
 int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
 				u8 *ctrl_key, size_t ctrl_key_len,
 				u8 *sess_key, size_t sess_key_len);
+int nvme_auth_generate_psk(u8 hmac_id, u8 *skey, size_t skey_len,
+			   u8 *c1, u8 *c2, size_t hash_len,
+			   u8 **ret_psk, size_t *ret_len);
 
 #endif /* _NVME_AUTH_H */
-- 
2.35.3

