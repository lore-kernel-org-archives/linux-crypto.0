From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GCM & CTR (fwd)
Date: Tue, 23 Oct 2007 15:35:56 +0800
Message-ID: <20071023073556.GA28017@gondor.apana.org.au>
References: <200710222101.l9ML1IG4026190@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, mikko.herranen@cs.helsinki.fi
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1670 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750891AbXJWHgf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 03:36:35 -0400
Content-Disposition: inline
In-Reply-To: <200710222101.l9ML1IG4026190@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 22, 2007 at 04:01:18PM -0500, Joy Latten wrote:
>
> So ctr(aes,0,16,4) would indicate to use last 4 bytes
> of IV for counter. 
> 
> Does this seem ok?

Yeah that looks fine.  Although GCM also has a salt/IV split
so it'd use ctr(aes,4,12,4).

> Would there be some concern of user initializing counter,
> because it could be initialized to a high number... then 
> counter could rapidly rollover? Would this be a problem? 
> If so, then we could use entire counterblock for counter 
> in this instance and not allow user to specify countersize...

Rolling over is not the issue.  What would be a problem is if
it rolls over to the same value.  However, that would require
(for a 4-byte counter block) 2^32 blocks of data.

I think it's sufficient to let the caller worry about issues
like this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
