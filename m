From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Question] AEAD crypto api for userspace can't deal with a
 PTlen=0 vector
Date: Mon, 11 May 2015 14:36:06 +0800
Message-ID: <20150511063606.GB2430@gondor.apana.org.au>
References: <554B3415.3060707@huawei.com>
 <1449423.5ryfY6rDCG@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yao Dongdong <yaodongdong@huawei.com>,
	linux-crypto@vger.kernel.org, "Lihui (Eric)" <lihui8@huawei.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52871 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbEKGgJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 02:36:09 -0400
Content-Disposition: inline
In-Reply-To: <1449423.5ryfY6rDCG@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 07, 2015 at 01:28:14PM +0200, Stephan Mueller wrote:
>
> You cannot. Currently, the interface is not intended to handle such specific 
> CAVS conditions (zero CT and AAD). Note, this test effectively only validates 
> GHASH.

No we should definitely be able to support this case.  However,
we don't have to do it through read(2).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
