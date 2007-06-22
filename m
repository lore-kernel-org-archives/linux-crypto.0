From: Herbert Xu <herbert.xu@redhat.com>
Subject: Re: [PATCH 1/1] Crypto: [xp ]cbc: use 64bit regs on 64bit machines (rev. 2)
Date: Sat, 23 Jun 2007 07:40:25 +0800
Message-ID: <20070622234024.GB3167@gondor.apana.org.au>
References: <20070614122900.GA7286@Chamillionaire.breakpoint.cc> <20070622124130.GB30017@gondor.apana.org.au> <20070622224406.GA29941@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3593 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbXFVXk1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 19:40:27 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1I1sjp-0006de-EX
	for <linux-crypto@vger.kernel.org>; Sat, 23 Jun 2007 09:40:25 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1I1sjp-0000tZ-00
	for <linux-crypto@vger.kernel.org>; Sat, 23 Jun 2007 07:40:25 +0800
Content-Disposition: inline
In-Reply-To: <20070622224406.GA29941@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 23, 2007 at 12:44:06AM +0200, Sebastian Siewior wrote:
>
> >OK this makes sense.  However you need to make sure that alignmask
> >is set appropriately (i.e., at least 8/16).
> 
> I don't thing I understand. Why do I have to change the alignmask for
> the xor operation? I guess you are talking about crypto_cbc_alloc()
> 
> |if (!(alg->cra_blocksize % 4))
> |        inst->alg.cra_alignmask |= 3;
> 
> don't you?

Yes.

> Since this (also) changes the alignment of in+out data I would prefer not
> to. The speed up you gain from less xors is probably less than what you
> spent on additional kmap()/memcpy()/kmalloc() in case the data is %4 but
> not %5.

Without it the data is not guaranteed to be aligned to 64 bits and
you'll get alignment traps on non-x86 architectures.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
