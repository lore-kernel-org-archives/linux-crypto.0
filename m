From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: algif_skcipher - initialize upon init request
Date: Sun, 30 Nov 2014 10:55:26 +0100
Message-ID: <2770903.h32OWUVXRy@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54839 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaK3Jza (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Nov 2014 04:55:30 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S9D83> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 30 Nov 2014 10:55:26 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When using the algif_skcipher, the following call sequence causess a
re-initialization:

1. sendmsg with ALG_SET_OP and iov == NULL, iovlen == 0 (i.e
initializing the cipher, but not sending data)

2. sendmsg with msg->msg-controllen == 0 and iov != NULL (using the initalized
cipher handle by sending data)

In step 2, the cipher operation type (encryption or decryption) is reset
to always decryption, because the local variable of enc is put into
ctx->enc as ctx->user is still zero.

The same applies when all send data is processed and ctx->used falls to
zero followed by user space to send new data.

This patch changes the behavior to only reset the cipher operation type
(and the IV) if such configuration request is received.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f80e652..1f157c7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -251,6 +251,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
+	bool init = 0;
 	int err;
 	int i;
 
@@ -259,6 +260,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 		if (err)
 			return err;
 
+		init = 1;
 		switch (con.op) {
 		case ALG_OP_ENCRYPT:
 			enc = 1;
@@ -280,7 +282,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	if (!ctx->more && ctx->used)
 		goto unlock;
 
-	if (!ctx->used) {
+	if (init) {
 		ctx->enc = enc;
 		if (con.iv)
 			memcpy(ctx->iv, con.iv->iv, ivsize);
-- 
2.1.0
