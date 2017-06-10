From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto:drbg- Fixes panic in wait_for_completion call.
Date: Sat, 10 Jun 2017 12:17:27 +0800
Message-ID: <20170610041727.GG14719@gondor.apana.org.au>
References: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com>
 <12466881.1IDO9Q7xg5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53038 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdFJE7T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 00:59:19 -0400
Content-Disposition: inline
In-Reply-To: <12466881.1IDO9Q7xg5@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 26, 2017 at 12:12:51PM +0200, Stephan Müller wrote:
> Am Donnerstag, 25. Mai 2017, 17:23:47 CEST schrieb Harsh Jain:
> 
> Hi Harsh,
> 
> > Initialise ctr_completion variable before use.
> 
> Thank you very much for catching this.
> 
> But I think the chosen function is wrong. When we have an HMAC or Hash DRBG, this completion function does not need to be initialized.
> 
> May I ask you to check this patch?

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
