From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 17:58:39 +0200
Message-ID: <CAHmME9qjTyYpm_PsQ5_oZSfZBGa29zME1XHVak9F4Ued-qm67g@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
 <CAKv+Gu8z1r7F_wbR6-e0Vbryqby7djDy2OR6JJURCsTo6ZMa2g@mail.gmail.com>
 <CAHmME9pcODNc2m26DH1cQY6R+grxYW5dvFpNDpz_GiugM3qufw@mail.gmail.com> <CAKv+Gu9GVbSETjp01tANMwJgA6O9aexhnH+47836KjZg+71q2A@mail.gmail.com>
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9GVbSETjp01tANMwJgA6O9aexhnH+47836KjZg+71q2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 13, 2018 at 5:43 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> I'd prefer it if all the accelerated software implementations live in
> the same place. But I do strongly prefer arch code to live in
> arch/$arch

Zinc follows the scheme of the raid6 code, as well as of most other
crypto libraries: code is grouped by cipher, making it easy for people
to work with and understand differing implementations. It also allows
us to trivially link these together at compile time rather than at
link time, which makes cipher selection much more efficient. It's
really much more maintainable this way.

> I think AES-GCM is a useful example here. I really like the SIMD token
> abstraction a lot, but I would like to understand how this would work
> in Zinc if you have
> a) a generic implementation
> b) perhaps an arch specific scalar implementation
> c) a pure NEON implementation
> d) an implementation using AES instructions but not the PMULL instructions
> e) an implementation that uses AES and PMULL instructions.

The same way that Zinc currently chooses between the five different
implementations for, say, x86_64 ChaCha20:

- Generic C scalar
- SSSE3
- AVX2
- AVX512F
- AVX512VL

We make a decision based on CPU capabilities, SIMD context, and input
length, and then choose the right function.

> You know what? If you're up for it, let's not wait until Plumbers, but
> instead, let's collaborate off list to get this into shape.

Sure, sounds good.

Jason
