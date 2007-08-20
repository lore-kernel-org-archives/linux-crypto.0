From: Andi Kleen <ak@suse.de>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 12:47:14 +0200
Message-ID: <20070820104714.GH16680@bingen.suse.de>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820094508.GE9651@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <ak@suse.de>, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXHTJxT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 05:53:19 -0400
Content-Disposition: inline
In-Reply-To: <20070820094508.GE9651@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Not modprobe, but the crypto subsystem. If you have the generic C code
> and the assembly variant it picks the assembly over C. The selection is

But only if they're both loaded. Who loads both? 

> In that case yes. Would it help to add MODULE_ALIAS("aes") to the
> assembly version in order to load it (atleast both)?

No, modprobe will only load the first it finds.

> >Also if one implementation is always better than the other
> >then I see little reason to ever have both.
> 
> If you are sure that nobody needs aes on machnies prio i586 than you
> could disable the generic version on i386.

Why should the i586 version not run on 486/386? 

> BUT: you might get into some trouble if you remove it from selections
> because some modules select it automaticly, IEEE80211_CRYPT_CCMP for
> instance.

Ok that is a problem.

-Andi
