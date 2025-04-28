Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7773427A93B;
	Mon, 28 Apr 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745857510; cv=none; b=VOJfUgNj7DqfkLaBZc4+yaAof8TmHDD7sO5++5a6m0djZCyKs/CcC0vQTKqG5XBPCX5VImkM1E0SFrWdaOCASZRkTr6E8pfYfXc/GvkhNjEgvFToCA8MQII2qtLz6G1+pGVWH3dRRCIpbB1lpXBpV0b6wCL/8dR34CJJahBSzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745857510; c=relaxed/simple;
	bh=DC+fkFB95gFx1bjI+xkkfdsQoC3dSDs6Bku9PBAALK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Omqx1z8d74jdGwP0VU6LLD6x7HD2UUdkniUYhY6hEISIcq00HIwf1G2Ojq05MsMTcBkxOhxnr5DH4+Q0cEfbax3UtfEtdJ6aW/3gMmuusLJsnn+H2I0nl2taMWv2GWtPMJiYFBkLjLV1nOixKs695L8w/qzq0j58I6NQNga0t+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnizaJDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnizaJDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3CEC4CEE4;
	Mon, 28 Apr 2025 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745857510;
	bh=DC+fkFB95gFx1bjI+xkkfdsQoC3dSDs6Bku9PBAALK8=;
	h=From:To:Cc:Subject:Date:From;
	b=RnizaJDV1n0o2v6NnjXe6U0A8ta6W1wIuAF5qmWxpUKBdl6FDHZUeAqKpS4rizmEP
	 RDBjLHoG55zjPZy0HdAqpNS1lMrp2t6rXqXcX2kqdE4kv8KVz6vuuwhe6IYYu/R1L1
	 kOFHg1sLke4g6ldzJFUfi2ghOovFzFqgAbOh2WZaloN1M+LukmRyg5Dl5q+Rqg/Zqe
	 M/stefzw/jlc1Yii7E2CxwiImqlBIsXJxQ6Zx9P2Po/uFU4IQ+ESfWEa4pjNFHC4a8
	 hu2Kgm/SOkEaOzH9XAd0qjAsxH38QoAhPkfJ9pfM4WEJ8U1chiIRU16gj3/OWtk7Ne
	 Jsft9NCkmV6Jg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v2] crypto: crc32 - remove "generic" from file and module names
Date: Mon, 28 Apr 2025 09:24:58 -0700
Message-ID: <20250428162458.29732-1-ebiggers@kernel.org>
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
remove the "generic" part of the filenames and module names:

    crypto/crc32-generic.c => crypto/crc32.c
    crypto/crc32c-generic.c => crypto/crc32c.c
    crc32-generic.ko => crc32-cryptoapi.ko
    crc32c-generic.ko => crc32c-cryptoapi.ko

The reason for adding the -cryptoapi suffixes to the module names is to
avoid a module name collision with crc32.ko which is the library API.

We could instead rename the library module to libcrc32.ko.  However,
while lib/crypto/ uses that convention, the rest of lib/ doesn't.  Since
the library API is the primary API for CRC-32, I'd like to keep the
unsuffixed name for it and make the Crypto API modules use a suffix.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this via the crc tree.

v2: Added -cryptoapi suffix to avoid duplicate module name.
    Reported by Arnd Bergmann.

 crypto/Makefile                       | 10 ++++++----
 crypto/{crc32_generic.c => crc32.c}   |  0
 crypto/{crc32c_generic.c => crc32c.c} |  0
 3 files changed, 6 insertions(+), 4 deletions(-)
 rename crypto/{crc32_generic.c => crc32.c} (100%)
 rename crypto/{crc32c_generic.c => crc32c.c} (100%)

diff --git a/crypto/Makefile b/crypto/Makefile
index 0e6ab5ffd3f77..186f968baa39e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -150,14 +150,16 @@ obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha_generic.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
-obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
-obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
-CFLAGS_crc32c_generic.o += -DARCH=$(ARCH)
-CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
+obj-$(CONFIG_CRYPTO_CRC32C) += crc32c-cryptoapi.o
+crc32c-cryptoapi-y := crc32c.o
+CFLAGS_crc32c.o += -DARCH=$(ARCH)
+obj-$(CONFIG_CRYPTO_CRC32) += crc32-cryptoapi.o
+crc32-cryptoapi-y := crc32.o
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

base-commit: 35984c730dea1a9fdd5d931f298849605850856a
-- 
2.49.0

