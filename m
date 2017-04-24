From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif_aead - Require setkey before accept(2)
Date: Mon, 24 Apr 2017 18:22:39 +0800
Message-ID: <20170424102239.GE20943@gondor.apana.org.au>
References: <2439869.UPpkkqdW7f@positron.chronox.de>
 <3234815.BdC1qsBGSt@tauon.chronox.de>
 <20170424090313.GA20718@gondor.apana.org.au>
 <1688100.DB4uBLsSBi@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:47324 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1168586AbdDXKjA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 06:39:00 -0400
Content-Disposition: inline
In-Reply-To: <1688100.DB4uBLsSBi@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 24, 2017 at 11:15:23AM +0200, Stephan Müller wrote:
> Am Montag, 24. April 2017, 11:03:13 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Mon, Apr 24, 2017 at 11:01:50AM +0200, Stephan Müller wrote:
> > > Shall I send an updated patch with aead_sock_destruct cleared?
> > 
> > Yes please.
> 
> Please find attached v2 with the discussed change.
> 
> ---8<---
> 
> Some cipher implementations will crash if you try to use them
> without calling setkey first.  This patch adds a check so that
> the accept(2) call will fail with -ENOKEY if setkey hasn't been
> done on the socket yet.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
