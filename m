From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 7/7] crypto: amcc: check return value of sg_nents_for_len
Date: Wed,  4 Nov 2015 21:13:39 +0100
Message-ID: <1446668045-8620-7-git-send-email-clabbe.montjoie@gmail.com>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, davem@davemloft.net,
	dmitry.torokhov@gmail.com, fabio.estevam@freescale.com,
	herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sg_nents_for_len() function could fail, this patch add a check for
its return value.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 27288fc..e6f7757 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -781,6 +781,10 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 
 	/* figure how many gd is needed */
 	num_gd = sg_nents_for_len(src, datalen);
+	if ((int)num_gd < 0) {
+		dev_err(dev->core_dev->device, "Invalid number of src SG.\n");
+		return -EINVAL;
+	}
 	if (num_gd == 1)
 		num_gd = 0;
 
-- 
2.4.10
