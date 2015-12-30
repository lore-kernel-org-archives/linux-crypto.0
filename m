From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: use-after-free in alg_bind
Date: Wed, 30 Dec 2015 11:58:58 +0100
Message-ID: <CACT4Y+ZG_e2NBTCG3Qa06-F79JwG0BxRHyMwwPsrZRMp80cqug@mail.gmail.com>
References: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
 <20151230012436.GA8173@gondor.apana.org.au> <CACT4Y+ZUiiXUY06MEGQfz3FN8pugrNpSJb2QjMQ9CyRCP6kojw@mail.gmail.com>
 <20151230105300.GA10383@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>,
	syzkaller <syzkaller@googlegroups.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151230105300.GA10383@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 30, 2015 at 11:53 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Dec 30, 2015 at 11:19:45AM +0100, Dmitry Vyukov wrote:
>>
>> This use-after-free does not reproduce on every run. It seems to be
>> triggered by some race. Try to run the program in a parallel loop.
>> I use stress tool for this:
>> https://github.com/golang/tools/blob/master/cmd/stress/stress.go
>> If you have Go toolchain installed, then then following will do:
>> $ go get golang.org/x/tools/cmd/stress
>> $ stress -p 16 ./a.out
>
> I've tried a few thousand instances of it but still no luck.
>>
>>
>> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
>> index a8e7aa3..82a7dcd 100644
>
> There are a few missing hunks in your patch and the patch to
> if_alg.h is missing.
>
> So please start with the current crypto tree and then apply the
> latest version (v2) of "crypto: af_alg - Disallow bind/setkey/...
> after accept(2)" and try again.


I forgot to diff include/crypto/if_alg.h, but the changes are there
(otherwise all references to refcnt would not compile). Also I moved
ask->refcnt checks to alg_setsockopt to fix the deadlock, I believe
that's the missing chunks you refer to. I can retest if you wish, but
I don't think that my changes can affect the reported use-after-free.
Do you?


diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 018afb2..589716f 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -30,6 +30,8 @@ struct alg_sock {

        struct sock *parent;

+       unsigned int refcnt;
+
        const struct af_alg_type *type;
        void *private;
 };
@@ -67,6 +69,7 @@ int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);

 int af_alg_release(struct socket *sock);
+void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock);

 int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
@@ -83,11 +86,6 @@ static inline struct alg_sock *alg_sk(struct sock *sk)
        return (struct alg_sock *)sk;
 }

-static inline void af_alg_release_parent(struct sock *sk)
-{
-       sock_put(alg_sk(sk)->parent);
-}
-
 static inline void af_alg_init_completion(struct af_alg_completion *completion)
 {
        init_completion(&completion->completion);
