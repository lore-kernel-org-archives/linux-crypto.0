From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2] crypto: algif_skcipher - Require setkey before accept(2)
Date: Mon, 28 Dec 2015 14:39:43 +0100
Message-ID: <CACT4Y+Y-K+QTNw3ZokVrRz4pCvMUN6GqRjDGdd1H2M=Qp1GRYA@mail.gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <20151225074005.GA14690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: syzkaller <syzkaller@googlegroups.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151225074005.GA14690@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 25, 2015 at 8:40 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Dmitry Vyukov <dvyukov@google.com> wrote:
>>
>> I am testing with your two patches:
>> crypto: algif_skcipher - Use new skcipher interface
>> crypto: algif_skcipher - Require setkey before accept(2)
>> on top of a88164345b81292b55a8d4829fdd35c8d611cd7d (Dec 23).
>
> You sent the email to everyone on the original CC list except me.
> Please don't do that.

Hi Herbert,

My email client just followed instructions in your email. You've said
to Reply-to: syzkaller@googlegroups.com.

This version of the patch does fix the crash.

Tested-by: Dmitry Vyukov <dvyukov@google.com>

However, crypto is still considerably unstable. I will post reports
that I see separately.


>> Now the following program causes a bunch of use-after-frees and them
>> kills kernel:
>
> Yes there is an obvious bug in the patch that Julia Lawall has
> responded to in another thread.  Here is a fixed version.
>
> ---8<--
> Some cipher implementations will crash if you try to use them
> without calling setkey first.  This patch adds a check so that
> the accept(2) call will fail with -ENOKEY if setkey hasn't been
> done on the socket yet.
>
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 5c756b3..f4431bc 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -31,6 +31,11 @@ struct skcipher_sg_list {
>         struct scatterlist sg[0];
>  };
>
> +struct skcipher_tfm {
> +       struct crypto_skcipher *skcipher;
> +       bool has_key;
> +};
> +
>  struct skcipher_ctx {
>         struct list_head tsgl;
>         struct af_alg_sgl rsgl;
> @@ -750,17 +755,41 @@ static struct proto_ops algif_skcipher_ops = {
>
>  static void *skcipher_bind(const char *name, u32 type, u32 mask)
>  {
> -       return crypto_alloc_skcipher(name, type, mask);
> +       struct skcipher_tfm *tfm;
> +       struct crypto_skcipher *skcipher;
> +
> +       tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
> +       if (!tfm)
> +               return ERR_PTR(-ENOMEM);
> +
> +       skcipher = crypto_alloc_skcipher(name, type, mask);
> +       if (IS_ERR(skcipher)) {
> +               kfree(tfm);
> +               return ERR_CAST(skcipher);
> +       }
> +
> +       tfm->skcipher = skcipher;
> +
> +       return tfm;
>  }
>
>  static void skcipher_release(void *private)
>  {
> -       crypto_free_skcipher(private);
> +       struct skcipher_tfm *tfm = private;
> +
> +       crypto_free_skcipher(tfm->skcipher);
> +       kfree(tfm);
>  }
>
>  static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
>  {
> -       return crypto_skcipher_setkey(private, key, keylen);
> +       struct skcipher_tfm *tfm = private;
> +       int err;
> +
> +       err = crypto_skcipher_setkey(tfm->skcipher, key, keylen);
> +       tfm->has_key = !err;
> +
> +       return err;
>  }
>
>  static void skcipher_wait(struct sock *sk)
> @@ -792,20 +821,25 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
>  {
>         struct skcipher_ctx *ctx;
>         struct alg_sock *ask = alg_sk(sk);
> -       unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(private);
> +       struct skcipher_tfm *tfm = private;
> +       struct crypto_skcipher *skcipher = tfm->skcipher;
> +       unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(skcipher);
> +
> +       if (!tfm->has_key)
> +               return -ENOKEY;
>
>         ctx = sock_kmalloc(sk, len, GFP_KERNEL);
>         if (!ctx)
>                 return -ENOMEM;
>
> -       ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(private),
> +       ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(skcipher),
>                                GFP_KERNEL);
>         if (!ctx->iv) {
>                 sock_kfree_s(sk, ctx, len);
>                 return -ENOMEM;
>         }
>
> -       memset(ctx->iv, 0, crypto_skcipher_ivsize(private));
> +       memset(ctx->iv, 0, crypto_skcipher_ivsize(skcipher));
>
>         INIT_LIST_HEAD(&ctx->tsgl);
>         ctx->len = len;
> @@ -818,7 +852,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
>
>         ask->private = ctx;
>
> -       skcipher_request_set_tfm(&ctx->req, private);
> +       skcipher_request_set_tfm(&ctx->req, skcipher);
>         skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>                                       af_alg_complete, &ctx->completion);
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To post to this group, send email to syzkaller@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20151225074005.GA14690%40gondor.apana.org.au.
> For more options, visit https://groups.google.com/d/optout.
