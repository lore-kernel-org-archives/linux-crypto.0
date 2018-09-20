From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Thu, 20 Sep 2018 08:41:57 -0700
Message-ID: <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-3-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(+ Arnd, Eric)

On 18 September 2018 at 09:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
...

> diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
> new file mode 100644
> index 000000000000..83dfd63988c0
> --- /dev/null
> +++ b/lib/zinc/Makefile
> @@ -0,0 +1,4 @@

Apologies for not spotting these before:

> +ccflags-y := -O3

-O3 optimization has been problematic in the past, at least on x86 but
I think on other architectures as well. Please stick with -O2.

> +ccflags-y += -Wframe-larger-than=$(if (CONFIG_KASAN),16384,8192)

There is no way we can support code in the kernel with that kind of
stack space requirements. I will let Arnd comment on what we typically
allow, since he deals with such issues on a regular basis.

> +ccflags-y += -D'pr_fmt(fmt)="zinc: " fmt'
> +ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG
> --
> 2.19.0
>
