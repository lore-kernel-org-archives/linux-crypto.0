From: David Miller <davem@davemloft.net>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Fri, 19 Mar 2010 19:46:12 -0700 (PDT)
Message-ID: <20100319.194612.226782074.davem@davemloft.net>
References: <20100319234044.GA5127@jenkins>
	<20100320010115.GA30561@gondor.apana.org.au>
	<20100320010849.GA30654@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: brandon@ifup.org, linux-crypto@vger.kernel.org,
	rusty@rustcorp.com.au
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49410
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab0CTCpu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Mar 2010 22:45:50 -0400
In-Reply-To: <20100320010849.GA30654@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 20 Mar 2010 09:08:49 +0800

> On Sat, Mar 20, 2010 at 09:01:15AM +0800, Herbert Xu wrote:
>>
>> IIRC modprobe(8) in user-space is supposed to load all dependencies
>> prior to loading the main module.  So something must've gone wrong
>> before bnx2/bnx2x was loaded.  Please strace it to see why libcrc32c
>> wasn't loaded successfully before the kernel ever saw bnx2/bnx2x.
> 
> In fact I just tried it on my machine and modprobe bnx2x correctly
> loaded libcrc32c + crc32c before loading bnx2x (you don't need the
> hardware, it'll stay loaded).  My kernel is 2.6.33-rc8.
> 
> I suspect it's a user-space problem.  I'm using module-init-tools
> 3.4-1 from Debian.

Even if userland "does" this, nothing stops another thread
from rmmod'ing the dependency in between the modloads.

We have to handle this case properly in the kernel, no matter
what.
