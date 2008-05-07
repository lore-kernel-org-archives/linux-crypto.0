From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 03/n]: Indicate asynchronous processing to crypto API
Date: Wed, 07 May 2008 14:19:36 +0200
Message-ID: <48219E58.4000503@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090205000108090504050803"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62279 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbYEGMUQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:20:16 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090205000108090504050803
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------090205000108090504050803
Content-Type: text/x-diff;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

commit 835b2aece80670cd439ff74e51a647836f73d0ca
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:42:06 2008 +0200

    [HIFN]: Indicate asynchronous processing to crypto API
    
    hifn_setup_crypto() needs to return -EINPROGRESS on success to indicate
    asynchronous processing to the crypto API. This also means it must not
    return the errno code returned by hifn_process_queue(), if any.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e5c3bc4..cce6e6f 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2202,9 +2202,9 @@ static int hifn_setup_crypto(struct ablkcipher_request *req, u8 op,
 		return err;
 
 	if (dev->started < HIFN_QUEUE_LENGTH &&	dev->queue.qlen)
-		err = hifn_process_queue(dev);
+		hifn_process_queue(dev);
 
-	return err;
+	return -EINPROGRESS;
 }
 
 /*

--------------090205000108090504050803--
