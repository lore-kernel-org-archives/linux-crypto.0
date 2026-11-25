Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795636174;
	b=cybh5s1axPKhm8x8EL5V1id/jR3ICAp9L0bvM5MqNbkUJgPxI93Bf+dggAbCYLwQgXtk
	 7vgLdrQu297KcUwt+cbyqIOQBS3ssuD7C1gN864MwnHpT07r8EN18nIaRxLe3Flvm/yhV
	 68ksZhsxqqDUAQJ/y2VWQiUUpN6lrPI7M0OtkrTZN5/LiOTe14/xDJhxUFLVAGgnDuU87
	 iRlau4Uh3nu5prGMrBpDoXnV31nP7tjmder9In0Y3cnm+FIYQlaKUkc4Z4p07zWdZPxhY
	 czyN4mGvWpzTed3UhtOVoy8Xu52DfBpd8IQ6FGtk8T5KGO5xP34oK9HNNX9yW49b6pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795636174;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Now/n1D8cTe8TVsz40b+XPOk1HOsyNGAE87l+llLmoE=;
	b=QA0kCPUr0aHruga3rp0CsY0ZchA3hkWV/NlfCY0FdcgQf+33ogW+RPsF9M/zzNwdzqkX
	 vEuKlOSHIPt56Ynqroo5i9T9l5NYJna84lC+Y8k8IDF9qUd2EbJuRVd90bEyeRTwpxlRz
	 T6PY4ktv5gGv9XPCtTlrC39dUWgQv8OLXTySeuhVnbzzCCV7ZZsBznYpfcBwC9ytT6TKB
	 2IOUoPOiZZ7O0JPeafvKhdzhBsyX6z7FwLoDFD2REeH9Xur8LpHVrvvpgauzVlOOqgcrx
	 XvfyvIb3GOCund1+7Uofge6n1aluAjlkaOH9Bg20EdFw4ypmu8yfLOew8K+g/UfMAVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzzXIMyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DFA54606A32A;
	Wed, 25 Nov 2026 19:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzzXIMyY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 945B91F000C0;
	Wed, 25 Nov 2026 19:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795636173;
	bh=Now/n1D8cTe8TVsz40b+XPOk1HOsyNGAE87l+llLmoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AzzXIMyY9pSWnJ5KIEnjbzLINTeBS98u1hSdF3AyHpY/So+rGhXPwQ+tCTU+czBZt
	 evFUOgltOUIl7lTE31GllCjC84qcrAL+1MKSWdTyJuXw9zzBOVYAYMwOnqBxS0MmkZ
	 oS6fOVNIcHjw0M8LUgLFZXokEx1drSmDjoqODYUHnHvI4usz8Q0pQeNvtlX7kYJ4XA
	 wHcpR99aoMuN4L36uBs2mg5t6HhXnX33OS8B44SXMxTew0W0FFm1I9mu5J4Na8O5Vn
	 H7am+1ZXGKBmYs7kotLJuGAyevKCuY63e5RZbQ2gTiwrufEDkgY3jUAiFdKxnu6RRO
	 M6pkoJitxQ+lA==
Date: Wed, 25 Nov 2026 21:49:29 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
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
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v3 1/9] KEYS: Factor out opt-in KEYCTL_PKEY
Message-ID: <awc7yQrc4R6Y915l@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-2-jarkko@kernel.org>
 <sashiko-outbox-233977@kernel.org>
 <awcvqLlRgAoeG8iU@kernel.org>
 <awcwHuvFhr7yfbgO@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="q6DvZ2pZ0MZhmS4J"
Content-Disposition: inline
In-Reply-To: <awcwHuvFhr7yfbgO@kernel.org>


--q6DvZ2pZ0MZhmS4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 25, 2026 at 08:59:45PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 25, 2026 at 08:57:48PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 25, 2026 at 06:22:49PM +0000, sashiko-bot@kernel.org wrote:
> > > [Severity: Medium]
> > > Should TURRIS_SIGNING_KEY, TURRIS_OMNIA_MCU_KEYCTL and
> > > TURRIS_MOX_RWTM_KEYCTL be updated to depend on KEYCTL_PKEY instead of
> > > ASYMMETRIC_KEY_TYPE?
> > 
> > Yes, and it make sense to add a level of granularity to this i.e., to
> > make on/off subsystem specific choice.
> 
> In other words you want to have it "default on" for Turris while at the
> same time being "default off" for asymmetric keys.
> 
> Not particularly complicated to implement but this was pretty useful
> review comment from Sashiko to point this out.

What do you think of this?

Br, Jarkko

--q6DvZ2pZ0MZhmS4J
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KEYS-Factor-out-KEYCTL_PKEY.patch"

From 722be64c6b1eed4d6b07ee2667133db266d70921 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@kernel.org>
Date: Tue, 24 Nov 2026 12:56:33 +0200
Subject: [PATCH] KEYS: Factor out KEYCTL_PKEY

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
index c452d71cce03..28c6cd942c59 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -314,7 +314,7 @@ static inline long compat_keyctl_dh_compute(
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


--q6DvZ2pZ0MZhmS4J--
