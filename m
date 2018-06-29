From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 4/9] dm integrity: Remove VLA usage
Date: Fri, 29 Jun 2018 22:43:34 +0200
Message-ID: <CAK8P3a3F2y8B3a5zhYyG2KSMmSx5L3J3C_0sV-Csa0zPOzYJhA@mail.gmail.com>
References: <20180629002843.31095-1-keescook@chromium.org> <20180629002843.31095-5-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180629002843.31095-5-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 29, 2018 at 2:28 AM, Kees Cook <keescook@chromium.org> wrote:

> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 86438b2f10dd..85e8ce1625a2 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -521,7 +521,12 @@ static void section_mac(struct dm_integrity_c *ic, unsigned section, __u8 result
>                 }
>                 memset(result + size, 0, JOURNAL_MAC_SIZE - size);
>         } else {
> -               __u8 digest[size];
> +               __u8 digest[SHASH_MAX_DIGESTSIZE];
> +
> +               if (WARN_ON(size > sizeof(digest))) {
> +                       dm_integrity_io_error(ic, "digest_size", -EINVAL);
> +                       goto err;
> +               }

I'm still slightly worried that some patches like this one could make
things worse
and lead to an actual stack overflow. You define SHASH_MAX_DIGESTSIZE
as '512', which is still quite a lot to put on the kernel stack. The
function also
uses SHASH_DESC_ON_STACK(), so now you have two copies. Then you
could call shash_final_unaligned(), which seems to put a third copy on
the stack,
so replacing each one with a fixed-size buffer adds quite a bit of bloat.

Is there actually a digest that can be used in dm-integrity with more than 64
byte output (matching JOURNAL_MAC_SIZE) here?

       Arnd
