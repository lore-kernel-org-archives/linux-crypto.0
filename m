From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] Switch remaining algorithms to shash
Date: Thu, 4 Dec 2008 16:02:29 +0800
Message-ID: <20081204080229.GA18640@gondor.apana.org.au>
References: <12283498922490-git-send-email-ken@codelabs.ch> <20081204064812.GB18141@gondor.apana.org.au> <49378D0D.8090201@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44766 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750737AbYLDICf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 03:02:35 -0500
Content-Disposition: inline
In-Reply-To: <49378D0D.8090201@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 04, 2008 at 08:55:57AM +0100, Adrian-Ken Rueegsegger wrote:
>
> If I read the code correctly l and r are not read-only, e.g. in
> michael_update there are multiple assignments to mctx->l and mctx->r.
> That's the reason why I left them in the desc context.

I see.  In that case your patch is correct.

This also means that the original michael_mic semantics broke
the crypto API requirement that setkey be persistent across the
life-time of an tfm (at least until the next setkey).  Luckily
it seems that the michael_mic users always perform a setkey
prior to each operation so this is OK.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
