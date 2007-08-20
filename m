From: Andi Kleen <ak@suse.de>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 13:12:39 +0200
Message-ID: <20070820111239.GI16680@bingen.suse.de>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820094508.GE9651@Chamillionaire.breakpoint.cc> <20070820104714.GH16680@bingen.suse.de> <20070820100819.GF9651@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <ak@suse.de>, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:59596 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXHTKSn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 06:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20070820100819.GF9651@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 20, 2007 at 12:08:19PM +0200, Sebastian Siewior wrote:
> * Andi Kleen | 2007-08-20 12:47:14 [+0200]:
> 
> >> Not modprobe, but the crypto subsystem. If you have the generic C code
> >> and the assembly variant it picks the assembly over C. The selection is
> >
> >But only if they're both loaded. Who loads both? 
> In my case I do.

You're unusual then.

I'm thinking of standard distribution kernel users though. They 
just want to tell some high level configuration they want aes
(or twofish) and expect the most efficient implementation 
to be loaded automatically.

The distribution kernel could just disable the generic AES,
but if that's a good idea there this could as well be done in all
kernels.

> >> In that case yes. Would it help to add MODULE_ALIAS("aes") to the
> >> assembly version in order to load it (atleast both)?
> >
> >No, modprobe will only load the first it finds.
> 
> The s390 guys have MODULE_ALIAS("aes"); in their hw driver [1]. If it
> doesn't load both (aes.ko + aes_s390.ko) modules, than I wonder what's
> the reason for this.

When only one is enabled then aes_s390 will be loaded. 

But when both are enabled only one wins. At least on my system
that seems to be the C version.

> 
> >> >Also if one implementation is always better than the other
> >> >then I see little reason to ever have both.
> >> 
> >> If you are sure that nobody needs aes on machnies prio i586 than you
> >> could disable the generic version on i386.
> >
> >Why should the i586 version not run on 486/386? 
> 
> I assumed it uses some opcodes which are not available on 486. 

There are not many. From a quick scan I didn't find any.

I assume the 586 refers to it being tuned for P5? Although that would
be also weird, few people still care about P5 tuning and it's quite
different from newer CPUs and likely not beneficial on them.

> >> BUT: you might get into some trouble if you remove it from selections
> >> because some modules select it automaticly, IEEE80211_CRYPT_CCMP for
> >> instance.
> >
> >Ok that is a problem.
> 
> Not really I guess. The aes algorithm shouldn't be directly used by the
> wlan stack. It should only make sure that the user does not forget to
> enable aes since it is required for CCMP. 

Well it still would need to be solved to get rid of the generic
aes/twofish. I don't know how unfortunately. Or could the select
just be dropped?

-Andi
