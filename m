From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 01/11] crypto: xcbc: Remove VLA usage
Date: Mon, 25 Jun 2018 14:32:13 -0700
Message-ID: <CAGXu5jLbRdZVFqqzKEndogOktfTecBDxyUPvb-=+mgTmQ65v0Q@mail.gmail.com>
References: <20180625211026.15819-1-keescook@chromium.org> <20180625211026.15819-2-keescook@chromium.org>
 <4d9f90abbf87539d3588f88117806f76c6826030.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4d9f90abbf87539d3588f88117806f76c6826030.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 2:23 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2018-06-25 at 14:10 -0700, Kees Cook wrote:
>> In the quest to remove all stack VLA usage from the kernel[1], this uses
>> the maximum blocksize and adds a sanity check. For xcbc, the blocksize
>> must always be 16, so use that, since it's already being enforced during
>> instantiation.
>
> Is it time yet to change this warning from 'make W=3' to W=1?
> ---
>  scripts/Makefile.extrawarn | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 8d5357053f86..27ba478d40cd 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -29,6 +29,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
>  warning-1 += $(call cc-option, -Wunused-but-set-variable)
>  warning-1 += $(call cc-option, -Wunused-const-variable)
>  warning-1 += $(call cc-option, -Wpacked-not-aligned)
> +warning-1 += $(call cc-option, -Wvla)
>  warning-1 += $(call cc-disable-warning, missing-field-initializers)
>  warning-1 += $(call cc-disable-warning, sign-compare)
>
> @@ -52,7 +53,6 @@ warning-3 += -Wpointer-arith
>  warning-3 += -Wredundant-decls
>  warning-3 += -Wswitch-default
>  warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
> -warning-3 += $(call cc-option, -Wvla)
>
>  warning := $(warning-$(findstring 1,
> $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>  warning += $(warning-$(findstring 2,
> $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))

I was going to skip the churn since I intend to make the default build
use -Wvla for the next merge window (assuming we've killed all the
VLAs by then). After crypto, only fs/ntfs remains, and I have that
half done already. There are a couple more still under some
development back-and-forth.

I'm not _opposed_ to this change, but I'd rather just make it the
default. And then the next cycle, I'd want it to be -Werror=vla, but I
may get shouted down. ;)

-Kees

-- 
Kees Cook
Pixel Security
