Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549295;
	b=PNXJmX38DoqkyYU0Mhi28Z0IONXPj1g7ppcbS+YI5zkl5ZJFZwMnHwzT0uR5n3b+JDYV
	 xr19wpk1VaepkxEMZEjC3Rg1LJxeVEl/SYP/6yctE79xaH57NFL8tSk+uBbbLUXzK2Hie
	 AdcDlJh0oBRnLP69wnvrB1HT7GcETPkqVjWm9OoA3O92cB4H7fRfRZ4f5/s8afBia945I
	 A8jYI8XJushcAK/04wcOUzuMoVKIWB/eWsHBUhmqty070orbNyhmTlNzzbU3pfgQhQfG6
	 aiZ+1R1PZXOwYMA1Y51jrpkXmgtvUJOaNejviOBPdHIO8ioem785X+Z6AYchjYPCvZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=gVWLM/RnZkFPv4E1B1t6YeMjIey4ol5MvPkRu41zHAM=;
	b=2JJgmbd0oQW5jfck20F0eeMmsj9p3OCDx5TldJo8bCYZueMYJzN9H7x7MzNODeJSwtLY
	 v9uwcO+iK3XZoBB252uUwqDwh8Cp8hBqbYUhafjL6se/5zJ6KDUxeuxOg6P9vuO/AOUiy
	 y+CwZkUEISSMjVFrFMzYuL3o/hjhyiMSl8xw7TFm7ak4PWwlLd8Hmr4757mXWIKOE6ZZb
	 sR0lI5TZtFxL3s7Vyf8odjc2rbmB/EYg9t/c/4JTYfjkunoKzaBVQMv2vItrNGlk/rgen
	 HuB7+SJ00HmtxbDkbc3YzNEzD/3AZwuuOr7beOlaxyPTZJO8W85u4OIdQ21jyU7R1Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dY3fHovn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C280F606A31E;
	Tue, 24 Nov 2026 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dY3fHovn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CEE061F01567;
	Tue, 24 Nov 2026 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795549295;
	bh=gVWLM/RnZkFPv4E1B1t6YeMjIey4ol5MvPkRu41zHAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY3fHovnC50umoBYho19YFSku6Eot4ZNP/2IxSBKsAbRpCPUcNFNSyUTjwZV3v82G
	 DB8Fbdo3OhNWPWoJdyv/qYwCTavAP7qbWQXdz/6t5B2fFpkk0kgqtk+rU0zb07J+Gm
	 zrHQXQeES8h602M8iPnwpszK0yhYwb9uzm+G8Halm/RjzHT1/jvhe2z1MEPSHN2vIZ
	 uIpwFvFY3c00eLMvbf8M+DZ3q4Kv7keySJgtoZhj4gTaoz2M/BbRaZAwkXFRldopvF
	 EiywWJM3UBKcz66jMm7Zm1sVFvCA40yXIajWoPwtEvIGwg6i1CWVq0nJUatGGAcOZW
	 LLRYSvz6OAvuw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v2 9/9] KEYS: trusted: Add asymmetric key support for TPM2
Date: Tue, 24 Nov 2026 21:40:43 +0200
Message-ID: <20261124194043.1651679-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124194043.1651679-1-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the TPM 2.0 trusted key backend to load OID_TPMLoadableKey
(2.23.133.10.1.3) RSA (2048/3072/4096) and ECC (NIST P-256/P-384/P-521)
keys and expose query, sign, verify, and RSA encrypt/decrypt operations
through key_type_trusted.

The feature is enabled with opt-in CONFIG_TRUSTED_KEYS_ASYMMETRIC.

Co-developed-by: James Prestwood <prestwoj@gmail.com>
Signed-off-by: James Prestwood <prestwoj@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 .../security/keys/trusted-encrypted.rst       |    7 +-
 include/keys/trusted-type.h                   |    4 +-
 include/keys/trusted_tpm.h                    |   15 +
 include/linux/tpm_command.h                   |   11 +
 security/keys/trusted-keys/Kconfig            |   10 +
 security/keys/trusted-keys/trusted_tpm1.c     |   26 +
 security/keys/trusted-keys/trusted_tpm2.c     | 1039 ++++++++++++++++-
 7 files changed, 1107 insertions(+), 5 deletions(-)

diff --git a/Documentation/security/keys/trusted-encrypted.rst b/Documentation/security/keys/trusted-encrypted.rst
index c6a507ef228a..30a8c6d1c0c8 100644
--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -589,7 +589,12 @@ available are::
                     represents a symmetric key and must be unsealed before
                     use.
 
-The trusted key code only uses the TPM Sealed Data OID.
+The trusted key code uses TPM Sealed Data for symmetric keys.
+
+When ``CONFIG_TRUSTED_KEYS_ASYMMETRIC`` is enabled, TPM 2.0 backend accepts TPM
+Loadable keys through the ``trusted`` key type. Use the keyctl pkey-operations
+for these keys. For RSA OAEP encryption and decryption, specify ``enc=oaep`` and
+a ``hash=`` matching the key's scheme, if fixed.
 
 emptyAuth is true if the key has well known authorization "".  If it
 is false or not present, the key requires an explicit authorization
diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index 790ffabb0d18..eebc2c33bce7 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -19,7 +19,9 @@
 
 #define MIN_KEY_SIZE			32
 #define MAX_KEY_SIZE			128
-#if IS_ENABLED(CONFIG_TRUSTED_KEYS_PKWM)
+#if IS_ENABLED(CONFIG_TRUSTED_KEYS_TPM)
+#define MAX_BLOB_SIZE			2048
+#elif IS_ENABLED(CONFIG_TRUSTED_KEYS_PKWM)
 #define MAX_BLOB_SIZE			1152
 #else
 #define MAX_BLOB_SIZE                   512
diff --git a/include/keys/trusted_tpm.h b/include/keys/trusted_tpm.h
index b8b1f5c8fbc3..ea968ecc0c3f 100644
--- a/include/keys/trusted_tpm.h
+++ b/include/keys/trusted_tpm.h
@@ -4,6 +4,8 @@
 
 #include <keys/trusted-type.h>
 
+struct kernel_pkey_params;
+struct kernel_pkey_query;
 extern struct trusted_key_ops trusted_key_tpm_ops;
 
 struct trusted_key_tpm {
@@ -18,6 +20,12 @@ struct trusted_key_tpm {
 	u32 policydigest_len;
 	unsigned char policydigest[MAX_DIGEST_SIZE];
 	u32 policyhandle;
+	u32 attrs;
+	u16 alg_type;
+	u16 scheme;
+	u16 scheme_hash;
+	u16 key_bits;
+	u16 coord_size;
 };
 
 int tpm2_seal_trusted(struct tpm_chip *chip,
@@ -26,4 +34,11 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options);
+int tpm2_asym_query(const struct kernel_pkey_params *params,
+		    struct kernel_pkey_query *info);
+int tpm2_asym_eds_op(struct tpm_chip *chip, struct kernel_pkey_params *params,
+		     const void *in, void *out);
+int tpm2_asym_verify_signature(struct tpm_chip *chip,
+			       struct kernel_pkey_params *params,
+			       const void *in, const void *in2);
 #endif
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 6576a7df6d8c..498b82cf3142 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -184,6 +184,7 @@ enum tpm2_structures {
 	TPM2_ST_NO_SESSIONS	= 0x8001,
 	TPM2_ST_SESSIONS	= 0x8002,
 	TPM2_ST_CREATION	= 0x8021,
+	TPM2_ST_HASHCHECK	= 0x8024,
 };
 
 /* Indicates from what layer of the software stack the error comes from */
@@ -218,12 +219,15 @@ enum tpm2_command_codes {
 	TPM2_CC_NV_READ			= 0x014E,
 	TPM2_CC_CREATE			= 0x0153,
 	TPM2_CC_LOAD			= 0x0157,
+	TPM2_CC_RSA_DECRYPT		= 0x0159,
 	TPM2_CC_SEQUENCE_UPDATE		= 0x015C,
+	TPM2_CC_SIGN			= 0x015D,
 	TPM2_CC_UNSEAL			= 0x015E,
 	TPM2_CC_CONTEXT_LOAD		= 0x0161,
 	TPM2_CC_CONTEXT_SAVE		= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT		= 0x0165,
 	TPM2_CC_READ_PUBLIC		= 0x0173,
+	TPM2_CC_RSA_ENCRYPT		= 0x0174,
 	TPM2_CC_START_AUTH_SESS		= 0x0176,
 	TPM2_CC_VERIFY_SIGNATURE	= 0x0177,
 	TPM2_CC_GET_CAPABILITY		= 0x017A,
@@ -278,6 +282,8 @@ enum tpm2_mso_type {
 enum tpm2_curves {
 	TPM2_ECC_NONE		= 0x0000,
 	TPM2_ECC_NIST_P256	= 0x0003,
+	TPM2_ECC_NIST_P384	= 0x0004,
+	TPM2_ECC_NIST_P521	= 0x0005,
 };
 
 enum tpm2_object_attributes {
@@ -457,6 +463,7 @@ struct tpm2_context {
 /* If you add a new hash to this, increment TPM_MAX_HASHES below */
 enum tpm_algorithms {
 	TPM_ALG_ERROR		= 0x0000,
+	TPM_ALG_RSA		= 0x0001,
 	TPM_ALG_SHA1		= 0x0004,
 	TPM_ALG_AES		= 0x0006,
 	TPM_ALG_KEYEDHASH	= 0x0008,
@@ -465,6 +472,10 @@ enum tpm_algorithms {
 	TPM_ALG_SHA512		= 0x000D,
 	TPM_ALG_NULL		= 0x0010,
 	TPM_ALG_SM3_256		= 0x0012,
+	TPM_ALG_RSASSA		= 0x0014,
+	TPM_ALG_RSAES		= 0x0015,
+	TPM_ALG_OAEP		= 0x0017,
+	TPM_ALG_ECDSA		= 0x0018,
 	TPM_ALG_ECC		= 0x0023,
 	TPM_ALG_CFB		= 0x0043,
 };
diff --git a/security/keys/trusted-keys/Kconfig b/security/keys/trusted-keys/Kconfig
index e5a4a53aeab2..48fea7981ab4 100644
--- a/security/keys/trusted-keys/Kconfig
+++ b/security/keys/trusted-keys/Kconfig
@@ -38,6 +38,16 @@ config TRUSTED_KEYS_TPM
 	  The TPM only unseals the keys, if the boot PCRs and other
 	  criteria match.
 
+config TRUSTED_KEYS_ASYMMETRIC
+	bool "Asymmetric TPM 2.0 trusted keys"
+	depends on TRUSTED_KEYS_TPM
+	select KEYCTL_PKEY
+	help
+	  Allow the trusted key type to load TPM 2.0 RSA and ECC keys and
+	  use them through the keyctl public-key operations.
+	  This adds signing, signature verification, and RSA encryption and
+	  decryption without changing support for sealed symmetric keys.
+
 config TRUSTED_KEYS_TEE
 	bool "TEE-based trusted keys"
 	depends on TEE >= TRUSTED_KEYS
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 3b7af11d30c4..4e458473b5dc 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -943,6 +943,9 @@ static int trusted_tpm_unseal(struct trusted_key_payload *p, char *datablob)
 		}
 	}
 
+	if (!p->key_len)
+		p->private = no_free_ptr(private);
+
 	return ret;
 }
 
@@ -951,6 +954,20 @@ static int trusted_tpm_get_random(unsigned char *key, size_t key_len)
 	return tpm_get_random(chip, key, key_len);
 }
 
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+static int trusted_tpm_asym_eds_op(struct kernel_pkey_params *params,
+				   const void *in, void *out)
+{
+	return tpm2_asym_eds_op(chip, params, in, out);
+}
+
+static int trusted_tpm_asym_verify_signature(struct kernel_pkey_params *params,
+					     const void *in, const void *in2)
+{
+	return tpm2_asym_verify_signature(chip, params, in, in2);
+}
+#endif
+
 static int __init init_digests(void)
 {
 	int i;
@@ -976,6 +993,15 @@ static int __init trusted_tpm_init(void)
 	ret = init_digests();
 	if (ret < 0)
 		goto err_put;
+
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+	if (tpm_is_tpm2(chip) > 0) {
+		key_type_trusted.asym_query = tpm2_asym_query;
+		key_type_trusted.asym_eds_op = trusted_tpm_asym_eds_op;
+		key_type_trusted.asym_verify_signature =
+			trusted_tpm_asym_verify_signature;
+	}
+#endif
 	ret = register_key_type(&key_type_trusted);
 	if (ret < 0)
 		goto err_free;
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index e3cd02e19857..0c8ccfd8ec1b 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -4,6 +4,11 @@
  * Copyright (C) 2014 Intel Corporation
  */
 
+#include <crypto/hash_info.h>
+#include <crypto/internal/ecc.h>
+#include <linux/cleanup.h>
+#include <linux/keyctl.h>
+#include <linux/slab.h>
 #include <linux/asn1_encoder.h>
 #include <linux/oid_registry.h>
 #include <linux/string.h>
@@ -124,6 +129,13 @@ static int tpm2_key_decode(const struct trusted_key_payload *payload,
 	if (ctx.has_policy && !private->policyhandle)
 		return -EOPNOTSUPP;
 
+	if (ctx.priv_len < 2 || ctx.pub_len < 2)
+		return -EBADMSG;
+
+	if (get_unaligned_be16(ctx.priv) + 2 != ctx.priv_len ||
+	    get_unaligned_be16(ctx.pub) + 2 != ctx.pub_len)
+		return -EBADMSG;
+
 	if (ctx.priv_len + ctx.pub_len > MAX_BLOB_SIZE)
 		return -EINVAL;
 
@@ -215,7 +227,7 @@ int tpm2_key_type(void *context, size_t hdrlen,
 	struct tpm2_key_context *ctx = context;
 	enum OID oid = look_up_OID(value, vlen);
 
-	if (oid == OID_TPMSealedData) {
+	if (oid == OID_TPMSealedData || oid == OID_TPMLoadableKey) {
 		ctx->oid = oid;
 		return 0;
 	}
@@ -469,6 +481,224 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	return tpm_ret_to_err(rc);
 }
 
+static int tpm2_read_u16(const u8 **p, size_t *rem, u16 *val)
+{
+	if (*rem < sizeof(u16))
+		return -EBADMSG;
+
+	*val = get_unaligned_be16(*p);
+	*p += sizeof(u16);
+	*rem -= sizeof(u16);
+	return 0;
+}
+
+static int tpm2_read_u32(const u8 **p, size_t *rem, u32 *val)
+{
+	if (*rem < sizeof(u32))
+		return -EBADMSG;
+
+	*val = get_unaligned_be32(*p);
+	*p += sizeof(u32);
+	*rem -= sizeof(u32);
+	return 0;
+}
+
+static int tpm2_skip_bytes(const u8 **p, size_t *rem, size_t len)
+{
+	if (*rem < len)
+		return -EBADMSG;
+
+	*p += len;
+	*rem -= len;
+	return 0;
+}
+
+static int tpm2_parse_rsa_public(struct trusted_key_tpm *private,
+				 const u8 *p, size_t rem)
+{
+	u32 exponent;
+	u16 mod_size;
+	int ret;
+
+	switch (private->scheme) {
+	case TPM_ALG_NULL:
+		private->scheme_hash = TPM_ALG_NULL;
+		break;
+	case TPM_ALG_RSASSA:
+		if (!(private->attrs & TPM2_OA_SIGN))
+			return -EBADMSG;
+		ret = tpm2_read_u16(&p, &rem, &private->scheme_hash);
+		if (ret)
+			return ret;
+		break;
+	case TPM_ALG_RSAES:
+		if (!(private->attrs & TPM2_OA_DECRYPT))
+			return -EBADMSG;
+		private->scheme_hash = TPM_ALG_NULL;
+		break;
+	case TPM_ALG_OAEP:
+		if (!(private->attrs & TPM2_OA_DECRYPT))
+			return -EBADMSG;
+		ret = tpm2_read_u16(&p, &rem, &private->scheme_hash);
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = tpm2_read_u16(&p, &rem, &private->key_bits);
+	if (ret)
+		return ret;
+	if (private->key_bits != 2048 &&
+	    private->key_bits != 3072 &&
+	    private->key_bits != 4096)
+		return -EOPNOTSUPP;
+
+	ret = tpm2_read_u32(&p, &rem, &exponent);
+	if (ret)
+		return ret;
+	if (exponent != 0 && exponent != 0x00010001)
+		return -EOPNOTSUPP;
+
+	ret = tpm2_read_u16(&p, &rem, &mod_size);
+	if (ret)
+		return ret;
+	if (mod_size != private->key_bits / 8)
+		return -EBADMSG;
+
+	ret = tpm2_skip_bytes(&p, &rem, mod_size);
+	if (ret)
+		return ret;
+
+	return rem ? -EBADMSG : 0;
+}
+
+static int tpm2_parse_ecc_public(struct trusted_key_tpm *private,
+				 const u8 *p, size_t rem)
+{
+	u16 curve_id, kdf, x_size, y_size;
+	int ret;
+
+	if (!(private->attrs & TPM2_OA_SIGN))
+		return -EINVAL;
+
+	switch (private->scheme) {
+	case TPM_ALG_NULL:
+		private->scheme_hash = TPM_ALG_NULL;
+		break;
+	case TPM_ALG_ECDSA:
+		ret = tpm2_read_u16(&p, &rem, &private->scheme_hash);
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = tpm2_read_u16(&p, &rem, &curve_id);
+	if (ret)
+		return ret;
+
+	switch (curve_id) {
+	case TPM2_ECC_NIST_P256:
+		private->key_bits = 256;
+		private->coord_size = 32;
+		break;
+	case TPM2_ECC_NIST_P384:
+		private->key_bits = 384;
+		private->coord_size = 48;
+		break;
+	case TPM2_ECC_NIST_P521:
+		private->key_bits = 521;
+		private->coord_size = 66;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = tpm2_read_u16(&p, &rem, &kdf);
+	if (ret)
+		return ret;
+	if (kdf != TPM_ALG_NULL)
+		return -EOPNOTSUPP;
+
+	ret = tpm2_read_u16(&p, &rem, &x_size);
+	if (ret)
+		return ret;
+	if (!x_size || x_size > private->coord_size)
+		return -EBADMSG;
+	ret = tpm2_skip_bytes(&p, &rem, x_size);
+	if (ret)
+		return ret;
+
+	ret = tpm2_read_u16(&p, &rem, &y_size);
+	if (ret)
+		return ret;
+	if (!y_size || y_size > private->coord_size)
+		return -EBADMSG;
+	ret = tpm2_skip_bytes(&p, &rem, y_size);
+	if (ret)
+		return ret;
+
+	return rem ? -EBADMSG : 0;
+}
+
+static int tpm2_parse_asym_public(struct trusted_key_tpm *private,
+				  const u8 *pub, unsigned int pub_len)
+{
+	u16 name_alg, policy_len, symmetric;
+	size_t rem = pub_len;
+	const u8 *p = pub;
+	int ret;
+
+	ret = tpm2_read_u16(&p, &rem, &private->alg_type);
+	if (ret)
+		return ret;
+
+	ret = tpm2_read_u16(&p, &rem, &name_alg);
+	if (ret)
+		return ret;
+	if (name_alg == TPM_ALG_ERROR || name_alg == TPM_ALG_NULL)
+		return -EBADMSG;
+
+	ret = tpm2_read_u32(&p, &rem, &private->attrs);
+	if (ret)
+		return ret;
+	if (private->attrs & TPM2_OA_RESTRICTED)
+		return -EINVAL;
+	if (!(private->attrs & (TPM2_OA_SIGN | TPM2_OA_DECRYPT)))
+		return -EINVAL;
+
+	ret = tpm2_read_u16(&p, &rem, &policy_len);
+	if (ret)
+		return ret;
+	if (policy_len && !private->policyhandle)
+		return -EOPNOTSUPP;
+	ret = tpm2_skip_bytes(&p, &rem, policy_len);
+	if (ret)
+		return ret;
+
+	ret = tpm2_read_u16(&p, &rem, &symmetric);
+	if (ret)
+		return ret;
+	if (symmetric != TPM_ALG_NULL)
+		return -EBADMSG;
+
+	ret = tpm2_read_u16(&p, &rem, &private->scheme);
+	if (ret)
+		return ret;
+
+	switch (private->alg_type) {
+	case TPM_ALG_RSA:
+		return tpm2_parse_rsa_public(private, p, rem);
+	case TPM_ALG_ECC:
+		return tpm2_parse_ecc_public(private, p, rem);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int tpm2_load_blob(struct tpm_chip *chip,
 			  struct trusted_key_tpm *private,
 			  const u8 *blob, unsigned int blob_len,
@@ -554,12 +784,13 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	unsigned int private_len;
 	unsigned int public_len;
 	unsigned int blob_len;
+	enum OID oid = OID_TPMSealedData;
 	u32 parent = 0;
 	u8 *blob, *pub;
 	int rc;
 	u32 attrs;
 
-	rc = tpm2_key_decode(payload, private, &parent, &blob, &blob_len, NULL);
+	rc = tpm2_key_decode(payload, private, &parent, &blob, &blob_len, &oid);
 	if (rc) {
 		if (rc != -EBADMSG ||
 		    (payload->blob_len &&
@@ -612,6 +843,17 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
+	if (oid == OID_TPMLoadableKey) {
+		if (!IS_ENABLED(CONFIG_TRUSTED_KEYS_ASYMMETRIC))
+			return -EOPNOTSUPP;
+
+		rc = tpm2_parse_asym_public(private, pub, public_len);
+		if (rc)
+			return rc;
+		payload->migratable = 0;
+		payload->key_len = 0;
+	}
+
 	return tpm2_load_blob(chip, private, blob, blob_len, blob_handle);
 }
 
@@ -670,6 +912,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	u16 data_len;
 	u8 *data;
 	int rc;
+
 	rc = tpm2_start_auth_session(chip);
 	if (rc)
 		return rc;
@@ -739,6 +982,7 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options)
 {
+	struct trusted_key_tpm *private = options->private;
 	u32 blob_handle;
 	int rc;
 
@@ -750,10 +994,799 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 	if (rc)
 		goto out;
 
-	rc = tpm2_unseal_cmd(chip, payload, options, blob_handle);
+	if (!private->alg_type)
+		rc = tpm2_unseal_cmd(chip, payload, options, blob_handle);
 	tpm2_flush_context(chip, blob_handle);
 
 out:
 	tpm_put_ops(chip);
 	return tpm_ret_to_err(rc);
 }
+
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+static int tpm2_asym_load(struct tpm_chip *chip,
+			  const struct trusted_key_payload *payload,
+			  struct trusted_key_tpm *private,
+			  u32 *key_handle)
+{
+	u8 *blob __free(kfree) = NULL;
+	unsigned int blob_len;
+	int rc;
+
+	rc = tpm2_key_decode(payload, private, NULL, &blob, &blob_len, NULL);
+	if (rc)
+		return rc;
+
+	return tpm2_load_blob(chip, private, blob, blob_len, key_handle);
+}
+
+static int tpm2_asym_hash_lookup(const struct trusted_key_tpm *private,
+				 const char *hash_algo,
+				 int *hash_id, int *tpm_hash)
+{
+	int id, alg;
+
+	if (!hash_algo)
+		return -EINVAL;
+
+	id = match_string(hash_algo_name, HASH_ALGO__LAST, hash_algo);
+	if (id < 0)
+		return -ENOPKG;
+
+	alg = tpm2_find_hash_alg(id);
+	if (alg < 0)
+		return -ENOPKG;
+
+	if (private->scheme_hash != TPM_ALG_NULL && alg != private->scheme_hash)
+		return -EINVAL;
+
+	if (hash_id)
+		*hash_id = id;
+	if (tpm_hash)
+		*tpm_hash = alg;
+	return 0;
+}
+
+static int tpm2_asym_sig_scheme(const struct trusted_key_tpm *private,
+				const char *encoding, const char *hash_algo,
+				u16 *scheme, int *hash_id, int *tpm_hash)
+{
+	if (!(private->attrs & TPM2_OA_SIGN))
+		return -EOPNOTSUPP;
+	if (!encoding)
+		return -EINVAL;
+
+	switch (private->alg_type) {
+	case TPM_ALG_RSA:
+		if (strcmp(encoding, "pkcs1") != 0)
+			return -ENOPKG;
+		if (private->scheme != TPM_ALG_NULL &&
+		    private->scheme != TPM_ALG_RSASSA)
+			return -ENOPKG;
+		*scheme = TPM_ALG_RSASSA;
+		break;
+	case TPM_ALG_ECC:
+		if (strcmp(encoding, "x962") != 0)
+			return -ENOPKG;
+		if (private->scheme != TPM_ALG_NULL &&
+		    private->scheme != TPM_ALG_ECDSA)
+			return -ENOPKG;
+		*scheme = TPM_ALG_ECDSA;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return tpm2_asym_hash_lookup(private, hash_algo, hash_id, tpm_hash);
+}
+
+static int tpm2_asym_enc_scheme(const struct trusted_key_tpm *private,
+				const char *encoding, const char *hash_algo,
+				u16 *scheme, u16 *scheme_hash)
+{
+	int tpm_hash, ret;
+
+	if (private->alg_type != TPM_ALG_RSA ||
+	    !(private->attrs & TPM2_OA_DECRYPT))
+		return -EOPNOTSUPP;
+	if (!encoding)
+		return -EINVAL;
+
+	if (strcmp(encoding, "pkcs1") == 0) {
+		if (private->scheme != TPM_ALG_NULL &&
+		    private->scheme != TPM_ALG_RSAES)
+			return -ENOPKG;
+		*scheme = TPM_ALG_RSAES;
+		*scheme_hash = TPM_ALG_NULL;
+		return 0;
+	}
+
+	if (strcmp(encoding, "oaep") == 0) {
+		if (private->scheme != TPM_ALG_NULL &&
+		    private->scheme != TPM_ALG_OAEP)
+			return -ENOPKG;
+		ret = tpm2_asym_hash_lookup(private, hash_algo, NULL,
+					    &tpm_hash);
+		if (ret)
+			return ret;
+		*scheme = TPM_ALG_OAEP;
+		*scheme_hash = tpm_hash;
+		return 0;
+	}
+
+	if (strcmp(encoding, "raw") == 0) {
+		if (hash_algo)
+			return -EINVAL;
+		if (private->scheme != TPM_ALG_NULL)
+			return -ENOPKG;
+		*scheme = TPM_ALG_NULL;
+		*scheme_hash = TPM_ALG_NULL;
+		return 0;
+	}
+
+	return -ENOPKG;
+}
+
+static int tpm2_asym_rsa_encrypt(struct tpm_chip *chip,
+				 const struct trusted_key_payload *payload,
+				 struct trusted_key_tpm *private,
+				 struct kernel_pkey_params *params,
+				 const void *in, void *out)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u16 ciphertext_len, scheme, scheme_hash;
+	u32 key_handle;
+	off_t offset;
+	int rc;
+
+	rc = tpm2_asym_enc_scheme(private, params->encoding, params->hash_algo,
+				  &scheme, &scheme_hash);
+	if (rc)
+		return rc;
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = tpm_try_get_ops(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm2_asym_load(chip, payload, private, &key_handle);
+	if (rc)
+		goto out_ops;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_RSA_ENCRYPT);
+	tpm_buf_append_u32(buf, key_handle);
+	tpm_buf_append_u16(buf, params->in_len);
+	tpm_buf_append(buf, in, params->in_len);
+	tpm_buf_append_u16(buf, scheme);
+	if (scheme == TPM_ALG_OAEP)
+		tpm_buf_append_u16(buf, scheme_hash);
+	tpm_buf_append_u16(buf, 0);
+	if (buf->flags & TPM_BUF_INVALID) {
+		rc = -E2BIG;
+		goto out_key;
+	}
+
+	rc = tpm_transmit_cmd(chip, buf, 2, "TPM2_RSA_Encrypt");
+	if (rc) {
+		rc = tpm_ret_to_err(rc);
+		goto out_key;
+	}
+
+	offset = TPM_HEADER_SIZE;
+	ciphertext_len = tpm_buf_read_u16(buf, &offset);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    offset + ciphertext_len > buf->length) {
+		rc = -EIO;
+		goto out_key;
+	}
+	if (params->out_len < ciphertext_len) {
+		rc = -EMSGSIZE;
+		goto out_key;
+	}
+
+	memcpy(out, &buf->data[offset], ciphertext_len);
+	rc = ciphertext_len;
+
+out_key:
+	tpm2_flush_context(chip, key_handle);
+out_ops:
+	tpm_put_ops(chip);
+	return rc;
+}
+
+static int tpm2_asym_rsa_decrypt(struct tpm_chip *chip,
+				 const struct trusted_key_payload *payload,
+				 struct trusted_key_tpm *private,
+				 struct kernel_pkey_params *params,
+				 const void *in, void *out)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u32 key_handle, param_size;
+	u16 decrypted_len, scheme, scheme_hash;
+	off_t offset;
+	int rc;
+
+	rc = tpm2_asym_enc_scheme(private, params->encoding, params->hash_algo,
+				  &scheme, &scheme_hash);
+	if (rc)
+		return rc;
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = tpm_try_get_ops(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm2_asym_load(chip, payload, private, &key_handle);
+	if (rc)
+		goto out_ops;
+
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out_key;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_RSA_DECRYPT);
+
+	rc = tpm_buf_append_name(chip, buf, key_handle, NULL);
+	if (rc)
+		goto out_key;
+
+	tpm2_buf_append_key_auth(chip, buf, private,
+				 TPM2_SA_DECRYPT | TPM2_SA_ENCRYPT);
+	tpm_buf_append_u16(buf, params->in_len);
+	tpm_buf_append(buf, in, params->in_len);
+	tpm_buf_append_u16(buf, scheme);
+	if (scheme == TPM_ALG_OAEP)
+		tpm_buf_append_u16(buf, scheme_hash);
+	tpm_buf_append_u16(buf, 0);
+	if (buf->flags & TPM_BUF_INVALID) {
+		tpm2_end_auth_session(chip);
+		rc = -E2BIG;
+		goto out_key;
+	}
+
+	rc = tpm_buf_fill_hmac_session(chip, buf);
+	if (rc)
+		goto out_key;
+
+	rc = tpm_transmit_cmd(chip, buf, 6, "TPM2_RSA_Decrypt");
+	rc = tpm_buf_check_hmac_response(chip, buf, rc);
+	if (rc) {
+		rc = tpm_ret_to_err(rc);
+		goto out_key;
+	}
+
+	offset = TPM_HEADER_SIZE;
+	param_size = tpm_buf_read_u32(buf, &offset);
+	decrypted_len = tpm_buf_read_u16(buf, &offset);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    param_size < 2 + decrypted_len ||
+	    param_size > buf->length - (offset - 2)) {
+		rc = -EIO;
+		goto out_key;
+	}
+	if (params->out_len < decrypted_len) {
+		rc = -EMSGSIZE;
+		goto out_key;
+	}
+
+	memcpy(out, &buf->data[offset], decrypted_len);
+	rc = decrypted_len;
+
+out_key:
+	tpm2_flush_context(chip, key_handle);
+out_ops:
+	tpm_put_ops(chip);
+	return rc;
+}
+
+static int tpm2_asym_parse_ecdsa_sig(struct tpm_buf *buf, off_t *offset,
+				     size_t param_end,
+				     struct kernel_pkey_params *params,
+				     void *out)
+{
+	u8 der[2 * (2 + ECC_MAX_BYTES + 1)];
+	u16 r_size, s_size;
+	u8 *encoded, *ptr;
+	const u8 *r, *s;
+
+	r_size = tpm_buf_read_u16(buf, offset);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    !r_size || r_size > ECC_MAX_BYTES ||
+	    *offset + r_size > param_end)
+		return -EIO;
+	r = &buf->data[*offset];
+	*offset += r_size;
+
+	s_size = tpm_buf_read_u16(buf, offset);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    !s_size || s_size > ECC_MAX_BYTES ||
+	    *offset + s_size > param_end)
+		return -EIO;
+	s = &buf->data[*offset];
+	*offset += s_size;
+
+	ptr = der;
+	ptr = asn1_encode_integer_bytes(ptr, der + sizeof(der), r, r_size);
+	ptr = asn1_encode_integer_bytes(ptr, der + sizeof(der), s, s_size);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	encoded = asn1_encode_sequence(out, (u8 *)out + params->out_len,
+				       der, ptr - der);
+	if (IS_ERR(encoded))
+		return PTR_ERR(encoded) == -EINVAL ? -EMSGSIZE : PTR_ERR(encoded);
+
+	return encoded - (u8 *)out;
+}
+
+static int tpm2_asym_parse_signature(struct tpm_buf *buf, u16 scheme,
+				     int tpm_hash,
+				     struct kernel_pkey_params *params,
+				     void *out)
+{
+	off_t offset = TPM_HEADER_SIZE;
+	u16 sig_alg, hash_alg, sig_len;
+	size_t param_end;
+	u32 param_size;
+
+	param_size = tpm_buf_read_u32(buf, &offset);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    param_size < 4 || param_size > buf->length - offset)
+		return -EIO;
+	param_end = offset + param_size;
+
+	sig_alg = tpm_buf_read_u16(buf, &offset);
+	hash_alg = tpm_buf_read_u16(buf, &offset);
+	if ((buf->flags & TPM_BUF_INVALID) ||
+	    sig_alg != scheme || hash_alg != tpm_hash)
+		return -EIO;
+
+	switch (scheme) {
+	case TPM_ALG_RSASSA:
+		sig_len = tpm_buf_read_u16(buf, &offset);
+		if ((buf->flags & TPM_BUF_INVALID) ||
+		    offset + sig_len > param_end)
+			return -EIO;
+		if (sig_len > params->out_len)
+			return -EMSGSIZE;
+		memcpy(out, &buf->data[offset], sig_len);
+		return sig_len;
+	case TPM_ALG_ECDSA:
+		return tpm2_asym_parse_ecdsa_sig(buf, &offset, param_end,
+						 params, out);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int tpm2_asym_sign(struct tpm_chip *chip,
+			  const struct trusted_key_payload *payload,
+			  struct trusted_key_tpm *private,
+			  struct kernel_pkey_params *params,
+			  const void *in, void *out)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	int hash_id, tpm_hash, rc;
+	u32 key_handle;
+	u16 scheme;
+
+	rc = tpm2_asym_sig_scheme(private, params->encoding, params->hash_algo,
+				  &scheme, &hash_id, &tpm_hash);
+	if (rc)
+		return rc;
+	if (params->in_len != hash_digest_size[hash_id])
+		return -EINVAL;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = tpm_try_get_ops(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm2_asym_load(chip, payload, private, &key_handle);
+	if (rc)
+		goto out_ops;
+
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out_key;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_SIGN);
+
+	rc = tpm_buf_append_name(chip, buf, key_handle, NULL);
+	if (rc)
+		goto out_key;
+
+	tpm2_buf_append_key_auth(chip, buf, private, TPM2_SA_DECRYPT);
+
+	/* digest (TPM2B_DIGEST) */
+	tpm_buf_append_u16(buf, params->in_len);
+	tpm_buf_append(buf, in, params->in_len);
+
+	/* inScheme (TPMT_SIG_SCHEME) */
+	tpm_buf_append_u16(buf, scheme);
+	tpm_buf_append_u16(buf, tpm_hash);
+
+	/* validation (TPMT_TK_HASHCHECK): NULL ticket */
+	tpm_buf_append_u16(buf, TPM2_ST_HASHCHECK);
+	tpm_buf_append_u32(buf, TPM2_RH_NULL);
+	tpm_buf_append_u16(buf, 0);
+
+	if (buf->flags & TPM_BUF_INVALID) {
+		tpm2_end_auth_session(chip);
+		rc = -E2BIG;
+		goto out_key;
+	}
+
+	rc = tpm_buf_fill_hmac_session(chip, buf);
+	if (rc)
+		goto out_key;
+
+	rc = tpm_transmit_cmd(chip, buf, 4, "TPM2_Sign");
+	rc = tpm_buf_check_hmac_response(chip, buf, rc);
+	if (rc) {
+		rc = tpm_ret_to_err(rc);
+		goto out_key;
+	}
+
+	rc = tpm2_asym_parse_signature(buf, scheme, tpm_hash, params, out);
+
+out_key:
+	tpm2_flush_context(chip, key_handle);
+out_ops:
+	tpm_put_ops(chip);
+	return rc;
+}
+
+static int tpm2_asym_decode_der_int(const u8 **p, const u8 *end,
+				    u16 max_len, const u8 **out, u16 *out_len)
+{
+	u32 len;
+
+	if (*p >= end || *(*p)++ != ASN1_INT)
+		return -EBADMSG;
+	if (*p >= end)
+		return -EBADMSG;
+
+	len = *(*p)++;
+	if (!len || len >= 0x80 || *p + len > end)
+		return -EBADMSG;
+
+	/* Negative DER INTEGER or non-minimal zero padding */
+	if (**p & 0x80)
+		return -EBADMSG;
+	if (len > 1 && (*p)[0] == 0x00 && !((*p)[1] & 0x80))
+		return -EBADMSG;
+	if (len > 1 && **p == 0x00) {
+		(*p)++;
+		len--;
+	}
+	if (len > max_len)
+		return -EBADMSG;
+
+	*out = *p;
+	*out_len = len;
+	*p += len;
+	return 0;
+}
+
+static int tpm2_asym_decode_ecdsa_sig(const u8 *der, u32 der_len,
+				      u16 coord_size,
+				      const u8 **r, u16 *r_len,
+				      const u8 **s, u16 *s_len)
+{
+	const u8 *end = der + der_len;
+	const u8 *p = der;
+	u32 seq_len;
+	int ret;
+
+	if (p >= end || *p++ != (ASN1_CONS_BIT | ASN1_SEQ))
+		return -EBADMSG;
+	if (p >= end)
+		return -EBADMSG;
+
+	if (*p < 0x80) {
+		seq_len = *p++;
+	} else if (*p == 0x81) {
+		if (++p >= end)
+			return -EBADMSG;
+		seq_len = *p++;
+		if (seq_len < 0x80)
+			return -EBADMSG;
+	} else {
+		return -EBADMSG;
+	}
+
+	if (p + seq_len != end)
+		return -EBADMSG;
+
+	ret = tpm2_asym_decode_der_int(&p, end, coord_size, r, r_len);
+	if (ret)
+		return ret;
+
+	ret = tpm2_asym_decode_der_int(&p, end, coord_size, s, s_len);
+	if (ret)
+		return ret;
+
+	return p == end ? 0 : -EBADMSG;
+}
+
+static unsigned int tpm2_asym_der_len_size(unsigned int len)
+{
+	if (len < 128)
+		return 1;
+	if (len <= 255)
+		return 2;
+	return 3;
+}
+
+static int tpm2_asym_rsa_query(const struct trusted_key_tpm *private,
+			       const struct kernel_pkey_params *params,
+			       struct kernel_pkey_query *info)
+{
+	u16 max_data_size = TPM2_MAX_DIGEST_SIZE;
+	u16 mod_size = private->key_bits / 8;
+	int hash_id, ret;
+
+	if (!params->encoding)
+		return -EINVAL;
+
+	memset(info, 0, sizeof(*info));
+	info->key_size = private->key_bits;
+
+	if (strcmp(params->encoding, "pkcs1") == 0) {
+		if (params->hash_algo) {
+			ret = tpm2_asym_hash_lookup(private, params->hash_algo,
+						    &hash_id, NULL);
+			if (ret)
+				return ret;
+			max_data_size = hash_digest_size[hash_id];
+		}
+
+		if ((private->attrs & TPM2_OA_SIGN) &&
+		    (private->scheme == TPM_ALG_NULL ||
+		     private->scheme == TPM_ALG_RSASSA)) {
+			info->max_data_size = max_data_size;
+			info->max_sig_size = mod_size;
+			info->supported_ops |= KEYCTL_SUPPORTS_SIGN |
+					       KEYCTL_SUPPORTS_VERIFY;
+		}
+		if ((private->attrs & TPM2_OA_DECRYPT) &&
+		    (private->scheme == TPM_ALG_NULL ||
+		     private->scheme == TPM_ALG_RSAES)) {
+			info->max_enc_size = mod_size;
+			info->max_dec_size = mod_size;
+			info->supported_ops |= KEYCTL_SUPPORTS_ENCRYPT |
+					       KEYCTL_SUPPORTS_DECRYPT;
+		}
+		return info->supported_ops ? 0 : -ENOPKG;
+	}
+
+	if (strcmp(params->encoding, "oaep") == 0) {
+		if (!(private->attrs & TPM2_OA_DECRYPT) ||
+		    (private->scheme != TPM_ALG_NULL &&
+		     private->scheme != TPM_ALG_OAEP))
+			return -ENOPKG;
+
+		ret = tpm2_asym_hash_lookup(private, params->hash_algo, NULL, NULL);
+		if (ret)
+			return ret;
+
+		/* keyutils can size the output buffer from either limit. */
+		info->max_enc_size = mod_size;
+		info->max_dec_size = mod_size;
+		info->supported_ops = KEYCTL_SUPPORTS_ENCRYPT |
+				      KEYCTL_SUPPORTS_DECRYPT;
+		return 0;
+	}
+
+	if (strcmp(params->encoding, "raw") == 0) {
+		if (params->hash_algo)
+			return -EINVAL;
+		if (!(private->attrs & TPM2_OA_DECRYPT) ||
+		    private->scheme != TPM_ALG_NULL)
+			return -ENOPKG;
+
+		info->max_data_size = mod_size;
+		info->max_enc_size = mod_size;
+		info->max_dec_size = mod_size;
+		info->supported_ops = KEYCTL_SUPPORTS_ENCRYPT |
+				      KEYCTL_SUPPORTS_DECRYPT;
+		return 0;
+	}
+
+	return -ENOPKG;
+}
+
+static int tpm2_asym_ecc_query(const struct trusted_key_tpm *private,
+			       const struct kernel_pkey_params *params,
+			       struct kernel_pkey_query *info)
+{
+	u16 max_data_size = TPM2_MAX_DIGEST_SIZE;
+	unsigned int int_len, seq_payload;
+	int hash_id, ret;
+
+	if (!params->encoding || strcmp(params->encoding, "x962") != 0)
+		return -ENOPKG;
+
+	if (params->hash_algo) {
+		ret = tpm2_asym_hash_lookup(private, params->hash_algo,
+					    &hash_id, NULL);
+		if (ret)
+			return ret;
+		max_data_size = hash_digest_size[hash_id];
+	}
+
+	int_len = private->coord_size + 1;
+	seq_payload = 2 * (1 + tpm2_asym_der_len_size(int_len) + int_len);
+
+	memset(info, 0, sizeof(*info));
+	info->key_size = private->key_bits;
+	info->max_sig_size = 1 + tpm2_asym_der_len_size(seq_payload) +
+			     seq_payload;
+	info->max_data_size = max_data_size;
+	info->supported_ops = KEYCTL_SUPPORTS_SIGN | KEYCTL_SUPPORTS_VERIFY;
+	return 0;
+}
+
+/**
+ * tpm2_asym_query() - query capabilities of an asymmetric TPM 2.0 trusted key
+ *
+ * @params: public-key operation parameters
+ * @info: returned key capabilities and maximum sizes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int tpm2_asym_query(const struct kernel_pkey_params *params,
+		    struct kernel_pkey_query *info)
+{
+	const struct trusted_key_payload *payload;
+	const struct trusted_key_tpm *private;
+
+	payload = dereference_key_locked(params->key);
+	if (!payload || !payload->private)
+		return -EOPNOTSUPP;
+	private = payload->private;
+
+	switch (private->alg_type) {
+	case TPM_ALG_RSA:
+		return tpm2_asym_rsa_query(private, params, info);
+	case TPM_ALG_ECC:
+		return tpm2_asym_ecc_query(private, params, info);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/**
+ * tpm2_asym_eds_op() - encrypt, decrypt, or sign with an asymmetric TPM 2.0 key
+ *
+ * @chip: TPM chip to use
+ * @params: public-key operation parameters
+ * @in: input plaintext, ciphertext, or digest buffer
+ * @out: output ciphertext, plaintext, or signature buffer
+ *
+ * Return: output byte count on success, negative errno on failure.
+ */
+int tpm2_asym_eds_op(struct tpm_chip *chip, struct kernel_pkey_params *params,
+		     const void *in, void *out)
+{
+	const struct trusted_key_payload *payload;
+	struct trusted_key_tpm *private;
+
+	payload = dereference_key_locked(params->key);
+	if (!payload || !payload->private)
+		return -EOPNOTSUPP;
+	private = payload->private;
+
+	switch (params->op) {
+	case kernel_pkey_encrypt:
+		return tpm2_asym_rsa_encrypt(chip, payload, private,
+					     params, in, out);
+	case kernel_pkey_decrypt:
+		return tpm2_asym_rsa_decrypt(chip, payload, private,
+					     params, in, out);
+	case kernel_pkey_sign:
+		return tpm2_asym_sign(chip, payload, private, params, in, out);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/**
+ * tpm2_asym_verify_signature() - verify a signature with an asymmetric TPM 2.0 key
+ *
+ * @chip: TPM chip to use
+ * @params: public-key operation parameters
+ * @in: digest buffer
+ * @in2: signature buffer
+ *
+ * Return: 0 on valid signature, negative errno on failure.
+ */
+int tpm2_asym_verify_signature(struct tpm_chip *chip,
+			       struct kernel_pkey_params *params,
+			       const void *in, const void *in2)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	const struct trusted_key_payload *payload;
+	struct trusted_key_tpm *private;
+	int hash_id, tpm_hash, rc;
+	u16 scheme, r_len, s_len;
+	const u8 *r, *s;
+	u32 key_handle;
+
+	payload = dereference_key_locked(params->key);
+	if (!payload || !payload->private)
+		return -EOPNOTSUPP;
+	private = payload->private;
+
+	rc = tpm2_asym_sig_scheme(private, params->encoding, params->hash_algo,
+				  &scheme, &hash_id, &tpm_hash);
+	if (rc)
+		return rc;
+	if (params->in_len != hash_digest_size[hash_id])
+		return -EINVAL;
+
+	if (scheme == TPM_ALG_ECDSA) {
+		rc = tpm2_asym_decode_ecdsa_sig(in2, params->in2_len,
+						private->coord_size,
+						&r, &r_len, &s, &s_len);
+		if (rc)
+			return rc;
+	}
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = tpm_try_get_ops(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm2_asym_load(chip, payload, private, &key_handle);
+	if (rc)
+		goto out_ops;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_VERIFY_SIGNATURE);
+	tpm_buf_append_u32(buf, key_handle);
+	tpm_buf_append_u16(buf, params->in_len);
+	tpm_buf_append(buf, in, params->in_len);
+	tpm_buf_append_u16(buf, scheme);
+	tpm_buf_append_u16(buf, tpm_hash);
+
+	if (scheme == TPM_ALG_RSASSA) {
+		tpm_buf_append_u16(buf, params->in2_len);
+		tpm_buf_append(buf, in2, params->in2_len);
+	} else {
+		tpm_buf_append_u16(buf, r_len);
+		tpm_buf_append(buf, r, r_len);
+		tpm_buf_append_u16(buf, s_len);
+		tpm_buf_append(buf, s, s_len);
+	}
+
+	if (buf->flags & TPM_BUF_INVALID) {
+		rc = -E2BIG;
+		goto out_key;
+	}
+
+	rc = tpm_transmit_cmd(chip, buf, 0, "TPM2_VerifySignature");
+	if (rc > 0)
+		rc = -EKEYREJECTED;
+
+out_key:
+	tpm2_flush_context(chip, key_handle);
+out_ops:
+	tpm_put_ops(chip);
+	return rc;
+}
+#endif
-- 
2.47.3

