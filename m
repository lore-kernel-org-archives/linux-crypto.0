From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 09/20] zinc: Poly1305 ARM and ARM64 implementations
Date: Wed, 19 Sep 2018 02:17:10 +0200
Message-ID: <CAHmME9r_qbbYo=sxOvUauXDetJ3uA2A=WdpvjzQwMgqYF3=h1A@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-10-Jason@zx2c4.com>
 <20180918225552.GA74746@gmail.com>
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
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918225552.GA74746@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

On Wed, Sep 19, 2018 at 12:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> This will compute the wrong digest if called with simd_context=HAVE_FULL_SIMD
> and then later with simd_context=HAVE_NO_SIMD, since poly1305_blocks_neon()
> converts the accumulator from base 32 to base 26, whereas poly1305_blocks_arm()
> assumes it is still in base 32.  Is that intentional?  I'm sure this is a rare
> case, but my understanding is that the existing crypto API doesn't preclude
> calling successive steps in different contexts.  And I'm concerned that it could
> be relevant in some cases, e.g. especially if people are importing a hash state
> that was exported earlier.  Handling it by silently computing the wrong digest
> is not a great idea...

Indeed you're right; Samuel and I were just discussing that recently.
I'd rather handle this correctly even if the contexts change, so I'll
see if I can fix this up properly for that unlikely case in the next
revision.

Jason
