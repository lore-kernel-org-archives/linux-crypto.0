From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Kconfig: Correct help text about feeding entropy
 pool
Date: Thu, 3 Aug 2017 14:25:34 +0800
Message-ID: <20170803062534.GA12689@gondor.apana.org.au>
References: <20170721172556.6877-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, prasannatsmkumar@gmail.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58458 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdHCGZk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:25:40 -0400
Content-Disposition: inline
In-Reply-To: <20170721172556.6877-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com> wrote:
> Modify Kconfig help text to reflect the fact that random data from hwrng
> is fed into kernel random number generator's entropy pool.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
