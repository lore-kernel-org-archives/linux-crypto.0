From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v3] crypto: AF_ALG - whitelist mask and type
Date: Tue, 02 Jan 2018 08:53:41 +0100
Message-ID: <2019517.bqA8BTu5nT@positron.chronox.de>
References: <001a1141c43ad30ccf055efb76ed@google.com> <1779114.sJA4SrkMo1@tauon.chronox.de> <20171222075843.GB27971@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ebiggers3@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44346 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbeABHxo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jan 2018 02:53:44 -0500
In-Reply-To: <20171222075843.GB27971@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The user space interface allows specifying the type and mask field used
to allocate the cipher. Only a subset of the possible flags are intended
for user space. Therefore, white-list the allowed flags.

In case the user space caller uses at least one non-allowed flag, EINVAL
is returned.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 35d4dcea381f..5231f421ad00 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -150,7 +150,7 @@ EXPORT_SYMBOL_GPL(af_alg_release_parent);
 
 static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
-	const u32 forbidden = CRYPTO_ALG_INTERNAL;
+	const u32 allowed = CRYPTO_ALG_KERN_DRIVER_ONLY;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct sockaddr_alg *sa = (void *)uaddr;
@@ -158,6 +158,10 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	void *private;
 	int err;
 
+	/* If caller uses non-allowed flag, return error. */
+	if ((sa->salg_feat & ~allowed) || (sa->salg_mask & ~allowed))
+		return -EINVAL;
+
 	if (sock->state == SS_CONNECTED)
 		return -EINVAL;
 
@@ -176,9 +180,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
-	private = type->bind(sa->salg_name,
-			     sa->salg_feat & ~forbidden,
-			     sa->salg_mask & ~forbidden);
+	private = type->bind(sa->salg_name, sa->salg_feat, sa->salg_mask);
 	if (IS_ERR(private)) {
 		module_put(type->owner);
 		return PTR_ERR(private);
-- 
2.14.3
