From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] prng: fix repetition test to properly update on each iteration
Date: Mon, 7 Jul 2008 22:42:00 +0800
Message-ID: <20080707144200.GA13660@gondor.apana.org.au>
References: <20080707142210.GB5372@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53913 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969AbYGGOmF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2008 10:42:05 -0400
Content-Disposition: inline
In-Reply-To: <20080707142210.GB5372@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 07, 2008 at 10:22:10AM -0400, Neil Horman wrote:
> 
> Fixing a silly bug that I missed in the initial submission
> Fix the repetition test in prng to update on each iteration.  Currently we check
> against the last iteration to make sure the given prng context isn't stuck, but
> we never update the last data buffer.
> 
> Best
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
