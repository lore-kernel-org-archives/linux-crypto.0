From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: testmgr - check that entries in
 alg_test_descs are in correct order
Date: Fri, 21 Jun 2013 15:17:28 +0800
Message-ID: <20130621071727.GD24151@gondor.apana.org.au>
References: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:45542 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753883Ab3FUHRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Jun 2013 03:17:30 -0400
Content-Disposition: inline
In-Reply-To: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 13, 2013 at 05:37:40PM +0300, Jussi Kivilinna wrote:
> Patch adds check for alg_test_descs list order, so that accidentically
> misplaced entries are found quicker. Duplicate entries are also checked for.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
