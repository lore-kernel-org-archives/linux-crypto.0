From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: algif - suppress sending source address information in recvmsg
Date: Sun,  7 Apr 2013 14:05:39 +0200
Message-ID: <1365336339-403-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:46206 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491Ab3DGMGC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Apr 2013 08:06:02 -0400
Received: by mail-bk0-f49.google.com with SMTP id w12so2687140bku.22
        for <linux-crypto@vger.kernel.org>; Sun, 07 Apr 2013 05:06:01 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current code does not set the msg_namelen member to 0 and therefore
makes net/socket.c leak the local sockaddr_storage variable to userland
-- 128 bytes of kernel stack memory. Fix that.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 crypto/algif_hash.c     |    2 ++
 crypto/algif_skcipher.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..0262210 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -161,6 +161,8 @@ static int hash_recvmsg(struct kiocb *unused, struct socket *sock,
 	else if (len < ds)
 		msg->msg_flags |= MSG_TRUNC;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	if (ctx->more) {
 		ctx->more = 0;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..a1c4f0a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -432,6 +432,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 	long copied = 0;
 
 	lock_sock(sk);
+	msg->msg_namelen = 0;
 	for (iov = msg->msg_iov, iovlen = msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
 		unsigned long seglen = iov->iov_len;
-- 
1.7.10.4
