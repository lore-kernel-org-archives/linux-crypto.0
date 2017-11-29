From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2] crypto: AF_ALG - wait for data at beginning of recvmsg
Date: Wed, 29 Nov 2017 12:02:23 +0100
Message-ID: <5089033.JsYCqWMXId@positron.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <2780580.3j7i2QamZF@tauon.chronox.de> <20171129104230.GA24369@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42654 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbdK2LC0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 06:02:26 -0500
In-Reply-To: <20171129104230.GA24369@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The wait for data is a non-atomic operation that can sleep and therefore
potentially release the socket lock. The release of the socket lock
allows another thread to modify the context data structure. The waiting
operation for new data therefore must be called at the beginning of
recvmsg. This prevents a race condition where checks of the members of
the context data structure are performed by recvmsg while there is a
potential for modification of these values.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 6 ------
 crypto/algif_aead.c     | 6 ++++++
 crypto/algif_skcipher.c | 6 ++++++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index e720dfe962db..e75e188b145b 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1138,12 +1138,6 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 		if (!af_alg_readable(sk))
 			break;
 
-		if (!ctx->used) {
-			err = af_alg_wait_for_data(sk, flags);
-			if (err)
-				return err;
-		}
-
 		seglen = min_t(size_t, (maxsize - len),
 			       msg_data_left(msg));
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 7d2d162666e5..15e561dc47b5 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -111,6 +111,12 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
 
+	if (!ctx->used) {
+		err = af_alg_wait_for_data(sk, flags);
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Data length provided by caller via sendmsg/sendpage that has not
 	 * yet been processed.
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 30cff827dd8f..6fb595cd63ac 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -72,6 +72,12 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	int err = 0;
 	size_t len = 0;
 
+	if (!ctx->used) {
+		err = af_alg_wait_for_data(sk, flags);
+		if (err)
+			return err;
+	}
+
 	/* Allocate cipher request for current operation. */
 	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
 				     crypto_skcipher_reqsize(tfm));
-- 
2.14.3
