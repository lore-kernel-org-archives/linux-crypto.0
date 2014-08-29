From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers: crypto: mv_cesa.h: Add missing #define
Date: Fri, 29 Aug 2014 21:48:54 +0800
Message-ID: <20140829134854.GD9971@gondor.apana.org.au>
References: <1408725217-2342-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39622 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaH2NtC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2014 09:49:02 -0400
Content-Disposition: inline
In-Reply-To: <1408725217-2342-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 22, 2014 at 06:33:37PM +0200, Rasmus Villemoes wrote:
> Clearly this was meant to be an include guard, but the #define was
> missing.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
