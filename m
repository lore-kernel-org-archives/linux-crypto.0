From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
Date: Wed, 10 Aug 2011 18:59:58 +0800
Message-ID: <20110810105958.GA2607@gondor.apana.org.au>
References: <1312619188.5589.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60632 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HJLAJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2011 07:00:09 -0400
Content-Disposition: inline
In-Reply-To: <1312619188.5589.27.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 06, 2011 at 08:26:25AM +0000, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
> Fix a get/put_cpu() imbalance in the error case when qp == NULL
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

I tried to apply your patch but it doesn't work as your mailer
has turned all the tabs into spaces.  Please resend and make
sure that you can still apply the patch that the list forwards
back to you.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
