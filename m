From: Brandon Philips <brandon@ifup.org>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Fri, 19 Mar 2010 21:21:03 -0700
Message-ID: <20100320042103.GB5127@jenkins>
References: <20100319234044.GA5127@jenkins>
 <20100320010115.GA30561@gondor.apana.org.au>
 <20100320010849.GA30654@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63124 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0CTEVS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Mar 2010 00:21:18 -0400
Received: by gyg8 with SMTP id 8so1842649gyg.19
        for <linux-crypto@vger.kernel.org>; Fri, 19 Mar 2010 21:21:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20100320010849.GA30654@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09:08 Sat 20 Mar 2010, Herbert Xu wrote:
> On Sat, Mar 20, 2010 at 09:01:15AM +0800, Herbert Xu wrote:
> >
> > IIRC modprobe(8) in user-space is supposed to load all dependencies
> > prior to loading the main module.  So something must've gone wrong
> > before bnx2/bnx2x was loaded.  Please strace it to see why libcrc32c
> > wasn't loaded successfully before the kernel ever saw bnx2/bnx2x.
> 
> In fact I just tried it on my machine and modprobe bnx2x correctly
> loaded libcrc32c + crc32c before loading bnx2x (you don't need the
> hardware, it'll stay loaded).  My kernel is 2.6.33-rc8.
> 
> I suspect it's a user-space problem.  I'm using module-init-tools
> 3.4-1 from Debian.

This is module-init-tools 3.11.1 and SUSE Linux Enterprise SP1 RC1. I
can only reproduce on boot (thus why I changed bnx2 which I have) so
perhaps SUSE is doing something odd in how it loads modules at boot.

I will trace the boot process and get more information on exactly what
happens before it gets stuck.

Do you see how it is getting stuck though with modprobe bnx2 and
modprobe libcrc32c going at the same time though?

Cheers,

	Brandon
