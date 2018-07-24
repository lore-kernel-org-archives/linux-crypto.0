From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v6 18/18] crypto: Remove AHASH_REQUEST_ON_STACK
Date: Tue, 24 Jul 2018 10:53:26 -0700
Message-ID: <CAGXu5j+gTpZFkXE8XSNgYPEpBT4+hCb1kzv8s8KrSTerHyKp6w@mail.gmail.com>
References: <20180724164936.37477-1-keescook@chromium.org> <20180724164936.37477-19-keescook@chromium.org>
 <1bdc706ae86039c4ffcff39698251424d54af116.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
        Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
        "Gustavo A. R. Silva" <gustavo-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>,
        Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>,
        Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
        Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
        Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>,
        Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>,
        Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
        Giovanni Cabiddu <giovanni.cabiddu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1bdc706ae86039c4ffcff39698251424d54af116.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 24, 2018 at 10:31 AM, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> On Tue, 2018-07-24 at 09:49 -0700, Kees Cook wrote:
>> All users of AHASH_REQUEST_ON_STACK have been removed from the kernel, so
>> drop it entirely so no VLAs get reintroduced by future users.
>
> checkpatch has a test for that.
> It could now be removed as well.
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 34e4683de7a3..a3517334d661 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -796,7 +796,7 @@ our $declaration_macros = qr{(?x:
>         (?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
>         (?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
>         (?:$Storage\s+)?${Type}\s+uninitialized_var\s*\(|
> -       (?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
> +       (?:SKCIPHER_REQUEST|SHASH_DESC)_ON_STACK\s*\(
>  )};

Ah! Cool. I've added this now.

-Kees

-- 
Kees Cook
Pixel Security
