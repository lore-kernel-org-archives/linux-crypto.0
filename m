From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Fri, 13 Jan 2017 19:03:35 +0800
Message-ID: <20170113110335.GA23617@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <5211147.RjDSfvrhhz@tauon.atsec.com>
 <20170113102145.GA23349@gondor.apana.org.au>
 <1588177.ehMkkoOMrj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44629 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751544AbdAMLDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:03:43 -0500
Content-Disposition: inline
In-Reply-To: <1588177.ehMkkoOMrj@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 11:49:05AM +0100, Stephan Müller wrote:
> 
> According to the man page of lio_listio(3) the provided AIO operations are 
> executed in an unspecified order. I would infer from that statement that even 
> if an order of write / read / write / read is defined by the caller, this 
> order may not be followed by the kernel. Thus we would need to consider the 
> case that in the end, algif has to process the order of write / write / read / 
> read or any other order.

Well if ordering is not guaranteed that I don't see how your code
can work either.  Or am I missing something?

> Besides, the crashes I reported for the current AIO implementation in 
> algif_aead and algif_skcipher are always triggered when invoking an aio_read 
> with two or more IOCBs. The most important aspect I want to cover with the 
> patch set is to stop crashing the kernel.

Please stop adding new features and just fix the existing crash.
Once we have that covered and backported to stable then we can
start addressing new features.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
