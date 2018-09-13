From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 17:04:47 +0200
Message-ID: <CAKv+Gu9VamLBv5Ji5AtvugUrAYQYaotLFZZGA=Rt18JUDEaAMQ@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com> <CAHmME9oYAEwFQAriVRm5zZKCo0Sh1=t5YheNZ+MtKQLQPoMWeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHmME9oYAEwFQAriVRm5zZKCo0Sh1=t5YheNZ+MtKQLQPoMWeg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13 September 2018 at 16:15, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard,
>
> On Thu, Sep 13, 2018 at 12:56 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> In this series, you are dumping a huge volume of unannotated,
>> generated asm into the kernel which has been modified [by you] to
>> [among other things?] adhere to the kernel API (without documenting
>> what the changes are exactly). How does that live up to the promise of
>> better, peer reviewed code?
>
> The code still benefits from the review that's gone into OpenSSL. It's
> not modified in ways that would affect the cryptographic operations
> being done. It's modified to be suitable for kernel space.
>

So could we please at least have those changes as a separate patch then?

>> Then there is the performance claim. We know for instance that the
>> OpenSSL ARM NEON code for ChaCha20 is faster on cores that happen to
>> possess a micro-architectural property that ALU instructions are
>> essentially free when they are interleaved with SIMD instructions. But
>> we also know that a) Cortex-A7, which is a relevant target, is not one
>> of those cores, and b) that chip designers are not likely to optimize
>> for that particular usage pattern so relying on it in generic code is
>> unwise in general.
>
> That's interesting. I'll bring this up with AndyP. FWIW, if you think
> you have a real and compelling claim here, I'd be much more likely to
> accept a different ChaCha20 implementation than I would be to accept a
> different Poly1305 implementation. (It's a *lot* harder to screw up
> ChaCha20 than it is to screw up Poly1305.)
>

The question is really whether we want different implementations in
the crypto API and in zinc.

>> I am also concerned about your claim that all software algorithms will
>> be moved into this crypto library.
>
> I'll defer to Andy's response here, which I think is a correct one:
> https://lkml.org/lkml/2018/9/13/27
>
> The short answer is that Zinc is going to be adding the ciphers that
> people want to use for normal reasons from normal code. For example,
> after this merges, we'll next be working on moving the remaining
> non-optimized C code out of lib/ that's called by places (such as
> SHA2).
>

Excellent.

>> You are not specific about whose
>> responsibility it will be that this is going to happen in a timely
>> fashion.
>
> I thought I laid out the roadmap for this in the commit message. In
> case I wasn't clear: my plan is to tackle lib/ after merging, and I
> plan to do so in a timely manner. It's a pretty common tactic to keep
> layering on tasks, "what about X?", "what about Y?", "I won't agree
> unless Z!" -- when in reality kernel development and refactorings are
> done incrementally. I've been around on this list contributing code
> for long enough that you should have a decent amount of confidence
> that I'm not just going to disappear working on this or something
> insane like that. And neither are the two academic cryptographers CC'd
> on this thread. So, as Andy said, we're going to be porting to Zinc
> the primitives that are useful for the various applications of Zinc.
> This means yes, we'll have SHA2 in there.
>
>> chaining modes
>> What are the APIs
>> going to look like for block ciphers, taking chaining modes into
>> account?
>
> As mentioned in the commit message and numerous times, we're not
> trying to make a win32-like crypto API here or to remake the existing
> Linux crypto API. Rather we're providing libraries of specific
> functions that are useful for various circumstances. For example, if
> AES-GCM is desired at some point, then we'll have a similar API for
> that as we do for ChaPoly -- one that takes buffers and one that takes
> sg. Likewise, hash functions use the familiar init/update/final.
> "Generic" chaining modes aren't really part of the equation or design
> goals.
>
> Again, I realize you've spent a long time working on the existing
> crypto API, and so your questions and concerns are in the line of,
> "how are we going to make Zinc look like the existing crypto API in
> functionality?"

You are completely missing my point. I am not particularly invested in
the crypto API, and I share the concerns about its usability. That is
why I want to make sure that your solution actually results in a net
improvement for everybody, not just for WireGuard, in a maintainable
way.

> But that's not what we're up to here. We have a
> different and complementary design goal. I understand why you're
> squirming, but please recognize we're working on different things.
>
>> I'm sure it is rather simple to port the crypto API implementation of
>> ChaCha20 to use your library. I am more concerned about how your
>> library is going to expand to cover all other software algorithms that
>> we currently use in the kernel.
>
> The subset of algorithms we add will be developed with the same
> methodology as the present ones. There is nothing making this
> particularly difficult or even more difficult for other primitives
> than it was for ChaCha20. It's especially easy, in fact, since we're
> following similar design methodologies as the vast majority of other
> cryptography libraries that have been developed. Namely, we're
> creating simple things called "functions".
>
>> Of course. But please respond to all the concerns,
>> You have not
>> responded to that concern yet.
>
> Sorry, it's certainly not my intention. I've been on vacation with my
> family for the last several weeks, and only returned home
> sleep-deprived last night after 4 days of plane delays. I've now
> rested and will resume working on this full-time and I'll try my best
> to address concerns, and also go back through emails to find things I
> might have missed. (First, though, I'm going to deal with getting back
> the three suitcases the airline lost in transit...)
>
>> > Anyway, it sounds like this whole thing may have ruffled your feathers
>> > a bit. Will you be at Linux Plumbers Conference in November? I'm
>> > planning on attending, and perhaps we could find some time there to
>> > sit down and talk one on one a bit.
>>
>> That would be good, yes. I will be there.
>
> Looking forward to talking to you there, and hopefully we can put to
> rest any lingering concerns.
>
> Jason
