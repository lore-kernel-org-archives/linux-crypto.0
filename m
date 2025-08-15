Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4992183CC3;
	Fri, 15 Aug 2025 02:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755224723; cv=none; b=SHqc2xER+6Hp7oZuBaijVCzbdtxqYl8CeuCAx9pfGwyeDvvaZBWGjtwh64nMJ1j3gz3BhWQoGzRyrWmDJ+jv4RynrLL+9ZjzcZikIN/1KUfgxvcvS3dBZG8N7AvLASd2pGOyECBeKfCAXLSE/jEgFsvinB/+FtQfKpr828yTc24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755224723; c=relaxed/simple;
	bh=5EFxFjMUvSIxBtEdosXGJt6PnEhQZcoytIvxjB0sWMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TgPt5vDdoDKbiXqnKf4fbL7eyBr11wS98wFqJejtorcqOyqhYhCSLYvQGDpKI6n0Hgdy3nmIIEWOF0vTGpIEp9xfHv9+urTNn82fUoIk2YMSZpUzwXdtl++AIs2H/b45WI4e+OzldkTupSVhnz2xC9PCEe/ES/0sjE30d4v8t88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAIwhBCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAIwhBCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2C6C4CEED;
	Fri, 15 Aug 2025 02:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755224722;
	bh=5EFxFjMUvSIxBtEdosXGJt6PnEhQZcoytIvxjB0sWMo=;
	h=From:To:Cc:Subject:Date:From;
	b=EAIwhBCEhzFJssg/juRoAQiY0vZBhzG9HO9GMM0WYTOQqFrzP2IDynJrUJ3HDvioN
	 yOj7EYcMHyaEE3gFe4iBlpJf54Sb/Ye2Mi1lRttEOg92mUIDm1qe77ocOzngYZZgxR
	 9ghq6UZiU9xIFX/cpEvvOCg1kjZbGf+Z5Z2i8QgD+3QzMn6pkJLuPz/SaCeUKaMQYg
	 mddjIg3Fohj6+cErQwRglcAzRLy6LgHZ70LMsL8OhwpSk6lfmg76Yg9ncuLH1kPbXs
	 cfpQ7FpdYiMYjBfkZxBTRZz123Pf3xuJIXfxM0jfo2GmZNru/ix82eOtA2+n9de2qe
	 yaK+d6bY7Q/IQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
	netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next] nfc: s3fwrn5: Use SHA-1 library instead of crypto_shash
Date: Thu, 14 Aug 2025 19:23:29 -0700
Message-ID: <20250815022329.28672-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that a SHA-1 library API is available, use it instead of
crypto_shash.  This is simpler and faster.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nfc/s3fwrn5/Kconfig    |  3 +--
 drivers/nfc/s3fwrn5/firmware.c | 17 +----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
index 8a6b1a79de253..96386b73fa2b6 100644
--- a/drivers/nfc/s3fwrn5/Kconfig
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -1,10 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NFC_S3FWRN5
 	tristate
-	select CRYPTO
-	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA1
 	help
 	  Core driver for Samsung S3FWRN5 NFC chip. Contains core utilities
 	  of chip. It's intended to be used by PHYs to avoid duplicating lots
 	  of common code.
 
diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 781cdbcac104c..64d61b2a715ae 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -6,11 +6,10 @@
  * Robert Baldyga <r.baldyga@samsung.com>
  */
 
 #include <linux/completion.h>
 #include <linux/firmware.h>
-#include <crypto/hash.h>
 #include <crypto/sha1.h>
 
 #include "s3fwrn5.h"
 #include "firmware.h"
 
@@ -409,31 +408,17 @@ bool s3fwrn5_fw_check_version(const struct s3fwrn5_fw_info *fw_info, u32 version
 int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 {
 	struct device *dev = &fw_info->ndev->nfc_dev->dev;
 	struct s3fwrn5_fw_image *fw = &fw_info->fw;
 	u8 hash_data[SHA1_DIGEST_SIZE];
-	struct crypto_shash *tfm;
 	u32 image_size, off;
 	int ret;
 
 	image_size = fw_info->sector_size * fw->image_sectors;
 
 	/* Compute SHA of firmware data */
-
-	tfm = crypto_alloc_shash("sha1", 0, 0);
-	if (IS_ERR(tfm)) {
-		dev_err(dev, "Cannot allocate shash (code=%pe)\n", tfm);
-		return PTR_ERR(tfm);
-	}
-
-	ret = crypto_shash_tfm_digest(tfm, fw->image, image_size, hash_data);
-
-	crypto_free_shash(tfm);
-	if (ret) {
-		dev_err(dev, "Cannot compute hash (code=%d)\n", ret);
-		return ret;
-	}
+	sha1(fw->image, image_size, hash_data);
 
 	/* Firmware update process */
 
 	dev_info(dev, "Firmware update: %s\n", fw_info->fw_name);
 

base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.50.1

