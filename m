From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
Date: Mon, 31 Mar 2008 16:39:23 +0200
Message-ID: <1206974363.26149.2.camel@localhost>
References: <20080314092523.147382820@de.ibm.com>
	 <20080314093046.914555041@de.ibm.com>
	 <20080331142111.GB14688@gondor.apana.org.au>
Reply-To: schwidefsky@de.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:15325 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYCaOkE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Mar 2008 10:40:04 -0400
In-Reply-To: <20080331142111.GB14688@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-03-31 at 22:21 +0800, Herbert Xu wrote:
> > This patch allows user space applications to access large amounts of 
> > truly random data. The random data source is the build-in hardware 
> > random number generator on the CEX2C cards.
> > 
> > Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The patch looks OK.
> 
> Are you guys going to carry this patch in the s390 tree?

Yes, this patch should go in over git390.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


