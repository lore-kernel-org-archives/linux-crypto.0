From: David Miller <davem@davemloft.net>
Subject: [PATCH] crypto: Fix aead_{sendmsg,recvmsg}() signatures.
Date: Fri, 17 Apr 2015 15:19:53 -0400 (EDT)
Message-ID: <20150417.151953.196971237843380420.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46223 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbbDQTTz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 15:19:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The kiocb argument is no longer present.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 527d27b..95ad689 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -163,8 +163,7 @@ static void aead_data_wakeup(struct sock *sk)
 	rcu_read_unlock();
 }
 
-static int aead_sendmsg(struct kiocb *unused, struct socket *sock,
-			struct msghdr *msg, size_t size)
+static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -348,8 +347,8 @@ unlock:
 	return err ?: size;
 }
 
-static int aead_recvmsg(struct kiocb *unused, struct socket *sock,
-			struct msghdr *msg, size_t ignored, int flags)
+static int aead_recvmsg(struct socket *sock, struct msghdr *msg,
+			size_t ignored, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
