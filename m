From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: Fix module autoload for OF platform drivers
Date: Fri, 18 Sep 2015 21:56:29 +0800
Message-ID: <20150918135629.GA9249@gondor.apana.org.au>
References: <20150828164245.GA5023@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33189 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbIRN4i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 09:56:38 -0400
Content-Disposition: inline
In-Reply-To: <20150828164245.GA5023@goodgumbo.baconseed.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 28, 2015 at 06:42:45PM +0200, Luis de Bethencourt wrote:
> Hello,
> 
> This series add the missing MODULE_DEVICE_TABLE() for OF to eport
> that information so modules have the correct aliases built-in
> and autoloading works correctly.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
