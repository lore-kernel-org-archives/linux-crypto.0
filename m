From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 11:45:08 +0200
Message-ID: <20070820094508.GE9651@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46688 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577AbXHTJpN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 05:45:13 -0400
Content-Disposition: inline
In-Reply-To: <20070820101618.GE16680@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Andi Kleen | 2007-08-20 12:16:18 [+0200]:

>> Are you sure you get the C version when both are built-in
>> or loaded as modules? If so then we have a bug in the priority
>> code.
>
>The usual use case is: Somebody -- either admin or some command 
>implicitely -- executes modprobe aes because some text file
>specifies the aes cipher. At least on my system that loads
>the C version when both are enabled. modprobe will not load
>multiple modules in this case.
>
>I don't think modprobe knows anything about these priorities.

Not modprobe, but the crypto subsystem. If you have the generic C code
and the assembly variant it picks the assembly over C. The selection is
done before the particular subsystem, dm-crypt for instance, requests
the algorithm / module. It makes no sense to load the AES-i586 module
_after_ it is in use (dm-crypt loaded the encrypted root partition).
However, further requests will get the assembly variant.

>> We don't, but the system is meant to allow multiple
>> implementations to coexist and picking the best one
>> at run-time.
>
>But that would require teaching the module loading user space
>about all this first, right?

In that case yes. Would it help to add MODULE_ALIAS("aes") to the
assembly version in order to load it (atleast both)?

>Also if one implementation is always better than the other
>then I see little reason to ever have both.

If you are sure that nobody needs aes on machnies prio i586 than you
could disable the generic version on i386. Also on x86_64 the generic
version isn't required since an assembly optimized version is provided.
BUT: you might get into some trouble if you remove it from selections
because some modules select it automaticly, IEEE80211_CRYPT_CCMP for
instance.

>-Andi

Sebastian
