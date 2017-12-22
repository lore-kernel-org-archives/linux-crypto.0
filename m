From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 2/3] crypto: Implement a generic crypto statistics
Date: Fri, 22 Dec 2017 17:38:53 +1100
Message-ID: <20171222063852.GA26982@gondor.apana.org.au>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
 <1513800567-12764-3-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nhorman@tuxdriver.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:45920 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbdLVGjK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 01:39:10 -0500
Content-Disposition: inline
In-Reply-To: <1513800567-12764-3-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 08:09:26PM +0000, Corentin Labbe wrote:
> This patch implement a generic way to get statistics about all crypto
> usages.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Please don't use sysfs.  We already have crypto_user and this
should be exposed through that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
