From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 17:42:58 +0200
Message-ID: <CAKv+Gu9GVbSETjp01tANMwJgA6O9aexhnH+47836KjZg+71q2A@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
 <CAKv+Gu8z1r7F_wbR6-e0Vbryqby7djDy2OR6JJURCsTo6ZMa2g@mail.gmail.com> <CAHmME9pcODNc2m26DH1cQY6R+grxYW5dvFpNDpz_GiugM3qufw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9pcODNc2m26DH1cQY6R+grxYW5dvFpNDpz_GiugM3qufw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 13 September 2018 at 16:32, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Thu, Sep 13, 2018 at 7:41 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> But one of the supposed selling points of this crypto library is that
>> it gives engineers who are frightened of crypto in general and the
>> crypto API in particular simple and easy to use crypto primitives
>> rather than having to jump through the crypto API's hoops.
>
> The goal is for engineers who want to specifically use algorithm X
> from within the kernel in a non-dynamic way to be able to then use
> algorithm X with a simple function call. The goal is not to open it up
> to people who have no idea what they're doing; for that a NaCL-like
> library with functions like "crypto_box_open" or something would fit
> the bill; but that's also not what we're trying to do here. Please
> don't confuse the design goals. The rest of your email is therefore a
> bit of a straw man; cut the rhetoric out.
>
>> A crypto library whose only encryption algorithm is a stream cipher
>> does *not* deliver on that promise, since it is only suitable for
>> cases where IVs are guaranteed not to be reused.
>
> False. We also offer XChaCha20Poly1305, which takes a massive nonce,
> suitable for random generation.
>
> If there became a useful case for AES-PMAC-SIV or even AES-GCM or
> something to that extent, then Zinc would add that as required. But
> we're not going to start adding random ciphers unless they're needed.
>

I'd prefer it if all the accelerated software implementations live in
the same place. But I do strongly prefer arch code to live in
arch/$arch, simply because of the maintenance scope for arch
developers and maintainers.

I think AES-GCM is a useful example here. I really like the SIMD token
abstraction a lot, but I would like to understand how this would work
in Zinc if you have
a) a generic implementation
b) perhaps an arch specific scalar implementation
c) a pure NEON implementation
d) an implementation using AES instructions but not the PMULL instructions
e) an implementation that uses AES and PMULL instructions.

On arch/arm64 we support code patching, on other arches it may be
different. We also support udev loading of modules depending on CPU
capabilities, which means only the implementation you are likely to
use will be loaded, and other modules are disregarded.

I am not asking you to implement this now. But I do want to understand
how these use cases fit into Zinc. And note that this has nothing to
do with the crypto API: this could simply be a synchronous
aes_gcm_encrypt() library function that maps to any of the above at
runtime depending on the platform's capabilities.

>> You yourself were
>> bitten by the clunkiness of the crypto API when attempting to use the
>> SHA26 code, right? So shouldn't we move that into this crypto library
>> as well?
>
> As stated in the initial commit, and in numerous other emails
> stretching back a year, yes, sha256 and other things in lib/ are going
> to be put into Zinc following the initial merge of Zinc. These changes
> will happen incrementally, like everything else that happens in the
> kernel. Sha256, in particular, is probably the first thing I'll port
> post-merge.
>

Excellent.

>> I think it is reasonable for WireGuard to standardize on
>> ChaCha20/Poly1305 only, although I have my concerns about the flag day
>> that will be required if this 'one true cipher' ever does turn out to
>> be compromised (either that, or we will have to go back in time and
>> add some kind of protocol versioning to existing deployments of
>> WireGuard)
>
> Those concerns are not valid and have already been addressed (to you,
> I believe) on this mailing list and elsewhere. WireGuard is versioned,
> hence there's no need to "add" versioning, and it is prepared to roll
> out new cryptography in a subsequent version should there be any
> issues. In other words, your concern is based on a misunderstanding of
> the protocol. If you have issues, however, with the design decisions
> of WireGuard, something that's been heavily discussed with members of
> the linux kernel community, networking community, cryptography
> community, and so forth, for the last 3 years, I invite you to bring
> them up on <wireguard@lists.zx2c4.com>.
>

I'd prefer to have the discussion here, if you don't mind.

IIUC clients and servers need to run the same version of the protocol.
So does it require a flag day to switch the world over to the new
version when the old one is deprecated?

>> And frankly, if the code were as good as the prose, we wouldn't be
>> having this discussion.
>
> Please cut out this rhetoric. That's an obviously unprovable
> statement, but it probably isn't true anyway. I wish you'd stick to
> technical concerns only, rather than what appears to be a desire to
> derail this by any means necessary.
>

I apologize if I hit a nerve there, that was not my intention.

I am not an 'entrenched crypto API guy that is out to get you'. I am a
core ARM developer that takes an interest in crypto, shares your
concern about the usability of the crypto API, and tries to ensure
that what we end up is maintainable and usable for everybody.

>> Zinc adds its own clunky ways to mix arch and
>> generic code, involving GCC -include command line arguments and
>> #ifdefs everywhere. My review comments on this were completely ignored
>> by Jason.
>
> No, they were not ignored. v2 cleaned up the #ifdefs. v4 has already
> cleaned up the makefile stuff and will be even cleaner. Good things
> await, don't worry.
>

You know what? If you're up for it, let's not wait until Plumbers, but
instead, let's collaborate off list to get this into shape.
