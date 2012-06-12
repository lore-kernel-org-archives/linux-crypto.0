From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 9/9] crypto: add clk_prepare/clk_unprepare
Date: Tue, 12 Jun 2012 16:10:08 +0800
Message-ID: <20120612081008.GA13184@gondor.apana.org.au>
References: <1338870583-8704-1-git-send-email-pgaikwad@nvidia.com>
 <1338870583-8704-10-git-send-email-pgaikwad@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	swarren@wwwdotorg.org, linux@arm.linux.org.uk, olof@lixom.net,
	ccross@android.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:34224 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806Ab2FLIKu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 04:10:50 -0400
Content-Disposition: inline
In-Reply-To: <1338870583-8704-10-git-send-email-pgaikwad@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 05, 2012 at 09:59:43AM +0530, Prashant Gaikwad wrote:
> Use clk_prepare/clk_unprepare as required by the generic clk framework.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Acked-off: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
