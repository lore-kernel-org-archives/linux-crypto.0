From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Mon, 17 Sep 2018 09:06:36 -0700
Message-ID: <CALCETrXXg_nnp_pafK3+Pwd00PRUr=X=WfLu+YFYeggRs8-i1Q@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
 <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net> <CAHmME9qQR4ynsZ5xXejEdnr3oZcOnpRRTdohX+eT9Df+AU2_iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch,
        Eric Biggers <ebiggers@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9qQR4ynsZ5xXejEdnr3oZcOnpRRTdohX+eT9Df+AU2_iA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> On Sep 17, 2018, at 8:28 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Mon, Sep 17, 2018 at 4:52 PM Andy Lutomirski <luto@amacapital.net> wrote:
>>> * (Nit) The GCC command line -include'd .h files contain variable and
>>> function definitions so they are actually .c files.
>>
>> Hmm. I would suggest just getting rid of the -include magic entirely.  The resulting ifdef will be more comprehensible.
>
> I really don't think so, actually. The way the -include stuff works
> now is that the glue code is inlined in the same place that the
> assembly object file is added to the build object list, so it gels
> together cleanly, as the thing is defined and set in one single place.
> I could go back to the ifdefs - and even make them as clean as
> possible - but I think that puts more things in more places and is
> therefore more confusing. The -include system now works extremely
> well.

Is it really better than:

#ifdef CONFIG_X86_64
#include "whatever"
#endif

It seems a more obfuscated than needed to put the equivalent of that
into the Makefile, and I don't think people really like searching
through the Makefile to figure out why the code does what it does.
