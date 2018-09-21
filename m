From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Fri, 21 Sep 2018 05:16:11 +0200
Message-ID: <CAHmME9p-abAV-depcb+8wjAayv8WaGRqPXBswseH+ovsRbfJ-Q@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
 <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
 <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com> <20180921031255.GB11109@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921031255.GB11109@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andrew,

On Fri, Sep 21, 2018 at 5:13 AM Andrew Lunn <andrew@lunn.ch> wrote:
> Do you any stack usage information?
>
> A VPN can be at the bottom of some deep stack calls. Swap on NFS over
> the VPN? If you have one frame of 1K, you might be O.K. But if you
> have a few of these, i can see there might be issues of overflowing
> the stack.

It's pretty small, and most of the work is punted onto workqueues
pretty early, so the depth isn't as much of an issue as it would be if
I did everything from ndo_start_xmit. I've done some stack tracking
using the debug option for that, and it's generally far from the
deepest thing running.

Jason
