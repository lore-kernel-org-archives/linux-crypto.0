From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] crypto-jitterentropy: Delete unnecessary checks before
 the function call "kzfree"
Date: Wed, 24 Jun 2015 12:19:07 +0300
Message-ID: <20150624091907.GS28762@mwanda>
References: <5307CAA2.8060406@users.sourceforge.net>
 <3056833.hq1kqBmzGz@myon.chronox.de>
 <20150624074819.GR28762@mwanda>
 <20504077.rM6dY01J5R@tauon.atsec.com>
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
Received: from aserp1040.oracle.com ([141.146.126.69]:43048 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbFXJTY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 05:19:24 -0400
Content-Disposition: inline
In-Reply-To: <20504077.rM6dY01J5R@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ah.  I should have read the whole thread.  I sort of assumed we were
just adding abstractions for the fun of it (because I have worked in
staging for too long).

regards,
dan carpenter
