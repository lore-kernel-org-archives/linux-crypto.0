From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: bfin_crc: Remove unneeded linux/miscdevice.h include
Date: Thu, 15 Dec 2016 10:59:43 +0100
Message-ID: <20161215095943.10015-2-clabbe.montjoie@gmail.com>
References: <20161215095943.10015-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161215095943.10015-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

bfin_crc.h driver does not use any miscdevice, so this patch remove this
unnecessary inclusion.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/bfin_crc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/bfin_crc.h b/drivers/crypto/bfin_crc.h
index 75cef4d..786ef74 100644
--- a/drivers/crypto/bfin_crc.h
+++ b/drivers/crypto/bfin_crc.h
@@ -55,7 +55,6 @@ struct crc_info {
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/miscdevice.h>
 
 struct crc_register {
 	u32 control;
-- 
2.10.2
