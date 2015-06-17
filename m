From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: poly1305 - Pass key as first two message blocks
 to each desc_ctx
Date: Wed, 17 Jun 2015 17:13:47 +0800
Message-ID: <20150617091347.GA11190@gondor.apana.org.au>
References: <1434447256-6780-1-git-send-email-martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56897 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbFQJN5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 05:13:57 -0400
Content-Disposition: inline
In-Reply-To: <1434447256-6780-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 11:34:16AM +0200, Martin Willi wrote:
> The Poly1305 authenticator requires a unique key for each generated tag. This
> implies that we can't set the key per tfm, as multiple users set individual
> keys. Instead we pass a desc specific key as the first two blocks of the
> message to authenticate in update().
> 
> Signed-off-by: Martin Willi <martin@strongswan.org>

Patch applied.  Thanks Martin!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
