From: Yasir Auleear <yasirmx@hackers.mu>
Subject: [PATCH]crypto:asymmetric_keys:verify_pefile:zero memory content
 before freeing
Date: Sun, 23 Apr 2017 15:18:03 -0400
Message-ID: <20170423191803.GA30354@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout03.yourhostingaccount.com ([65.254.254.78]:44041 "EHLO
        walmailout03.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1044783AbdDWLsm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 07:48:42 -0400
Received: from mailscan11.yourhostingaccount.com ([10.1.15.11] helo=walmailscan11.yourhostingaccount.com)
        by walmailout03.yourhostingaccount.com with esmtp (Exim)
        id 1d2FX2-0004mi-9R
        for linux-crypto@vger.kernel.org; Sun, 23 Apr 2017 07:18:20 -0400
Received: from [10.114.3.32] (helo=walimpout12)
        by walmailscan11.yourhostingaccount.com with esmtp (Exim)
        id 1d2FX2-0008JR-4t
        for linux-crypto@vger.kernel.org; Sun, 23 Apr 2017 07:18:20 -0400
Received: from [197.227.108.220] (port=44096 helo=hackers.mu)
        by walauthsmtp13.yourhostingaccount.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim)
        id 1d2FWy-0003BC-E3
        for linux-crypto@vger.kernel.org; Sun, 23 Apr 2017 07:18:16 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Yasir Auleear <yasirmx@hackers.mu>
---
 crypto/asymmetric_keys/verify_pefile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 672a94c..d178650 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -381,7 +381,7 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	}
 
 error:
-	kfree(desc);
+	kzfree(desc);
 error_no_desc:
 	crypto_free_shash(tfm);
 	kleave(" = %d", ret);
@@ -450,6 +450,6 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	ret = pefile_digest_pe(pebuf, pelen, &ctx);
 
 error:
-	kfree(ctx.digest);
+	kzfree(ctx.digest);
 	return ret;
 }
-- 
2.9.3
