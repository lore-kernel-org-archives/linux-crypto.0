From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Wed, 19 Sep 2007 23:46:52 +0200
Message-ID: <20070919214652.GC20997@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070820130639.GN16680@bingen.suse.de> <20070902224226.GA22869@Chamillionaire.breakpoint.cc> <20070919122943.GD19866@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34704 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbXISVq7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 17:46:59 -0400
Content-Disposition: inline
In-Reply-To: <20070919122943.GD19866@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-09-19 20:29:43 [+0800]:

>On Mon, Sep 03, 2007 at 12:42:27AM +0200, Sebastian Siewior wrote:
>>
>> [crypto] do not use generic AES on i386 and x86_64
>> 
>> This patch automatically selects the assembly optimized version
>> of AES (if selected) and the generic version can no longer be
>> selected. The module will be called aes.ko
>
>You don't need to rename it because it already provides an
>alias for aes.

Right, forgot about that.

>Also please provide a way to build the generic AES code so
>that it can at least be tested on i386/x86_64.

You want to auto compile aes-x86_64 if you are on x86_64 and additonally
the generic version. Is that correct?
If so, why do you want to have them both?

Sebastian
