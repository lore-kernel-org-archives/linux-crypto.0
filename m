From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] Crypto: [xp ]cbc: use 64bit regs on 64bit machines (rev. 2)
Date: Fri, 22 Jun 2007 20:41:30 +0800
Message-ID: <20070622124130.GB30017@gondor.apana.org.au>
References: <20070614122900.GA7286@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3691 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751299AbXFVMlf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 08:41:35 -0400
Content-Disposition: inline
In-Reply-To: <20070614122900.GA7286@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 14, 2007 at 12:29:00PM +0000, Sebastian Siewior wrote:
> 
> Maybe my computer is just as tired as I am. In general I thing 64bit
> registers should be prefered.
> 
> Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>

OK this makes sense.  However you need to make sure that alignmask
is set appropriately (i.e., at least 8/16).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
