From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Wed, 3 Oct 2007 15:35:22 +0800
Message-ID: <20071003073522.GA7285@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3790 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751782AbXJCHfb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 03:35:31 -0400
Content-Disposition: inline
In-Reply-To: <20070930124239.GB24811@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 30, 2007 at 02:42:39PM +0200, Sebastian Siewior wrote:
>
> Herbert, I tried to implement a MODULE_PRIO() macro which would be used
> by the module loader and I noticed that it may not be required.
> If there are two modules providing the same alias and we modprobe that
> alias than modprobe will load both of them. It may be a waste of memory
> if we load the generic algorithm and the assembly optimized one.
> However, it would be good for some hardware drivers which need the
> generic implementation for some "corner cases". 
> What do you thing?

I think you're brilliant!

Could you please do a patch to rename aes.c to aes-generic.c and
add the appropriate alias to it? Please add the aes alias to padlock
and geode while you're at it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
