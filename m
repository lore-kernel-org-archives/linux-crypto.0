Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629993;
	b=tAE6OKAZTGNgj17j320zyXlFx+0lhVpI9SgpPpr17cJBtRL8g2d6GS53IwZay4haDvft
	 i5X9GsFkDqwVV1Kcs2ijJOEL8r0rLs0AucJHa2Q3lX7uBPWKEHykCag7bKaejKM7aFHXJ
	 nbrVyKxTknSZCWY3kPYVuMbH4/j112ly0cSYqr0Iz2kQ8HahkdnVMw3wiMQPDA6EKsLzE
	 g9XDymtHPMOePykMdt6Huqtg/A+Lm3USbIa5cf036O6v2Lv4fKiY58WhnVjLrPYu++NcI
	 ZhWXyPEHOTCYw7PZvj5FbVKPva7vBVRxA7/dSTJhrLb2rwBW3B6ukJcZHTGgqqLoJXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=U00yWHIo8HhrdyFuKMDRdBiL8d54KG7YlSUEsh2C5MM=;
	b=WHP+fzdJNolBS8vSq4ONiFfx/bt8UOKBBrbNQi5C0gzJqYknaEHoUtCupaG3KmI2aacn
	 MAIM2bsmOgQ61ZsQFjMBx3dpxgvjpfnkDPt25HR6t2fiwsVhbiAMjnqU5l7oF0A/4fpyT
	 1GxNd0s9s6tkxLq9ZE9AdLjSpg4yNrWtps7a9Fc9vDvOEk5JUYPpPzYhigMXtlfa6cE0s
	 vNhahNtekGK2dURCAdW+6o5XzwIL1TNdh/XVcDgeMgRLPUMVhTV/P37p7azhun1xa8kCB
	 0mrq4NB6Y4g+HJRk79h65mkgx4IcC2C9s2vGLcTieibICZ2n1Pnqxktxo7G9faYQFnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SzJaPlqJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1FCE2606A31E;
	Wed, 25 Nov 2026 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SzJaPlqJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E3F71F00A3E;
	Wed, 25 Nov 2026 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795629993;
	bh=U00yWHIo8HhrdyFuKMDRdBiL8d54KG7YlSUEsh2C5MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzJaPlqJ0DMwNK1s6wL3Pkh568FjgSIq0691VFOmewOFIDORl9wUV04BtlYS60a7/
	 mWivwg/9pA0xq+MoYzyaP24iHOAlXE1/YRbpPdwrybKyV8GH5rlvGV5gjSO/4TVDNF
	 fVaF75ksLGuVHnE9HTUX1h1e5QzxWuummGvaAUg6F6GzW8AE5z7PcPxxNN7pA0G4Yi
	 ShgfC8FAAWnbUV951C7RX1xr8Ch56ZwZKnqdHGApP4YOs2TZqSZvgIHGWvT8WzYAMO
	 /AcZrqpO8pOqm/n/XmVTjftPrfWeb87YAJv0Z4JZJjcrxIKsg8Kk+EaY24F7mXBlRh
	 xkaEfCG6QHcxA==
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
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v3 1/9] KEYS: Factor out opt-in KEYCTL_PKEY
Date: Wed, 25 Nov 2026 20:06:07 +0200
Message-ID: <20261125180616.1854753-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125180616.1854753-1-jarkko@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
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

Factor out CONFIG_KEYCTL_PKEY from CONFIG_ASYMMETRIC_KEY_TYPE as an
off-by-default option so that systems that only need asymmetric keys for
in-kernel signature verification can choose not expose KEYCTL_PKEY_*
operations, and other key types can use them without pulling in
crypto/asymmetric_keys.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/Kconfig    | 9 +++++++++
 security/keys/Makefile   | 2 +-
 security/keys/internal.h | 2 +-
 security/keys/keyctl.c   | 2 +-
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index 3f64d60d0f8a..75cc4043ca64 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -22,6 +22,15 @@ menuconfig KEYS
 
 if KEYS
 
+config KEYCTL_PKEY
+	bool "Public-key operations on retained keys"
+	help
+	  This option provides support for querying, encrypting, decrypting,
+	  signing, and verifying signatures via keyctl using public or
+	  asymmetric keys retained in the kernel.
+
+	  If you are unsure as to whether this is required, answer N.
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

