From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 05/23] zinc: import Andy Polyakov's ChaCha20
 ARM and ARM64 implementations
Date: Fri, 28 Sep 2018 17:57:18 +0200
Message-ID: <CAHmME9r3CuEkkxTEp0mDpPoYUR_CVqa8TVMB8ZTwBxLh9fQSTQ@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-6-Jason@zx2c4.com>
 <CAKv+Gu8-EwxFhQSUPxjEvTA5ZPz34RieMokM6CUqwURDr74jtg@mail.gmail.com>
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
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8-EwxFhQSUPxjEvTA5ZPz34RieMokM6CUqwURDr74jtg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Fri, Sep 28, 2018 at 5:49 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> As I mentioned before, I'd prefer this to be based on the original .pl
> but if I am the only one objecting to this, I guess I can live with
> it.

We're working on that, actually. It's not obvious when it'll be ready
to ship -- perhaps after the initial merge, but perhaps way sooner --
but that is something we're trying to do for arm/arm64/mips64.

Jason
