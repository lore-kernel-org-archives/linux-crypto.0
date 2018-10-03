From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 11/23] zinc: import Andy Polyakov's Poly1305
 ARM and ARM64 implementations
Date: Wed, 3 Oct 2018 16:08:47 +0200
Message-ID: <CAHmME9oAa+Ezqy639_wSKsUDW4vgSrkbJUVd1O8Jcbo3CN4WKg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-12-Jason@zx2c4.com>
 <20181003061236.GB745@sol.localdomain> <CAKv+Gu8-HoAEyYiPYqMOMy9MGduFLQik2YxdJziqxN_cUs0nCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@kernel.org>,
        Andy Polyakov <appro@openssl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8-HoAEyYiPYqMOMy9MGduFLQik2YxdJziqxN_cUs0nCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Wed, Oct 3, 2018 at 9:58 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> it has changed. This awkward commit splitting has been requested for the
> >> ARM[64] implementations in particular.
> >>
>
> "This awkward commit splitting"

Awkward in the sense that only those two commits are doing it, whereas
the rest of the series is not. Not awkward in any other sense that you
seemed to have divined based on your oversized punctuation below.
Fortunately, at your suggestion for v7, I've now done the splitting
for all of the other places, and so I the comment in the dev tree a
few days ago, since it's now done consistently across the patchset.

>
> Seriously?!?
>
> So you really think it is fine to import huge chunks of code like this
> from other projects without keeping track of the local changes?

As explained above, that's not what I meant at all.

Jason
