Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE0127E1C5;
	Mon,  2 Mar 2026 08:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438483; cv=none; b=PEvHpxSItO5YI0PmDpAA1S6/84R8oNoSvASxxWqMHoptpAYzzqFPxsGApVVrfSgVf+ggZiBP4H+K/sWo2Un0oFpxbdr3+T12OA6wYLyOCH8E6atfLS2sRmBVFhczhmZp2Xa1rN4/C/DqxjLfmzKZfBlv1b76VRk2dU8WDRrJfak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438483; c=relaxed/simple;
	bh=p8hTu5lh1brxdlnuDkCq/z1L+KEcC7XSNRJkdDk6Oyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejb/kXNWr8LCtfPcTY5ZXnKFH4R5DHP0dTgGwxnJEDJQW68+ooPkm2N9bl0vcD/1VauuBu53ULG2TRm/0f1vOp486v/Ul59HBZJmetLaYSiJsHIksMfyBMY8ghdLGLt/RhZ7MR1X2579ENKCaMLWshRqUGFjbCGw1Xn6kB7eVeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndwDmeE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndwDmeE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67980C4AF0B;
	Mon,  2 Mar 2026 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438482;
	bh=p8hTu5lh1brxdlnuDkCq/z1L+KEcC7XSNRJkdDk6Oyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndwDmeE2vhZtieBRvsfdLWHDojA3vfIFgjDqA5B23FhHGJ1aWNtyTMCSXVRjveTFy
	 atrqAgz9j2cnB+YzwHJQJHDuq7jvUJbBayHs8kNiuz7MYLhbrzgzFNHrLzmRisCWcv
	 UV02iZESgmd5eBoIFXosMyF9+bdSSrx33001SRmhp5KmlD9JerrR05g++cppr3bY6+
	 XRKk3Qxrqr5DQ/u3lG8GPDU8e3zkL0h/3yJfe+GIsxd4opPGboeFCuAVIl/nebv2PM
	 fWKXXT6/ZQU1HeLT94ICTRKIMwJ7c+gUKchFSvds1OQxHJlW6GRieJTD9ZT/KpSwES
	 kXBDwvTZzN+DA==
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
Subject: [PATCH 07/21] nvme-auth: common: add HMAC helper functions
Date: Sun,  1 Mar 2026 23:59:45 -0800
Message-ID: <20260302075959.338638-8-ebiggers@kernel.org>
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

Add some helper functions for computing HMAC-SHA256, HMAC-SHA384, or
HMAC-SHA512 values using the crypto library instead of crypto_shash.
These will enable some significant simplifications and performance
improvements in nvme-auth.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/Kconfig |  2 ++
 drivers/nvme/common/auth.c  | 66 +++++++++++++++++++++++++++++++++++++
 include/linux/nvme-auth.h   | 14 ++++++++
 3 files changed, 82 insertions(+)

diff --git a/drivers/nvme/common/Kconfig b/drivers/nvme/common/Kconfig
index d19988c13af5f..1ec507d1f9b5f 100644
--- a/drivers/nvme/common/Kconfig
+++ b/drivers/nvme/common/Kconfig
@@ -11,10 +11,12 @@ config NVME_AUTH
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_DH
 	select CRYPTO_DH_RFC7919_GROUPS
 	select CRYPTO_HKDF
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 
 config NVME_AUTH_KUNIT_TEST
 	tristate "KUnit tests for NVMe authentication" if !KUNIT_ALL_TESTS
 	depends on KUNIT && NVME_AUTH
 	default KUNIT_ALL_TESTS
diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 9e33fc02cf51a..00f21176181f6 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -10,10 +10,11 @@
 #include <linux/scatterlist.h>
 #include <linux/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/dh.h>
 #include <crypto/hkdf.h>
+#include <crypto/sha2.h>
 #include <linux/nvme.h>
 #include <linux/nvme-auth.h>
 
 static u32 nvme_dhchap_seqnum;
 static DEFINE_MUTEX(nvme_dhchap_mutex);
@@ -232,10 +233,75 @@ void nvme_auth_free_key(struct nvme_dhchap_key *key)
 		return;
 	kfree_sensitive(key);
 }
 EXPORT_SYMBOL_GPL(nvme_auth_free_key);
 
+/*
+ * Start computing an HMAC value, given the algorithm ID and raw key.
+ *
+ * The context should be zeroized at the end of its lifetime.  The caller can do
+ * that implicitly by calling nvme_auth_hmac_final(), or explicitly (needed when
+ * a context is abandoned without finalizing it) by calling memzero_explicit().
+ */
+int nvme_auth_hmac_init(struct nvme_auth_hmac_ctx *hmac, u8 hmac_id,
+			const u8 *key, size_t key_len)
+{
+	hmac->hmac_id = hmac_id;
+	switch (hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		hmac_sha256_init_usingrawkey(&hmac->sha256, key, key_len);
+		return 0;
+	case NVME_AUTH_HASH_SHA384:
+		hmac_sha384_init_usingrawkey(&hmac->sha384, key, key_len);
+		return 0;
+	case NVME_AUTH_HASH_SHA512:
+		hmac_sha512_init_usingrawkey(&hmac->sha512, key, key_len);
+		return 0;
+	}
+	pr_warn("%s: invalid hash algorithm %d\n", __func__, hmac_id);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_init);
+
+void nvme_auth_hmac_update(struct nvme_auth_hmac_ctx *hmac, const u8 *data,
+			   size_t data_len)
+{
+	switch (hmac->hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		hmac_sha256_update(&hmac->sha256, data, data_len);
+		return;
+	case NVME_AUTH_HASH_SHA384:
+		hmac_sha384_update(&hmac->sha384, data, data_len);
+		return;
+	case NVME_AUTH_HASH_SHA512:
+		hmac_sha512_update(&hmac->sha512, data, data_len);
+		return;
+	}
+	/* Unreachable because nvme_auth_hmac_init() validated hmac_id */
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_update);
+
+/* Finish computing an HMAC value.  Note that this zeroizes the HMAC context. */
+void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out)
+{
+	switch (hmac->hmac_id) {
+	case NVME_AUTH_HASH_SHA256:
+		hmac_sha256_final(&hmac->sha256, out);
+		return;
+	case NVME_AUTH_HASH_SHA384:
+		hmac_sha384_final(&hmac->sha384, out);
+		return;
+	case NVME_AUTH_HASH_SHA512:
+		hmac_sha512_final(&hmac->sha512, out);
+		return;
+	}
+	/* Unreachable because nvme_auth_hmac_init() validated hmac_id */
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_final);
+
 struct nvme_dhchap_key *nvme_auth_transform_key(
 		const struct nvme_dhchap_key *key, const char *nqn)
 {
 	const char *hmac_name;
 	struct crypto_shash *key_tfm;
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index 02ca9a7162565..940d0703eb1df 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -5,10 +5,11 @@
 
 #ifndef _NVME_AUTH_H
 #define _NVME_AUTH_H
 
 #include <crypto/kpp.h>
+#include <crypto/sha2.h>
 
 struct nvme_dhchap_key {
 	size_t len;
 	u8 hash;
 	u8 key[];
@@ -21,10 +22,23 @@ u8 nvme_auth_dhgroup_id(const char *dhgroup_name);
 
 const char *nvme_auth_hmac_name(u8 hmac_id);
 const char *nvme_auth_digest_name(u8 hmac_id);
 size_t nvme_auth_hmac_hash_len(u8 hmac_id);
 u8 nvme_auth_hmac_id(const char *hmac_name);
+struct nvme_auth_hmac_ctx {
+	u8 hmac_id;
+	union {
+		struct hmac_sha256_ctx sha256;
+		struct hmac_sha384_ctx sha384;
+		struct hmac_sha512_ctx sha512;
+	};
+};
+int nvme_auth_hmac_init(struct nvme_auth_hmac_ctx *hmac, u8 hmac_id,
+			const u8 *key, size_t key_len);
+void nvme_auth_hmac_update(struct nvme_auth_hmac_ctx *hmac, const u8 *data,
+			   size_t data_len);
+void nvme_auth_hmac_final(struct nvme_auth_hmac_ctx *hmac, u8 *out);
 
 u32 nvme_auth_key_struct_size(u32 key_len);
 struct nvme_dhchap_key *nvme_auth_extract_key(const char *secret, u8 key_hash);
 void nvme_auth_free_key(struct nvme_dhchap_key *key);
 struct nvme_dhchap_key *nvme_auth_alloc_key(u32 len, u8 hash);
-- 
2.53.0

