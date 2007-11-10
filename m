From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: geode: fix not inplace encryption
Date: Sat, 10 Nov 2007 19:39:14 +0800
Message-ID: <20071110113914.GD5485@gondor.apana.org.au>
References: <20071106200155.GA28183@Chamillionaire.breakpoint.cc> <20071106213040.GA30907@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@kernel.org
To: Jordan Crouse <jordan.crouse@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1845 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbXKJLjV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 06:39:21 -0500
Content-Disposition: inline
In-Reply-To: <20071106213040.GA30907@cosmic.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 06, 2007 at 02:30:40PM -0700, Jordan Crouse wrote:
> On 06/11/07 21:01 +0100, Sebastian Siewior wrote:
> > Currently the Geode AES module fails to encrypt or decrypt if
> > the coherent bits are not set what is currently the case if the
> > encryption does not occur inplace. However, the encryption works 
> > on my Geode machine _only_ if the coherent bits are always set.
> > 
> > Cc: Jordan Crouse <jordan.crouse@amd.com>
> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> Acked-by: Jordan Crouse <jordan.crouse@amd.com>
> 
> Anything in the cache is suspect - turning on coherency is the best plan
> to be rock solid.

Patch applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
