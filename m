From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Mon, 8 Oct 2007 11:21:12 +0800
Message-ID: <20071008032112.GC32087@gondor.apana.org.au>
References: <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc> <20071005151051.GA13666@gondor.apana.org.au> <20071006220220.GC3645@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1604 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbXJHDVO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2007 23:21:14 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IejBB-0005G5-Bh
	for <linux-crypto@vger.kernel.org>; Mon, 08 Oct 2007 13:21:13 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IejBA-0008NR-00
	for <linux-crypto@vger.kernel.org>; Mon, 08 Oct 2007 11:21:12 +0800
Content-Disposition: inline
In-Reply-To: <20071006220220.GC3645@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 07, 2007 at 12:02:20AM +0200, Sebastian Siewior wrote:
>
> >BTW, the dead-lock does exist after all.  The lock that's held
> >is the user-space file lock held by modprobe.  Assuming that
> >padlock-sha comes before sha in the alias list, then the second
> >modprobe will hit padlock-sha again and dead-lock.
> 
> Really, hmm. That CRYPTO_ALG_NEED_FALLBACK flag is unused than? 

That flag is only known to the crypto code.  Modprobe knows
nothing of it so the two probes will look the same to modprobe.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
