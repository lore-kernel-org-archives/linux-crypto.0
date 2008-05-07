From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 02/n]: Remove printk_ratelimit() for debugging printk
Date: Wed, 07 May 2008 14:15:38 +0200
Message-ID: <48219D6A.3060208@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030309060109080401080006"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62111 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYEGMQR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:16:17 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030309060109080401080006
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------030309060109080401080006
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit 9dbbaf326c4033cd8d973cb6bf10298faf50180c
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:38:01 2008 +0200

    [HIFN]: Remove printk_ratelimit() for debugging printk
    
    Without debugging this spams the log with "printk: N messages surpressed"
    without any actual messages on error. With debugging its more useful to
    always see the message.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index d7a51ee..e5c3bc4 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1651,7 +1651,7 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 err_out:
 	spin_unlock_irqrestore(&dev->lock, flags);
 err_out_exit:
-	if (err && printk_ratelimit())
+	if (err)
 		dprintk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
 				"type: %u, err: %d.\n",
 			dev->name, ctx->iv, ctx->ivsize,

--------------030309060109080401080006--
