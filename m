From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 18 Sep 2018 18:45:06 +0200
Message-ID: <CAHmME9oCWv9J7=fpTCgDJeVNffYW1Y7MVukp8HT8RaVn8cDt_Q@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAHmME9ohGPTX-fkhP6zaWdx3SbkiqO5kWkWE-bDk=pm-nUqYvw@mail.gmail.com>
 <8937D6B1-D21C-4C47-8A89-A466CDB6FB04@amacapital.net> <CAKv+Gu-t5HPj+Y3-7JqkaKTdt-0ewOUobQaEuikpeOaX_SF+zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-t5HPj+Y3-7JqkaKTdt-0ewOUobQaEuikpeOaX_SF+zg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Tue, Sep 18, 2018 at 6:06 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> as long as we have data that supports the claim  that it
> is actually faster on hardware people care about.

Seems reasonable. I'll next be turning my attention back to ARM
performance. I'll try to gather some numbers. Expect data at some
point next week.

Regards,
Jason
