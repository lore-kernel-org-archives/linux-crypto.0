From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Wed, 04 May 2016 11:29:57 -0700
Message-ID: <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-2-git-send-email-tytso@mit.edu> <CAH8yC8kEWaH7FM03LRxMk555784Cw-b816=O50WqXWW-0Nep5Q@mail.gmail.com> <20160504174901.GC3901@thunk.org> <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: noloader@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On May 4, 2016 11:22:25 AM PDT, Jeffrey Walton <noloader@gmail.com> wrote:
>On Wed, May 4, 2016 at 1:49 PM,  <tytso@mit.edu> wrote:
>> On Wed, May 04, 2016 at 10:40:20AM -0400, Jeffrey Walton wrote:
>>> > +static inline u32 rotl32(u32 v, u8 n)
>>> > +{
>>> > +       return (v << n) | (v >> (sizeof(v) * 8 - n));
>>> > +}
>>>
>>> That's undefined behavior when n=0.
>>
>> Sure, but it's never called with n = 0; I've double checked and the
>> compiler seems to do the right thing with the above pattern as well.
>
>> Hmm, it looks like there is a "standard" version rotate left and
>right
>> defined in include/linux/bitops.h.  So I suspect it would make sense
>> to use rol32 as defined in bitops.h --- and this is probably
>something
>
>bitops.h could work in this case, but its not an ideal solution. GCC
>does not optimize the code below as expected under all use cases
>because GCC does not recognize it as a rotate (see
>http://gcc.gnu.org/bugzilla/show_bug.cgi?id=57157):
>
>    return (v << n) | (v >> (sizeof(v) * 8 - n));
>
>And outside of special cases like Salsa, ChaCha and BLAKE2, the code
>provided in bitops.h suffers UB on arbitrary data. So I think care
>needs to be taken when selecting functions from bitops.h.
>
>> that we should do for the rest of crypto/*.c, where people seem to be
>> defininig their own version of something like rotl32 (I copied the
>> contents of crypto/chacha20_generic.c to lib/chacha20, so this
>pattern
>> of defining one's own version of rol32 isn't new).
>
>Yeah, I kind of thought there was some duplication going on.
>
>But I think bitops.h should be fixed. Many folks don't realize the
>lurking UB, and many folks don't realize its not always optimized
>well.
>
>>> I think the portable way to do a rotate that avoids UB is the
>>> following. GCC, Clang and ICC recognize the pattern, and emit a
>rotate
>>> instruction.
>>>
>>>     static const unsigned int MASK=31;
>>>     return (v<<n)|(v>>(-n&MASK));
>>>
>>> You should also avoid the following because its not constant time
>due
>>> to the branch:
>>>
>>>     return n == 0 ? v : (v << n) | (v >> (sizeof(v) * 8 - n));
>>>
>>
>> Where is this coming from?  I don't see this construct in the patch.
>
>My bad... It was a general observation. I've seen folks try to correct
>the UB by turning to something like that.
>
>Jeff

We don't care about UB, we care about gcc, and to a lesser extent LLVM and ICC.  If bitops.h doesn't do the right thing, we need to fix bitops.h.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
