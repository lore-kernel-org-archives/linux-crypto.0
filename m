From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 02/17] zinc: introduce minimal cryptography library
Date: Sat, 25 Aug 2018 10:40:06 -0600
Message-ID: <20180825164005.GA7748@zx2c4.com>
References: <20180824213849.23647-1-Jason@zx2c4.com>
 <20180824213849.23647-3-Jason@zx2c4.com>
 <20180825062951.GC726@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180825062951.GC726@sol.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Eric,

On Fri, Aug 24, 2018 at 11:29:52PM -0700, Eric Biggers wrote:
> I thought you were going to wrap lines at 80 characters?  It's hard to read the
> extremely long lines, and they encourage deep nesting.

I somehow noted this for the WireGuard side of things but assumed I
didn't need to do so for Zinc. Hah, such wishful thinking. I'll have
this wrapped at 80 for v3.

> As I said before, I still think you need to switch the crypto API ChaCha20 and
> Poly1305 over to use the new implementations.  It's not okay to have two
> completely different sets of ChaCha20 and Poly1305 implementations just because
> you want a different API, so you might as well get started on it...  The thing
> is that before you try it, it's not clear what problems will come up that
> require changes to the design.  So, this really ought to be addressed up-front.

It was my hope that this entire series could enter the tree through
Dave's net-next, and that I wouldn't have to touch anything in crypto/ or
touch any of Herbert's stuff at all in anyway. However, if you want, I
can start to play with that in another branch for a separate patchset,
and of course I'd really value your feedback on that and on doing it
right.

> It's also not clearly explained whether/why/how the new ChaCha20 and Poly1305
> implementations are better than the existing ones.  The patch adding the ARM and
> ARM64 ChaCha, for example, just says who wrote them, with no mention of why the
> particular implementations were chosen.

I can expand on that, sure. One primary advantage that I do touch on on
the big introductory commit message, though, is that sharing code means
that we benefit from the eyeballs and fuzzing hours spent on OpenSSL,
and I think this general advantage is extremely compelling.

> You've also documented a lot of stuff in commit messages which will be lost as
> it isn't being added to the source itself.  There are various examples of this,
> such as information about where the various implementations came from, what you
> changed, why a particular implementation isn't used on Skylake or whatever, etc.
> Can you please make sure that any important information is in comments, e.g. at
> the top of the files?

Good idea. I'll do that for v3.

> I still think the "Zinc" name is confusing and misleading, and people are going
> to forget that it means "crypto".  lib/crypto/ would be more intuitive.
> But I don't care *that* much myself, and you should see what others think...

I'd like to keep it. It also enables a natural path for a corresponding
userspace library that shares all of the same code, and one that I think
will be compelling to attract academics and developers to contributing
to these efforts. Plus, can't I name what I made?

> It seems you still don't explicitly clarify anywhere in the source itself that
> the copyright holders of the code from OpenSSL have relicensed it under GPLv2.
> I only see a GPLv2 license slapped on the files, yet no such license is presence
> in the OpenSSL originals, at least in the one I checked.

The SPDX headers for those came out of a discussion on how to encode
CRYPTOGAMS into SPDX from the SPDX mailing list several months ago.

> If you did receive
> explicit permission, then you should include an explicit clarification in each
> file like the one in arch/arm/crypto/sha1-armv4-large.S.

That's a good idea.

> As Ard and I discussed recently on my patch
> "crypto: arm/poly1305 - add NEON accelerated Poly1305 implementation"
> which proposed adding the exact same poly1305-arm.S file, for all the OpenSSL
> assembly it would probably be better to include the .pl file and generate the .S
> file as part of the build process.  For one, there is semantic information like
> register names in the .pl script that is lost in the .S file, thereby making the
> .S file less readable.

But on the other hand, the .S files have been modified and changed to
fit kernel constraints and conventions. They're very much no longer
merely "generated". This is most apparent with the x86_64 files, but is
present too with the ARM files. We're still, I believe, bug-for-bug
similar to the originals -- keeping with the point of going with Andy's
implementations in the first place -- and we've been able to pretty
trivially track OpenSSL changes -- but nonetheless important tweaks have
been done to make this suitable to kernel space.

> There are still some alignment bugs where integers are loaded from byte arrays
> without using the unaligned access macros, e.g. in chacha20_init(),
> hchacha20_generic(), and fe_frombytes_impl().  I found these grepping for
> le32_to_cpu.  Interestingly, that last one is in "formally verified" code :-)

Thanks. I'll do another pass at these for v3.

Jason
