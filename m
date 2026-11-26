Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726248;
	b=N0p2V5yK/f2A7+QTZNvdLmB95tVu7K3k6N3a80guY0sBuWbEqbIb/o7aOYR/GlEKLV8j
	 Xvky5KRL/lnEkk+yAzrjoATc7x11yRIHpuSANEMNhcN7y+aSDUSaVl9ECVKv1ay3QT9bj
	 ILxfMkCGL4L0TRj6el63b9JTBQGdlAXnKj3RSIwHIhD3C16UkoeXrMilX3DpxLuv9OpTe
	 iycycYvGFASKRykpoK5CP5btIPJ5FyKjJoNhh28+1iqw8akBoTJLxM18H4CdlDN67/xRu
	 j6K+HVsVWpPRlZawVVpaas1QdvximM5tK+NZCRy2nRpYhnY3QoebhXXksaJ3en6f8jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QUS127OQPTmIdakw/CoBN9+3F8uXf7GAgSpHTspKrTs=;
	b=fW0mu6kYpY8zYZAnHw9tLoyHkvEOdqp0TYzIFlrB9XWZIBkRpaYwmjhQC4bEHl7+PutA
	 Ba7+Eo8MVNrt9WQJBnhblL7durqBSMH15KXEb4yRbd4PIU6CM7atgWcUwJoOWK2eYEbRQ
	 wxcFfIiHFQwjT3ckIxPp3MXwtJIpNPiAwgODAB+DjW4Yk0w8Izl51n8hsPRSpHkKEIPQQ
	 y5N5RLrbUacoS8IcdkqOjvSIQrn0ZcCVGrXqatowEHNlGoIBKeJehitAZS8qB7DjlAI1e
	 U8kxtMYHnyHn7jbkHsXD3NNV07Gm3cA4WP+GVGpGQqbGCELFtu2JDkRcYaeiRdhpV+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRTldiYl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CD5BD606A32C;
	Thu, 26 Nov 2026 20:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRTldiYl
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B41551F00899;
	Thu, 26 Nov 2026 20:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726248;
	bh=QUS127OQPTmIdakw/CoBN9+3F8uXf7GAgSpHTspKrTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRTldiYlFE3cOeg2Yq4u136mRZnSYPMOe7x0ul8mcISPa7hXRPg9h+tWut3smfIOe
	 865G9ts0CvGxQZ0+TJCVZ59q/k14eCf5vL6NK9krsMmAzE1LFGr4NEMVM4zckRpLk2
	 dFhubEZIapqrH2IQp4rrWILLxeQ2Q61gck30RHY8P3g7WiFy/0XxipV2Rko6aBEBaI
	 T9QyfD/SB1juJ7m6NYvbH2daMyCtqfC+JgLMpNGwlKytTy7KXP5bBC8fiU0D6RvHgL
	 Kv8Fky/jVTXXZ345vnegcE4VpEVI6Ry2qmGKP+sxS19VfGt5uWORKc8szoxcXQXE71
	 XRVd6OzZNoAgA==
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
Subject: [PATCH v4 01/11] KEYS: Factor out KEYCTL_PKEY
Date: Thu, 26 Nov 2026 22:50:11 +0200
Message-ID: <20261126205021.2200819-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126205021.2200819-1-jarkko@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
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

Factor out CONFIG_KEYCTL_PKEY from CONFIG_ASYMMETRIC_KEY_TYPE as a hidden
helper symbol and make keyctl public-key support a per-subsystem choice:

- Add off-by-default CONFIG_ASYMMETRIC_KEY_PKEY to gate keyctl public-key
  operations on software asymmetric keys so systems that only need
  CONFIG_ASYMMETRIC_KEY_TYPE for in-kernel signature verification do not
  expose KEYCTL_PKEY_* operations.
- Switch TURRIS_SIGNING_KEY, TURRIS_OMNIA_MCU_KEYCTL, and
  TURRIS_MOX_RWTM_KEYCTL from CONFIG_ASYMMETRIC_KEY_TYPE to
  CONFIG_KEYCTL_PKEY while keeping them enabled by default.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 crypto/asymmetric_keys/Kconfig           | 11 +++++++++++
 crypto/asymmetric_keys/asymmetric_keys.h |  2 ++
 crypto/asymmetric_keys/asymmetric_type.c |  4 ++++
 drivers/firmware/Kconfig                 |  1 -
 drivers/platform/cznic/Kconfig           |  3 +--
 security/keys/Kconfig                    |  3 +++
 security/keys/Makefile                   |  2 +-
 security/keys/internal.h                 |  2 +-
 security/keys/keyctl.c                   |  2 +-
 9 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index c73979b2e98e..a1fa64a38f24 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -10,6 +10,17 @@ menuconfig ASYMMETRIC_KEY_TYPE
 
 if ASYMMETRIC_KEY_TYPE
 
+config ASYMMETRIC_KEY_PKEY
+	bool "Asymmetric key keyctl public-key operations"
+	select KEYCTL_PKEY
+	help
+	  This option exposes keyctl public-key operations (query, encrypt,
+	  decrypt, sign, and verify) on asymmetric keys to userspace.
+	  In-kernel signature verification (such as module and kexec
+	  verification) does not require this option.
+
+	  If you are unsure as to whether this is required, answer N.
+
 config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	tristate "Asymmetric public-key crypto algorithm subtype"
 	select MPILIB
diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
index dc854cb737fb..7b669f41f297 100644
--- a/crypto/asymmetric_keys/asymmetric_keys.h
+++ b/crypto/asymmetric_keys/asymmetric_keys.h
@@ -13,5 +13,7 @@ extern int __asymmetric_key_hex_to_key_id(const char *id,
 					  struct asymmetric_key_id *match_id,
 					  size_t hexlen);
 
+#ifdef CONFIG_ASYMMETRIC_KEY_PKEY
 extern int asymmetric_key_eds_op(struct kernel_pkey_params *params,
 				 const void *in, void *out);
+#endif
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 16a7ae16593c..8b8a75b70527 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -565,6 +565,7 @@ static struct key_restriction *asymmetric_lookup_restriction(
 	return ret;
 }
 
+#ifdef CONFIG_ASYMMETRIC_KEY_PKEY
 int asymmetric_key_eds_op(struct kernel_pkey_params *params,
 			  const void *in, void *out)
 {
@@ -603,6 +604,7 @@ static int asymmetric_key_verify_signature(struct kernel_pkey_params *params,
 
 	return verify_signature(params->key, &sig);
 }
+#endif
 
 struct key_type key_type_asymmetric = {
 	.name			= "asymmetric",
@@ -614,9 +616,11 @@ struct key_type key_type_asymmetric = {
 	.destroy		= asymmetric_key_destroy,
 	.describe		= asymmetric_key_describe,
 	.lookup_restriction	= asymmetric_lookup_restriction,
+#ifdef CONFIG_ASYMMETRIC_KEY_PKEY
 	.asym_query		= query_asymmetric_key,
 	.asym_eds_op		= asymmetric_key_eds_op,
 	.asym_verify_signature	= asymmetric_key_verify_signature,
+#endif
 };
 EXPORT_SYMBOL_GPL(key_type_asymmetric);
 
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 43e2e2a64594..9f382ba10fc9 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -288,7 +288,6 @@ config TURRIS_MOX_RWTM_KEYCTL
 	bool "Turris Mox rWTM ECDSA message signing"
 	default y
 	depends on KEYS
-	depends on ASYMMETRIC_KEY_TYPE
 	select CZNIC_PLATFORMS
 	select TURRIS_SIGNING_KEY
 	help
diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index 61cff5f7e02e..850319fb8c67 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -80,7 +80,6 @@ config TURRIS_OMNIA_MCU_KEYCTL
 	bool "Turris Omnia MCU ECDSA message signing"
 	default y
 	depends on KEYS
-	depends on ASYMMETRIC_KEY_TYPE
 	depends on TURRIS_OMNIA_MCU_GPIO
 	select TURRIS_SIGNING_KEY
 	help
@@ -93,6 +92,6 @@ endif # TURRIS_OMNIA_MCU
 config TURRIS_SIGNING_KEY
 	tristate
 	depends on KEYS
-	depends on ASYMMETRIC_KEY_TYPE
+	select KEYCTL_PKEY
 
 endif # CZNIC_PLATFORMS
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index 3f64d60d0f8a..c0cd894d306c 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -22,6 +22,9 @@ menuconfig KEYS
 
 if KEYS
 
+config KEYCTL_PKEY
+	bool
+
 config KEYS_REQUEST_CACHE
 	bool "Enable temporary caching of the last request_key() result"
 	help
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 5f40807f05b3..aafd28f7ee2f 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
 obj-$(CONFIG_PERSISTENT_KEYRINGS) += persistent.o
 obj-$(CONFIG_KEY_DH_OPERATIONS) += dh.o
-obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += keyctl_pkey.o
+obj-$(CONFIG_KEYCTL_PKEY) += keyctl_pkey.o
 
 #
 # Key types
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 4cf6b8070227..1821ba1165c1 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -316,7 +316,7 @@ static inline long compat_keyctl_dh_compute(
 #endif
 #endif
 
-#ifdef CONFIG_ASYMMETRIC_KEY_TYPE
+#ifdef CONFIG_KEYCTL_PKEY
 extern long keyctl_pkey_query(key_serial_t,
 			      const char __user *,
 			      struct keyctl_pkey_query __user *);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d6b10fd67627..417bba539bb1 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -28,7 +28,7 @@ static const unsigned char keyrings_capabilities[2] = {
 	[0] = (KEYCTL_CAPS0_CAPABILITIES |
 	       (IS_ENABLED(CONFIG_PERSISTENT_KEYRINGS)	? KEYCTL_CAPS0_PERSISTENT_KEYRINGS : 0) |
 	       (IS_ENABLED(CONFIG_KEY_DH_OPERATIONS)	? KEYCTL_CAPS0_DIFFIE_HELLMAN : 0) |
-	       (IS_ENABLED(CONFIG_ASYMMETRIC_KEY_TYPE)	? KEYCTL_CAPS0_PUBLIC_KEY : 0) |
+	       (IS_ENABLED(CONFIG_KEYCTL_PKEY)		? KEYCTL_CAPS0_PUBLIC_KEY : 0) |
 	       (IS_ENABLED(CONFIG_BIG_KEYS)		? KEYCTL_CAPS0_BIG_KEY : 0) |
 	       KEYCTL_CAPS0_INVALIDATE |
 	       KEYCTL_CAPS0_RESTRICT_KEYRING |
-- 
2.47.3

