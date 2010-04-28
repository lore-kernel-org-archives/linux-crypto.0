From: Dan Carpenter <error27@gmail.com>
Subject: [patch] crypto: cleanup: remove unneeded null check
Date: Wed, 28 Apr 2010 10:55:15 +0200
Message-ID: <20100428085515.GE29093@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Brad Bosch <bradbosch@comcast.net>,
	Richard Hartmann <richih.mailinglist@gmail.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37020 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0D1Izg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Apr 2010 04:55:36 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We don't check "frontend" consistently in crypto_init_spawn2().  We
check it at the start of the function but then we dereference it 
unconditionally in the parameter list when we call crypto_init_spawn().

I looked at the places that call crypto_init_spawn2() and "frontend" is
always a valid pointer so I removed the check for null.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 76fae27..c3cf1a6 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -544,7 +544,7 @@ int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
 {
 	int err = -EINVAL;
 
-	if (frontend && (alg->cra_flags ^ frontend->type) & frontend->maskset)
+	if ((alg->cra_flags ^ frontend->type) & frontend->maskset)
 		goto out;
 
 	spawn->frontend = frontend;
