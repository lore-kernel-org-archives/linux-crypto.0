From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 18/20] crypto: port ChaCha20 to Zinc
Date: Fri, 14 Sep 2018 19:49:13 +0200
Message-ID: <CAHmME9o737NcFNobmJf8LVq51-Vd9gqR9jntgSAtJSP5gnBdTA@mail.gmail.com>
References: <20180914162240.7925-1-Jason@zx2c4.com> <20180914162240.7925-19-Jason@zx2c4.com>
 <CAKv+Gu-wwFJOL82+iJYCu8rbzeDWLYH=5PtGOJBUouB1zdiZjg@mail.gmail.com>
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
        Eric Biggers <ebiggers@google.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-wwFJOL82+iJYCu8rbzeDWLYH=5PtGOJBUouB1zdiZjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 14, 2018 at 7:38 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> so could we please bring that discussion to a close before we drop the ARM code?

My understanding is that either these will find their way up to AndyP
and then back down here, or Eric or you will augment the .S in this
patch at a later date with an improvement commit that includes some
benchmarks.

Jason
