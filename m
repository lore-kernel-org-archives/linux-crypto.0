From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Wed, 10 Oct 2007 23:17:43 +0800
Message-ID: <20071010151743.GA8337@gondor.apana.org.au>
References: <200710091944.l99JiedH009971@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3833 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753953AbXJJPSK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Oct 2007 11:18:10 -0400
Content-Disposition: inline
In-Reply-To: <200710091944.l99JiedH009971@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 09, 2007 at 02:44:40PM -0500, Joy Latten wrote:
> This should contain the geniv as well as all the
> improvements discussed. All the testcases pass.

This looks pretty good!

I'm going to apply this once I fix up the geniv problems found
by Sebastian.

BTW, could you please send me a final changeset description
and Signed-off-by?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
