From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Fri, 31 Oct 2014 04:01:04 +0100
Message-ID: <201410310401.04278.marex@denx.de>
References: <7502136.9BkWHTZ0th@myon.chronox.de> <20141016131007.GA11517@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44200 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaJaDJI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Oct 2014 23:09:08 -0400
In-Reply-To: <20141016131007.GA11517@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, October 16, 2014 at 03:10:07 PM, Herbert Xu wrote:
> On Tue, Oct 14, 2014 at 09:46:50PM +0200, Stephan Mueller wrote:
> > The update adds a complete interface documentation of the kernel crypto
> > API. All cipher types supported by the kernel crypto API are documented.
> > 
> > In addition, kernel and user space example code is provided. The sample
> > code covers synchronous and asynchronous cipher operation, random
> > number generation and performing hashing as well as encryption and
> > decryption in user space.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Thanks for the patch Stephan!
> 
> Marek Vasut <marex@denx.de> has also been working on a set of
> documentation for the crypto API so he might have some comments
> on this.

Sorry for the late reply, thanks for keeping me in the loop.

I can share the last state of the document I wrote. Currently,
it is not possible for me to keep up with my workload and do
anything else, so that's all I can do.

Apologies.

Best regards,
Marek Vasut
