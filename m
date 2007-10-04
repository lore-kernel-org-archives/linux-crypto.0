From: Andi Kleen <ak@suse.de>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 4 Oct 2007 11:31:56 +0200
Message-ID: <200710041131.56625.ak@suse.de>
References: <200708200234.25620.ak@suse.de> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <20071004084818.GB23890@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:36654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761681AbXJDJdx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 05:33:53 -0400
In-Reply-To: <20071004084818.GB23890@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 04 October 2007 10:48, Herbert Xu wrote:
> On Thu, Oct 04, 2007 at 10:35:12AM +0200, Sebastian Siewior wrote:
> > Two last questions:
> > - What about the i386 assembly vs generic implementation? Do you prefer
> >   the patch that I have send earlier (choose the assembly by default
> >   making the generic optional) or do you want both of them loaded at
> >   the same time.
>
> I'd prefer both to be built by default so that if something
> does go wrong we can ask people to check by using aes-generic.

Is that really needed? How often did you see a broken AES implementation? 
They tend to be well tested and high quality after all and I haven't ever seen 
any evidence that the assembler functions are any less stable than C.
In fact they're probably more stable because they don't have to worry
about being miscompiled.

I also think it is a bad idea to install the generic function by default -- it 
increases the risk the user ends up with a unnecessary slow implementation

-Andi
