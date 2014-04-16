From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] crypto: omap-des - use devm_ioremap_resource()
Date: Wed, 16 Apr 2014 21:48:25 +0800
Message-ID: <20140416134825.GB4684@gondor.apana.org.au>
References: <001d01cf4ed2$494fd0e0$dbef72a0$%han@samsung.com>
 <008301cf52e6$9b764990$d262dcb0$%han@samsung.com>
 <5346BEF6.9090104@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jingoo Han <jg1.han@samsung.com>,
	'David Miller' <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53795 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161121AbaDPNsd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2014 09:48:33 -0400
Content-Disposition: inline
In-Reply-To: <5346BEF6.9090104@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 10, 2014 at 10:55:34AM -0500, Joel Fernandes wrote:
> On 04/07/2014 11:54 PM, Jingoo Han wrote:
> > Use devm_ioremap_resource() because devm_request_and_ioremap() is
> > obsoleted by devm_ioremap_resource().
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Joel Fernandes <joelf@ti.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
