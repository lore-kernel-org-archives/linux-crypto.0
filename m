From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: only call put_page on referenced and used
 pages
Date: Tue, 22 Aug 2017 15:59:08 +0800
Message-ID: <20170822075908.GL6269@gondor.apana.org.au>
References: <2922624.oQubu9mOmR@positron.chronox.de>
 <3178607.Y0F1IYYMXo@tauon.chronox.de>
 <20170816093731.GA21573@gondor.apana.org.au>
 <3026257.T9F4K2f5sf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:40954 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932359AbdHVH7S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:59:18 -0400
Content-Disposition: inline
In-Reply-To: <3026257.T9F4K2f5sf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 16, 2017 at 11:56:24AM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> This patch was created against the current Linus development tree.
> 
> The functional test was conducted at the time v3 was aired. The patch
> v4 is compile-tested.
> 
> Ciao
> Stephan
> 
> ---8<---
> For asynchronous operation, SGs are allocated without a page mapped to
> them or with a page that is not used (ref-counted). If the SGL is freed,
> the code must only call put_page for an SG if there was a page assigned
> and ref-counted in the first place.
> 
> This fixes a kernel crash when using io_submit with more than one iocb
> using the sendmsg and sendpage (vmsplice/splice) interface.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
