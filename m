From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix DMA-API warning
Date: Thu, 22 May 2014 21:09:25 +0800
Message-ID: <20140522130924.GE3598@gondor.apana.org.au>
References: <20140519165133.GA3365@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35617 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEVNJc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 09:09:32 -0400
Content-Disposition: inline
In-Reply-To: <20140519165133.GA3365@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 19, 2014 at 09:51:33AM -0700, Tadeusz Struk wrote:
> With DMA-API debug enabled testmgr triggers a "DMA-API: device driver maps memory from stack" warning, when tested on a crypto HW accelerator.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
