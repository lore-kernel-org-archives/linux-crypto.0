From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 4 Oct 2007 12:00:32 +0200
Message-ID: <20071004100032.GC11305@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <20071004084818.GB23890@gondor.apana.org.au> <200710041131.56625.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43271 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbXJDKAe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 06:00:34 -0400
Content-Disposition: inline
In-Reply-To: <200710041131.56625.ak@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Andi Kleen | 2007-10-04 11:31:56 [+0200]:

>On Thursday 04 October 2007 10:48, Herbert Xu wrote:
>> On Thu, Oct 04, 2007 at 10:35:12AM +0200, Sebastian Siewior wrote:
>> > Two last questions:
>> > - What about the i386 assembly vs generic implementation? Do you prefer
>> >   the patch that I have send earlier (choose the assembly by default
>> >   making the generic optional) or do you want both of them loaded at
>> >   the same time.
>>
>> I'd prefer both to be built by default so that if something
>> does go wrong we can ask people to check by using aes-generic.
>
>Is that really needed? How often did you see a broken AES implementation? 
>They tend to be well tested and high quality after all and I haven't ever seen 
>any evidence that the assembler functions are any less stable than C.
>In fact they're probably more stable because they don't have to worry
>about being miscompiled.
>
>I also think it is a bad idea to install the generic function by default -- it 
>increases the risk the user ends up with a unnecessary slow implementation

With the first patch I send earlier (where you wrote "it looks good to
me") the assembly version is selected by default and the generic is
optional (you don't have to compile it at all).
With the patch I've send today both variants (generic + assembly) are
loaded (if available of course) and thr crypto API can decide which one
is the best.

The end user will not end up with a slow implementation because the
distro does not have to ship generic version plus if it does than both
modules are loaded and crypto API picks the best.

>-Andi

Sebastian
