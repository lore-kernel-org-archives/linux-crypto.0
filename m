From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: algif_aead - fix uninitialized variable warning
Date: Thu, 08 Dec 2016 07:09:44 +0100
Message-ID: <1660604.GQeZumkfIP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39126 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbcLHGJr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 01:09:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case the user provided insufficient data, the code may return
prematurely without any operation. In this case, the processed
data indicated with outlen is zero.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 2fbf239..e9c0993 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -420,7 +420,7 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
 	int err = -ENOMEM;
 	unsigned long used;
-	size_t outlen;
+	size_t outlen = 0;
 	size_t usedpages = 0;
 
 	lock_sock(sk);
-- 
2.9.3
