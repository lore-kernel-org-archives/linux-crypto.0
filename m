From: Pirabarlen-Cheenaramen <selven@hackers.mu>
Subject: [PATCH] crypto: testmgr: clean up memory for sensitive information
Date: Sun, 23 Apr 2017 01:40:56 +0200
Message-ID: <20170422234056.GA25272@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from walmailout02.yourhostingaccount.com ([65.254.253.197]:37446
        "EHLO walmailout02.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1427384AbdDWAlz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Apr 2017 20:41:55 -0400
Received: from mailscan05.yourhostingaccount.com ([10.1.15.5] helo=walmailscan05.yourhostingaccount.com)
        by walmailout02.yourhostingaccount.com with esmtp (Exim)
        id 1d24eF-000145-QO
        for linux-crypto@vger.kernel.org; Sat, 22 Apr 2017 19:41:03 -0400
Received: from [10.114.3.33] (helo=walimpout13)
        by walmailscan05.yourhostingaccount.com with esmtp (Exim)
        id 1d24eF-0007xr-Nj
        for linux-crypto@vger.kernel.org; Sat, 22 Apr 2017 19:41:03 -0400
Received: from x1-6-50-6a-03-e0-98-fa.cpe.webspeed.dk ([188.181.91.111]:58504 helo=hackers.mu)
        by walauthsmtp07.yourhostingaccount.com with esmtpa (Exim)
        id 1d24eC-0007f7-Bi
        for linux-crypto@vger.kernel.org; Sat, 22 Apr 2017 19:41:00 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Pirabarlen-Cheenaramen <selven@hackers.mu>
---
 crypto/testmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index cd075c7..0af2e16 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -953,8 +953,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 out_noaxbuf:
 	testmgr_free_buf(xbuf);
 out_noxbuf:
-	kfree(key);
-	kfree(iv);
+	kzfree(key);
+	kzfree(iv);
 	return ret;
 }
 
-- 
1.9.1
