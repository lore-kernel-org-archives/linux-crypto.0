From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: make tables used from assembler __visible
Date: Wed, 14 Aug 2013 20:49:25 +1000
Message-ID: <20130814104925.GB13403@gondor.apana.org.au>
References: <1376182871-17690-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39423 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932467Ab3HNKta (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 06:49:30 -0400
Content-Disposition: inline
In-Reply-To: <1376182871-17690-1-git-send-email-andi@firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 10, 2013 at 06:01:11PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Tables used from assembler should be marked __visible to let
> the compiler know.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Patch applied.  Thanks Andi.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
