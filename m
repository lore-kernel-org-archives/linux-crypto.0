From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: use-after-free in alg_bind
Date: Wed, 30 Dec 2015 20:52:52 +0800
Message-ID: <20151230125252.GA10952@gondor.apana.org.au>
References: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
 <20151230012436.GA8173@gondor.apana.org.au>
 <CACT4Y+ZUiiXUY06MEGQfz3FN8pugrNpSJb2QjMQ9CyRCP6kojw@mail.gmail.com>
 <20151230105300.GA10383@gondor.apana.org.au>
 <CACT4Y+ZG_e2NBTCG3Qa06-F79JwG0BxRHyMwwPsrZRMp80cqug@mail.gmail.com>
 <20151230122417.GA10774@gondor.apana.org.au>
 <CACT4Y+Y2VW2QP7NmzjmDg-wjfhB=q-6CUJ6=CeEEt9yxDYomXw@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y2VW2QP7NmzjmDg-wjfhB=q-6CUJ6=CeEEt9yxDYomXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 30, 2015 at 01:45:15PM +0100, Dmitry Vyukov wrote:
>
> This seems to be a zero-day. Should we CC stable@vger.kernel.org ?
> 
> Code in 03c8efc1ffeb6b82a22c1af8dd908af349563314 (Oct 19, 2010) contained:
> 
> +       sock_init_data(newsock, sk2);
> +
> +       err = type->accept(ask->private, sk2);
> +       if (err) {
> +               sk_free(sk2);
> +               goto unlock;
> +       }
> 
> There were no sock_graft call, but sock_init_data also sets
> newsock->sk = sk2, which seems to be enough for the double-free.

But accept only started failing because the newly added has_key
check.  Otherwise the only way for it to fail is if we run out
of memory.

IOW the bug can only be easily triggered in the current crypto tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
