From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Wed, 12 Sep 2018 01:30:15 +0200
Message-ID: <20180911233015.GD11474@lunn.ch>
References: <20180911010838.8818-1-Jason@zx2c4.com>
 <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <20180911145624.GA21635@kroah.com>
 <20180911214737.GA81235@gmail.com>
 <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 04:02:52PM -0600, Jason A. Donenfeld wrote:
> On Tue, Sep 11, 2018 at 3:47 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > Of course, the real problem is that even after multiple revisions of this
> > patchset, there's still no actual conversions of the existing crypto API
> > algorithms over to use the new implementations.  "Zinc" is still completely
> > separate from the existing crypto API.
> 
> No this is not, "the real problem [...] after multiple revisions"
> because I've offered to do this and stated pretty clearly my intent to
> do so. But, as I've mentioned before, I'd really prefer to land this
> series through net-next

Hi Jason

Just as an FYI:

1) I don't think anybody in netdev has taken a serious look at the
network code yet. There is little point until the controversial part
of the code, Zinc, has been sorted out.

2) I personally would be surprised if DaveM took this code without
having an Acked-by from the crypto subsystem people. In the same way,
i doubt the crypto people would take an Ethernet driver without having
DaveM's Acked-by.

       Andrew
