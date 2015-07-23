From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/8] remove 'platform' shared NX driver
Date: Thu, 23 Jul 2015 18:20:02 +0800
Message-ID: <20150723102002.GC13181@gondor.apana.org.au>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48407 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbGWKUL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jul 2015 06:20:11 -0400
Content-Disposition: inline
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2015 at 02:26:30PM -0400, Dan Streetman wrote:
> The shared 'platform' driver module isn't needed, the platform drivers
> can directly register with crypto instead.  It only adds unneeded
> complexity and problems.
> 
> The first 4 patches are minor updates/bugfixes to the pSeries driver.
> 
> The 5th patch is a minor update to the NX crypto driver.
> 
> The last 3 patches merge the crypto and common code driver, and move
> the crypto compression driver registration into the platform (pSeries
> and PowerNV) drivers.  Both platform drivers use the same alg name and
> driver name when registering, but since only one (at most) will register
> on a system, depending on the platform, their registration will not
> conflict.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
