From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 17:45:49 +0200
Message-ID: <CAHmME9rfCc-Hp08AzeWT8M19Nivs3DY=DnmEQ9pT-qxf+vKiXw@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CAHmME9oYAEwFQAriVRm5zZKCo0Sh1=t5YheNZ+MtKQLQPoMWeg@mail.gmail.com> <CAKv+Gu9VamLBv5Ji5AtvugUrAYQYaotLFZZGA=Rt18JUDEaAMQ@mail.gmail.com>
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9VamLBv5Ji5AtvugUrAYQYaotLFZZGA=Rt18JUDEaAMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 13, 2018 at 5:04 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> > The code still benefits from the review that's gone into OpenSSL. It's
> > not modified in ways that would affect the cryptographic operations
> > being done. It's modified to be suitable for kernel space.
>
> So could we please at least have those changes as a separate patch then?

I'll experiment with a couple ways of trying to communicate with
precision what's been changed from OpenSSL for the next round of
patches.

> > That's interesting. I'll bring this up with AndyP. FWIW, if you think
> > you have a real and compelling claim here, I'd be much more likely to
> > accept a different ChaCha20 implementation than I would be to accept a
> > different Poly1305 implementation. (It's a *lot* harder to screw up
> > ChaCha20 than it is to screw up Poly1305.)
>
> The question is really whether we want different implementations in
> the crypto API and in zinc.

Per earlier in this discussion, I've already authored patches that
replaces the crypto API's implementations with simple calls to Zinc,
so that code isn't duplicated. These will be in v4 and you can comment
on the approach then.

> You are completely missing my point. I am not particularly invested in
> the crypto API, and I share the concerns about its usability. That is
> why I want to make sure that your solution actually results in a net
> improvement for everybody, not just for WireGuard, in a maintainable
> way.

Right, likewise. I've put quite a bit of effort into separating Zinc
into Zinc and not into something part of WireGuard. The motivation for
doing so is a decent amount of call sites all around the kernel that
I'd like to gradually fix up.
