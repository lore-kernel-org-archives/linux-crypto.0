From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Fri, 14 Sep 2018 11:53:10 +0200
Message-ID: <CAHmME9qmDEk-aPYH2CA+q0G7rYfUt6W_WijAgusPVYe48OzwdQ@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
 <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com>
 <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com>
 <CAKv+Gu8z1r7F_wbR6-e0Vbryqby7djDy2OR6JJURCsTo6ZMa2g@mail.gmail.com>
 <CAHmME9pcODNc2m26DH1cQY6R+grxYW5dvFpNDpz_GiugM3qufw@mail.gmail.com>
 <CAKv+Gu9GVbSETjp01tANMwJgA6O9aexhnH+47836KjZg+71q2A@mail.gmail.com>
 <CAHmME9qjTyYpm_PsQ5_oZSfZBGa29zME1XHVak9F4Ued-qm67g@mail.gmail.com> <CAKv+Gu8zULznCmgz++LNNTwfTifaz5L92h=vvWb4yh5fHh-huQ@mail.gmail.com>
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
In-Reply-To: <CAKv+Gu8zULznCmgz++LNNTwfTifaz5L92h=vvWb4yh5fHh-huQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 14, 2018 at 8:15 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> OK, so given random.c's future dependency on Zinc (for ChaCha20), and
> the fact that Zinc is one monolithic piece of code, all versions of
> all algorithms will always be statically linked into the kernel
> proper. I'm not sure that is acceptable.

v4 already addresses that issue, actually. I'll post it shortly.

> BTW you haven't answered my question yet about what happens when the
> WireGuard protocol version changes: will we need a flag day and switch
> all deployments over at the same time?

No, that won't be necessary, necessarily. Peers are individually
versioned and the protocol is fairly flexible in this regard.
