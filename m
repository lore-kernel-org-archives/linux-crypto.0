From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Tue, 2 Oct 2018 05:20:06 +0200
Message-ID: <CAHmME9oR4=ajV4jPaFrB9G93B3boT+fzY+0FxO5AaoT5rrsORQ@mail.gmail.com>
References: <20180925145622.29959-5-Jason@zx2c4.com> <20181002031848.lyxrergyyxyc5cwi@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        X86 ML <x86@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002031848.lyxrergyyxyc5cwi@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Tue, Oct 2, 2018 at 5:18 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > size    old     new
> > ----    ----    ----
> > 0       62      52
>
> What is the old column? Is it the existing x86-64 implementation
> in the kernel or something else? This needs to be made clear in the
> patch description.

Good idea. I'll make that more clear.

> The same comment from the previous patch also stands here.  Please
> ensure that we only have one copy of chacha x86-64 code in the kernel.
> Either replace the existing one right here or in a follow-up patch
> in the same series.

Yes indeed this happens within this same series.

Jason
