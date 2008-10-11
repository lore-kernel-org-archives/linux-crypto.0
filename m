From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: talitos - pass correct interrupt status to
	error handler
Date: Sat, 11 Oct 2008 10:15:08 +0800
Message-ID: <20081011021508.GC3685@gondor.apana.org.au>
References: <1223323740.24986.12.camel@al08linux99> <20081010175848.a6ce7bd5.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Lee Nipper <lee.nipper@freescale.com>, Vishnu@freescale.com
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51256 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753134AbYJKCPM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2008 22:15:12 -0400
Content-Disposition: inline
In-Reply-To: <20081010175848.a6ce7bd5.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 10, 2008 at 05:58:48PM -0500, Kim Phillips wrote:
>
> Herbert, I noticed your crypto update pull request was missing this
> patch series (and the off-by-one fix from Suresh).  I realize they were
> posted a bit late, but are they under consideration for 2.6.28?

I'm going to run them through cryptodev-2.6 before pushing upstream
if the schedule works out.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
