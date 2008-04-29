From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] crypto: Correct kzalloc error test
Date: Tue, 29 Apr 2008 15:38:15 +0200 (MEST)
Message-ID: <Pine.LNX.4.58.0804291536220.1185@pc-041.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:46475 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbYD2NiW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Apr 2008 09:38:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Normally, kzalloc returns NULL or a valid pointer value, not a value to be
tested using IS_ERR.

Signed-off-by: Julia Lawall <julia@diku.dk>
---
diff -u -p  a/crypto/cryptd.c b/crypto/cryptd.c
--- a/crypto/cryptd.c	2008-04-16 13:27:56.000000000 +0200
+++ b/crypto/cryptd.c	2008-04-29 15:29:54.000000000 +0200
@@ -190,7 +190,7 @@ static struct crypto_instance *cryptd_al
 	int err;

 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
-	if (IS_ERR(inst))
+	if (!inst)
 		goto out;

 	err = -ENAMETOOLONG;
