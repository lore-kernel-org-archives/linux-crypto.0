From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: AF_ALG - fix AEAD tag memory handling
Date: Mon, 5 Dec 2016 20:26:52 +0800
Message-ID: <20161205122652.GA10635@gondor.apana.org.au>
References: <14103787.a1H06iWQgk@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43531 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751100AbcLEM1g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 07:27:36 -0500
Content-Disposition: inline
In-Reply-To: <14103787.a1H06iWQgk@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 02, 2016 at 03:16:26PM +0100, Stephan Mueller wrote:
>
> In addition, the code now handles the situation where the provided
> output buffer is too small by reducing the size of the processed
> input buffer accordingly. Due to this handling, he changes are

I think that's dangerous.  The AEAD interface doesn't do chaining
so it's all or nothing.  If the input doesn't fit within the output
buffer then you should not truncate the input as that would either
generate a bogus tag on encryption or accept a bogus tag on
decryption.

I suggest that you instead return EINVAL in such a case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
