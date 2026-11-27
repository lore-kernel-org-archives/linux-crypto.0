Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759042;
	b=UqaXBRZx500BMceOWaUaii+bVyozLDALUKmv2d4fYZPtk0uwfl7HiRnfjZ7Kx1OI2spa
	 5RWDdGNpeP4xf/hEQqIISPH8kit9SwqxSOO9l7tOCnQzl27DhLXtBCHImE7QiLVeA2B2/
	 LZ0aJ/j0tSaM3ILM45NTWCKz8eR0DmZWx59/ZJr94vZQVThKl2lhxg4svR4vHZniKyBGD
	 RV6TtClC9LTCS6QGSx1h2zab2q3jRRslHarNaurmNPqRBFH7mHAYphStQbh2FCQIVjANW
	 5JoC5Q5lSMsZoxDwRlwxZc9SGYEg77etzqxuG7Kk5EA9sTo8R7usxwQjFtN8St9mBKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r7WTwrhHthjr3rq/6hZd0q3/cL0tDONCidveuo4l1Bc=;
	b=0w8XXayxWwb/cq90Tb0puivzKfY0/ZlTXL9kY0OCnsxAZb4YYeFPbu7dxyMLdkAYUFGb
	 OrasKcy2AyjAQxo800FoS7zGw/AlYA+DnjqoQRxOGCbQCZv27DYFlSCnSPOUiV8JbxNcy
	 bNzJ0IJCkbsseBPSLbLFYZvlV9aomKo4gYZWSL13fHIWzEAxOxYzpRuyu1Ah63waq9Tel
	 Vv1Pgu90oemHg9NxFNKs5JiXprghwjWK5qwqQgJGpR5V5O9VWOQERjayXkRSSTBSFjTYL
	 CMERs7vueFYKcwVr38ErkNI1H1USUMIQtdSahsxOyTFKTys9Q+TGYvMGdJUw+TiBqAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4fqYKGh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4B78F606A31E;
	Fri, 27 Nov 2026 05:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4fqYKGh
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E1CC61F00927;
	Fri, 27 Nov 2026 05:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759041;
	bh=r7WTwrhHthjr3rq/6hZd0q3/cL0tDONCidveuo4l1Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4fqYKGhiDfXnVIEtaVV5a3XF+YSmbPLW2MgT5Pz28QlweEwGaaD6QBeg4iRnyTIJ
	 b3M2yUwl7wObAA757dl5VPvkzvrMAG1x+HBbj4ZeDWyMaDIf/u4FmxyLb08VJN7w8D
	 IjbRN69/pDwEAciELmDDfEc1UMfjUbb3JLCjaBkbrhxCiVmL8z6RrLA9dPWiwzRJmz
	 Yb0MjPyCCN1lc507yRcEAJXjOauhiGl0GgFOC0BzLWfwclBKfvagCPN2TjMiIEIxtx
	 vVGyWxPxaaG0fHOO+p/VLZ8cZvYfYlF0FN/i/UWoynK++/QTBZdJ+ptnscDwSqIrkr
	 u26sC91n/vB1Q==
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
Subject: [PATCH v5 16/17] KEYS: trusted: Add asymmetric key operations
Date: Fri, 27 Nov 2026 07:56:01 +0200
Message-ID: <20261127055602.2357884-17-jarkko@kernel.org>
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

Add optional asymmetric key callbacks (asym_query, asym_eds_op, and
asym_verify_signature) to struct trusted_key_ops and wire them to
key_type_trusted in trusted_core via static calls when a backend
provides them.

Gate the support with CONFIG_TRUSTED_KEYS_ASYMMETRIC, exposed when a
backend selects HAVE_TRUSTED_KEYS_ASYMMETRIC.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/keys/trusted-type.h               | 14 ++++
 security/keys/trusted-keys/Kconfig        | 14 ++++
 security/keys/trusted-keys/trusted_core.c | 83 +++++++++++++++++++++++
 3 files changed, 111 insertions(+)

diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index 790ffabb0d18..ced67057c5be 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -27,6 +27,9 @@
 #define MAX_PCRINFO_SIZE		64
 #define MAX_DIGEST_SIZE			64
 
+struct kernel_pkey_params;
+struct kernel_pkey_query;
+
 struct trusted_key_payload {
 	struct rcu_head rcu;
 	unsigned int key_len;
@@ -62,6 +65,17 @@ struct trusted_key_ops {
 	/* Optional: Get a randomized key. */
 	int (*get_random)(unsigned char *key, size_t key_len);
 
+	/* Optional: Asymmetric key operations. */
+	int (*asym_query)(const struct trusted_key_payload *p,
+			  const struct kernel_pkey_params *params,
+			  struct kernel_pkey_query *info);
+	int (*asym_eds_op)(const struct trusted_key_payload *p,
+			   struct kernel_pkey_params *params,
+			   const void *in, void *out);
+	int (*asym_verify_signature)(const struct trusted_key_payload *p,
+				     struct kernel_pkey_params *params,
+				     const void *in, const void *in2);
+
 	/* Exit key interface. */
 	void (*exit)(void);
 };
diff --git a/security/keys/trusted-keys/Kconfig b/security/keys/trusted-keys/Kconfig
index e5a4a53aeab2..30b49460c3d9 100644
--- a/security/keys/trusted-keys/Kconfig
+++ b/security/keys/trusted-keys/Kconfig
@@ -4,6 +4,20 @@ config HAVE_TRUSTED_KEYS
 config HAVE_TRUSTED_KEYS_DEBUG
 	bool
 
+config HAVE_TRUSTED_KEYS_ASYMMETRIC
+	bool
+
+config TRUSTED_KEYS_ASYMMETRIC
+	bool "Asymmetric trusted keys"
+	depends on HAVE_TRUSTED_KEYS_ASYMMETRIC
+	default y
+	select KEYCTL_PKEY
+	help
+	  Allow trusted key backends that support asymmetric keys to load
+	  public/private key blobs and expose them through the keyctl
+	  public-key operations (query, encrypt, decrypt, sign, and verify)
+	  without changing support for sealed symmetric keys.
+
 config TRUSTED_KEYS_DEBUG
 	bool "Debug trusted keys"
 	depends on HAVE_TRUSTED_KEYS_DEBUG
diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
index 1db6497ba297..fb39f29aa7a5 100644
--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -18,6 +18,7 @@
 #include <linux/hex.h>
 #include <linux/init.h>
 #include <linux/key-type.h>
+#include <linux/keyctl.h>
 #include <linux/module.h>
 #include <linux/parser.h>
 #include <linux/random.h>
@@ -64,6 +65,14 @@ DEFINE_STATIC_CALL_NULL(trusted_key_unseal,
 			*trusted_key_sources[0].ops->unseal);
 DEFINE_STATIC_CALL_NULL(trusted_key_get_random,
 			*trusted_key_sources[0].ops->get_random);
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+DEFINE_STATIC_CALL_NULL(trusted_key_asym_query,
+			*trusted_key_sources[0].ops->asym_query);
+DEFINE_STATIC_CALL_NULL(trusted_key_asym_eds_op,
+			*trusted_key_sources[0].ops->asym_eds_op);
+DEFINE_STATIC_CALL_NULL(trusted_key_asym_verify_signature,
+			*trusted_key_sources[0].ops->asym_verify_signature);
+#endif
 static void (*trusted_key_exit)(void);
 static unsigned char migratable __ro_after_init;
 
@@ -333,6 +342,78 @@ static void trusted_destroy(struct key *key)
 	trusted_payload_free(key->payload.data[0]);
 }
 
+#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
+static int trusted_asym_query(const struct kernel_pkey_params *params,
+			      struct kernel_pkey_query *info)
+{
+	const struct trusted_key_payload *p;
+
+	p = dereference_key_locked(params->key);
+	if (!p || p->key_len || !p->private)
+		return -EOPNOTSUPP;
+
+	return static_call(trusted_key_asym_query)(p, params, info);
+}
+
+static int trusted_asym_eds_op(struct kernel_pkey_params *params,
+			       const void *in, void *out)
+{
+	const struct trusted_key_payload *p;
+
+	p = dereference_key_locked(params->key);
+	if (!p || p->key_len || !p->private)
+		return -EOPNOTSUPP;
+
+	return static_call(trusted_key_asym_eds_op)(p, params, in, out);
+}
+
+static int trusted_asym_verify_signature(struct kernel_pkey_params *params,
+					 const void *in, const void *in2)
+{
+	const struct trusted_key_payload *p;
+
+	p = dereference_key_locked(params->key);
+	if (!p || p->key_len || !p->private)
+		return -EOPNOTSUPP;
+
+	return static_call(trusted_key_asym_verify_signature)(p, params,
+							      in, in2);
+}
+
+static void trusted_asym_init(const struct trusted_key_ops *ops)
+{
+	if (!ops->asym_query || !ops->asym_eds_op ||
+	    !ops->asym_verify_signature)
+		return;
+
+	static_call_update(trusted_key_asym_query, ops->asym_query);
+	static_call_update(trusted_key_asym_eds_op, ops->asym_eds_op);
+	static_call_update(trusted_key_asym_verify_signature,
+			   ops->asym_verify_signature);
+	key_type_trusted.asym_query = trusted_asym_query;
+	key_type_trusted.asym_eds_op = trusted_asym_eds_op;
+	key_type_trusted.asym_verify_signature = trusted_asym_verify_signature;
+}
+
+static void trusted_asym_reset(void)
+{
+	static_call_update(trusted_key_asym_query, NULL);
+	static_call_update(trusted_key_asym_eds_op, NULL);
+	static_call_update(trusted_key_asym_verify_signature, NULL);
+	key_type_trusted.asym_query = NULL;
+	key_type_trusted.asym_eds_op = NULL;
+	key_type_trusted.asym_verify_signature = NULL;
+}
+#else
+static inline void trusted_asym_init(const struct trusted_key_ops *ops)
+{
+}
+
+static inline void trusted_asym_reset(void)
+{
+}
+#endif
+
 struct key_type key_type_trusted = {
 	.name = "trusted",
 	.instantiate = trusted_instantiate,
@@ -384,6 +465,7 @@ static int __init init_trusted(void)
 		static_call_update(trusted_key_seal, trusted_key_sources[i].ops->seal);
 		static_call_update(trusted_key_unseal, trusted_key_sources[i].ops->unseal);
 		static_call_update(trusted_key_get_random, get_random);
+		trusted_asym_init(trusted_key_sources[i].ops);
 		migratable = trusted_key_sources[i].ops->migratable;
 
 		ret = trusted_key_sources[i].ops->init();
@@ -393,6 +475,7 @@ static int __init init_trusted(void)
 			static_call_update(trusted_key_seal, NULL);
 			static_call_update(trusted_key_unseal, NULL);
 			static_call_update(trusted_key_get_random, NULL);
+			trusted_asym_reset();
 			migratable = 0;
 		}
 
-- 
2.47.3

