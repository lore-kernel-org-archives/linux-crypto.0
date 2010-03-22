From: Dan Carpenter <error27@gmail.com>
Subject: [patch v3] pcrypt: handle crypto_get_attr_type() errors
Date: Mon, 22 Mar 2010 18:28:45 +0300
Message-ID: <20100322152845.GT21571@bicker>
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com> <20100322135319.GQ21571@bicker> <20100322145357.GK20508@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32892 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0CVP2z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Mar 2010 11:28:55 -0400
Content-Disposition: inline
In-Reply-To: <20100322145357.GK20508@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was concerned about the error handling for crypto_get_attr_type() in
pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply
avoid calling crypto_get_attr_type() if we passed the type and mask as a
parameters.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
All three versions have basically been the same except for style issues.
I will confess that this (hopefully final :P) version looks much nicer 
than the earlier ones.

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8020124..247178c 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -315,16 +315,13 @@ out_free_inst:
 	goto out;
 }
 
-static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
+static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
+						 u32 type, u32 mask)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	struct crypto_attr_type *algt;
