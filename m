From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias
Date: Fri, 5 Oct 2007 15:50:56 +0200
Message-ID: <20071005135056.GA19693@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54467 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbXJENu6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Oct 2007 09:50:58 -0400
Content-Disposition: inline
In-Reply-To: <20071005085744.GC10959@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-05 16:57:44 [+0800]:

>This patch is correct per se but it combined with the code in
>padlock-sha can cause a dead-lock.  Padlock-sha tries to load
>the generic sha module in its init function.  At this point it
>is still holding the module_mutex so the probe will dead-lock.

I did not find a module_mutex. We hold a readlock of crypto_alg_sem
within the crypto subsystem and request_module() increments
kmod_concurrent (which may not exceed a certain limit). 

>The probe is actually pointless since we can always probe when
>the algorithm is actually used which does not lead to dead-locks
>like this.

Right.

>So please delete the padlock_sha_check_fallbacks code in your
>patch to make it load correctly.
okey, updated patch will follow.

>Cheers,
Sebastian
