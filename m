From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Fix a resource release omission in error handling
 code
Date: Tue, 9 Aug 2016 18:59:05 +0800
Message-ID: <20160809105905.GA7099@gondor.apana.org.au>
References: <20160722133242.21916-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48926 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbcHIK7P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 06:59:15 -0400
Content-Disposition: inline
In-Reply-To: <20160722133242.21916-1-lambert.quentin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 22, 2016 at 03:32:40PM +0200, Quentin Lambert wrote:
> The first patch is a style fix, the second add calls to npe_release.
> The reason for me thinking that they are necessary is that every other branches
> leading to an error return are calling this function.

Both patches applied.  BTW, your patches came in the wrong order.
Please send them in the correct order next time.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
