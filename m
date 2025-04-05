Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBE61B6CEF;
	Sat,  5 Apr 2025 18:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743878022; cv=none; b=YxhNKaDAKG7R7WYQLJsJyJE+RTVhf7qJqln9jGySP3bmFIpeClo1VKsUeKoToqfQSZqIdAZyOwYZCz4JJYpHkTp5RarbNp7BUvdWyGr263xLpxaSyu/rEZlLnG8C74feBIMt2q6hCX76M4KdUpOFDblaGP/HHmhFrSSC73Pffko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743878022; c=relaxed/simple;
	bh=teDk8TeNfqt2r9k4vRhENAbqbxGaLsP4BGLh3eFVikA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rVjybRWs6LxK5fOyjFN9VZvX0wejmJbSV7wmptoikFLTLLDGTp7/i6x5pVpTlCPUn/Zs1zfeEYBdrwGl+ZUAlXvQNUBPn2BgnBU1XBKCg+3U47i7FFRYd50iXYD0jbrxt75IwdMFt5w5zq5x21AWcd3PzAsJcSYFl12ricKBVuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNd2N8bZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNd2N8bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234C6C4CEE7;
	Sat,  5 Apr 2025 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743878022;
	bh=teDk8TeNfqt2r9k4vRhENAbqbxGaLsP4BGLh3eFVikA=;
	h=From:To:Cc:Subject:Date:From;
	b=SNd2N8bZEvC7Zp5Wpnqf2texr+3zJ2Xt2wHL7x45wI07f2WU1Mu0WJpAaP5QM71vT
	 lMDD9xrezlzkDfNGDmNgfc7sQkqBNU/9pMz1gqyi2eXhJW/FU3kWo/k/Q7S2cP33wt
	 EPAO4gooO2/KKdLspYf8jX0VwQYql3yM5mxy9zSg/ukrE3iTpsyUrnHWj3GK6aWv6L
	 wI4ZNkB0FETJXN2D4+muXosKt4nEPiSl/No+Z8P6FN2PiEzWTyCpKmqBIogKjXclwc
	 Mnl+Plsoicf0ulSrI9GGz3tBzxQEnTJqUy9POJRS+C8HdbHy7fWiOQuLW1Xar931wS
	 LEebPdVefDIAQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: crc32 - remove "_generic" from filenames
Date: Sat,  5 Apr 2025 11:33:24 -0700
Message-ID: <20250405183324.441383-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since crc32_generic.c and crc32c_generic.c now expose both the generic
and architecture-optimized implementations via the crypto_shash API,
rather than just the generic implementations as they originally did,
remove the "_generic" part of the filenames.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Makefile                       | 8 ++++----
 crypto/{crc32_generic.c => crc32.c}   | 0
 crypto/{crc32c_generic.c => crc32c.c} | 0
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename crypto/{crc32_generic.c => crc32.c} (100%)
 rename crypto/{crc32c_generic.c => crc32c.c} (100%)

diff --git a/crypto/Makefile b/crypto/Makefile
index 0e6ab5ffd3f77..c073a4967dc2a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -150,14 +150,14 @@ obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha_generic.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
-obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
-obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
-CFLAGS_crc32c_generic.o += -DARCH=$(ARCH)
-CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
+obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
+obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
+CFLAGS_crc32c.o += -DARCH=$(ARCH)
+CFLAGS_crc32.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_KRB5ENC) += krb5enc.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
diff --git a/crypto/crc32_generic.c b/crypto/crc32.c
similarity index 100%
rename from crypto/crc32_generic.c
rename to crypto/crc32.c
diff --git a/crypto/crc32c_generic.c b/crypto/crc32c.c
similarity index 100%
rename from crypto/crc32c_generic.c
rename to crypto/crc32c.c

base-commit: 56f944529ec2292cbe63377a76df3759d702dd39
-- 
2.49.0

