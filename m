From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: prevent nx 842 load if no hw driver
Date: Wed, 3 Jun 2015 13:08:10 +0800
Message-ID: <20150603050810.GB3884@gondor.apana.org.au>
References: <1432844491-27174-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56953 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbbFCFIO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 01:08:14 -0400
Content-Disposition: inline
In-Reply-To: <1432844491-27174-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 28, 2015 at 04:21:31PM -0400, Dan Streetman wrote:
> Change the nx-842 common driver to wait for loading of both platform
> drivers, and fail loading if the platform driver pointer is not set.
> Add an independent platform driver pointer, that the platform drivers
> set if they find they are able to load (i.e. if they find their platform
> devicetree node(s)).
> 
> The problem is currently, the main nx-842 driver will stay loaded even
> if there is no platform driver and thus no possible way it can do any
> compression or decompression.  This allows the crypto 842-nx driver
> to load even if it won't actually work.  For crypto compression users
> (e.g. zswap) that expect an available crypto compression driver to
> actually work, this is bad.  This patch fixes that, so the 842-nx crypto
> compression driver won't load if it doesn't have the driver and hardware
> available to perform the compression.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.  Though I had to do the Makefile bit by hand because
it contains references to nx-compress-test which doesn't exist
in my tree.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
