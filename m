From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Re:[PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Date: Thu, 26 Feb 2009 14:42:27 +0800
Message-ID: <20090226064227.GA11766@gondor.apana.org.au>
References: <49A5654C.1080002@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chohnstaedt@innominate.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60049 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbZBZGme (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 01:42:34 -0500
Content-Disposition: inline
In-Reply-To: <49A5654C.1080002@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Karl Hiramoto <karl@hiramoto.org> wrote:
> 
> The attached patch fixes my issue, but am not sure if it is correct or
> will  cause problems else where.

This is what we'll do once generic chaining is available on all
architectures.  Until then it's up to the driver to fix the SG
list up before passing it to DMA.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
