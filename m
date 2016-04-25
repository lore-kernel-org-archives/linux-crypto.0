From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: s5p-sss - Use common BIT macro
Date: Mon, 25 Apr 2016 19:23:09 +0800
Message-ID: <20160425112309.GD10114@gondor.apana.org.au>
References: <1461327323-23288-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vz@mleia.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57599 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbcDYLXR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 07:23:17 -0400
Content-Disposition: inline
In-Reply-To: <1461327323-23288-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 22, 2016 at 02:15:22PM +0200, Krzysztof Kozlowski wrote:
> The BIT() macro is obvious and well known, so prefer to use it instead
> of crafted own macro.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Both applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
