From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 06/17] crypto: inside-secure - EBUSY is not an error on async request
Date: Thu, 14 Dec 2017 15:26:48 +0100
Message-ID: <20171214142659.16987-7-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Ofer Heifetz <oferh@marvell.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36779 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbdLNOaF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:05 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ofer Heifetz <oferh@marvell.com>

When initializing the IVs crypto_ahash_update() is called, which at some
point will call crypto_enqueue_request(). This function can return
-EBUSY when no resource is available and the request is queued. Since
this is a valid case, -EBUSY shouldn't be treated as an error.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: commit message]
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index d156637d6144..4a4d95302a93 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -862,7 +862,7 @@ static int safexcel_hmac_init_iv(struct ahash_request *areq,
 	req->last_req = true;
 
 	ret = crypto_ahash_update(areq);
-	if (ret && ret != -EINPROGRESS)
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
 		return ret;
 
 	wait_for_completion_interruptible(&result.completion);
-- 
2.14.3
