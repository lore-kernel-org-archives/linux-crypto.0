From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] remove similar aes glue code
Date: Fri, 30 Nov 2007 00:15:30 +1100
Message-ID: <20071129131530.GD8487@gondor.apana.org.au>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc> <20071110111955.GB5485@gondor.apana.org.au> <20071110212000.GC15150@Chamillionaire.breakpoint.cc> <20071111011856.GA10745@gondor.apana.org.au> <20071126093500.GD18309@Chamillionaire.breakpoint.cc> <20071126103222.GA26178@gondor.apana.org.au> <20071127193159.GA3506@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3628 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756321AbXK2NPf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Nov 2007 08:15:35 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IxjEr-0003q1-Ey
	for <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2007 00:15:33 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IxjEp-0004E3-00
	for <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2007 00:15:31 +1100
Content-Disposition: inline
In-Reply-To: <20071127193159.GA3506@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 27, 2007 at 08:31:59PM +0100, Sebastian Siewior wrote:
> 32 bit and 64 bit glue code is using (now) the same
> piece code. This patch unifies them.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks Sebastian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
