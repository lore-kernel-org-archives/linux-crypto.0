From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tegra: remove include of <mach/clk.h>
Date: Mon, 15 Oct 2012 22:33:29 +0800
Message-ID: <20121015143328.GC25426@gondor.apana.org.au>
References: <1349216260-917-1-git-send-email-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:58815 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131Ab2JOOdx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Oct 2012 10:33:53 -0400
Content-Disposition: inline
In-Reply-To: <1349216260-917-1-git-send-email-swarren@wwwdotorg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 02, 2012 at 04:17:40PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Nothing from this file is used, and the file will hopefully be deleted
> soon.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
