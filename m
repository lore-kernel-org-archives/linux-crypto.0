From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
Date: Wed, 2 May 2007 05:56:43 -0400 (EDT)
Message-ID: <alpine.DEB.0.98.0705020547140.9993@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
 <20070502044345.GA29384@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hammerhead.shentel.net ([204.111.1.228]:36805 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992988AbXEBJ6O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 May 2007 05:58:14 -0400
In-Reply-To: <20070502044345.GA29384@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> > Convert the subdirectory "crypto" to UTF-8. The files changed are 
> > <crypto/fcrypt.c> and <crypto/api.c>.
> > 
> > Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> Thanks.  Could you fix up include/linux/crypto.h as well?

Sure, will do. Since I've gotten almost no feedback about these patches 
whatsoever, I figured either I was doing it wrong or nobody cared. I guess 
I'll finish them all up and resubmit them and hope they stick. Gimme a 
few days: There's a huge number of files throughout the tree to change, 
and some of them (like the .map files) require non-trivial alterations.

(Were you able to successfully apply the patch attached in octet-stream 
encoding?)
