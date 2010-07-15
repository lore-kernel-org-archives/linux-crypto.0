From: Dan Carpenter <error27@gmail.com>
Subject: [patch] crypto/ablkcipher: missing return statement
Date: Thu, 15 Jul 2010 09:57:36 +0200
Message-ID: <20100715075736.GC5164@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Richard Hartmann <richih.mailinglist@gmail.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45790 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab0GOH7D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jul 2010 03:59:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The intent was to return here.  In the original an allocation failure
would lead to a NULL dereference.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 98a6610..a854df2 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -165,7 +165,7 @@ static inline int ablkcipher_next_slow(struct ablkcipher_request *req,
 
 	p = kmalloc(n, GFP_ATOMIC);
 	if (!p)
-		ablkcipher_walk_done(req, walk, -ENOMEM);
+		return ablkcipher_walk_done(req, walk, -ENOMEM);
 
 	base = p + 1;
 
