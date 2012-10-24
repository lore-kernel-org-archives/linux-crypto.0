From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix missing unlock on error case
Date: Wed, 24 Oct 2012 21:12:24 +0800
Message-ID: <20121024131224.GC3251@gondor.apana.org.au>
References: <CAPgLHd8f2UorFGa57n94k_7cbD8G3XNYVOkmHPqhySs2Nd0pNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
	linux-crypto@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:49970 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402Ab2JXNMi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2012 09:12:38 -0400
Content-Disposition: inline
In-Reply-To: <CAPgLHd8f2UorFGa57n94k_7cbD8G3XNYVOkmHPqhySs2Nd0pNw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 21, 2012 at 07:56:42PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock on the error handling path in function
> tegra_aes_get_random() and tegra_aes_rng_reset().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
