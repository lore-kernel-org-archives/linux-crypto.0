From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Date: Thu, 26 Feb 2009 20:10:43 +0800
Message-ID: <20090226121043.GA13749@gondor.apana.org.au>
References: <20090226095552.GB5811@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55668 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754800AbZBZMK4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 07:10:56 -0500
Content-Disposition: inline
In-Reply-To: <20090226095552.GB5811@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
> We can't merge this until _all_ of ARM has been fixed for walking
> scatterlist chains.

Right, this is definitely not the way to fix this bug.  Because
even if ARM completely supported chaining, you still have to fix
all the other architectures as well.

So please just fix the driver to remove the chaining before doing
DMA.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
