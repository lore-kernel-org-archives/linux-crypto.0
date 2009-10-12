From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] crypto: Fix test in get_prng_bytes()
Date: Mon, 12 Oct 2009 15:09:09 +0200
Message-ID: <4AD32A75.5030706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58463 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbZJLNAa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2009 09:00:30 -0400
Received: by ewy4 with SMTP id 4so2423129ewy.37
        for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2009 05:59:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

size_t nbytes cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or should this test be removed?

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3aa6e38..9162456 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -192,7 +192,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 	int err;
 
 
-	if (nbytes < 0)
+	if ((ssize_t)nbytes < 0)
 		return -EINVAL;
 
 	spin_lock_bh(&ctx->prng_lock);
