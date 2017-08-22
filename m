From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v7 5/7] io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo}
 macros
Date: Tue, 22 Aug 2017 20:40:06 +0300
Message-ID: <CAHp75Ve3gG6KdjVBmJZAw25uXRmzfCMUv1kFvg0TbhN7ebTqdw@mail.gmail.com>
References: <20170822170228.17196-1-logang@deltatee.com> <20170822170228.17196-6-logang@deltatee.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822170228.17196-6-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 22, 2017 at 8:02 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> This patch adds generic io{read|write}64[be]{_lo_hi|_hi_lo} macros if
> they are not already defined by the architecture. (As they are provided
> by the generic iomap library).
>
> The patch also points io{read|write}64[be] to the variant specified by the
> header name.
>
> This is because new drivers are encouraged to use ioreadXX, et al instead
> of readX[1], et al -- and mixing ioreadXX with readq is pretty ugly.
>
> [1] ldd3: section 9.4.2

ldd -> LDD

It's a pretty outdated book, though quite many chapters are actual for
these days.

Recomendation is kinda arguable. I doubt modern architectures make
difference between IO operations and MMIO.
Does, for example, PCI requires some special signal (message / wire)
handling when pio_*() accessors used vs. mmio_*() ones?

> cc: Christoph Hellwig <hch@lst.de>
> cc: Arnd Bergmann <arnd@arndb.de>
> cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

cc -> Cc ?

-- 
With Best Regards,
Andy Shevchenko
