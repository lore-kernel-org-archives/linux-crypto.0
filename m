From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Tue, 11 Sep 2018 14:47:38 -0700
Message-ID: <20180911214737.GA81235@gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com>
 <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <20180911145624.GA21635@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180911145624.GA21635@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 04:56:24PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 11, 2018 at 12:08:56PM +0200, Ard Biesheuvel wrote:
> > > As Zinc is simply library code, its config options are un-menued, with
> > > the exception of CONFIG_ZINC_DEBUG, which enables various selftests and
> > > BUG_ONs.
> > >
> > 
> > In spite of the wall of text, you fail to point out exactly why the
> > existing AEAD API in unsuitable, and why fixing it is not an option.
> > 
> > As I pointed out in a previous version, I don't think we need a
> > separate crypto API/library in the kernel, and I don't think you have
> > convinced anyone else yet either.
> 
> Um, then why do people keep sprinkling new crypto/hash code all around
> the kernel tree?  It's because what we have as a crypto api is complex
> and is hard to use for many in-kernel users.
> 
> Something like this new interface (zinc) is a much "saner" api for
> writing kernel code that has to interact with crypto/hash primitives.
> 
> I see no reason why the existing crypto code can be redone to use the
> zinc crypto primitives over time, making there only be one main location
> for the crypto algorithms.  But to do it the other way around is pretty
> much impossible given the complexities in the existing api that has been
> created over time.
> 
> Not to say that the existing api is not a viable one, but ugh, really?
> You have to admit it is a pain to try to use in any "normal" type of
> "here's a bytestream, go give me a hash" type of method, right?
> 
> Also there is the added benefit that the crypto primitives here have
> been audited by a number of people (so Jason stated), and they are
> written in a way that the crypto community can more easily interact and
> contribute to.  Which is _way_ better than what we have today.
> 
> So this gets my "stamp of approval" for whatever it is worth :)
> 

I think you mean you see no reason why it *cannot* be converted?  The
conversions definitely *should* be done, just like how some of the existing
crypto API algorithms like SHA-256 already wrap implementations in lib/.  In my
view, lib/zinc/ isn't fundamentally different from what we already have for some
algorithms.  So it's misguided to design/present it as some novel thing, which
unfortunately this patchset still does to a large extent.  (The actual new thing
is how architecture-specific implementations are handled.)

Of course, the real problem is that even after multiple revisions of this
patchset, there's still no actual conversions of the existing crypto API
algorithms over to use the new implementations.  "Zinc" is still completely
separate from the existing crypto API.

So, it's not yet clear that the conversions will actually work out without
problems that would require changes in "Zinc".  I don't think it makes sense to
merge all this stuff without doing the conversions, or at the very least
demonstrating how they will be done.

In particular, in its current form "Zinc" is useless for anyone that needs the
existing crypto API.  For example, for HPolyC,
(https://lkml.org/lkml/2018/8/6/857), I need to make improvements to ChaCha and
Poly1305 in the existing crypto API, e.g. to add support for XChaCha and
NEON-accelerated Poly1305.  Having completely separate ChaCha and Poly1305
implementations in Zinc doesn't help at all.  If anything, it makes things
harder because people will have to review/maintain both sets of implementations;
and when trying to make the improvements I need, I'll find myself in the middle
of a holy war between two competing camps who each have their own opinion about
The Right Way To Do Crypto, and their own crypto implementations and APIs in the
kernel.

- Eric
