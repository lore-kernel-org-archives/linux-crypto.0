From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: shash - fix module refcount
Date: Thu, 5 Feb 2009 16:20:03 +1100
Message-ID: <20090205052003.GD22749@gondor.apana.org.au>
References: <1233346179-6779-1-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48154 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753189AbZBEFUG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 00:20:06 -0500
Content-Disposition: inline
In-Reply-To: <1233346179-6779-1-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 30, 2009 at 09:09:39PM +0100, Adrian-Ken Rueegsegger wrote:
> Module reference counting for shash is incorrect: when
> a new shash transformation is created the refcount is not
> increased as it should.
> 
> Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>

Applied to crypto-2.6.  Thanks Adrian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
