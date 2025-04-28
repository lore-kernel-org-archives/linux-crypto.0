Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206322951DD;
	Mon, 28 Apr 2025 19:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745867465; cv=none; b=j3BBshsecLMTY+N9+mSOzrwJIGT/VBqGgpxcqEQFGSHT9gAwHDcaRMW69WnMBfw+ZDEOuWF8a61E/hxRuIsEnbLBFtCI0Kz2cyLEdrOR8qbKU0CHmpF3wmyhG3042O11MXKsRmHX0/NkgPXnlBOkEKGYbsBusXGALNOd+CESoVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745867465; c=relaxed/simple;
	bh=W/2PfOMP1ufmxDEWSm83y57lSfqLcyzGyOX/hgMEc0M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W2j9e64r40rXxntJ6m7vaOetFr4IOauHHDp9IyZcnuA5YIm/cvhm81UKw8QamEb6FMBmD7hI9FUcsyTNJt1ehumRMztAnPuZX6PfzVxchlfnfxyah+3wvaLH0Nv8IJiWR1H+QbGJ+tAeqis4q9BtPWyljbmizEXLh7oKMEEh6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Waybpf0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Waybpf0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D37AC4CEEC;
	Mon, 28 Apr 2025 19:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745867464;
	bh=W/2PfOMP1ufmxDEWSm83y57lSfqLcyzGyOX/hgMEc0M=;
	h=From:To:Cc:Subject:Date:From;
	b=Waybpf0aiWJ5DbK1TxpJMDQyxhUXdz8pXyzObIoye7pfgUylJgm2iyKQla80rsEca
	 0+BqDFpjYBGxms2PP2it4DBqvXBN9uwNtWSGtfNRJ1so9CY/3/Rf6R5d/0Yhf1yzEI
	 owKaJ2ycOpcOllcUPHQR/hPKZNmK5EWa8W7cNzalmjozpZfmAn90V7Ro0w+4nLfNqO
	 1OlBqqmvzLW2gjiJ1aA/BdpEEokaqG1HIHUdKauA04XpOwLN4dRjM5eqaF1YONqzcK
	 Pv4mi7YHWc6NP1OARjy6BtBXUWvlhlapnK9mfniXeNMdxt0OfKJj1VCmMMb1ef0TPb
	 zx/Qan9iqxlgg==
From: Eric Biggers <ebiggers@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
Subject: [PATCH] firmware_loader: use SHA-256 library API instead of crypto_shash API
Date: Mon, 28 Apr 2025 12:09:09 -0700
Message-ID: <20250428190909.852705-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This user of SHA-256 does not support any other algorithm, so the
crypto_shash abstraction provides no value.  Just use the SHA-256
library API instead, which is much simpler and easier to use.

Also take advantage of printk's built-in hex conversion using %*phN.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the firmware_loader tree for 6.16.

 drivers/base/firmware_loader/Kconfig |  4 +---
 drivers/base/firmware_loader/main.c  | 34 ++++------------------------
 2 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/base/firmware_loader/Kconfig b/drivers/base/firmware_loader/Kconfig
index a037016742651..752b9a9bea038 100644
--- a/drivers/base/firmware_loader/Kconfig
+++ b/drivers/base/firmware_loader/Kconfig
@@ -1,12 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 menu "Firmware loader"
 
 config FW_LOADER
 	tristate "Firmware loading facility" if EXPERT
-	select CRYPTO_HASH if FW_LOADER_DEBUG
-	select CRYPTO_SHA256 if FW_LOADER_DEBUG
+	select CRYPTO_LIB_SHA256 if FW_LOADER_DEBUG
 	default y
 	help
 	  This enables the firmware loading facility in the kernel. The kernel
 	  will first look for built-in firmware, if it has any. Next, it will
 	  look for the requested firmware in a series of filesystem paths:
@@ -26,11 +25,10 @@ config FW_LOADER
 	  You also want to be sure to enable this built-in if you are going to
 	  enable built-in firmware (CONFIG_EXTRA_FIRMWARE).
 
 config FW_LOADER_DEBUG
 	bool "Log filenames and checksums for loaded firmware"
-	depends on CRYPTO = FW_LOADER || CRYPTO=y
 	depends on DYNAMIC_DEBUG
 	depends on FW_LOADER
 	default FW_LOADER
 	help
 	  Select this option to use dynamic debug to log firmware filenames and
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index cb0912ea3e627..44486b2c71728 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -804,45 +804,19 @@ static void fw_abort_batch_reqs(struct firmware *fw)
 		fw_state_aborted(fw_priv);
 	mutex_unlock(&fw_lock);
 }
 
 #if defined(CONFIG_FW_LOADER_DEBUG)
-#include <crypto/hash.h>
 #include <crypto/sha2.h>
 
 static void fw_log_firmware_info(const struct firmware *fw, const char *name, struct device *device)
 {
-	struct shash_desc *shash;
-	struct crypto_shash *alg;
-	u8 *sha256buf;
-	char *outbuf;
+	u8 digest[SHA256_DIGEST_SIZE];
 
-	alg = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(alg))
-		return;
-
-	sha256buf = kmalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
-	outbuf = kmalloc(SHA256_BLOCK_SIZE + 1, GFP_KERNEL);
-	shash = kmalloc(sizeof(*shash) + crypto_shash_descsize(alg), GFP_KERNEL);
-	if (!sha256buf || !outbuf || !shash)
-		goto out_free;
-
-	shash->tfm = alg;
-
-	if (crypto_shash_digest(shash, fw->data, fw->size, sha256buf) < 0)
-		goto out_free;
-
-	for (int i = 0; i < SHA256_DIGEST_SIZE; i++)
-		sprintf(&outbuf[i * 2], "%02x", sha256buf[i]);
-	outbuf[SHA256_BLOCK_SIZE] = 0;
-	dev_dbg(device, "Loaded FW: %s, sha256: %s\n", name, outbuf);
-
-out_free:
-	kfree(shash);
-	kfree(outbuf);
-	kfree(sha256buf);
-	crypto_free_shash(alg);
+	sha256(fw->data, fw->size, digest);
+	dev_dbg(device, "Loaded FW: %s, sha256: %*phN\n",
+		name, SHA256_DIGEST_SIZE, digest);
 }
 #else
 static void fw_log_firmware_info(const struct firmware *fw, const char *name,
 				 struct device *device)
 {}

base-commit: 33035b665157558254b3c21c3f049fd728e72368
-- 
2.49.0

