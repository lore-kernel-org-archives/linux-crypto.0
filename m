From: Robert Donald Rickett <robert.rickett@gmail.com>
Subject: [PATCH] crypto: wp512: fixed a brace coding style issue
Date: Mon, 15 Jan 2018 17:01:46 -0600
Message-ID: <20180115230146.fsj2tazvjd4yllqp@shadow1911>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        robert.rickett@gmail.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:38073 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeAOXBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 18:01:49 -0500
Received: by mail-yw0-f196.google.com with SMTP id m84so6036974ywd.5
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jan 2018 15:01:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed a coding style issue.

Signed-off-by: Robert Donald Rickett <robert.rickett@gmail.com>
---
 crypto/wp512.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/wp512.c b/crypto/wp512.c
index 7ee5a043a988..58983e23900d 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -993,9 +993,8 @@ static int wp512_init(struct shash_desc *desc) {
 	memset(wctx->bitLength, 0, 32);
 	wctx->bufferBits = wctx->bufferPos = 0;
 	wctx->buffer[0] = 0;
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++)
 		wctx->hash[i] = 0L;
-	}
 
 	return 0;
 }
-- 
2.14.1
