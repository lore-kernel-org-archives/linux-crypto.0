From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 3/7] asm-generic/io.h: make ioread64 and iowrite64
 universally available
Date: Thu, 22 Jun 2017 14:24:58 -0600
Message-ID: <e856de0b-e9a3-8228-7a73-4daa38cb4479@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-4-logang@deltatee.com>
 <20170622211431.14270378@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170622211431.14270378@alans-desktop>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/22/2017 2:14 PM, Alan Cox wrote:
> If a platform doesn't support 64bit I/O operations from the CPU then you
> either need to use some kind of platform/architecture specific interface
> if present or accept you don't have one.

Yes, I understand that.

The thing is that every user that's currently using it right now is 
patching in their own version that splits it on non-64bit systems.

> It's not safe to split it. Possibly for some use cases you could add an
> ioread64_maysplit()

I'm open to doing something like that.

> What btw is the actual ARM compiler warning ? Is the compiler also trying
> to tell you it's a bad idea ?

It's just the compiler noting that you are mixing volatile and 
non-volatile pointers. Strangely some io{read|write}XX use volatile but 
most do not. But it's nothing crazy.

Logan
