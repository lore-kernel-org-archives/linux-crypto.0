From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/7] alpha: provide ioread64 and iowrite64
 implementations
Date: Thu, 22 Jun 2017 21:08:28 +0100
Message-ID: <20170622210828.27304f6a@alans-desktop>
References: <20170622164817.25515-1-logang@deltatee.com>
        <20170622164817.25515-5-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170622164817.25515-5-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 22 Jun 2017 10:48:14 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Alpha implements its own io operation and doesn't use the
> common library. Thus to make ioread64 and iowrite64 globally
> available we need to add implementations for alpha.
> 
> For this, we simply use calls that chain two 32-bit operations.
> (mostly because I don't really understand the alpha architecture.)

But this does not do the same thing as an ioread64 with regards to
atomicity or side effects on the device. The same is true of the other
hacks. You either have a real 64bit single read/write from MMIO space or
you don't. You can't fake it.


Alan
