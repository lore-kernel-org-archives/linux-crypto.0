From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Fri, 1 May 2015 11:20:35 +0800
Message-ID: <20150501032035.GA371@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <1742335.S7ujyfP8MQ@myon.chronox.de>
 <20150428025402.GB29738@gondor.apana.org.au>
 <1906826.TjaHhvv93b@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55072 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbEADUj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 23:20:39 -0400
Content-Disposition: inline
In-Reply-To: <1906826.TjaHhvv93b@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2015 at 04:58:31AM +0200, Stephan Mueller wrote:
>
> Hm, in case of dm-crypt, that is not really possible, because this is fully 
> driven by user space: libcryptsetup sets up a temporary dm-crypt container for 
> the LUKS header space. Then user space accesses the data it needs and re-
> injects it into the kernel for the bulk encryption dm-crypt component.

If both user-space and the kernel implements the same algorithm
correctly why wouldn't it work?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
