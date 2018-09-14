From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 08/20] zinc: Poly1305 ARM and ARM64 implementations
Date: Fri, 14 Sep 2018 19:45:32 +0200
Message-ID: <CAHmME9rnzs5x3RTa3ZY0wYvScwssOumNL90YMTXyO4sv8Lwvgw@mail.gmail.com>
References: <20180914162240.7925-1-Jason@zx2c4.com> <20180914162240.7925-9-Jason@zx2c4.com>
 <CAKv+Gu8BD=fLk3zm8tvRQ3H-yiePqzXOrKLEz1BLFSRRz2opOQ@mail.gmail.com>
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
In-Reply-To: <CAKv+Gu8BD=fLk3zm8tvRQ3H-yiePqzXOrKLEz1BLFSRRz2opOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Fri, Sep 14, 2018 at 7:27 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> As I asked in response to v3, could we please have this as a separate
> patch on top? The diff below is corrupted.

I had played with that originally, but thought it made things actually
harder to review, whereas here you have the changes presented pretty
straight forwardly, and I'd appreciate your review of them. If you and
Eric both prefer I split this into two commits, with the first one
just plopping down the CRYPTOGAMS code as is and the second one
bringing it up to kernel-snuff, I can do that.

> Also, both Andy and Eric have offered to get involved in upstreaming
> these changes to OpenSSL, so there is no delta to begin with.

Yes, I think this is probably a good long-term plan, which we can act
on sometime after Zinc is merged.

> I still don't like the GCC -includes, especially because these .h
> files contain function and variable definitions so they are not
> actually header files to begin with.

I very very strongly disagree with you here. I think doing it via
-include is significantly cleaner than any of the alternatives, and
allows the code to be cleanly expressed as conditionals that the
optimizer trivially compiles out in the case of stub functions
returning false and branch optimizes when the stub functions return
true. It is extremely important that these compile together as one
compilation unit. Yes, this is a different design than the crypto
API's approach, but I believe the approach presented here poses
significant improvements and is a lot cleaner.

> Also, you mentioned in the commit log that you got rid of defines and
> made the code more modular, but as far as I can tell, libzinc is still
> a single monolithic binary that is essentially always builtin once we
> move random.c to it.

Yes, it's still monolithic, but it's now trivial to split up when the
time comes to do that. If you and AndyL think that it should be split
into multiple modules _now_, then I can go ahead and do that for v5.
But if it's not essential, it seems simpler to keep it as is. I'll
wait for word from you two on this.

Jason
