From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH] net/ipsec: don't treat EINPROGRESS as a regular error
Date: Fri, 21 May 2010 19:59:05 +0100
Message-ID: <20100521185905.GB1697@jirafa.cyrius.com>
References: <4B144627.7060901@gmail.com>
 <20091204212847.GC28480@deprecation.cyrius.com>
 <4BCB4009.70707@gmail.com>
 <20100418191719.GA2508@Chamillionaire.breakpoint.cc>
 <4BCE125F.30200@gmail.com>
 <20100424144215.GA9057@Chamillionaire.breakpoint.cc>
 <20100425011821.GA5284@gondor.apana.org.au>
 <20100425152928.GA14489@Chamillionaire.breakpoint.cc>
 <20100426011711.GA19734@gondor.apana.org.au>
 <20100426181142.GA22245@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "L.C." <lucorsel@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tortuga.cyrius.com ([94.228.35.166]:51125 "EHLO
	tortuga.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0EUTJP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 May 2010 15:09:15 -0400
Content-Disposition: inline
In-Reply-To: <20100426181142.GA22245@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Andrzej Siewior <sebastian@breakpoint.cc> [2010-04-26 20:11]:
> >OK that was my fault.  Steffen had all the requisite EINPROGRESS
> >checks in place but I told him to get rid of them.
> >
> >This patch should fix it.
> Excellent job Herbert, it does solve the problem.

Herbert, this bug was originally reported with 2.6.32 so can you
please ensure that the fix will land in -stable.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=180ce7e81030e1ef763d58f97f9ab840ff57d848

Thanks.
-- 
Martin Michlmayr
http://www.cyrius.com/
