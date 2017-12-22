From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: seqiv - Remove unused alg/spawn variable
Date: Fri, 22 Dec 2017 20:10:22 +1100
Message-ID: <20171222091022.GG32542@gondor.apana.org.au>
References: <1513107014-11975-1-git-send-email-clabbe@baylibre.com>
 <1513107014-11975-2-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46486 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965148AbdLVJK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 04:10:29 -0500
Content-Disposition: inline
In-Reply-To: <1513107014-11975-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 12, 2017 at 07:30:14PM +0000, Corentin Labbe wrote:
> This patch remove two unused variable and some dead "code" using it.
> 
> Fixes: 92932d03c2b3 ("crypto: seqiv - Remove AEAD compatibility code")
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
