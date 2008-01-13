From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] twofish-asm: Merge common glue code
Date: Sun, 13 Jan 2008 11:35:14 +1100
Message-ID: <20080113003513.GA8764@gondor.apana.org.au>
References: <20080112003420.GB23721@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2708 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751937AbYAMAfT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Jan 2008 19:35:19 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1JDqon-0007wm-54
	for <linux-crypto@vger.kernel.org>; Sun, 13 Jan 2008 11:35:17 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1JDqok-0002OZ-00
	for <linux-crypto@vger.kernel.org>; Sun, 13 Jan 2008 11:35:14 +1100
Content-Disposition: inline
In-Reply-To: <20080112003420.GB23721@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 12, 2008 at 01:34:20AM +0100, Sebastian Siewior wrote:
> There is almost no difference between 32 & 64 bit glue code.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Applied to cryptodev-2.6.  Thanks Sebastian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
