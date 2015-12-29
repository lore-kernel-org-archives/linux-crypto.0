From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: use-after-free in hash_sock_destruct
Date: Tue, 29 Dec 2015 16:28:29 +0100
Message-ID: <CACT4Y+bn=SOHH-Ac4fV9yCH2mwWjo2wUYD-omaeRJ=R0W7a+MQ@mail.gmail.com>
References: <CACT4Y+a8Y5qz7rODCJ9QJbVhNv2WmS+COx7dSejGU=3kBWjLLQ@mail.gmail.com>
 <20151229144037.GA5576@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: syzkaller <syzkaller@googlegroups.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37938 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbbL2P2u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2015 10:28:50 -0500
Received: by mail-wm0-f46.google.com with SMTP id b14so17306944wmb.1
        for <linux-crypto@vger.kernel.org>; Tue, 29 Dec 2015 07:28:50 -0800 (PST)
In-Reply-To: <20151229144037.GA5576@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 29, 2015 at 3:40 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Dec 17, 2015 at 01:59:50PM +0100, Dmitry Vyukov wrote:
>>
>> The following program causes use-after-free in hash_sock_destruct:
>
> This patch should fix the problem.  AFAIK everything that you have
> reported should now be fixed.  If you still have issues please
> resubmit them (and please cc me).  Thanks!

Thanks Herbert!
I will do another round of crypto testing with this patch (on top of
the other two patches) and report if I see any bugs.



> ---8<---
> Subject: crypto: af_alg - Disallow bind/setkey/... after accept(2)
>
> Each af_alg parent socket obtained by socket(2) corresponds to a
> tfm object once bind(2) has succeeded.  An accept(2) call on that
> parent socket creates a context which then uses the tfm object.
>
> Therefore as long as any child sockets created by accept(2) exist
> the parent socket must not be modified or freed.
>
> This patch guarantees this by using locks and a reference count
> on the parent socket.  Any attempt to modify the parent socket will
> fail with EBUSY.
>
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index a8e7aa3..f5a2426 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -125,6 +125,23 @@ int af_alg_release(struct socket *sock)
>  }
>  EXPORT_SYMBOL_GPL(af_alg_release);
>
> +void af_alg_release_parent(struct sock *sk)
> +{
> +       struct alg_sock *ask = alg_sk(sk);
> +       bool last;
> +
> +       sk = ask->parent;
> +       ask = alg_sk(sk);
> +
> +       lock_sock(sk);
> +       last = !--ask->refcnt;
> +       release_sock(sk);
> +
> +       if (last)
> +               sock_put(sk);
> +}
> +EXPORT_SYMBOL_GPL(af_alg_release_parent);
> +
>  static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  {
>         const u32 forbidden = CRYPTO_ALG_INTERNAL;
> @@ -133,6 +150,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>         struct sockaddr_alg *sa = (void *)uaddr;
>         const struct af_alg_type *type;
>         void *private;
> +       int err;
>
>         if (sock->state == SS_CONNECTED)
>                 return -EINVAL;
> @@ -160,16 +178,22 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>                 return PTR_ERR(private);
>         }
>
> +       err = -EBUSY;
>         lock_sock(sk);
> +       if (ask->refcnt)
> +               goto unlock;
>
>         swap(ask->type, type);
>         swap(ask->private, private);
>
> +       err = 0;
> +
> +unlock:
>         release_sock(sk);
>
>         alg_do_release(type, private);
>
> -       return 0;
> +       return err;
>  }
>
>  static int alg_setkey(struct sock *sk, char __user *ukey,
> @@ -188,14 +212,41 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
>         if (copy_from_user(key, ukey, keylen))
>                 goto out;
>
> +       err = -EBUSY;
> +       lock_sock(sk);
> +       if (ask->refcnt)
> +               goto unlock;
> +
>         err = type->setkey(ask->private, key, keylen);
>
> +unlock:
> +       release_sock(sk);
> +
>  out:
>         sock_kzfree_s(sk, key, keylen);
>
>         return err;
>  }
>
> +static int alg_setauthsize(struct sock *sk, unsigned int size)
> +{
> +       int err;
> +       struct alg_sock *ask = alg_sk(sk);
> +       const struct af_alg_type *type = ask->type;
> +
> +       err = -EBUSY;
> +       lock_sock(sk);
> +       if (ask->refcnt)
> +               goto unlock;
> +
> +       err = type->setauthsize(ask->private, size);
> +
> +unlock:
> +       release_sock(sk);
> +
> +       return err;
> +}
> +
>  static int alg_setsockopt(struct socket *sock, int level, int optname,
>                           char __user *optval, unsigned int optlen)
>  {
> @@ -224,7 +275,7 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
>                         goto unlock;
>                 if (!type->setauthsize)
>                         goto unlock;
> -               err = type->setauthsize(ask->private, optlen);
> +               err = alg_setauthsize(sk, optlen);
>         }
>
>  unlock:
> @@ -264,7 +315,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
>
>         sk2->sk_family = PF_ALG;
>
> -       sock_hold(sk);
> +       if (!ask->refcnt++)
> +               sock_hold(sk);
>         alg_sk(sk2)->parent = sk;
>         alg_sk(sk2)->type = type;
>
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 018afb2..589716f 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -30,6 +30,8 @@ struct alg_sock {
>
>         struct sock *parent;
>
> +       unsigned int refcnt;
> +
>         const struct af_alg_type *type;
>         void *private;
>  };
> @@ -67,6 +69,7 @@ int af_alg_register_type(const struct af_alg_type *type);
>  int af_alg_unregister_type(const struct af_alg_type *type);
>
>  int af_alg_release(struct socket *sock);
> +void af_alg_release_parent(struct sock *sk);
>  int af_alg_accept(struct sock *sk, struct socket *newsock);
>
>  int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
> @@ -83,11 +86,6 @@ static inline struct alg_sock *alg_sk(struct sock *sk)
>         return (struct alg_sock *)sk;
>  }
>
> -static inline void af_alg_release_parent(struct sock *sk)
> -{
> -       sock_put(alg_sk(sk)->parent);
> -}
> -
>  static inline void af_alg_init_completion(struct af_alg_completion *completion)
>  {
>         init_completion(&completion->completion);
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
