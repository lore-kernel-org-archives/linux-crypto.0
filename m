From: Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 4/7] alpha: provide ioread64 and iowrite64 implementations
Date: Thu, 22 Jun 2017 14:20:43 -0700
Message-ID: <a854aa15-3ec7-1605-aeef-e41948996d21@twiddle.net>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-5-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34649 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbdFVVUw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 17:20:52 -0400
In-Reply-To: <20170622164817.25515-5-logang@deltatee.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/22/2017 09:48 AM, Logan Gunthorpe wrote:
> Alpha implements its own io operation and doesn't use the
> common library. Thus to make ioread64 and iowrite64 globally
> available we need to add implementations for alpha.
> 
> For this, we simply use calls that chain two 32-bit operations.
> (mostly because I don't really understand the alpha architecture.)

It's not difficult to provide this interface[*].  I believe the only reason I 
didn't do so from the beginning is that it wasn't used.



r~


* At least for systems other than Jensen, which cannot generate 64-bit I/O.  On 
the other hand, Jensen doesn't have PCI (EISA only), and so won't have any 
devices that care.
