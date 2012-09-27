From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: testmgr - allow non-multi page and multi
 page skcipher tests from same test template
Date: Wed, 26 Sep 2012 22:44:52 -0700
Message-ID: <20120927054452.GE22311@gondor.apana.org.au>
References: <20120919064249.10607.45593.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:37392 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755581Ab2I0Foz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:44:55 -0400
Content-Disposition: inline
In-Reply-To: <20120919064249.10607.45593.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 19, 2012 at 09:42:49AM +0300, Jussi Kivilinna wrote:
> Allow non-multi page and multi page skcipher tests to be run on same test template, to avoid
> duplicating data.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

All three patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
