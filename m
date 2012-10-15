From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: convert to use be16_add_cpu()
Date: Mon, 15 Oct 2012 22:31:49 +0800
Message-ID: <20121015143149.GB25426@gondor.apana.org.au>
References: <CAPgLHd83AK565T27aqLUcK4o8ZJh=RCaBaqcnHH8ivwQTBgcaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
	yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:42435 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898Ab2JOOcx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Oct 2012 10:32:53 -0400
Content-Disposition: inline
In-Reply-To: <CAPgLHd83AK565T27aqLUcK4o8ZJh=RCaBaqcnHH8ivwQTBgcaA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 28, 2012 at 12:52:25PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Convert cpu_to_be16(be16_to_cpu(E1) + E2) to use be16_add_cpu().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
