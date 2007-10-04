From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 4 Oct 2007 11:39:26 +0200
Message-ID: <20071004093926.GB11305@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <20071004084818.GB23890@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:32773 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759311AbXJDJj2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 05:39:28 -0400
Content-Disposition: inline
In-Reply-To: <20071004084818.GB23890@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-04 16:48:18 [+0800]:

>On Thu, Oct 04, 2007 at 10:35:12AM +0200, Sebastian Siewior wrote:
>>
>> Two last questions:
>> - What about the i386 assembly vs generic implementation? Do you prefer
>>   the patch that I have send earlier (choose the assembly by default
>>   making the generic optional) or do you want both of them loaded at
>>   the same time.
>
>I'd prefer both to be built by default so that if something
>does go wrong we can ask people to check by using aes-generic.
That sounds fair to me. I don't touch twofish since it is not auto
selected like aes is and the assembly version is available by default
unless the user enabled both. Maybe a hint in Kconfig's help would
help but I don't thing it is necessary. The distros should not compile
it in first place :)

>> - What might be the best fallback strategy for the s390 + geode aes
>>   driver? 
>
>I've been trying to avoid this :)
>
>Yes your proposal is definitely on the right track.
>
>My original plan is to have a template like keylen(aes,16) that
>only supports key length 16.  So perhaps you can take a look at
>doing that or come up with a different solution.
Okey. So I drop my changes to the driver and try to fix the crypto API
like I was doing in first place.

>Cheers,

Sebastian
