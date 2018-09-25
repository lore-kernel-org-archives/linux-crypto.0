From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Tue, 25 Sep 2018 16:29:03 +0200
Message-ID: <CAHmME9ofMSsLBJnGjt3VdErnFOQnGTFh8HMmduxRYC1EYyQkkQ@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
 <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
 <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com>
 <CAK8P3a2VL16mtyq0HjNOXuSp8YJXik4J9Z_aPzksmTAbFB+=_g@mail.gmail.com> <CAK8P3a3j0eqAPc-Vkp7YFxT56R2-LrqL_EcULQFam5Bm93gPyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3j0eqAPc-Vkp7YFxT56R2-LrqL_EcULQFam5Bm93gPyw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Arnd,

On Tue, Sep 25, 2018 at 9:18 AM Arnd Bergmann <arnd@arndb.de> wrote:
> I think I misread your earlier sentence and thought you had said the
> exact opposite.
>
> For confirmation, I've downloaded your git tree and built it with my
> collection of compilers (gcc-4.6 through 8.1) and tried building it
> in various configurations. Nothing alarming stood out, the only
> thing that I think would might warrant some investigation is this one:
>
> lib/zinc/curve25519/curve25519-hacl64.h: In function 'curve25519_generic':
> lib/zinc/curve25519/curve25519-hacl64.h:785:1: warning: the frame size
> of 1536 bytes is larger than 500 bytes [-Wframe-larger-than=]
>
> Without KASAN, this takes 832 bytes, which is still more than it should
> use from a look at the source code.
>
> I first suspected some misoptimization around the get/put_unaligned_le64()
> calls, but playing around with it some more led me to this patch:

Excellent detective work. Thanks for spotting that before I had a time
to respond here. I'll also send that same fix to the HACL* team at
INRIA, so they can add it as a heuristic.

Jason
