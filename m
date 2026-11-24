Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549283;
	b=aP4e8LZAQRaiB8TCiCNzTJzVTyBdelO0WEc2T93Hw+TidlvtTTtycBr4AI7k010/uiEk
	 5wK9jd2AROl3U7KOeHIjNvvGCnPVY7qCzOVMCIoq/HmsZiwrcDDJaHXc4UaIAm806s2wD
	 ebkSqGa8BKFlUcituxEHyYwDMYPHrhQL7TI9hERvLbAUr7Zv79pTcxwWYqTBqdQu8kG1F
	 7oYNmK9yz1ctfH3Sfdq9jmmT4dVOxCBFBrOAp3wr+brCHFDfl5TJyGAIl5TdCq94xiDuD
	 e+ona1/AW40ukEWAMJat94Zln7CyfEjNlUSJCMbe20swOF9uSWk8jOYPLpoJQPrCdew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SV/yiOYP/0MeNKZw5YjS4f8WYb1DDXzMpTFrDVl9LTM=;
	b=JZHY4vjFz8O0DXlRu8W2REbBxBINZZMOfQjN5zfhnsN+2DtJJL654Ulot+0Za/tUPLli
	 RLj6iVYJgO8uHsK4/OoS00mwZEMTSc5fsh8Bsg/BvbL1DMaXx6x3HoYGuSlyle14f+G0r
	 KklEyu50JcrPRSJUowFMqlUVwKV1bzogyga61MfMUUm8TN3hqoox0vekQI0aM1CCbuRIa
	 jdp9TtLMUQHkaeEGXJN2/ablGaq/xbFq/1a7fu67/c4u0R9M38bXCJmwkbP9Jcq2sGKSu
	 r9KJ+Oy+AdwJ5vyV9wEL4EDCuXbbNWgwYObks2lYwwm5pVcSS/dJN6ABVZvLsEFXC6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WrfLv0p6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B738F606A326;
	Tue, 24 Nov 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WrfLv0p6
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 971D51F000CF;
	Tue, 24 Nov 2026 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795549283;
	bh=SV/yiOYP/0MeNKZw5YjS4f8WYb1DDXzMpTFrDVl9LTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrfLv0p6N8DWFntxW2KHnYkGxCbc9GF13XpqdpkuGVS9VqXYDWZk+17DjOwgmR+cf
	 EUW38mUSEcDEgRmZV327Af1WpgQiXc3N3KUzHqy1U2xcbDKnRqSYyJ4MZcKzcGXDNl
	 uR83W5tPCGDjq2laURNz+bSZFG7ojnjfk42b4dytUTyIWvI06yHn9paweH7sDTgipz
	 nGnkf9nMqm9UKnv+UJ9reM5CYG4aRRt+eDuGkRR4/yp0dXnnJmvKQ/17BeLvGNkyNt
	 ENdJEVY2XnrWHm0TDCxTstY1d4GHzbJhYBNDtWYcfU8qtHTg4S6sMUPA/pMdxrDjte
	 3mwtKis1xCFYA==
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
Subject: [PATCH v2 6/9] KEYS: Factor out KEYCTL_PKEY
Date: Tue, 24 Nov 2026 21:40:40 +0200
Message-ID: <20261124194043.1651679-7-jarkko@kernel.org>
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

