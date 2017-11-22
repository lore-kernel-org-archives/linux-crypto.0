From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 5/5] crypto: chacha20 - Fix keystream alignment for
 chacha20_block()
Date: Wed, 22 Nov 2017 13:29:50 -0800
Message-ID: <20171122212950.GA74584@gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com>
 <20171122195139.121269-6-ebiggers3@gmail.com>
 <CAKv+Gu__YdYWXgGfNSng8fDj9F0pw-i4zbAaN+uxES+r6mRMpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu__YdYWXgGfNSng8fDj9F0pw-i4zbAaN+uxES+r6mRMpw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 22, 2017 at 08:51:57PM +0000, Ard Biesheuvel wrote:
> On 22 November 2017 at 19:51, Eric Biggers <ebiggers3@gmail.com> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > When chacha20_block() outputs the keystream block, it uses 'u32' stores
> > directly.  However, the callers (crypto/chacha20_generic.c and
> > drivers/char/random.c) declare the keystream buffer as a 'u8' array,
> > which is not guaranteed to have the needed alignment.
> >
> > Fix it by having both callers declare the keystream as a 'u32' array.
> > For now this is preferable to switching over to the unaligned access
> > macros because chacha20_block() is only being used in cases where we can
> > easily control the alignment (stack buffers).
> >
> 
> Given this paragraph, I think we agree the correct way to fix this
> would be to make chacha20_block() adhere to its prototype, so if we
> deviate from that, there should be a good reason. On which
> architecture that cares about alignment is this expected to result in
> a measurable performance benefit?
> 

Well, variables on the stack tend to be 4 or even 8-byte aligned anyway, so this
change probably doesn't make a difference in practice currently.  But it still
should be fixed, in case it does become a problem.

We could certainly leave the type as u8 array and use put_unaligned_le32()
instead; that would be a simpler change.  But that would be slower on
architectures where a potentially-unaligned access requires multiple
instructions.

Eric
