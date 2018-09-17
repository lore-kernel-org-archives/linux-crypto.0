From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Mon, 17 Sep 2018 18:17:04 +0200
Message-ID: <CAHmME9qjZw-hmTtBC0f4mCz_ERMZaYqw6gOa+04mXPju-X2Hsg@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
 <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net> <CAHmME9qQR4ynsZ5xXejEdnr3oZcOnpRRTdohX+eT9Df+AU2_iA@mail.gmail.com>
 <CALCETrXXg_nnp_pafK3+Pwd00PRUr=X=WfLu+YFYeggRs8-i1Q@mail.gmail.com>
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
In-Reply-To: <CALCETrXXg_nnp_pafK3+Pwd00PRUr=X=WfLu+YFYeggRs8-i1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 17, 2018 at 6:06 PM Andy Lutomirski <luto@amacapital.net> wrote:
> #ifdef CONFIG_X86_64
> #include "whatever"
> #endif
>
> It seems a more obfuscated than needed to put the equivalent of that
> into the Makefile, and I don't think people really like searching
> through the Makefile to figure out why the code does what it does.

Okay, I'll change it back to ifdefs for v5.
