Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759046;
	b=W7lo5h4ZieIQNYSVz34yZeygnqe5eROhoHFUomwFKQknItrLKSS3KskVwss9D2vEguDU
	 gcRls+GjiVA3A2EWpYAJX4Xe8aXffa3YB+TnXHZ3PP1gYqIgNQ4TlSXpCjGwyqKSc/0l1
	 OqhcJzeGYv5qOfBGnvL4mFLrjNh6iy07mEnU5I9MmvLy4RvZQRpEwjxy+3gi98umejDXv
	 EHNabgKWdWu0smbZLTc4v/9eSH3EW/hLRaRk6UjvnctME01VeAW7qdMNA3JWRQhOJQ5Iu
	 FU5k78gG8Iy79mGqDxBiZLDlDuU8v1CPa9CfKftEd+/Y0w5sXzyXeN8epUwUjLHIGjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Z+AY4l1rWaY5zluuiaHoITja1zM6HzvBlGo7M1XpxYI=;
	b=098Wb3GGJSxQnqctf2MnbJZvANKUTN9hk+K6kGQbNF1Nsy12GWUTeLJu419AAEZJbyzc
	 +bUp5Goq754BjkdTZBE30nc65tFND/p+0EKN9c8u9u2WuII8r8DCz6hr86IER9um7HTc6
	 2G8iWAZgC3FQpjnqCyyG4gxA24e+tRbmDzLQ5eFQXqJk44Jcz9AhCBze6t+gymmBTj25a
	 A5/qXz43Vu187zM/IqgZ0nXsF2L0Vch2+rS6xZH4bY+RZo2qqD9HtxbPLRxlLN+gIf1z1
	 8OUHaiEqyAr4nqac5e+XWBQMBCEVo6WRp6NpLZxzth0jY5+RWoiHN5zOtYEaWi6kM7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iK6nm0R+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3BF9E606A693;
	Fri, 27 Nov 2026 05:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iK6nm0R+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2E6FA1F00939;
	Fri, 27 Nov 2026 05:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759046;
	bh=Z+AY4l1rWaY5zluuiaHoITja1zM6HzvBlGo7M1XpxYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iK6nm0R+BCAMAcES/d+V/FcyW3X9vj9Plh18Bn1Yi2xsNAUF+lc6uMGcIoTfn0YKt
	 DGFNF9yVj8pzqNWcME5LKwzwdS6yj0oedxKtPLTaY7t+E8exLGXZtwoelb50SMkYcN
	 o5AZGfaVDNs5QW5l64OnUL/sM2P0Kx1nKslEaZu3P/mNZipy49hDP+vuZT4x/wCbQM
	 1h61sC1Bc18nXLFFRUhzRAHW2jl2Q18njbC2KxTP8szFl5wxizAvRtmbHWinkJu2gl
	 JrpOaoghilXFK9RuniKcRJoB7WQkILF/E2DfP02V8LbceqI8s34jlAtdFRZ339fHws
	 SWeXAEOYmhh0Q==
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
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan McDowell <noodles@meta.com>,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v5 17/17] KEYS: trusted: Add asymmetric key support for TPM2
Date: Fri, 27 Nov 2026 07:56:02 +0200
Message-ID: <20261127055602.2357884-18-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127055602.2357884-1-jarkko@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
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
keys and wire query, sign, verify, and RSA encrypt/decrypt operations to
trusted_key_tpm_ops.

Select HAVE_TRUSTED_KEYS_ASYMMETRIC when CONFIG_TRUSTED_KEYS_TPM is
enabled.

Co-developed-by: James Prestwood <prestwoj@gmail.com>
Signed-off-by: James Prestwood <prestwoj@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 .../security/keys/trusted-encrypted.rst       |   7 +-
 include/keys/trusted-type.h                   |   4 +-
 include/keys/trusted_tpm.h                    |  17 +
 include/linux/tpm_command.h                   |  11 +
 security/keys/trusted-keys/Kconfig            |   1 +
 security/keys/trusted-keys/trusted_tpm1.c     |  24 +
 security/keys/trusted-keys/trusted_tpm2.c     | 987 +++++++++++++++++-
 7 files changed, 1046 insertions(+), 5 deletions(-)

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
index ced67057c5be..f34c38af1488 100644
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
index b8b1f5c8fbc3..18f3ed6f5ce8 100644
--- a/include/keys/trusted_tpm.h
+++ b/include/keys/trusted_tpm.h
@@ -18,6 +18,12 @@ struct trusted_key_tpm {
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
@@ -26,4 +32,15 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options);
+int tpm2_asym_query(const struct trusted_key_payload *payload,
+		    const struct kernel_pkey_params *params,
+		    struct kernel_pkey_query *info);
+int tpm2_asym_eds_op(struct tpm_chip *chip,
+		     const struct trusted_key_payload *payload,
+		     struct kernel_pkey_params *params,
+		     const void *in, void *out);
+int tpm2_asym_verify_signature(struct tpm_chip *chip,
+			       const struct trusted_key_payload *payload,
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
index 30b49460c3d9..fce92c8c4d0b 100644
--- a/security/keys/trusted-keys/Kconfig
+++ b/security/keys/trusted-keys/Kconfig
@@ -38,6 +38,7 @@ config TRUSTED_KEYS_TPM
 	depends on TCG_TPM >= TRUSTED_KEYS
 	default y
 	select HAVE_TRUSTED_KEYS_DEBUG
+	select HAVE_TRUSTED_KEYS_ASYMMETRIC
 	select CRYPTO_HASH_INFO
 	select CRYPTO_LIB_SHA1
 	select CRYPTO_LIB_UTILS
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 3b7af11d30c4..7ff5110027d0 100644
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
 
@@ -951,6 +954,22 @@ static int trusted_tpm_get_random(unsigned char *key, size_t key_len)
 	return tpm_get_random(chip, key, key_len);
 }
 
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+static int trusted_tpm_asym_eds_op(const struct trusted_key_payload *p,
+				   struct kernel_pkey_params *params,
+				   const void *in, void *out)
+{
+	return tpm2_asym_eds_op(chip, p, params, in, out);
+}
+
+static int trusted_tpm_asym_verify_signature(const struct trusted_key_payload *p,
+					     struct kernel_pkey_params *params,
+					     const void *in, const void *in2)
+{
+	return tpm2_asym_verify_signature(chip, p, params, in, in2);
+}
+#endif
+
 static int __init init_digests(void)
 {
 	int i;
@@ -1002,5 +1021,10 @@ struct trusted_key_ops trusted_key_tpm_ops = {
 	.seal = trusted_tpm_seal,
 	.unseal = trusted_tpm_unseal,
 	.get_random = trusted_tpm_get_random,
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+	.asym_query = tpm2_asym_query,
+	.asym_eds_op = trusted_tpm_asym_eds_op,
+	.asym_verify_signature = trusted_tpm_asym_verify_signature,
+#endif
 	.exit = trusted_tpm_exit,
 };
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 467e8570b106..dee7fb4e99a8 100644
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
@@ -448,6 +460,177 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	return tpm_ret_to_err(rc);
 }
 
+static int tpm2_asym_parse_rsa_public(struct trusted_key_tpm *private,
+				      struct tpm_buf *buf, off_t *offset)
+{
+	u32 exponent;
+	u16 mod_size;
+
+	switch (private->scheme) {
+	case TPM_ALG_NULL:
+		private->scheme_hash = TPM_ALG_NULL;
+		break;
+	case TPM_ALG_RSASSA:
+		if (!(private->attrs & TPM2_OA_SIGN))
+			return -EBADMSG;
+		if (!tpm_buf_read_u16(buf, offset, &private->scheme_hash))
+			return -EBADMSG;
+		break;
+	case TPM_ALG_RSAES:
+		if (!(private->attrs & TPM2_OA_DECRYPT))
+			return -EBADMSG;
+		private->scheme_hash = TPM_ALG_NULL;
+		break;
+	case TPM_ALG_OAEP:
+		if (!(private->attrs & TPM2_OA_DECRYPT))
+			return -EBADMSG;
+		if (!tpm_buf_read_u16(buf, offset, &private->scheme_hash))
+			return -EBADMSG;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!tpm_buf_read_u16(buf, offset, &private->key_bits))
+		return -EBADMSG;
+	if (private->key_bits != 2048 &&
+	    private->key_bits != 3072 &&
+	    private->key_bits != 4096)
+		return -EOPNOTSUPP;
+
+	if (!tpm_buf_read_u32(buf, offset, &exponent))
+		return -EBADMSG;
+	if (exponent != 0 && exponent != 0x00010001)
+		return -EOPNOTSUPP;
+
+	if (!tpm_buf_read_u16(buf, offset, &mod_size))
+		return -EBADMSG;
+	if (mod_size != private->key_bits / 8)
+		return -EBADMSG;
+	if (mod_size > tpm_buf_length(buf) - *offset)
+		return -EBADMSG;
+	*offset += mod_size;
+
+	return *offset == tpm_buf_length(buf) ? 0 : -EBADMSG;
+}
+
+static int tpm2_asym_parse_ecc_public(struct trusted_key_tpm *private,
+				      struct tpm_buf *buf, off_t *offset)
+{
+	u16 curve_id, kdf, x_size, y_size;
+
+	if (!(private->attrs & TPM2_OA_SIGN))
+		return -EINVAL;
+
+	switch (private->scheme) {
+	case TPM_ALG_NULL:
+		private->scheme_hash = TPM_ALG_NULL;
+		break;
+	case TPM_ALG_ECDSA:
+		if (!tpm_buf_read_u16(buf, offset, &private->scheme_hash))
+			return -EBADMSG;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!tpm_buf_read_u16(buf, offset, &curve_id))
+		return -EBADMSG;
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
+	if (!tpm_buf_read_u16(buf, offset, &kdf))
+		return -EBADMSG;
+	if (kdf != TPM_ALG_NULL)
+		return -EOPNOTSUPP;
+
+	if (!tpm_buf_read_u16(buf, offset, &x_size))
+		return -EBADMSG;
+	if (!x_size || x_size > private->coord_size ||
+	    x_size > tpm_buf_length(buf) - *offset)
+		return -EBADMSG;
+	*offset += x_size;
+
+	if (!tpm_buf_read_u16(buf, offset, &y_size))
+		return -EBADMSG;
+	if (!y_size || y_size > private->coord_size ||
+	    y_size > tpm_buf_length(buf) - *offset)
+		return -EBADMSG;
+	*offset += y_size;
+
+	return *offset == tpm_buf_length(buf) ? 0 : -EBADMSG;
+}
+
+static int tpm2_asym_parse_public(struct trusted_key_tpm *private,
+				  const u8 *pub, unsigned int pub_len)
+{
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u16 name_alg, policy_len, symmetric;
+	off_t offset = 2;
+
+	buf = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	tpm_buf_init_sized(buf, TPM_BUFSIZE);
+	tpm_buf_append(buf, pub, pub_len);
+	if (buf->flags & TPM_BUF_INVALID)
+		return -EBADMSG;
+
+	if (!tpm_buf_read_u16(buf, &offset, &private->alg_type) ||
+	    !tpm_buf_read_u16(buf, &offset, &name_alg))
+		return -EBADMSG;
+	if (name_alg == TPM_ALG_ERROR || name_alg == TPM_ALG_NULL)
+		return -EBADMSG;
+
+	if (!tpm_buf_read_u32(buf, &offset, &private->attrs))
+		return -EBADMSG;
+	if (private->attrs & TPM2_OA_RESTRICTED)
+		return -EINVAL;
+	if (!(private->attrs & (TPM2_OA_SIGN | TPM2_OA_DECRYPT)))
+		return -EINVAL;
+
+	if (!tpm_buf_read_u16(buf, &offset, &policy_len))
+		return -EBADMSG;
+	if (policy_len && !private->policyhandle)
+		return -EOPNOTSUPP;
+	if (policy_len > tpm_buf_length(buf) - offset)
+		return -EBADMSG;
+	offset += policy_len;
+
+	if (!tpm_buf_read_u16(buf, &offset, &symmetric))
+		return -EBADMSG;
+	if (symmetric != TPM_ALG_NULL)
+		return -EBADMSG;
+
+	if (!tpm_buf_read_u16(buf, &offset, &private->scheme))
+		return -EBADMSG;
+
+	switch (private->alg_type) {
+	case TPM_ALG_RSA:
+		return tpm2_asym_parse_rsa_public(private, buf, &offset);
+	case TPM_ALG_ECC:
+		return tpm2_asym_parse_ecc_public(private, buf, &offset);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int tpm2_load_blob(struct tpm_chip *chip,
 			  struct trusted_key_tpm *private,
 			  const u8 *blob, unsigned int blob_len,
@@ -534,12 +717,13 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
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
@@ -592,6 +776,17 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 	if (blob_len > payload->blob_len)
 		return -E2BIG;
 
+	if (oid == OID_TPMLoadableKey) {
+		if (!IS_ENABLED(CONFIG_TRUSTED_KEYS_ASYMMETRIC))
+			return -EOPNOTSUPP;
+
+		rc = tpm2_asym_parse_public(private, pub, public_len);
+		if (rc)
+			return rc;
+		payload->migratable = 0;
+		payload->key_len = 0;
+	}
+
 	return tpm2_load_blob(chip, private, blob, blob_len, blob_handle);
 }
 
@@ -725,6 +920,7 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 			struct trusted_key_payload *payload,
 			struct trusted_key_options *options)
 {
+	struct trusted_key_tpm *private = options->private;
 	u32 blob_handle;
 	int rc;
 
@@ -736,10 +932,795 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
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
+	if (!tpm_buf_read_u16(buf, &offset, &ciphertext_len) ||
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
+	u8 key_name[TPM2_MAX_NAME_SIZE];
+	struct tpm_buf *buf __free(kfree) = NULL;
+	u16 decrypted_len, key_name_size, scheme, scheme_hash;
+	u32 key_handle, param_size;
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
+	rc = tpm2_read_public(chip, key_handle, key_name);
+	if (rc < 0)
+		goto out_key;
+	key_name_size = rc;
+
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out_key;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_RSA_DECRYPT);
+
+	rc = tpm_buf_append_name(chip, buf, key_handle, key_name,
+				 key_name_size);
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
+	if (!tpm_buf_read_u32(buf, &offset, &param_size) ||
+	    !tpm_buf_read_u16(buf, &offset, &decrypted_len) ||
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
+	if (!tpm_buf_read_u16(buf, offset, &r_size) ||
+	    !r_size || r_size > ECC_MAX_BYTES ||
+	    *offset + r_size > param_end)
+		return -EIO;
+	r = &buf->data[*offset];
+	*offset += r_size;
+
+	if (!tpm_buf_read_u16(buf, offset, &s_size) ||
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
+	if (!tpm_buf_read_u32(buf, &offset, &param_size) ||
+	    param_size < 4 || param_size > buf->length - offset)
+		return -EIO;
+	param_end = offset + param_size;
+
+	if (!tpm_buf_read_u16(buf, &offset, &sig_alg) ||
+	    !tpm_buf_read_u16(buf, &offset, &hash_alg) ||
+	    sig_alg != scheme || hash_alg != tpm_hash)
+		return -EIO;
+
+	switch (scheme) {
+	case TPM_ALG_RSASSA:
+		if (!tpm_buf_read_u16(buf, &offset, &sig_len) ||
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
+	u8 key_name[TPM2_MAX_NAME_SIZE];
+	struct tpm_buf *buf __free(kfree) = NULL;
+	int hash_id, tpm_hash, rc;
+	u16 key_name_size, scheme;
+	u32 key_handle;
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
+	rc = tpm2_read_public(chip, key_handle, key_name);
+	if (rc < 0)
+		goto out_key;
+	key_name_size = rc;
+
+	rc = tpm2_start_auth_session(chip);
+	if (rc)
+		goto out_key;
+
+	tpm_buf_init(buf, TPM_BUFSIZE);
+	tpm_buf_reset(buf, TPM2_ST_SESSIONS, TPM2_CC_SIGN);
+
+	rc = tpm_buf_append_name(chip, buf, key_handle, key_name,
+				 key_name_size);
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
+ * @payload: trusted key payload
+ * @params: public-key operation parameters
+ * @info: returned key capabilities and maximum sizes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int tpm2_asym_query(const struct trusted_key_payload *payload,
+		    const struct kernel_pkey_params *params,
+		    struct kernel_pkey_query *info)
+{
+	const struct trusted_key_tpm *private = payload->private;
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
+ * @payload: trusted key payload
+ * @params: public-key operation parameters
+ * @in: input plaintext, ciphertext, or digest buffer
+ * @out: output ciphertext, plaintext, or signature buffer
+ *
+ * Return: output byte count on success, negative errno on failure.
+ */
+int tpm2_asym_eds_op(struct tpm_chip *chip,
+		     const struct trusted_key_payload *payload,
+		     struct kernel_pkey_params *params,
+		     const void *in, void *out)
+{
+	struct trusted_key_tpm *private = payload->private;
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
+ * @payload: trusted key payload
+ * @params: public-key operation parameters
+ * @in: digest buffer
+ * @in2: signature buffer
+ *
+ * Return: 0 on valid signature, negative errno on failure.
+ */
+int tpm2_asym_verify_signature(struct tpm_chip *chip,
+			       const struct trusted_key_payload *payload,
+			       struct kernel_pkey_params *params,
+			       const void *in, const void *in2)
+{
+	struct trusted_key_tpm *private = payload->private;
+	struct tpm_buf *buf __free(kfree) = NULL;
+	int hash_id, tpm_hash, rc;
+	u16 scheme, r_len, s_len;
+	const u8 *r, *s;
+	u32 key_handle;
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

