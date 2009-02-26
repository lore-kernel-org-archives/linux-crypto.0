From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Thu, 26 Feb 2009 14:41:08 +0800
Message-ID: <20090226064108.GA11726@gondor.apana.org.au>
References: <20090225115407.GB6283@elara.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: karl@hiramoto.org, chohnstaedt@innominate.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christian Hohnstaedt <chohnstaedt@innominate.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60044 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733AbZBZGlS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 01:41:18 -0500
Content-Disposition: inline
In-Reply-To: <20090225115407.GB6283@elara.bln.innominate.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Hohnstaedt <chohnstaedt@innominate.com> wrote:
>
> However the scatterlist iteration in the arm implementation of
> dma_map_sg() uses neither of them, but simply sg++
> 
> Please try the attached compile-tested patch.

The chaining is only allowed within the crypto layer (because
we haven't ported the generic chaining to all platforms).  So
for the time being all drivers must remove the chaining before
giving the scatter list to an external party, such as the DMA
API.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
