Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC91266B67;
	Mon, 28 Apr 2025 12:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844937; cv=none; b=KqclnG4NKNZEFjXbF52VVi1UGNdNsGjU8E8bHBM18VGQTcR3rB0xXEA6r8rE56RALsQwS67ojICoGt5JZM72oeu+HCiqeMSdmbxUkQVHaY14FqY02sAMaB9Ht1Ia8Zj/7P4LTgVEgrlC9Y9c8AXesPSWyiK5iK4YVBjl9OfOfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844937; c=relaxed/simple;
	bh=X+xLCbiG+4JgTGFLVyMpzBshiy8LrzoV71eX7VicFbo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dkBReUx8CcjItGJnidXEpfdYpp/5VuON46TccF+o1C6V+c8Rg7A/2iSDzF16SLnN1RKzifV/CIeBALmDnaCFLnpmtQpM7QJw1jGLe87JzppB7CUDb7sdJL0dGeapPpAA1LuQU5jBR678Hr3uf4ujAVGr1svxvHeqtoL+JeQ/kZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSjrJ1yY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSjrJ1yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3962C4CEE4;
	Mon, 28 Apr 2025 12:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745844937;
	bh=X+xLCbiG+4JgTGFLVyMpzBshiy8LrzoV71eX7VicFbo=;
	h=From:To:Cc:Subject:Date:From;
	b=iSjrJ1yYBFS88e5l8XTZ0bYtP1CsipMiSfkHgL1ojBEgMgvmjgwK98hGFzikcYuQ0
	 fbL6cwlDVD7ZdLEttMYaF4a9quHe5Qy9azNzpRBhUcZPj5Z/83vtM7vQ5le5BFihSl
	 HhyRvI+Wfjrb81SG7XDm+E32gDlkcJA+8WZ7i5lU2hdA9ZIYbVRDCW7hmG687guIwX
	 RQFIJhyRPPPLVuN5f08+1Xw3hWKZQ3h/T1yDmaMt9mHuBkvQLEwl4cskPx+Mkq0sbd
	 UikqaBcYSbi3346DkprINITV/oHO9oKumJeO1YInc1q/w7lsnkw21ZOwg4MWwHbvuW
	 srXcsf47tCOfw==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "crypto: crc32 - remove "_generic" from filenames"
Date: Mon, 28 Apr 2025 14:54:02 +0200
Message-Id: <20250428125530.2018272-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Each loadable module in the kernel must have a unique name, so renaming
the crc32 crypto module made it conflict with the crc32 library, as
shown by the build failure:

 error: the following would cause module name conflict:
   crypto/crc32.ko
   lib/crc32.ko

This could be solved by renaming one of the two conflicting modules
to something else again. As I can't think of a better name, just
revert back to the previous state as the easiest fix.

Fixes: ce653e0a7e0a ("crypto: crc32 - remove "_generic" from filenames")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Makefile                       | 8 ++++----
 crypto/{crc32.c => crc32_generic.c}   | 0
 crypto/{crc32c.c => crc32c_generic.c} | 0
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename crypto/{crc32.c => crc32_generic.c} (100%)
 rename crypto/{crc32c.c => crc32c_generic.c} (100%)

diff --git a/crypto/Makefile b/crypto/Makefile
index f238281b16c0..5d2f2a28d8a0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -153,10 +153,10 @@ obj-$(CONFIG_CRYPTO_POLY1305) += poly1305.o
 CFLAGS_poly1305.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
-obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
-obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
-CFLAGS_crc32c.o += -DARCH=$(ARCH)
-CFLAGS_crc32.o += -DARCH=$(ARCH)
+obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
+obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
+CFLAGS_crc32c_generic.o += -DARCH=$(ARCH)
+CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_KRB5ENC) += krb5enc.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
diff --git a/crypto/crc32.c b/crypto/crc32_generic.c
similarity index 100%
rename from crypto/crc32.c
rename to crypto/crc32_generic.c
diff --git a/crypto/crc32c.c b/crypto/crc32c_generic.c
similarity index 100%
rename from crypto/crc32c.c
rename to crypto/crc32c_generic.c
-- 
2.39.5

