From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v7 5/7] io-64-nonatomic: add
 io{read|write}64[be]{_lo_hi|_hi_lo} macros
Date: Tue, 22 Aug 2017 11:55:43 -0600
Message-ID: <ac32fc61-8a54-faf9-55ad-cd2da5fd6503@deltatee.com>
References: <20170822170228.17196-1-logang@deltatee.com>
 <20170822170228.17196-6-logang@deltatee.com>
 <CAHp75Ve3gG6KdjVBmJZAw25uXRmzfCMUv1kFvg0TbhN7ebTqdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAHp75Ve3gG6KdjVBmJZAw25uXRmzfCMUv1kFvg0TbhN7ebTqdw@mail.gmail.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 22/08/17 11:40 AM, Andy Shevchenko wrote:
> ldd -> LDD

Ok.

> Recomendation is kinda arguable. I doubt modern architectures make
> difference between IO operations and MMIO.
> Does, for example, PCI requires some special signal (message / wire)
> handling when pio_*() accessors used vs. mmio_*() ones?

Sort of. There is a difference between the two in x86. But really if 
it's not a valid recommendation someone should just go through and 
deprecate one of them or document better when one should be used over 
the other. In any case it's still really ugly to mix the two types in 
the same driver.

> cc -> Cc ?

Fixed.

Logan
