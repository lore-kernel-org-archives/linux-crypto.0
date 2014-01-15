From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] crypto: ccp - more code fixes/cleanup
Date: Wed, 15 Jan 2014 11:42:30 +0800
Message-ID: <20140115034230.GA13556@gondor.apana.org.au>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34005 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaAODmi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 22:42:38 -0500
Content-Disposition: inline
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 06, 2014 at 01:33:53PM -0600, Tom Lendacky wrote:
> The following series implements a fix to hash length wrapping as well
> as some additional fixes and cleanups (proper gfp_t type on some memory
> allocations, scatterlist usage improvements, null request result field
> checks and driver enabled/disabled changes).
> 
> This patch series is based on the cryptodev-2.6 kernel tree.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
