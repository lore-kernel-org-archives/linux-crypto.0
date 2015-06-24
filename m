From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] crypto-jitterentropy: Delete unnecessary checks before
 the function call "kzfree"
Date: Wed, 24 Jun 2015 10:48:19 +0300
Message-ID: <20150624074819.GR28762@mwanda>
References: <5307CAA2.8060406@users.sourceforge.net>
 <5317A59D.4@users.sourceforge.net>
 <5589CD95.9080508@users.sourceforge.net>
 <3056833.hq1kqBmzGz@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19308 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbFXHsm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 03:48:42 -0400
Content-Disposition: inline
In-Reply-To: <3056833.hq1kqBmzGz@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The other NULL assignment isn't useful either.  Also If
"entropy_collector" is NULL then we would oops calling
kzfree(entropy_collector->mem);
       ^^^^^^^^^^^^^^^^^^^^^^
Dereference.

I don't understand the patch that you sent.  We shouldn't be introducing
jent_zalloc() or jent_zfree().  Why are you adding abstractions there?
Quite bad ones as well.

regards,
dan carpenter
