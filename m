From: Loganaden Velvindron <logan@hackers.mu>
Subject: [PATCH] crypto: ecc : Wipe memory for p on errors.
Date: Sat, 22 Apr 2017 15:31:34 +0400
Message-ID: <20170422113134.hzulmuvnveqg7sjq@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from walmailout06.yourhostingaccount.com ([65.254.253.50]:34541 "EHLO
        walmailout06.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1423019AbdDVMCX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Apr 2017 08:02:23 -0400
Received: from mailscan08.yourhostingaccount.com ([10.1.15.8] helo=walmailscan08.yourhostingaccount.com)
        by walmailout06.yourhostingaccount.com with esmtp (Exim)
        id 1d1tGZ-00045g-Bq
        for linux-crypto@vger.kernel.org; Sat, 22 Apr 2017 07:31:51 -0400
Received: from [10.114.3.31] (helo=walimpout11)
        by walmailscan08.yourhostingaccount.com with esmtp (Exim)
        id 1d1tGZ-0003fE-AQ
        for linux-crypto@vger.kernel.org; Sat, 22 Apr 2017 07:31:51 -0400
Received: from [197.226.251.188] (port=39382 helo=hackers.mu)
        by walauthsmtp16.yourhostingaccount.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim)
        id 1d1tGV-0003zn-CS
        for linux-crypto@vger.kernel.org; Sat, 22 Apr 2017 07:31:48 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Loganaden Velvindron <logan@hackers.mu>
---
 crypto/ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 414c78a..32f50c34 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -88,7 +88,7 @@ static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 err_alloc_y:
 	ecc_free_digits_space(p->x);
 err_alloc_x:
-	kfree(p);
+	kzfree(p);
 	return NULL;
 }
 
-- 
2.9.3
