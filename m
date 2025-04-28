Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527451A8F7F;
	Mon, 28 Apr 2025 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745867907; cv=none; b=TwSBjSs+wCqqBvi4GD20HY2EijqZcTOO78/c7S6x7QsBw4w23xl7DMpFbvNzu8WSiUr2No3AYxnsCoSbDmFrjYJCTWu8F6x3FgJng/fEPwDEZas8+NIMX6tsu4SfhuaP0DxRXYIMzvBupkT2ff5ENNbmHssKQVxYYEVvO5Y0jko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745867907; c=relaxed/simple;
	bh=i/QKM52Nh1KGsdn9abmiVXQDvhwyr9YUB3yshFRt/jI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CBCwFX1XQGy7CsnozdlNRWy14/jgNMIgdOz+qDklDh4c9bGmtEL5NzYzG6hLaeN/CwkfpuZJS7tjtq91EQrl8yIt/6wVKla5xrQYjH6kIhYWets5BhJ0YNS16xkgDifTE+ePbJ0YrNJaocEfSBS4mFvwCKQrZqpl/zr4ytuekWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiUoHHBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiUoHHBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE04C4CEE4;
	Mon, 28 Apr 2025 19:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745867906;
	bh=i/QKM52Nh1KGsdn9abmiVXQDvhwyr9YUB3yshFRt/jI=;
	h=From:To:Cc:Subject:Date:From;
	b=SiUoHHBfFUaCjrcHhCWfjHbXTsrf6I4Ov+fNENselLjh993Gozy+iF9itHD21rRkM
	 0uuk8If8HnS6gzaWAhO3mUDsdNgsEp6ItbhKdnQHoHuYItlQxEEpxhw1Uo/S1AAHhT
	 eJ5ZRNMbUKiqnb7fqPvg5Y2/K3H/ft+KzigimMFAyziEYPCYilz9K9Zz5N29X2Ye4r
	 0rTMOEOQn7dHiXU6iK8rhUnVSeQOogKGXJbdvtGyWBX3FzpPzi9TeAsida3waVOj7y
	 dbsvweahRMoSUOm7D1r/L0y6KwvFk2tMmxPvejnEtUfzbCDvPbcH5E3cjMDGhBAWPy
	 y/hU1TYTUoExg==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: use SHA-256 library API instead of crypto_shash API
Date: Mon, 28 Apr 2025 12:16:06 -0700
Message-ID: <20250428191606.856198-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/net/usb/Kconfig |  4 +---
 drivers/net/usb/r8152.c | 46 +++++++----------------------------------
 2 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 3c360d4f06352..370b32fc25880 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -99,13 +99,11 @@ config USB_RTL8150
 config USB_RTL8152
 	tristate "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 	select MII
 	select PHYLIB
 	select CRC32
-	select CRYPTO
-	select CRYPTO_HASH
-	select CRYPTO_SHA256
+	select CRYPTO_LIB_SHA256
 	help
 	  This option adds support for Realtek RTL8152 based USB 2.0
 	  10/100 Ethernet adapters and RTL8153 based USB 3.0 10/100/1000
 	  Ethernet adapters.
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2cab046749a92..67f5d30ffcbab 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -24,11 +24,11 @@
 #include <linux/usb/cdc.h>
 #include <linux/suspend.h>
 #include <linux/atomic.h>
 #include <linux/acpi.h>
 #include <linux/firmware.h>
-#include <crypto/hash.h>
+#include <crypto/sha2.h>
 #include <linux/usb/r8152.h>
 #include <net/gso.h>
 
 /* Information for net-next */
 #define NETNEXT_VERSION		"12"
@@ -4626,52 +4626,20 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
  * make sure the file is correct.
  */
 static long rtl8152_fw_verify_checksum(struct r8152 *tp,
 				       struct fw_header *fw_hdr, size_t size)
 {
-	unsigned char checksum[sizeof(fw_hdr->checksum)];
-	struct crypto_shash *alg;
-	struct shash_desc *sdesc;
-	size_t len;
-	long rc;
-
-	alg = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(alg)) {
-		rc = PTR_ERR(alg);
-		goto out;
-	}
-
-	if (crypto_shash_digestsize(alg) != sizeof(fw_hdr->checksum)) {
-		rc = -EFAULT;
-		dev_err(&tp->intf->dev, "digestsize incorrect (%u)\n",
-			crypto_shash_digestsize(alg));
-		goto free_shash;
-	}
+	u8 checksum[sizeof(fw_hdr->checksum)];
 
-	len = sizeof(*sdesc) + crypto_shash_descsize(alg);
-	sdesc = kmalloc(len, GFP_KERNEL);
-	if (!sdesc) {
-		rc = -ENOMEM;
-		goto free_shash;
-	}
-	sdesc->tfm = alg;
-
-	len = size - sizeof(fw_hdr->checksum);
-	rc = crypto_shash_digest(sdesc, fw_hdr->version, len, checksum);
-	kfree(sdesc);
-	if (rc)
-		goto free_shash;
+	BUILD_BUG_ON(sizeof(checksum) != SHA256_DIGEST_SIZE);
+	sha256(fw_hdr->version, size - sizeof(checksum), checksum);
 
-	if (memcmp(fw_hdr->checksum, checksum, sizeof(fw_hdr->checksum))) {
+	if (memcmp(fw_hdr->checksum, checksum, sizeof(checksum))) {
 		dev_err(&tp->intf->dev, "checksum fail\n");
-		rc = -EFAULT;
+		return -EFAULT;
 	}
-
-free_shash:
-	crypto_free_shash(alg);
-out:
-	return rc;
+	return 0;
 }
 
 static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
 {
 	const struct firmware *fw = rtl_fw->fw;

base-commit: 33035b665157558254b3c21c3f049fd728e72368
-- 
2.49.0

