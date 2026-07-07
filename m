Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02B38BF61;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402642; cv=none; b=bfShdWUdTP5INliiamsbiFRLuGw36DXaQpTuREKt/wHjVfLxsccM5HO63M0RIEo9uqqYdaeRnxyHKPtZjCgxza41h6h/N/Uyw9EsUp65rjoobQ1sLSxtr16sGGIoVblymb35/JaldQLZq4w94jrSbI6ZX2f/d0lT3c6BQJGHGIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402642; c=relaxed/simple;
	bh=kuevmsz8HNCXqx7j+f5olgMgRh8eFDVZwwTTobAWyZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MedFO6l3GSNTSu/pLvV6BX3ZDWa2TDvBSpiYMnPEPkC08JB1Hkk7D8zzcmGmuMEgtxE7CrZyXphuFK0amJZBj/gGTnSRtKTllpTNVK/l7/QJXPyMvlkTGk+XDxXw0DyIwuffIZDMO19Asxv9SzU4oHS3F13zemHqtpZAA7Mvwjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qc8o/vc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qc8o/vc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5AE1F00ACA;
	Tue,  7 Jul 2026 05:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402641;
	bh=A74zXRJZH4ltkzEAczNR0u1XsNAvavfz+8X4QrQio+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qc8o/vc7pwGbcEDjMc9HFq31zY7+rTGf6dyYYvb6/DVyZgyRxsZl1frc2aTYiXLiE
	 UTRMEFIopsviRJM/ZR6HvlIowHS67G9fdjfxhiTZtUR94H+vDoFUtsmhNiANIdM6kE
	 zyKQgIfdBuobAcXq42Y4FGvoMRtFxVP9W2dYVkjqUBx27wWCFenNS+xPEsvlVjqxyf
	 dR0HHDzmeCDascAlEKgBJYGw+bB1WgWdUNz3+JE39Ksa+uQ6Rzl8JBmlhO2LgMPigI
	 z1u0UwJHTTIsDrnJnBpJgis+Ic+HwhFkt8h7VRp6Rnm5LBm3LKJIDK5yNGidAQI77j
	 WcSHdJ9Cu5aCA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 18/33] fscrypt: Use aes_ecb_encrypt() for v1 key derivation
Date: Mon,  6 Jul 2026 22:34:48 -0700
Message-ID: <20260707053503.209874-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there's a library function aes_ecb_encrypt(), use it instead of
a loop of aes_encrypt() calls.

Note that the use of AES-ECB here is purely for the key derivation
function used by the deprecated v1 encryption policies.  v2 encryption
policies use HKDF-SHA512 instead.  Nevertheless, the original version
has to continue to be supported for backwards compatibility.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/Kconfig       | 2 +-
 fs/crypto/keysetup_v1.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 983d8ad1f417..7662d8c45f07 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -3,7 +3,7 @@ config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
 	select CRYPTO
 	select CRYPTO_SKCIPHER
-	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_AES_ECB # for deprecated v1 key derivation function
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select KEYS
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index e6e527c73f16..70385d82fa73 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -20,7 +20,7 @@
  *    managed alongside the master keys in the filesystem-level keyring)
  */
 
-#include <crypto/aes.h>
+#include <crypto/aes-ecb.h>
 #include <crypto/utils.h>
 #include <keys/user-type.h>
 #include <linux/hashtable.h>
@@ -240,8 +240,7 @@ static int setup_v1_file_key_derived(struct fscrypt_inode_info *ci,
 
 	static_assert(FSCRYPT_FILE_NONCE_SIZE == AES_KEYSIZE_128);
 	aes_prepareenckey(&aes, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
-	for (unsigned int i = 0; i < derived_keysize; i += AES_BLOCK_SIZE)
-		aes_encrypt(&aes, &derived_key[i], &raw_master_key[i]);
+	aes_ecb_encrypt(derived_key, raw_master_key, derived_keysize, &aes);
 
 	err = fscrypt_set_per_file_enc_key(ci, derived_key);
 
-- 
2.54.0

