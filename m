From: Colin King <colin.king@canonical.com>
Subject: [PATCH][crypto-next] crypto: cavium: fix spelling mistake "Revsion" -> "Revision"
Date: Tue, 13 Jun 2017 09:52:54 +0100
Message-ID: <20170613085254.20855-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54930 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdFMIw7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 04:52:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in seq_printf message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index eee6fb501580..ae44a464cd2d 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -399,7 +399,7 @@ static int nitrox_show(struct seq_file *s, void *v)
 	struct nitrox_device *ndev = s->private;
 
 	seq_printf(s, "NITROX-5 [idx: %d]\n", ndev->idx);
-	seq_printf(s, "  Revsion ID: 0x%0x\n", ndev->hw.revision_id);
+	seq_printf(s, "  Revision ID: 0x%0x\n", ndev->hw.revision_id);
 	seq_printf(s, "  Cores [AE: %u  SE: %u]\n",
 		   ndev->hw.ae_cores, ndev->hw.se_cores);
 	seq_printf(s, "  Number of Queues: %u\n", ndev->nr_queues);
-- 
2.11.0
