From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Intermediate Hash states
Date: Fri, 20 Feb 2015 21:57:33 +0100
Message-ID: <3239574.ZaEUEYnfrB@tachyon.chronox.de>
References: <CAHTT9VLHi6m8-NNS_MJ2cabNm2Eng18zs8iGqJudP1ANb-99Ww@mail.gmail.com> <3307166.8E51TTmzB6@tachyon.chronox.de> <CAHTT9VLchccUkWBSjKGFyAAU51xpkJj4LWi6AieXMK+iig3JJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60275 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbBTU5i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 15:57:38 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S1670D> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Fri, 20 Feb 2015 21:57:34 +0100
In-Reply-To: <CAHTT9VLchccUkWBSjKGFyAAU51xpkJj4LWi6AieXMK+iig3JJw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 21. Februar 2015, 01:39:23 schrieb sri sowj:

Hi sri,

> Hi Muller ,
> 
> Thanks for the information provided.
> 
> I am little confused between current scenario (multiple threads will
> send multiple requests to crypto H/W) and export/import.
> 
> Please can you let me know when export/imports can be used in real time?
> 
> I Have seen many references of these method(export/import) in open
> source , but not really sure when its being used in real time.
> 
When you talk about crypto accelerators, then the serialization depends on the 
accelerator driver and the properties of the hardware.

For in-CPU accelerators (like AES-NI or z/Series CPACF) where you have one 
caller for one hardware instance, every core implements these instructions and 
thus, there is no need of serialization. Of course, these cipher instruction 
must be atomic instructions to ensure that no serialization is needed (to 
protect in case of interrupts).

But for hardware where we only have one hardware component (i.e. 1:n hardware 
vs caller), the driver interfacing that driver must ensure serialization. When 
you look into those implementations, you see locks or mutexes being used.


> BR,
> Srisowj
> 
> On Sat, Feb 21, 2015 at 1:07 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Donnerstag, 19. Februar 2015, 21:48:30 schrieb sri sowj:
> > 
> > Hi sri,
> > 
> >> Hi ,
> >> 
> >> I am trying to understand Hashing Algorithms implementation in linux
> >> kernel
> >> .
> >> 
> >> I am really not sure on how to deal with following scenario.
> >> 
> >> assume when App1 is in middle of
> >> execution(crypto_ahash_init/update/update...) ,App2 sends a request
> >> may be from another cpu in multi-core system to underlying crypto
> >> driver .
> >> Then essentially input1 has to save its  state(intermediate Hash) and
> >> serves App2 request.
> >> 
> >> App1 ---------> Linux kernel crypto driver
> >> 
> >>        crypto_ahash_init(input1);
> >>        
> >>         crypto_ahash_update(input1);
> >>        
> >>        ..................
> >>        ..................
> >>        
> >>         crypto_ahash_update(input1); // multple Hash requests
> >>        
> >>        ..................
> >>        ..................
> >>     
> >>     crypto_ahash_final()
> >> 
> >> App2 ---------> Linux kernel crypto driver
> >> 
> >>         crypto_ahash_init(input2);
> >>         crypto_ahash_update(input2);
> >> 
> >> Here in this scenario how to track,save and restore the Hash state for
> >> App1
> >> ?
> > 
> > The ahash (ablkcipher too) uses kernel threads. Those are scheduled like
> > normal processes, including the context switching.
> > 
> >> BR,
> >> Srisowj
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > Ciao
> > Stephan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
