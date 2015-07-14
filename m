From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Drop owner assignment from platform_driver
Date: Tue, 14 Jul 2015 15:01:40 +0800
Message-ID: <20150714070140.GA20728@gondor.apana.org.au>
References: <1436507176-27632-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45004 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbbGNHB5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 03:01:57 -0400
Content-Disposition: inline
In-Reply-To: <1436507176-27632-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 10, 2015 at 02:46:16PM +0900, Krzysztof Kozlowski wrote:
> platform_driver does not need to set an owner because
> platform_driver_register() will set it.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
