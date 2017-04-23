From: Codarren Velvindron <codarren@hackers.mu>
Subject: [PATCH] crypto: tcrypt: Zero iv before freeing it
Date: Sun, 23 Apr 2017 20:12:04 +0400
Message-ID: <20170423161204.GA9489@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout03.yourhostingaccount.com ([65.254.254.78]:48213 "EHLO
        walmailout03.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S971339AbdDWQnA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 12:43:00 -0400
Received: from mailscan10.yourhostingaccount.com ([10.1.15.10] helo=walmailscan10.yourhostingaccount.com)
        by walmailout03.yourhostingaccount.com with esmtp (Exim)
        id 1d2K7R-0000CI-V1
        for linux-crypto@vger.kernel.org; Sun, 23 Apr 2017 12:12:13 -0400
Received: from [10.114.3.32] (helo=walimpout12)
        by walmailscan10.yourhostingaccount.com with esmtp (Exim)
        id 1d2K7R-0008MJ-Rr
        for linux-crypto@vger.kernel.org; Sun, 23 Apr 2017 12:12:13 -0400
Received: from [197.226.251.189] (port=42108 helo=hackers.mu)
        by walauthsmtp12.yourhostingaccount.com with esmtpa (Exim)
        id 1d2K7N-0003Tt-VR
        for linux-crypto@vger.kernel.org; Sun, 23 Apr 2017 12:12:10 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Codarren Velvindron <codarren@hackers.mu>
---
 crypto/tcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9a11f3c..48a721c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -384,7 +384,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 out_noaxbuf:
 	testmgr_free_buf(xbuf);
 out_noxbuf:
-	kfree(iv);
+	kzfree(iv);
 	return;
 }
 
-- 
2.7.4
