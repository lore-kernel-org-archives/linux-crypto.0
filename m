From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2] crypto: AF_ALG - limit mask and type
Date: Tue, 19 Dec 2017 07:25:04 +0100
Message-ID: <3658547.Hu7AXH7hma@positron.chronox.de>
References: <001a1141c43ad30ccf055efb76ed@google.com> <4450500.tGvsruIfR8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, ebiggers3@gmail.com
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44400 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933780AbdLSGZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Dec 2017 01:25:07 -0500
In-Reply-To: <4450500.tGvsruIfR8@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The user space interface allows specifying the type and the mask field
used to allocate the cipher. As user space can precisely select the
desired cipher by using either the name or the driver name, additional
selection options for cipher are not considered necessary and relevant
for user space.

This fixes a bug where user space is able to cause one cipher to be
registered multiple times potentially exhausting kernel memory.

Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1e5353f62067..4f4cfc5a7ef3 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -150,7 +150,6 @@ EXPORT_SYMBOL_GPL(af_alg_release_parent);
 
 static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
-	const u32 forbidden = CRYPTO_ALG_INTERNAL;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct sockaddr_alg *sa = (void *)uaddr;
@@ -176,9 +175,12 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
-	private = type->bind(sa->salg_name,
-			     sa->salg_feat & ~forbidden,
-			     sa->salg_mask & ~forbidden);
+	/*
+	 * The use of the salg_feat and salg_mask are forbidden as they expose
+	 * too much of the low-level handling which is not suitable for
+	 * hostile code.
+	 */
+	private = type->bind(sa->salg_name, 0, 0);
 	if (IS_ERR(private)) {
 		module_put(type->owner);
 		return PTR_ERR(private);
-- 
2.14.3
