Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B6421CFF6
	for <linux-crypto@vger.kernel.org>; Thu, 31 Jul 2025 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754001766; cv=none; b=Eq9Fyt0hyuz5T8j3QoDct7dh6QcA6MGhF4zzh69gQNNF8nZrg9LZWpcX2wNEKSxLzwrh386Zp4bGyeOIlyFLg5CMrkUdNLBovv6W78smUIjE2qa2/fsPqU/8kQ63frc7k739/NgQzmjBiH9HsrlFMqV4mfY3XhfuNIWFsaOrz20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754001766; c=relaxed/simple;
	bh=YtZsExNZ7skwTG/8FgKCjQfn5ajiDRGF++thUzSw4Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s3rNh1LQuaaP6zQcnCK5D3Ij6JUI6Rb4331LL9rrcfGFAjbLYdewrqwQBTBqNPcSLxfPs655wZWK/YYaNYsOx1xCAd08VWtKGKlzs4fQCvEwowwzgpb5+ku5fK59V4ENe2jjVLpkmIqLUtnFtrXi4tVlSDA7UmIGYIN3xg+fWEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oas7Djum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oas7Djum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA09C4CEEF;
	Thu, 31 Jul 2025 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754001765;
	bh=YtZsExNZ7skwTG/8FgKCjQfn5ajiDRGF++thUzSw4Dg=;
	h=From:To:Cc:Subject:Date:From;
	b=oas7DjumlHFPwzcRdjG9WtAHFMS4y+4+xmsQ/BwxVStQqQTwoRKAfe1o3biY82Qpg
	 wgAw7tg3epvyWhEVWinNoIFTyuspf6C2OZylOzlzGEaif/0alc3F0ua+pZClMCoGAQ
	 E4z9iTogVn6+N03GuoegeQ9LvkcQSS3CecCos3CnzpXbug0FqttTqlZmoFZHKU27z/
	 5ptc/A9x2ZI9bamnzBuh/P+RQrVe1XFJsjlWZ7SwTZ4p3iO4fjKYEEFoG8T0uIWbBC
	 6BkRG4x3MRKtxgv6XeIUcaFI5vbQpz/BPnlq12CeqKd8m8SoHvGY9hhEp9YO1bYA+/
	 NqRFFdxRjFO5w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: sha: Update Kconfig help for SHA1 and SHA256
Date: Thu, 31 Jul 2025 15:42:18 -0700
Message-ID: <20250731224218.137947-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the help text for CRYPTO_LIB_SHA1 and CRYPTO_LIB_SHA256 to
reflect the addition of HMAC support, and to be consistent with
CRYPTO_LIB_SHA512.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index c2b65b6a9bb6f..1e6b008f8fca4 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -138,12 +138,12 @@ config CRYPTO_LIB_CHACHA20POLY1305
 	select CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_SHA1
 	tristate
 	help
-	  The SHA-1 library functions.  Select this if your module uses any of
-	  the functions from <crypto/sha1.h>.
+	  The SHA-1 and HMAC-SHA1 library functions.  Select this if your module
+	  uses any of the functions from <crypto/sha1.h>.
 
 config CRYPTO_LIB_SHA1_ARCH
 	bool
 	depends on CRYPTO_LIB_SHA1 && !UML
 	default y if ARM
@@ -155,13 +155,13 @@ config CRYPTO_LIB_SHA1_ARCH
 	default y if X86_64
 
 config CRYPTO_LIB_SHA256
 	tristate
 	help
-	  Enable the SHA-256 library interface. This interface may be fulfilled
-	  by either the generic implementation or an arch-specific one, if one
-	  is available and enabled.
+	  The SHA-224, SHA-256, HMAC-SHA224, and HMAC-SHA256 library functions.
+	  Select this if your module uses any of these functions from
+	  <crypto/sha2.h>.
 
 config CRYPTO_LIB_SHA256_ARCH
 	bool
 	depends on CRYPTO_LIB_SHA256 && !UML
 	default y if ARM && !CPU_V7M

base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1

