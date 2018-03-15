From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 03/12] crypto: inside-secure - wait for the request to complete if in the backlog
Date: Thu, 15 Mar 2018 16:38:42 +0100
Message-ID: <20180315153851.9958-4-antoine.tenart@bootlin.com>
References: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch updates the safexcel_hmac_init_pad() function to also wait
for completion when the digest return code is -EBUSY, as it would mean
the request is in the backlog to be processed later.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Suggested-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 4953a2a86c10..77268c9f1620 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -842,7 +842,7 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
 		init_completion(&result.completion);
 
 		ret = crypto_ahash_digest(areq);
-		if (ret == -EINPROGRESS) {
+		if (ret == -EINPROGRESS || ret == -EBUSY) {
 			wait_for_completion_interruptible(&result.completion);
 			ret = result.error;
 		}
-- 
2.14.3
