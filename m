Return-Path: <SRS0=HgT6=OZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730772AbeLPXBF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Dec 2018 18:01:05 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jampala Srikanth <Jampala.Srikanth@cavium.com>
Subject: [PATCH] crypto: cavium/nitrox - Fix build with !CONFIG_DEBUG_FS
Date: Sun, 16 Dec 2018 15:00:30 -0800
Message-Id: <20181216230030.26206-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Fixes: cf718eaa8f9b ("crypto: cavium/nitrox - Enabled Mailbox support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
index 7b701ea6227af..a8d85ffa619ca 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
@@ -13,9 +13,8 @@ static inline int nitrox_debugfs_init(struct nitrox_device *ndev)
 	return 0;
 }
 
-static inline int nitrox_sriov_debugfs_init(struct nitrox_device *ndev)
+static inline void nitrox_debugfs_exit(struct nitrox_device *ndev)
 {
-	return 0;
 }
 #endif /* !CONFIG_DEBUG_FS */
 
-- 
2.19.2
