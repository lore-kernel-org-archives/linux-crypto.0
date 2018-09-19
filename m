From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Wed, 19 Sep 2018 09:55:32 -0700
Message-ID: <CAKv+Gu-JVLCbMuqFzsdC5TwOu0_jS4OeekD_GQcunV_7zGxAbQ@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
 <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
 <CAKv+Gu8OKyVvvgLy48GDV2KJt-UmmHbf5x0qNxQC_SDiddb9-g@mail.gmail.com> <20180918203658.GA28723@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918203658.GA28723@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 September 2018 at 13:36, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard,
>
> On Tue, Sep 18, 2018 at 11:53:11AM -0700, Ard Biesheuvel wrote:
>> On 17 September 2018 at 08:52, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> > Hi Ard,
>> >
>>
>> Given that you show no interest whatsoever in gaining an understanding
>> of the underlying requirements that we have to deal with in the crypto
>> API, the only way to get my point across is by repeatedly stating it
>
> Sorry if I've come across that way, but I am certainly interested in
> gaining such an understanding of said requirements.
>

Excellent.

So you are probably aware that there is a big push in the industry
these days towards high-performance accelerators on a coherent fabric,
potentially with device side caches, and this is the main reason that
the crypto API abstractions are the way they are today.

So while standardizing on Chacha20Poly1305 in WireGuard [while still a
policy decision in my view] seems reasonable to me, the decision to
limit WireGuard to synchronous software implementations seems to me
like something we may want to revisit in the future. What is your view
on that? And is the ChaCha20/Poly1305 AEAD construction in WireGuard
identical to the one in RFC 7539, i.e., could an accelerator built for
the IPsec flavor of ChaCha20Poly1305 potentially be reused for
WireGuard?
