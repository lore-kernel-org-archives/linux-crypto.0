From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Add bulk algorithm registration interface
Date: Thu, 26 Jan 2012 13:37:17 +1100
Message-ID: <20120126023717.GB10696@gondor.apana.org.au>
References: <1326843266-16782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35632 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2AZChZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jan 2012 21:37:25 -0500
Content-Disposition: inline
In-Reply-To: <1326843266-16782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 17, 2012 at 11:34:26PM +0000, Mark Brown wrote:
> Hardware crypto engines frequently need to register a selection of
> different algorithms with the core. Simplify their code slightly,
> especially the error handling, by providing functions to register a
> number of algorithms in a single call.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
