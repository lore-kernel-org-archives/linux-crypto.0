From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/6] crypto: sun4i-ss: fix spelling
Date: Wed, 10 Aug 2016 11:45:32 +0200
Message-ID: <1470822334-20672-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Two words are badly spelled, this patch respell them.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 7841d73..60031e0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -372,7 +372,7 @@ int sun4i_hash(struct ahash_request *areq)
  * I do not check RX FIFO size in this function since the size is 32
  * after each enabling and this function neither write more than 32 words.
  * If we come from the update part, we cannot have more than
- * 3 remainings bytes to write and SS is fast enought to not care about it.
+ * 3 remaining bytes to write and SS is fast enough to not care about it.
  */
 
 hash_final:
@@ -436,7 +436,7 @@ hash_final:
 
 	/*
 	 * Wait for SS to finish the hash.
-	 * The timeout could happen only in case of bad overcloking
+	 * The timeout could happen only in case of bad overclocking
 	 * or driver bug.
 	 */
 	i = 0;
-- 
2.7.3
