From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: user - add MODULE_ALIAS
Date: Mon, 24 Nov 2014 17:12:45 +0100
Message-ID: <2012632.fnfABE5hEY@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-kernel@vger.kernel.org,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54809 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbaKXUNt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2014 15:13:49 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S8D96> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 24 Nov 2014 21:13:46 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To allow automatic loading of the crypto_user kernel module, the netlink
MODULE_ALIAS is added.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/crypto_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e2a34fe..255df95 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -537,3 +537,4 @@ module_exit(crypto_user_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
 MODULE_DESCRIPTION("Crypto userspace configuration API");
+MODULE_ALIAS("net-pf-16-proto-21");
-- 
2.1.0
