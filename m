From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] load the DES module by an alias
Date: Fri, 5 Oct 2007 16:48:54 +0800
Message-ID: <20071005084854.GA10959@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSS-0004KR-RF@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1614 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752804AbXJEIs5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Oct 2007 04:48:57 -0400
Content-Disposition: inline
In-Reply-To: <E1IdMSS-0004KR-RF@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 03, 2007 at 09:23:37PM +0200, Sebastian Siewior wrote:
> Loading the crypto algorithm by the alias instead of by module directly
> has the advantage that all possible implementations of this algorithm
> are loaded automatically and the crypto API can choose the best one
> depending on its priority.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
