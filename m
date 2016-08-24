From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: drbg - fix error return code
Date: Wed, 24 Aug 2016 21:15:17 +0800
Message-ID: <20160824131517.GE3850@gondor.apana.org.au>
References: <1471705611-19309-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36185 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbcHXNPc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 09:15:32 -0400
Content-Disposition: inline
In-Reply-To: <1471705611-19309-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 20, 2016 at 03:06:51PM +0000, Wei Yongjun wrote:
> Fix to return a negative error code from the error handling
> case instead of 0.
> 
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
