From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] crypto: pcrypt - fix freeing pcrypt instances
Date: Thu, 21 Dec 2017 09:54:36 +0100
Message-ID: <CACT4Y+Yeo0wsui3i66jyED5O8ziVODxgfiJ-Yfdf6iZQ94XCoA@mail.gmail.com>
References: <94eb2c05a380d3908b056096eb58@google.com> <20171220222825.207321-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>,
        stable <stable@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:35418 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbdLUIy5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 03:54:57 -0500
Received: by mail-pl0-f68.google.com with SMTP id b96so10619717pli.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Dec 2017 00:54:57 -0800 (PST)
In-Reply-To: <20171220222825.207321-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:28 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> pcrypt is using the old way of freeing instances, where the ->free()
> method specified in the 'struct crypto_template' is passed a pointer to
> the 'struct crypto_instance'.  But the crypto_instance is being
> kfree()'d directly, which is incorrect because the memory was actually
> allocated as an aead_instance, which contains the crypto_instance at a
> nonzero offset.  Thus, the wrong pointer was being kfree()'d.


That's interesting. KASAN does not detect frees of invalid pointers
(e.g. into a middle of an object). It should.
I've requested a component for KASAN in kernel bugzilla to file this
(not sure if anybody is actually reading these emails), and so far
filed it in an internal bug tracker.


> Fix it by switching to the new way to free aead_instance's where the
> ->free() method is specified in the aead_instance itself.
>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 0496f56065e0 ("crypto: pcrypt - Add support for new AEAD interface")
> Cc: <stable@vger.kernel.org> # v4.2+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/pcrypt.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index ee9cfb99fe25..f8ec3d4ba4a8 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -254,6 +254,14 @@ static void pcrypt_aead_exit_tfm(struct crypto_aead *tfm)
>         crypto_free_aead(ctx->child);
>  }
>
> +static void pcrypt_free(struct aead_instance *inst)
> +{
> +       struct pcrypt_instance_ctx *ctx = aead_instance_ctx(inst);
> +
> +       crypto_drop_aead(&ctx->spawn);
> +       kfree(inst);
> +}
> +
>  static int pcrypt_init_instance(struct crypto_instance *inst,
>                                 struct crypto_alg *alg)
>  {
> @@ -319,6 +327,8 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
>         inst->alg.encrypt = pcrypt_aead_encrypt;
>         inst->alg.decrypt = pcrypt_aead_decrypt;
>
> +       inst->free = pcrypt_free;
> +
>         err = aead_register_instance(tmpl, inst);
>         if (err)
>                 goto out_drop_aead;
> @@ -349,14 +359,6 @@ static int pcrypt_create(struct crypto_template *tmpl, struct rtattr **tb)
>         return -EINVAL;
>  }
>
> -static void pcrypt_free(struct crypto_instance *inst)
> -{
> -       struct pcrypt_instance_ctx *ctx = crypto_instance_ctx(inst);
> -
> -       crypto_drop_aead(&ctx->spawn);
> -       kfree(inst);
> -}
> -
>  static int pcrypt_cpumask_change_notify(struct notifier_block *self,
>                                         unsigned long val, void *data)
>  {
> @@ -469,7 +471,6 @@ static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
>  static struct crypto_template pcrypt_tmpl = {
>         .name = "pcrypt",
>         .create = pcrypt_create,
> -       .free = pcrypt_free,
>         .module = THIS_MODULE,
>  };
>
> --
> 2.15.1.620.gb9897f4670-goog
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20171220222825.207321-1-ebiggers3%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
