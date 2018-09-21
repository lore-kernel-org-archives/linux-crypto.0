From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Fri, 21 Sep 2018 02:17:45 +0200
Message-ID: <CAHmME9qeas57qQe=0yfCRPWz=gC1_F5+047s6b4CUwdXQeoOEA@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Thu, Sep 20, 2018 at 5:42 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Apologies for not spotting these before:
>
> > +ccflags-y := -O3
>
> -O3 optimization has been problematic in the past, at least on x86 but
> I think on other architectures as well. Please stick with -O2.

Fixed up for v6.

>
> > +ccflags-y += -Wframe-larger-than=$(if (CONFIG_KASAN),16384,8192)
>
> There is no way we can support code in the kernel with that kind of
> stack space requirements. I will let Arnd comment on what we typically
> allow, since he deals with such issues on a regular basis.

Also fixed up for v6 by just removing that line entirely.

Jason
