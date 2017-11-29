From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chelsio: remove redundant assignments to reqctx
 and dst_size
Date: Wed, 29 Nov 2017 17:31:09 +1100
Message-ID: <20171129063109.GA21575@gondor.apana.org.au>
References: <20171109085413.4336-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40594 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750813AbdK2Gb6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:31:58 -0500
Content-Disposition: inline
In-Reply-To: <20171109085413.4336-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 09, 2017 at 08:54:13AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer reqctx is assigned the same value twice, once on initialization
> and again a few statements later, remove the second redundant assignment.
> Variable dst_size is assigned but it is never read, so the variable is
> redundant and can be removed. Cleans up clang warnings:
> 
> drivers/crypto/chelsio/chcr_algo.c:156:29: warning: Value stored to
> 'reqctx' during its initialization is never read
> drivers/crypto/chelsio/chcr_algo.c:2020:2: warning: Value stored to
> 'dst_size' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
