From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: User Space API handling of large buffer
Date: Sun, 30 Mar 2008 15:14:30 +0400
Message-ID: <20080330111429.GA15122@2ka.mipt.ru>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com> <20080325030723.GA12830@gondor.apana.org.au> <20080325122656.GA15675@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D6043EDDC3@SDCEXCHANGE01.ad.amcc.com> <20080326214821.GA4066@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604466B38@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43251 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYC3LOm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Mar 2008 07:14:42 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604466B38@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Thu, Mar 27, 2008 at 02:50:47PM -0700, Loc Ho (lho@amcc.com) wrote:
> While creating user space API for Linux Crypto, I have a problem with
> large buffer. I am look for suggestion as to how to handle large user
> buffer greater than PAGE_SIZE. In the event, call issues an operation
> with data larger than PAGE_SIZE, must I create an array of page size
> scatterlist? Or can I using just one scatterlist entry? 
> 
> Would Linux allocates non-continuous memory but use TLB to make them
> look continous when calling kmalloc?

With page tables it will be vmalloc(), but that is not what we want,
since hardware requires physical pages and thus will not work with
vmalloced area (without knowing that it was vmalloced), so better split
buffer into pages and link them into scatterlists.

-- 
	Evgeniy Polyakov
