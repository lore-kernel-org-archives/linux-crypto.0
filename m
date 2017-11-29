From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - wait for data at beginning of recvmsg
Date: Wed, 29 Nov 2017 11:17:26 +0100
Message-ID: <1970731.rxTGvFCgCz@positron.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <20171129071049.GA23023@gondor.apana.org.au> <2948680.ShXD61QQGe@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42628 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754207AbdK2KRa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 05:17:30 -0500
In-Reply-To: <2948680.ShXD61QQGe@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The wait for data is a non-atomic operation that can sleep and therefore
potentially release the socket lock. The release of the socket lock
allows another thread to modify the context data structure. The waiting
operation for new data therefore must be called at the beginning of
recvmsg. This prevents a race condition where checks of the members of
the context data structure are performed by recvmsg while there is a
potential for modification of these values.

For skcipher, ctx->used is used as an indicator whether to wait for new
data, because skcipher can operate on a subset of the overall data
to be processed.

In contrast, aead must check ctx->more which is a flag set by user space
indicating that all data has been sent. It is required for aead to wait
until all data intended to be send by the caller are received as
the authentication operation part of the aead cipher requires the
presence of the whole data.

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
index 7d2d162666e5..97243068af15 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -111,6 +111,12 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
 
+	if (ctx->more) {
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
