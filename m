From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: use-after-free in alg_bind
Date: Wed, 30 Dec 2015 20:24:17 +0800
Message-ID: <20151230122417.GA10774@gondor.apana.org.au>
References: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
 <20151230012436.GA8173@gondor.apana.org.au>
 <CACT4Y+ZUiiXUY06MEGQfz3FN8pugrNpSJb2QjMQ9CyRCP6kojw@mail.gmail.com>
 <20151230105300.GA10383@gondor.apana.org.au>
 <CACT4Y+ZG_e2NBTCG3Qa06-F79JwG0BxRHyMwwPsrZRMp80cqug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>,
	syzkaller <syzkaller@googlegroups.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59301 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbbL3MYZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Dec 2015 07:24:25 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZG_e2NBTCG3Qa06-F79JwG0BxRHyMwwPsrZRMp80cqug@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 30, 2015 at 11:58:58AM +0100, Dmitry Vyukov wrote:
>
> I forgot to diff include/crypto/if_alg.h, but the changes are there
> (otherwise all references to refcnt would not compile). Also I moved
> ask->refcnt checks to alg_setsockopt to fix the deadlock, I believe
> that's the missing chunks you refer to. I can retest if you wish, but
> I don't think that my changes can affect the reported use-after-free.
> Do you?

OK I see the problem now.  When accept fails we free the socket
twice.

---8<---
Subject: crypto: af_alg - Fix socket double-free when accept fails

When we fail an accept(2) call we will end up freeing the socket
twice, once due to the direct sk_free call and once again through
newsock.

This patch fixes this by removing the sk_free call.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7b5b592..eaf98e2 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -285,10 +285,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	security_sk_clone(sk, sk2);
 
 	err = type->accept(ask->private, sk2);
-	if (err) {
-		sk_free(sk2);
+	if (err)
 		goto unlock;
-	}
 
 	sk2->sk_family = PF_ALG;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
