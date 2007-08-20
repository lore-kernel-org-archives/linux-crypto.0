From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 12:08:19 +0200
Message-ID: <20070820100819.GF9651@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820094508.GE9651@Chamillionaire.breakpoint.cc> <20070820104714.GH16680@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53891 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbXHTKIW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 06:08:22 -0400
Content-Disposition: inline
In-Reply-To: <20070820104714.GH16680@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Andi Kleen | 2007-08-20 12:47:14 [+0200]:

>> Not modprobe, but the crypto subsystem. If you have the generic C code
>> and the assembly variant it picks the assembly over C. The selection is
>
>But only if they're both loaded. Who loads both? 
In my case I do. I have the assembly version compiled into the kernel.
The generic aes.o isn't loaded because the crypto API allready has an
algorithm.

>> In that case yes. Would it help to add MODULE_ALIAS("aes") to the
>> assembly version in order to load it (atleast both)?
>
>No, modprobe will only load the first it finds.

The s390 guys have MODULE_ALIAS("aes"); in their hw driver [1]. If it
doesn't load both (aes.ko + aes_s390.ko) modules, than I wonder what's
the reason for this.

>> >Also if one implementation is always better than the other
>> >then I see little reason to ever have both.
>> 
>> If you are sure that nobody needs aes on machnies prio i586 than you
>> could disable the generic version on i386.
>
>Why should the i586 version not run on 486/386? 

I assumed it uses some opcodes which are not available on 486. 

>
>> BUT: you might get into some trouble if you remove it from selections
>> because some modules select it automaticly, IEEE80211_CRYPT_CCMP for
>> instance.
>
>Ok that is a problem.

Not really I guess. The aes algorithm shouldn't be directly used by the
wlan stack. It should only make sure that the user does not forget to
enable aes since it is required for CCMP. 

>
>-Andi

Sebastian

[1] arch/s390/crypto/aes_s390.c
