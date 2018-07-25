From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v6 10/18] x86/power/64: Remove VLA usage
Date: Wed, 25 Jul 2018 13:32:23 +0200
Message-ID: <CAJZ5v0gVDotjufLKUW0YuQu2vA4fmU_gqia=ZA4DocW4XHxx0w@mail.gmail.com>
References: <20180724164936.37477-1-keescook@chromium.org> <20180724164936.37477-11-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregk
To: Kees Cook <keescook@chromium.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724164936.37477-11-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 24, 2018 at 6:49 PM, Kees Cook <keescook@chromium.org> wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> removes the discouraged use of AHASH_REQUEST_ON_STACK by switching to
> shash directly and allocating the descriptor in heap memory (which should
> be fine: the tfm has already been allocated there too).
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>

I think I can queue this up if there are no objections from others.

Do you want me to do that?

> ---
>  arch/x86/power/hibernate_64.c | 36 ++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
> index 67ccf64c8bd8..f8e3b668d20b 100644
> --- a/arch/x86/power/hibernate_64.c
> +++ b/arch/x86/power/hibernate_64.c
> @@ -233,29 +233,35 @@ struct restore_data_record {
>   */
>  static int get_e820_md5(struct e820_table *table, void *buf)
>  {
> -       struct scatterlist sg;
> -       struct crypto_ahash *tfm;
> +       struct crypto_shash *tfm;
> +       struct shash_desc *desc;
>         int size;
>         int ret = 0;
>
> -       tfm = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
> +       tfm = crypto_alloc_shash("md5", 0, 0);
>         if (IS_ERR(tfm))
>                 return -ENOMEM;
>
> -       {
> -               AHASH_REQUEST_ON_STACK(req, tfm);
> -               size = offsetof(struct e820_table, entries) + sizeof(struct e820_entry) * table->nr_entries;
> -               ahash_request_set_tfm(req, tfm);
> -               sg_init_one(&sg, (u8 *)table, size);
> -               ahash_request_set_callback(req, 0, NULL, NULL);
> -               ahash_request_set_crypt(req, &sg, buf, size);
> -
> -               if (crypto_ahash_digest(req))
> -                       ret = -EINVAL;
> -               ahash_request_zero(req);
> +       desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
> +                      GFP_KERNEL);
> +       if (!desc) {
> +               ret = -ENOMEM;
> +               goto free_tfm;
>         }
> -       crypto_free_ahash(tfm);
>
> +       desc->tfm = tfm;
> +       desc->flags = 0;
> +
> +       size = offsetof(struct e820_table, entries) +
> +               sizeof(struct e820_entry) * table->nr_entries;
> +
> +       if (crypto_shash_digest(desc, (u8 *)table, size, buf))
> +               ret = -EINVAL;
> +
> +       kzfree(desc);
> +
> +free_tfm:
> +       crypto_free_shash(tfm);
>         return ret;
>  }
>
> --
> 2.17.1
>
