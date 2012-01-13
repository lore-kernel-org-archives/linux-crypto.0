From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto - serpent-sse2: change transpose_4x4 to only
	use integer instructions
Date: Fri, 13 Jan 2012 16:36:20 +1100
Message-ID: <20120113053620.GC13918@gondor.apana.org.au>
References: <20111220105806.21682.30810.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40635 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2AMFgX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jan 2012 00:36:23 -0500
Content-Disposition: inline
In-Reply-To: <20111220105806.21682.30810.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 20, 2011 at 12:58:06PM +0200, Jussi Kivilinna wrote:
> Matrix transpose macro in serpent-sse2 uses mix of SSE2 integer and SSE floating
> point instructions, which might cause performance penality on some CPUs.
> 
> This patch replaces transpose_4x4 macro with version that uses only SSE2
> integer instructions.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
