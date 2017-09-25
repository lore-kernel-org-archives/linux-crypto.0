From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 3/5] crypto: chelsio: pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 16:06:14 +0530
Message-ID: <1506335776-1887-4-git-send-email-arvind.yadav.cs@gmail.com>
References: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, arei.gonglei@huawei.com, harsh@chelsio.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34318 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934593AbdIYKhb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2017 06:37:31 -0400
In-Reply-To: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/chelsio/chcr_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index b6dd9cb..32618bf 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -224,7 +224,7 @@ static int chcr_uld_state_change(void *handle, enum cxgb4_state state)
 static int __init chcr_crypto_init(void)
 {
 	if (cxgb4_register_uld(CXGB4_ULD_CRYPTO, &chcr_uld_info))
-		pr_err("ULD register fail: No chcr crypto support in cxgb4");
+		pr_err("ULD register fail: No chcr crypto support in cxgb4\n");
 
 	return 0;
 }
-- 
1.9.1
