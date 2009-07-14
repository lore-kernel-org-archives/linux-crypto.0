From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Bogus sha1 implementation in crypto4xx
Date: Tue, 14 Jul 2009 21:06:00 +0800
Message-ID: <20090714130600.GA11081@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: James Hsiao <jhsiao@amcc.com>, Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36140 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335AbZGNNGD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2009 09:06:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I just noticed that the sha1 implementation in crypto4xx is
fundamentally broken.  It stores the hash state in the context
of the tfm, instead of the context of the request.

This means that at any one time you can only have one entity
using the tfm, which is infeasible for an asynchronous hash.

So I'm going to disable the sha1 part of crypto4xx until this
is fixed.

This hasn't caused a problem before because we haven't started
using ahash yet, apart from tcrypt which is single-threaded.
I'm currently in the process of converting authenc (hence IPsec)
across, which means that we will soon rely on the fact that
you can have multiple hash operations ongoing at once.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
