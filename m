From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 04/n]: Handle ablkcipher_walk errors
Date: Wed, 07 May 2008 14:20:34 +0200
Message-ID: <48219E92.20802@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040800020906090702030307"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYEGMVN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:21:13 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040800020906090702030307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------040800020906090702030307
Content-Type: text/x-diff;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

commit 7e24c849df30a5d2b0bb89165b933ea2faa747bd
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:43:20 2008 +0200

    [HIFN]: Handle ablkcipher_walk errors
    
    ablkcipher_walk may return a negative error value, handle this properly
    instead of treating it as a huge number of scatter-gather elements.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index cce6e6f..4e89cd8 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1602,7 +1602,10 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	idx = 0;
 
 	sg_num = ablkcipher_walk(req, &ctx->walk);
--------------040800020906090702030307--
