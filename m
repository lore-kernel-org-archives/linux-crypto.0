From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 3/7] asm-generic/io.h: make ioread64 and iowrite64
 universally available
Date: Thu, 22 Jun 2017 14:38:28 -0600
Message-ID: <131f6a1c-ee4d-20eb-d1d3-200c70bbae0c@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-4-logang@deltatee.com>
 <20170622211431.14270378@alans-desktop>
 <e856de0b-e9a3-8228-7a73-4daa38cb4479@deltatee.com>
 <20170622213655.07dffac2@alans-desktop>
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
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <20170622213655.07dffac2@alans-desktop>
Sender: linux-alpha-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/22/2017 2:36 PM, Alan Cox wrote:
> I think that makes sense for the platforms with that problem. I'm not
> sure there are many that can't do it for mmio at least. 486SX can't do it
> and I guess some ARM32 but I think almost everyone else can including
> most 32bit x86.
>
> What's more of a problem is a lot of platforms can do 64bit MMIO via
> ioread/write64 but not 64bit port I/O, and it's not clear how you
> represent that via an ioread/write API that abstracts it away.

In Patch 2, we call bad_io_access for anyone trying to do 64bit accesses 
on port I/O.

Logan

