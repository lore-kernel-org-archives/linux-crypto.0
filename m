From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v13 01/10] iomap: Use correct endian conversion function
 in mmio_writeXXbe
Date: Mon, 26 Mar 2018 14:33:13 -0600
Message-ID: <6a063b65-668a-ef9c-696e-8c378e6b2640@deltatee.com>
References: <20180321163745.12286-1-logang@deltatee.com>
 <20180321163745.12286-2-logang@deltatee.com>
 <CAK8P3a25zQDxyaY3iVv+JmSSzs7F6ssGc+HdBkGs54ZfViX+Fg@mail.gmail.com>
 <726eb143-2cca-b221-b569-e193a962e357@deltatee.com>
 <CAK8P3a2HGW=PWBtFL_96rztqa7KUAhuYBHTL3cGKY2VE=Ag1rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2HGW=PWBtFL_96rztqa7KUAhuYBHTL3cGKY2VE=Ag1rA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 26/03/18 01:50 PM, Arnd Bergmann wrote:
> I wouldn't expect it to matter: the byte swap is almost always much
> cheaper compared to the actual bus access for the MMIO, and I
> would also guess that modern compilers can eliminate the double
> byte swap on architectures where writel() is an inline function. Most of
> the important architectures use ARCH_USE_BUILTIN_BSWAP, which
> guarantees that.

Fair enough. Sometime this week I'll update my patch set to change that.

Thanks,

Logan
