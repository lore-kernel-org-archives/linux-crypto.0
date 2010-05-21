From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] net/ipsec: don't treat EINPROGRESS as a regular error
Date: Sat, 22 May 2010 09:41:43 +1000
Message-ID: <20100521234143.GA7752@gondor.apana.org.au>
References: <20091204212847.GC28480@deprecation.cyrius.com> <4BCB4009.70707@gmail.com> <20100418191719.GA2508@Chamillionaire.breakpoint.cc> <4BCE125F.30200@gmail.com> <20100424144215.GA9057@Chamillionaire.breakpoint.cc> <20100425011821.GA5284@gondor.apana.org.au> <20100425152928.GA14489@Chamillionaire.breakpoint.cc> <20100426011711.GA19734@gondor.apana.org.au> <20100426181142.GA22245@Chamillionaire.breakpoint.cc> <20100521185905.GB1697@jirafa.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	"L.C." <lucorsel@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Martin Michlmayr <tbm@cyrius.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:55653 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758779Ab0EUXmH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 May 2010 19:42:07 -0400
Content-Disposition: inline
In-Reply-To: <20100521185905.GB1697@jirafa.cyrius.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 21, 2010 at 07:59:05PM +0100, Martin Michlmayr wrote:
> * Sebastian Andrzej Siewior <sebastian@breakpoint.cc> [2010-04-26 20:11]:
> > >OK that was my fault.  Steffen had all the requisite EINPROGRESS
> > >checks in place but I told him to get rid of them.
> > >
> > >This patch should fix it.
> > Excellent job Herbert, it does solve the problem.
> 
> Herbert, this bug was originally reported with 2.6.32 so can you
> please ensure that the fix will land in -stable.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=180ce7e81030e1ef763d58f97f9ab840ff57d848

Thanks, I will forward it to stable.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
