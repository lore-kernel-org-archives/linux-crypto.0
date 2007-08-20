From: Sebastian Siewior <bigeasy@breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 13:27:15 +0200
Message-ID: <20070820112715.GG9651@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820094508.GE9651@Chamillionaire.breakpoint.cc> <20070820104714.GH16680@bingen.suse.de> <20070820100819.GF9651@Chamillionaire.breakpoint.cc> <20070820111239.GI16680@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38119 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbXHTL1R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 07:27:17 -0400
Content-Disposition: inline
In-Reply-To: <20070820111239.GI16680@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Andi Kleen | 2007-08-20 13:12:39 [+0200]:

>I'm thinking of standard distribution kernel users though. They 
>just want to tell some high level configuration they want aes
>(or twofish) and expect the most efficient implementation 
>to be loaded automatically.
Sure.

>The distribution kernel could just disable the generic AES,
>but if that's a good idea there this could as well be done in all
>kernels.

If the i586 variant is working on all x86 machines than be my guest.

We still have the problem with hardware drivers like the via-aes driver.
In that case you don't to have the generic nor the i586 version. Adding
a priority to modprobe in case of two drivers with the same name/alias
might not to be worst idea. On s390 you might need both, since not every
machine provides hardware acceleration.

>> The s390 guys have MODULE_ALIAS("aes"); in their hw driver [1]. If it
>> doesn't load both (aes.ko + aes_s390.ko) modules, than I wonder what's
>> the reason for this.
>
>When only one is enabled then aes_s390 will be loaded. 
>
>But when both are enabled only one wins. At least on my system
>that seems to be the C version.

Okay, same here.

>> >> BUT: you might get into some trouble if you remove it from selections
>> >> because some modules select it automaticly, IEEE80211_CRYPT_CCMP for
>> >> instance.
>> >
>> >Ok that is a problem.
>> 
>> Not really I guess. The aes algorithm shouldn't be directly used by the
>> wlan stack. It should only make sure that the user does not forget to
>> enable aes since it is required for CCMP. 
>
>Well it still would need to be solved to get rid of the generic
>aes/twofish. I don't know how unfortunately. Or could the select
>just be dropped?

Yes, but wait for Herbert's ACK. Technically only the crypto subsystem
is required for compilation. AES is required because it is part of CCMP.
It is not needed for linking or anything. You have just to convince
your users to enable AES if they select CCMP or else it will not work
(that's the whole point about select in first place from my POV). This
should not be a problem in a distro kernel.

>-Andi
