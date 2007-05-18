From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch] [CRYPTO] add alignment for setkey()
Date: Fri, 18 May 2007 16:37:39 +0200
Message-ID: <20070518143739.GC16349@Chamillionaire.breakpoint.cc>
References: <20070510095717.GD26502@Chamillionaire.breakpoint.cc> <20070518063001.GA16171@gondor.apana.org.au> <20070518134341.GA16349@Chamillionaire.breakpoint.cc> <20070518134632.GA21326@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49390 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756270AbXEROhm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 May 2007 10:37:42 -0400
Content-Disposition: inline
In-Reply-To: <20070518134632.GA21326@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-05-18 23:46:32 [+1000]:

>> Good point. I take kmalloc() with GFP_KERNEL (the caller should not be
>> atomic at this point). Additionaly I zero the temporary key (I don't
>
>They shouldn't be.  But it would be good if you could do a grep to see
>if any of them are doing it in an atomic context since we've not tested
>for this before.
Huh, this was too fast. I greped after sending the patch...

drivers/net/ppp_mppe.c: can't tell, probably not.
net/mac80211/wep.c: caller is requesting memory with GFP_ATOMIC. The
code might get called from a tasklet handler but can't really say. There
are some skbs around.

The others are pretty easy to tell and they don't, just the mac80211.
Do you s/GFP_KERNEL/GFP_ATOMIC/ ?

>Thanks,
Sebastian
