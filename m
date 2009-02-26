From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in	scatterlist
Date: Thu, 26 Feb 2009 21:27:09 +0100
Message-ID: <49A6FB1D.2030807@hiramoto.org>
References: <20090226121043.GA13749@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	chohnstaedt@innominate.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:39928 "EHLO
	spunkymail-a17.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752810AbZBZU1L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 15:27:11 -0500
In-Reply-To: <20090226121043.GA13749@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>   
>> We can't merge this until _all_ of ARM has been fixed for walking
>> scatterlist chains.
>>     
>
> Right, this is definitely not the way to fix this bug.  Because
> even if ARM completely supported chaining, you still have to fix
> all the other architectures as well.
>
> So please just fix the driver to remove the chaining before doing
> DMA.
>
>   
Is there an example of how to do this somewhere? 

Thanks

Karl
