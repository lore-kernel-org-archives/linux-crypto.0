From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 00:56:53 +0200
Message-ID: <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com> <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
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
In-Reply-To: <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11 September 2018 at 23:22, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hello Ard,
>
> I realize you've put a lot of good and hard work into the existing
> crypto API, and that my writing in these commit messages might be a
> bit too bristly and dismissive of that hard work. So I think in a
> sense it's understandable that you've responded as such here. But
> hopefully I can address your concerns. One thing to keep in mind is
> that Zinc endeavors to provide the basis for simple and direct
> functions to software algorithms. This is fairly modest goal. Just
> some functions that do some stuff in software. Around these you'll
> still be able to have complicated and impressive dynamic dispatch and
> asynchronous mechanisms such as the present crypto API. Zinc is merely
> getting the software implementation side done in a very simple and
> direct way. So I don't think there's a good reason for so much
> antagonism, despite a perhaps overbearing tone of my commit messages.
> Rather, I expect that we'll wind up working together on this quite a
> bit down the line.
>

No worries, it takes more than this to piss me off. I do take pride in
my work, but I am perfectly aware that I am not a rare talent like
Andy Polyakov, which is actually why I have worked extensively with
him in the past to get kernel specific changes to the ARM/arm64 NEON
code into upstream OpenSSL, so that we could use the upstream code
unmodified and benefit from upstream review. [1] [2]

In this series, you are dumping a huge volume of unannotated,
generated asm into the kernel which has been modified [by you] to
[among other things?] adhere to the kernel API (without documenting
what the changes are exactly). How does that live up to the promise of
better, peer reviewed code?

Then there is the performance claim. We know for instance that the
OpenSSL ARM NEON code for ChaCha20 is faster on cores that happen to
possess a micro-architectural property that ALU instructions are
essentially free when they are interleaved with SIMD instructions. But
we also know that a) Cortex-A7, which is a relevant target, is not one
of those cores, and b) that chip designers are not likely to optimize
for that particular usage pattern so relying on it in generic code is
unwise in general.

I am also concerned about your claim that all software algorithms will
be moved into this crypto library. You are not specific about whose
responsibility it will be that this is going to happen in a timely
fashion. But more importantly, it is not clear at all how you expect
this to work for, e.g., h/w instruction based SHAxxx or AES in various
chaining modes, which should be used only on cores that implement
those instructions (note that on arm64, we have optional instructions
for AES, PMULL, SHA1, SHA256, SHA512, SHA3, SM3 and SM4). Are all
those implementations (only few of which will be used on a certain
core) going to be part of the monolithic library? What are the APIs
going to look like for block ciphers, taking chaining modes into
account?

I'm sure it is rather simple to port the crypto API implementation of
ChaCha20 to use your library. I am more concerned about how your
library is going to expand to cover all other software algorithms that
we currently use in the kernel.

>> In spite of the wall of text, you fail to point out exactly why the
>> existing AEAD API in unsuitable, and why fixing it is not an option.
>
> I thought I had addressed this. Firstly, there's a need for more than
> just AEAD, but ignoring that, the AEAD API is a big full API that does
> lots of things, makes allocations, parses descriptors, and so forth.
> I'm sure this kind of highly-engineered approach will continue to
> improve over time in that highly engineered direction. Zinc is doing
> something a bit different: it's providing a series of simple functions
> for various cryptographic routines. This is a considerably different
> goal -- perhaps even a complementary one -- to the AEAD API.
>

I understand how your crypto library is different from the crypto API.
But the question was why WireGuard cannot make use of the crypto APIs
AEAD interface. And note that this is an honest question: I know that
the crypto API is cumbersome to use in general, but it would be very
helpful to understand where exactly the impedance mismatch is between
what your code needs and what the crypto API provides.

>> I don't think you have
>> convinced anyone else yet either.
>
> Please only speak for yourself and refrain from rhetoric like this,
> which is patently false.
>

Fair enough. You have clearly convinced Greg :-)

>> Please refrain from sending a v4 with just a couple of more tweaks on
>> top
>
> Sorry, no, I'm not going to stop working hard on this because you're
> wary of a new approach. I will continue to improve the submission
> until it is mergable, and I do not intend to stop.
>

Of course. But please respond to all the concerns, not just the low
hanging fruit. I have already mentioned a couple of times that I
object to dumping large volumes of generated assembly into the kernel
tree without any annotation whatsoever, or any documentation about how
the generated code was hand tweaked before submission. You have not
responded to that concern yet.

> Anyway, it sounds like this whole thing may have ruffled your feathers
> a bit. Will you be at Linux Plumbers Conference in November? I'm
> planning on attending, and perhaps we could find some time there to
> sit down and talk one on one a bit.
>

That would be good, yes. I will be there.


[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e4e7f10bfc4069925e99cc4b428c3434e30b6c3f
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7918ecef073fe80eeb399a37d8d48561864eedf1
