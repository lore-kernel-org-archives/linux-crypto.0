From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx - add LE support to pSeries platform driver
Date: Fri, 19 Jun 2015 15:30:33 +0800
Message-ID: <20150619073033.GA10522@gondor.apana.org.au>
References: <1434643530-17728-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36580 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbbFSHan (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 03:30:43 -0400
Content-Disposition: inline
In-Reply-To: <1434643530-17728-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 12:05:30PM -0400, Dan Streetman wrote:
> Add support to the nx-842-pseries.c driver for running in little endian
> mode.
> 
> The pSeries platform NX 842 driver currently only works as big endian.
> This adds cpu_to_be*() and be*_to_cpu() in the appropriate places to
> work in LE mode also.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
