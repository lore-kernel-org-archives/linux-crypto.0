Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17B22A4E0;
	Mon, 10 Mar 2025 13:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741613224; cv=none; b=oQ/8BFwZ1/ohb0erJFX/XFY5DIYA1mhY/ogh+SE7YjdLu6VkCCo8aSm2iq1qR7zlwd3W1pYa/Z6S5/vG7pZ/sief5ioKgyoOjOWJcOvIj75ae7l4mVzJHW2DEnOlfiaeWeBuMyjlcy6HoRQW3HTxQvx69CtWtqXuUZtLzLuTZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741613224; c=relaxed/simple;
	bh=mER/O8b06hjWGlK9vixTIeglGzWo83VaznuRZmQmWpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QyysSyxs0gxFzPH8dIV5+eCCRzrBNR1emvspzPJ6kqNvDG9F+Yqy1cfeJ1T6WkKCRKFLdaGFGaTkTHIP/z6WmN5LKZtRHKoaUJJ1rdAuSDMj6vzZQFImtFBviTYMx1TTxb0X9BLun8ue6K9e/4PXCfj3XstoaY2G4rQ265k3PGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FI9KKuA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FI9KKuA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247AEC4CEE5;
	Mon, 10 Mar 2025 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741613224;
	bh=mER/O8b06hjWGlK9vixTIeglGzWo83VaznuRZmQmWpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FI9KKuA+jKkPVq7ILvzg+kXKkBHAcppO3slzbdDbQ83Gr01enW4vPt76jMSIsprSe
	 gdSQAH8i9CeGWdI39IiQYBksup9yKVH3dmBYKKQWQSHl/OyJTDvo0W7oyD8HWrQG+5
	 B3B/Ckj/73M/HORdNprm5SnDWeR5nk0Dnaxce6eDgYIN9XARBFUwn3JTz/hFP4jCwg
	 vp+P2RLMTZZIKwBD7UeTq6PYiI1Ag4HJu93EI7sSeScKWsMCOXVfDjV5W1xj3a2pFU
	 wNnA4TeeTb75czyBnnCEgmgiIrfSGAVq9ssD4ToOBqtkzHvnAGAX3AndyYX2P2uu2D
	 zFTkoN88Q5+iw==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: lib/Kconfig: hide library options
Date: Mon, 10 Mar 2025 14:26:40 +0100
Message-Id: <20250310132647.3256818-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310132647.3256818-1-arnd@kernel.org>
References: <20250310132647.3256818-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Any driver that needs these library functions should already be selecting
the corresponding Kconfig symbols, so there is no real point in making
these visible.

The original patch that made these user selectable described problems
with drivers failing to select the code they use, but as far as I can
tell, those were all bugs that got solved in the meantime and did not
get solved by that patch.

Fixes: e56e18985596 ("lib/crypto: add prompts back to crypto libraries")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
----
This does not actually fix a build failure, but I noticed that the
user visible options don't really make sense. Feel free to ignore
this one.
---
 lib/crypto/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 17322f871586..798972b29b68 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -63,7 +63,7 @@ config CRYPTO_LIB_CHACHA_INTERNAL
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 
 config CRYPTO_LIB_CHACHA
-	tristate "ChaCha library interface"
+	tristate
 	select CRYPTO
 	select CRYPTO_LIB_CHACHA_INTERNAL
 	help
@@ -93,7 +93,7 @@ config CRYPTO_LIB_CURVE25519_INTERNAL
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 
 config CRYPTO_LIB_CURVE25519
-	tristate "Curve25519 scalar multiplication library"
+	tristate
 	select CRYPTO
 	select CRYPTO_LIB_CURVE25519_INTERNAL
 	help
@@ -132,7 +132,7 @@ config CRYPTO_LIB_POLY1305_INTERNAL
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 
 config CRYPTO_LIB_POLY1305
-	tristate "Poly1305 library interface"
+	tristate
 	select CRYPTO
 	select CRYPTO_LIB_POLY1305_INTERNAL
 	help
@@ -141,7 +141,7 @@ config CRYPTO_LIB_POLY1305
 	  is available and enabled.
 
 config CRYPTO_LIB_CHACHA20POLY1305
-	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
+	tristate
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_UTILS
-- 
2.39.5

