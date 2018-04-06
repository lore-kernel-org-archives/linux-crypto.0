From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] crypto: chtls: remove redundant assignment to cdev->ports
Date: Fri,  6 Apr 2018 17:58:47 +0100
Message-ID: <20180406165847.29310-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a double assignment to cdev->ports, the first is redundant
as it is over-written so remove it.

Detected by CoverityScan, CID#1467432 ("Unused value")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 007c45c38fc7..984a53f19f8b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -216,7 +216,6 @@ static void *chtls_uld_add(const struct cxgb4_lld_info *info)
 	cdev->lldi = lldi;
 	cdev->pdev = lldi->pdev;
 	cdev->tids = lldi->tids;
-	cdev->ports = (struct net_device **)(cdev + 1);
 	cdev->ports = lldi->ports;
 	cdev->mtus = lldi->mtus;
 	cdev->tids = lldi->tids;
-- 
2.15.1
