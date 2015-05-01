From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Fri, 1 May 2015 15:30:36 +0800
Message-ID: <20150501073036.GA1999@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <1906826.TjaHhvv93b@myon.chronox.de>
 <20150501032035.GA371@gondor.apana.org.au>
 <43350012.VMEhAijB9c@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46409 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbbEAHal (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 03:30:41 -0400
Content-Disposition: inline
In-Reply-To: <43350012.VMEhAijB9c@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 01, 2015 at 09:27:07AM +0200, Stephan Mueller wrote:
>
> User space does not use any ciphers to protect the key, that is the 
> interesting part. The LUKS header will be mapped by a dm-crypt mapping and 
> then read from user space to access the key. So, userspace does not en/decrypt 
> the data.

So who is doing the encrypting/decrypting in this case?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
