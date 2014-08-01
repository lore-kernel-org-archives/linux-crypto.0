From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: atmel-sha: Switch to managed version of kzalloc
Date: Fri, 1 Aug 2014 22:40:29 +0800
Message-ID: <20140801144029.GD15005@gondor.apana.org.au>
References: <1406549756-26876-1-git-send-email-pramod.gurav@smartplayin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pramod Gurav <pramod.gurav@smartplayin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>
To: pramod.gurav.etc@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57894 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaHAOkf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Aug 2014 10:40:35 -0400
Content-Disposition: inline
In-Reply-To: <1406549756-26876-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 28, 2014 at 05:45:56PM +0530, pramod.gurav.etc@gmail.com wrote:
> From: Pramod Gurav <pramod.gurav@smartplayin.com>
> 
> This patch switches data allocation from kzalloc to devm_kzalloc.
> It also removed some kfree() on data that was earlier allocated
> using devm_kzalloc().
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
