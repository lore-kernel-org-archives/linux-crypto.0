From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias
Date: Fri, 5 Oct 2007 22:20:22 +0800
Message-ID: <20071005142022.GA13265@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <20071005135056.GA19693@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4232 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753550AbXJEOUZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Oct 2007 10:20:25 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Ido2R-00031K-5h
	for <linux-crypto@vger.kernel.org>; Sat, 06 Oct 2007 00:20:23 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1Ido2Q-0003Sv-00
	for <linux-crypto@vger.kernel.org>; Fri, 05 Oct 2007 22:20:22 +0800
Content-Disposition: inline
In-Reply-To: <20071005135056.GA19693@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 05, 2007 at 03:50:56PM +0200, Sebastian Siewior wrote:
>
> I did not find a module_mutex. We hold a readlock of crypto_alg_sem
> within the crypto subsystem and request_module() increments
> kmod_concurrent (which may not exceed a certain limit). 

Yes you're right.  The module_mutex (in kernel/module.c) is
dropped for the init call so the dead-lock won't actually occur.
However, it's still good to remove this code since doing a nested
modprobe of "sha" within a modprobe of "sha" just feels wrong.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
