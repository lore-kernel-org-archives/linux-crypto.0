Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8B27BF6E;
	Tue,  4 Mar 2025 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129683; cv=none; b=nqEgpYOJdf2JjBAWXokK8SHh70QLkaKG4i2BVe9uJ93f4da57XBOkM+WM2+rz2rhbtE+5T5zJ4izrAUhWUpMeeATIAaaOYLAKz9J6FurZV8wKAeyXkmi0PEMrRWoETGIiB0fSetzNjV5oshAVrRgYo8JEwdlayi1JPpHFi88//g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129683; c=relaxed/simple;
	bh=byHA6Rz1PjG0tOCb4XJriYFq/ChVdsuAJ+GkNBujcyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQBOhW3kymzyQs5XpskrA8aPm96zu9Juv/7MAvysVrIWOanYBkiKCMb48lE0wFbMHiV8Tjd86d73lZqmNl2NkyNFA9jIJwxLp/vFy0usSawuPXjbGMI0pdbE+jzUpOYww/sq/NS8MQFkSOc17LndKR8GWyTLI8Of3Yyv/ggOJm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcmML/uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcmML/uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD99C4CEEB;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129682;
	bh=byHA6Rz1PjG0tOCb4XJriYFq/ChVdsuAJ+GkNBujcyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcmML/uhSYt8Wl8TJWZu4xNSLRMZlQOJLqpWop14xxUq4JPVqKTzWlCMcDjLL5+Yt
	 WBZB5WqwBUcp89vMh4mEssGZl8GYRMbkMK0PVb+KP/l/5qYJROfZ3+wt1SNHZMbCfo
	 xGLanXCXWXJ0tlTk9IZoMsBqttFreahQUIh1XkldLKoOT+xPpEsRf6CitEk6tFGE5S
	 sXoQds8+LYliMWuaYjSTG0QX3M8CJpNcsM6vuO+oxO8Wqzbqo5+iWMZ328IHbOjGbX
	 dLYsaRKuR8dR0+PoCPrLGMKEMexCkSjlNAkIBuuLNSOQzIu4ZGPc2jtMpOkf/jYsAo
	 bVhhqnGoA+0+g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/5] lib/crc: remove unnecessary prompt for CONFIG_CRC8
Date: Tue,  4 Mar 2025 15:07:10 -0800
Message-ID: <20250304230712.167600-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250304230712.167600-1-ebiggers@kernel.org>
References: <20250304230712.167600-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

All modules that need CONFIG_CRC8 already select it, so there is no need
to bother users about the option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/configs/debug_defconfig | 1 -
 arch/s390/configs/defconfig       | 1 -
 lib/Kconfig                       | 6 +-----
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index ea9c3a944e37c..51c5b40920656 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -813,11 +813,10 @@ CONFIG_CRYPTO_PAES_S390=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
 CONFIG_CRYPTO_LIB_CURVE25519=m
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
-CONFIG_CRC8=m
 CONFIG_RANDOM32_SELFTEST=y
 CONFIG_XZ_DEC_MICROLZMA=y
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
 CONFIG_PRINTK_TIME=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index c929fa5131f1e..f2e6ada5c719d 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -801,11 +801,10 @@ CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
 CONFIG_PRIME_NUMBERS=m
 CONFIG_CRYPTO_LIB_CURVE25519=m
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
-CONFIG_CRC8=m
 CONFIG_XZ_DEC_MICROLZMA=y
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
 CONFIG_PRINTK_TIME=y
 CONFIG_DYNAMIC_DEBUG=y
diff --git a/lib/Kconfig b/lib/Kconfig
index 9b668c4b60e9e..31add0dc42925 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -220,15 +220,11 @@ config LIBCRC32C
 	help
 	  This option just selects CRC32 and is provided for compatibility
 	  purposes until the users are updated to select CRC32 directly.
 
 config CRC8
-	tristate "CRC8 function"
-	help
-	  This option provides CRC8 function. Drivers may select this
-	  when they need to do cyclic redundancy check according CRC8
-	  algorithm. Module will be called crc8.
+	tristate
 
 config CRC_OPTIMIZATIONS
 	bool "Enable optimized CRC implementations" if EXPERT
 	default y
 	help
-- 
2.48.1

