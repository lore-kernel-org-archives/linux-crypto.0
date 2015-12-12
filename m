From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: asymmetric_keys/signature.c does not need
 <module.h>
Date: Sat, 12 Dec 2015 13:44:20 +0800
Message-ID: <20151212054420.GE17504@gondor.apana.org.au>
References: <1449691528-29040-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41261 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbLLFo1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:44:27 -0500
Content-Disposition: inline
In-Reply-To: <1449691528-29040-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 03:05:28PM -0500, Paul Gortmaker wrote:
> This file does not contain any modular related function calls.  So get
> rid of module.h since it drags in a lot of other headers and adds to
> the preprocessing load.  It does export some symbols though, so we'll
> need to ensure it has export.h present instead.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
