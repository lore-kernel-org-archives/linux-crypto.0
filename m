From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v7 5/7] io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo}
 macros
Date: Wed, 23 Aug 2017 00:07:57 +0300
Message-ID: <CAHp75VedQ_t0vo51QXNOKoGDdt4sp8nyreNkteHpu0=zKxO8rw@mail.gmail.com>
References: <20170822170228.17196-1-logang@deltatee.com> <20170822170228.17196-6-logang@deltatee.com>
 <CAHp75Ve3gG6KdjVBmJZAw25uXRmzfCMUv1kFvg0TbhN7ebTqdw@mail.gmail.com> <ac32fc61-8a54-faf9-55ad-cd2da5fd6503@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <ac32fc61-8a54-faf9-55ad-cd2da5fd6503@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 22, 2017 at 8:55 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> On 22/08/17 11:40 AM, Andy Shevchenko wrote:
>> Recomendation is kinda arguable. I doubt modern architectures make
>> difference between IO operations and MMIO.
>> Does, for example, PCI requires some special signal (message / wire)
>> handling when pio_*() accessors used vs. mmio_*() ones?

> Sort of. There is a difference between the two in x86.

Yes, the difference is in signaling. The question is if it's still in
use. Looks like yes...

> But really if it's
> not a valid recommendation someone should just go through and deprecate one
> of them or document better when one should be used over the other. In any
> case it's still really ugly to mix the two types in the same driver.

Mixing is ugly, totally agree.

-- 
With Best Regards,
Andy Shevchenko
