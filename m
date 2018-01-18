From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: exynos-rng - Add SPDX license identifier and
 correct module license
Date: Thu, 18 Jan 2018 23:01:46 +1100
Message-ID: <20180118120146.GA20717@gondor.apana.org.au>
References: <20180109175736.6885-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55322 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbeARMCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 07:02:12 -0500
Content-Disposition: inline
In-Reply-To: <20180109175736.6885-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 09, 2018 at 06:57:35PM +0100, Krzysztof Kozlowski wrote:
> Replace GPL license statement with SPDX GPL-2.0 license identifier and
> correct the module license to GPLv2.
> 
> The license itself was a generic GPL because of copy-and-paste from old
> drivers/char/hw_random/exynos-rng.c driver (on which this was based on).
> However the module license indicated GPL-2.0 or later.  GPL-2.0 was
> intended by author so fix up this mess.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
