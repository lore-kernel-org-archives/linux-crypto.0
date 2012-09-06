From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: geode-aes: Use module_pci_driver
Date: Thu, 6 Sep 2012 13:21:28 -0700
Message-ID: <20120906202128.GF24269@gondor.apana.org.au>
References: <1346062531-27827-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org,
	davem@davemloft.net, patches@linaro.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:51622 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757870Ab2IFUVc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:21:32 -0400
Content-Disposition: inline
In-Reply-To: <1346062531-27827-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 27, 2012 at 03:45:31PM +0530, Sachin Kamat wrote:
> module_pci_driver makes the code simpler by eliminating
> module_init and module_exit calls.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
