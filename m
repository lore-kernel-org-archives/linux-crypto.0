From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto] S390-AES add fallback driver.
Date: Sat, 1 Dec 2007 12:48:20 +1100
Message-ID: <20071201014820.GA26895@gondor.apana.org.au>
References: <20071130123910.GA1814@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Glauber <jang@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3181 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756558AbXLABsW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Nov 2007 20:48:22 -0500
Content-Disposition: inline
In-Reply-To: <20071130123910.GA1814@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 30, 2007 at 01:39:10PM +0100, Sebastian Siewior wrote:
> Some CPUs support only 128 bit keys in HW. This patch adds SW fallback
> support for the other keys which may be required. The generic algorithm
> (and the block mode) must be availble in case of a fallback.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

Applied to cryptode-2.6.  Thanks Sebastian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
