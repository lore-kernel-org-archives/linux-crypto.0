From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: s5p-sss - Fix and minor improvements
Date: Fri, 24 Mar 2017 22:13:55 +0800
Message-ID: <20170324141355.GF14780@gondor.apana.org.au>
References: <20170317144922.27379-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Nathan Royce <nroycea+kernel@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42666 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757187AbdCXOOI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:14:08 -0400
Content-Disposition: inline
In-Reply-To: <20170317144922.27379-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 17, 2017 at 04:49:18PM +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> I still did not fix the NULL pointer dereference reported by
> Nathan Royce [1], but I got some other improvements.
> 
> Testing done on Odroid U3 (Exynos4412) with tcrypt and cryptsetup.
> 
> Best regards,
> Krzysztof

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
