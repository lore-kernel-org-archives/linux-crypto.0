From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Mon, 17 Sep 2018 17:31:50 +0200
Message-ID: <CAHmME9o2sB-rQo0DRh56AFe7ZLJJh+CU6Z1m5XZ4tA8vATCy1g@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com> <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 17, 2018 at 4:52 PM Andy Lutomirski <luto@amacapital.net> wrote:
> I think the module organization needs to change. It needs to be possible to have chacha20 built in but AES or whatever as a module.

Okay, I'll do that for v5.

> I might have agreed before Spectre :(. Unfortunately, unless we do some magic, I think the code would look something like:
>
> if (static_branch_likely(have_simd)) arch_chacha20();
>
> ...where arch_chacha20 is a *pointer*. And that will generate a retpoline and run very, very slowly.  (I just rewrote some of the x86 entry code to eliminate one retpoline. I got a 5% speedup on some tests according to the kbuild bot.)

Actually, the way it works now benefits from the compilers inliner and
the branch predictor. I benchmarked this without any retpoline
slowdowns, and the branch predictor becomes correct pretty much all
the time. We can tinker with this after the initial merge, if you
really want, but avoiding function pointers and instead using ordinary
branches really winds up being quite fast.
