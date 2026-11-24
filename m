Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521695;
	b=zN+EO7uaPv4Sep/lXD4DK/oB92hAVW9Ac8IzdgibX+2+1q9ePQ0qGqcpMjGg3i8H4HFb
	 d/8c+qpMCf4p3qJiXAplj17dPLBjK26xmpLLhwKMhDgAPOm+NWd3Anqfu4lhFAM2EEotv
	 tVcr1iptsjaUnuafhia4uGxvYggbSSvi0Agf8860i2fagE/kiwYj5fvvHvuCcvJmCSrMb
	 cR6fmnUkgOYgb72z/wtDhnNZpR5M6QOK1fJLXE3SrpZFiJYH4yVs2AINHNVrE8hoQjbWd
	 1DfDPs6GsbY4JML7gFqRM37m7pZUG6tLME87uya4wkjWn3tw8SinFS00K8PiRwxwxow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SV/yiOYP/0MeNKZw5YjS4f8WYb1DDXzMpTFrDVl9LTM=;
	b=00KCKm4sq2kseQgkHyBkvxTUKyj7HINpIJk4qg6jlVUyQ/W+aGmtMtQHk2tDgXzI2O0J
	 qbYSq5m10QL8FyMmGwl400OnrjJcXm+wmrw7rrCzp4OxQRm7878yfoXOMpehs7ldC+XcN
	 Z7Qf7TedLNY4bgXtJM9jm5fNojX3WQ6Xj1u8A55Rt3/1vDKpo3SztBSP8kJM9CPpuCDZQ
	 kO7CQZ/J0c8T4B4nqhHQj/ql5DiE0oa/Zu8N2aju84U7ooan65jczWD0mXuYJFO5Izqsm
	 E+7v+kU2yOGjQAQMgsZv6i3e+WBOWOU2i0d3CBlQMLGIXF8WkfReZJhb/AyG5VxVmVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A/8Shx78";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 04D55606A327;
	Tue, 24 Nov 2026 12:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A/8Shx78
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1C7C11F00AD4;
	Tue, 24 Nov 2026 12:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795521694;
	bh=SV/yiOYP/0MeNKZw5YjS4f8WYb1DDXzMpTFrDVl9LTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/8Shx78oLUGzXXbcTznS4Y+kKWHMNnFSH4S/zZp2bhLJbjZ6nycDiHEzLCfzu8Zi
	 XwFD+MHku2katBq+yOqLNyA98zOH37B7RmadHz1pXZYGRqwB0b/RlXvgyYk17+9uGn
	 Z11CwXOx86iI4hjU6Wib2gzi96LngwQOx9PDD3R+yMaIePV5ZUG/zbN1FmwptvC3cd
	 VoZ9rnvSjN6S2Vh243Qd0Z6j965WfdklCBRYREwsNps01Fxz3BgVuqeFgdFcM2gKbU
	 J11ejYOU1HBuiQjgPGtQGPICLXi7fBzndEH5uRNYWUJri6ECNZ8Bd2PNRrzY4r+bqn
	 5fSWzWxz2qY4g==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
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
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6/9] KEYS: Factor out KEYCTL_PKEY
Date: Tue, 24 Nov 2026 14:00:41 +0200
Message-ID: <20261124120044.1481752-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124120044.1481752-1-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
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

Factor out CONFIG_KEYCTL_PKEY from CONFIG_ASYMMETRIC_KEY_TYPE so key
types other than asymmetric can select keyctl public-key operations
without pulling in crypto/asymmetric_keys/.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 crypto/asymmetric_keys/Kconfig | 1 +
 security/keys/Kconfig          | 3 +++
 security/keys/Makefile         | 2 +-
 security/keys/internal.h       | 2 +-
 security/keys/keyctl.c         | 2 +-
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index c73979b2e98e..1c78a9a663c5 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -2,6 +2,7 @@
 menuconfig ASYMMETRIC_KEY_TYPE
 	bool "Asymmetric (public-key cryptographic) key type"
 	depends on KEYS
+	select KEYCTL_PKEY
 	help
 	  This option provides support for a key type that holds the data for
 	  the asymmetric keys used for public key cryptographic operations such
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

