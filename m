From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] random: always call random ready function
Date: Thu, 19 Oct 2017 13:58:18 -0700
Message-ID: <CAGXu5jJ_A11aCw04rJ2ktAG+OCL0RiXXGx387mgdHwhUe4P-=A@mail.gmail.com>
References: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
 <20171019204506.25090-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171019204506.25090-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 19, 2017 at 1:45 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> As this interface becomes more heavily used, it will be painful for
> callers to always need to check for -EALREADY.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 8ad92707e45f..e161acf35d4a 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1556,40 +1556,45 @@ EXPORT_SYMBOL(wait_for_random_bytes);
>
>  /*
>   * Add a callback function that will be invoked when the nonblocking
> - * pool is initialised.
> + * pool is initialised, or calls that function if it already is.
>   *
>   * returns: 0 if callback is successfully added
> - *         -EALREADY if pool is already initialised (callback not called)
>   *         -ENOENT if module for callback is not alive
>   */
>  int add_random_ready_callback(struct random_ready_callback *rdy)
>  {
>         struct module *owner;
>         unsigned long flags;
> -       int err = -EALREADY;
>
> -       if (crng_ready())
> -               return err;
> +       BUG_ON(!rdy->func);

Better to WARN_ON() and return a failure.

> +
> +       if (crng_ready()) {
> +               rdy->func(rdy);
> +               rdy->func = NULL;
> +               return 0;
> +       }
>
>         owner = rdy->owner;
>         if (!try_module_get(owner))
>                 return -ENOENT;
>
>         spin_lock_irqsave(&random_ready_list_lock, flags);
> -       if (crng_ready())
> +       if (crng_ready()) {
> +               rdy->func(rdy);
> +               rdy->func = NULL;
>                 goto out;
> +       }
>
>         owner = NULL;
>
>         list_add(&rdy->list, &random_ready_list);
> -       err = 0;
>
>  out:
>         spin_unlock_irqrestore(&random_ready_list_lock, flags);
>
>         module_put(owner);
>
> -       return err;
> +       return 0;
>  }
>  EXPORT_SYMBOL(add_random_ready_callback);
>
> @@ -1601,6 +1606,9 @@ void del_random_ready_callback(struct random_ready_callback *rdy)
>         unsigned long flags;
>         struct module *owner = NULL;
>
> +       if (!rdy->func)
> +               return;

Perhaps add a note here about what a NULL func means here? (e.g.
"Already run, not in the list.")

> +
>         spin_lock_irqsave(&random_ready_list_lock, flags);
>         if (!list_empty(&rdy->list)) {
>                 list_del_init(&rdy->list);
> --
> 2.14.2
>

Otherwise, yeah, looks sensible.

-Kees

-- 
Kees Cook
Pixel Security
