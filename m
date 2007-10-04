From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 4 Oct 2007 10:35:12 +0200
Message-ID: <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46050 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819AbXJDIfP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 04:35:15 -0400
Content-Disposition: inline
In-Reply-To: <20071003073522.GA7285@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-03 15:35:22 [+0800]:

>On Sun, Sep 30, 2007 at 02:42:39PM +0200, Sebastian Siewior wrote:
>>
>> Herbert, I tried to implement a MODULE_PRIO() macro which would be used
>> by the module loader and I noticed that it may not be required.
>> If there are two modules providing the same alias and we modprobe that
>> alias than modprobe will load both of them. It may be a waste of memory
>> if we load the generic algorithm and the assembly optimized one.
>> However, it would be good for some hardware drivers which need the
>> generic implementation for some "corner cases". 
>> What do you thing?
>
>I think you're brilliant!
>
>Could you please do a patch to rename aes.c to aes-generic.c and
>add the appropriate alias to it? Please add the aes alias to padlock
>and geode while you're at it.

I am sorry that I did not reply earlier but I was busy framing that
email :)
I send out rename patches for aes, des (s390 hw driver available) and
sha1+252 (s390 + via padlock hw).
Two last questions:
- What about the i386 assembly vs generic implementation? Do you prefer
  the patch that I have send earlier (choose the assembly by default
  making the generic optional) or do you want both of them loaded at
  the same time.
- What might be the best fallback strategy for the s390 + geode aes
  driver? 
  I tried to move the key size to the algorithm request function what
  works good most of the time. All users except the wlan stack do alloc
  cipher followed by setkey in the same function. The benefit would be
  that you don't return a cipher that is not able to handle certain key
  sizes (and you don't have to implement the fallback in every driver (2
  right now)) separately.
  I started to implement a fallback within the driver (two is not that
  much right now) and wanted to make sure that this is the prefered way
  of fixing this.

>Thanks,

Sebastian
