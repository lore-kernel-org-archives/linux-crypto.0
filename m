From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Trouble with non modular ciphers
Date: Thu, 31 Jan 2008 14:12:21 +0100
Message-ID: <20080131131221.GA21439@Chamillionaire.breakpoint.cc>
References: <200801311021.24240.ak@suse.de> <20080131124834.GA21310@Chamillionaire.breakpoint.cc> <200801311349.54179.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57978 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933827AbYAaNMW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jan 2008 08:12:22 -0500
Content-Disposition: inline
In-Reply-To: <200801311349.54179.ak@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Andi Kleen | 2008-01-31 13:49:54 [+0100]:

>On Thursday 31 January 2008 13:48:34 Sebastian Siewior wrote:
>> * Andi Kleen | 2008-01-31 10:21:24 [+0100]:
>> 
>> >FYI -- with a linus git kernel of yesterday or so I ran into a problem where 
>> >one cipher module (CBC) was compiled in and the rest modular. dm_crypt 
>> >could not resolve the cipher module until I turned it into a module.
>> and dm_crypt itself was a module?
>
>I don't remember to be honest. Is it important?
It could be possible that dm_crypt is trying to use the crypto API
before it is initialized, but I doubt it.

>
>> >Also I found that cryptomanager is quite unhappy when CONFIG_KMOD
>> >is not defined. Perhaps it should Kconfig select it?
>> If you disable modules, than why should one module enable it?
>
>CONFIG_KMOD is not modules (that is CONFIG_MODULES), but module
>autoloading.
Ach, you right. This problem has every user of try_then_request_module()
and I don't see anybody selecting CONFIG_KMOD in the kernel.

>-Andi
Sebastian
