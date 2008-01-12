From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Sat, 12 Jan 2008 13:56:45 +1100
Message-ID: <20080112025645.GA1590@gondor.apana.org.au>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au> <20080110133529.GA13851@Chamillionaire.breakpoint.cc> <20080110154650.GA29453@one.firstfloor.org> <20080112000937.GA23721@Chamillionaire.breakpoint.cc> <20080112024741.GA27661@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3067 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754101AbYALC4x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2008 21:56:53 -0500
Content-Disposition: inline
In-Reply-To: <20080112024741.GA27661@one.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 12, 2008 at 03:47:41AM +0100, Andi Kleen wrote:
> > The inline and not inline performance is quite similar. I guess the
> > little difference here and there is due to some random ctx switches (I
> 
> Are you sure you were not just IO bound? It would have been better
> to test in memory (e.g. using ramfs or just some direct test client)

He tested with tcrypt which is definitely not IO bound.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
