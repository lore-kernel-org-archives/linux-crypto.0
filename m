From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cra_priority usage
Date: Thu, 1 Apr 2010 16:54:30 +0800
Message-ID: <20100401085430.GA22789@gondor.apana.org.au>
References: <44813D8942D35947805CBEEA94195BB0013E4145A2@irsmsx505.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Nicolas, Mario" <mario.nicolas@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:34290 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493Ab0DAIyg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Apr 2010 04:54:36 -0400
Content-Disposition: inline
In-Reply-To: <44813D8942D35947805CBEEA94195BB0013E4145A2@irsmsx505.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nicolas, Mario <mario.nicolas@intel.com> wrote:
> So my questions are: 
> -What is this variable used for?
> -If there are multiple implementations of the same algorithm, how is one version chosen as opposed to another one?

The one with the numerically higher priority will be used.  If
there are multiple implementations with the same priority, the
one registered last will be used.

> I guess that the reason is that an asynchronous version always has a higher priority than a synchronous one. Is that correct?

Actually this is probably a bug.  I'll have a look to see why this
is the case.  Can you please post your complete source?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
