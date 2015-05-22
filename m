From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] crypto: Convert all AEAD users to new interface
Date: Fri, 22 May 2015 08:21:12 +0800
Message-ID: <20150522002112.GB29073@gondor.apana.org.au>
References: <20150521103938.GA23035@gondor.apana.org.au>
 <20150521.120347.286409931588196234.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	johannes@sipsolutions.net, marcel@holtmann.org,
	steffen.klassert@secunet.com
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49631 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbbEVAVa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 20:21:30 -0400
Content-Disposition: inline
In-Reply-To: <20150521.120347.286409931588196234.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 21, 2015 at 12:03:47PM -0400, David Miller wrote:
>
> No objections on my end.
> 
> I assume since the dependencies exist in the crypto tree, you'll
> want to merge this series there right?

Yes that's probably the easiest path.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
