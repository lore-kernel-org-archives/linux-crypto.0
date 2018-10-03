From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 11/23] zinc: import Andy Polyakov's Poly1305
 ARM and ARM64 implementations
Date: Wed, 3 Oct 2018 09:58:18 +0200
Message-ID: <CAKv+Gu8-HoAEyYiPYqMOMy9MGduFLQik2YxdJziqxN_cUs0nCA@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-12-Jason@zx2c4.com>
 <20181003061236.GB745@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andy Polyakov <appro@openssl.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181003061236.GB745@sol.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3 October 2018 at 08:12, Eric Biggers <ebiggers@kernel.org> wrote:
> On Tue, Sep 25, 2018 at 04:56:10PM +0200, Jason A. Donenfeld wrote:
>> These NEON and non-NEON implementations come from Andy Polyakov's
>> implementation, and are included here in raw form without modification,
>> so that subsequent commits that fix these up for the kernel can see how
>> it has changed. This awkward commit splitting has been requested for the
>> ARM[64] implementations in particular.
>>

"This awkward commit splitting"

Seriously?!?

So you really think it is fine to import huge chunks of code like this
from other projects without keeping track of the local changes?

>> While this is CRYPTOGAMS code, the originating code for this happens to
>> be the same as OpenSSL's commit 5bb1cd2292b388263a0cc05392bb99141212aa53
>
> Sorry to ruin the fun, but actually there are no Poly1305 implementations in
> CRYPTOGAMS (https://github.com/dot-asm/cryptogams).  Nor are there any ChaCha20
> implementations.
>

So was this code taken directly from the OpenSSL project then? If so,
why do the commit messages claim otherwise?

> Andy P., can you please add your Poly1305 and ChaCha20 implementations to the
> CRYPTOGAMS repository, so that they have a clear kernel-compatible license?
>
> It would be great if you'd include a kernel-compatible license directly in the
> versions in the OpenSSL tree too...
>

Yes please.
