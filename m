From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 4/7] alpha: provide ioread64 and iowrite64 implementations
Date: Thu, 22 Jun 2017 14:09:55 -0600
Message-ID: <401cdb64-6fdb-be30-b8bc-bf51c1a35074@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-5-logang@deltatee.com>
 <20170622210828.27304f6a@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
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
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170622210828.27304f6a@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/22/2017 2:08 PM, Alan Cox wrote:
> But this does not do the same thing as an ioread64 with regards to
> atomicity or side effects on the device. The same is true of the other
> hacks. You either have a real 64bit single read/write from MMIO space or
> you don't. You can't fake it.

Yes, I know. But is it not better than having every driver that wants to 
use these functions fake it themselves?

Logan
