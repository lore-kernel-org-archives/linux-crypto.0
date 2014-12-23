From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG: zeroize key data
Date: Tue, 23 Dec 2014 09:34:03 +0100
Message-ID: <4092638.L73RGXcGnC@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51006 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbaLWIeH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2014 03:34:07 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SD610> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 23 Dec 2014 09:34:04 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

alg_setkey should zeroize the sensitive data after use.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a8ff3c4..76d739d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -188,7 +188,7 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	err = type->setkey(ask->private, key, keylen);
 
 out:
-	sock_kfree_s(sk, key, keylen);
+	sock_kzfree_s(sk, key, keylen);
 
 	return err;
 }
-- 
2.1.0
