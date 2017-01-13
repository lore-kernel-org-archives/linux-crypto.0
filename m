From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 19:14:06 +0800
Message-ID: <20170113111406.GB23800@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <9279288.fr5DIlfFLr@positron.chronox.de>
 <20170113110417.GB23617@gondor.apana.org.au>
 <1593277.7QY5i6DVS0@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37755 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751350AbdAMLOM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:14:12 -0500
Content-Disposition: inline
In-Reply-To: <1593277.7QY5i6DVS0@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:12:39PM +0100, Stephan Müller wrote:
>
> Adding such code should IMHO not be impaired by pointing to the AAD held in 
> the src SGL by the dst SGL as offered with the older patch mentioned before.

The point is you're turning what could otherwise be a linear SGL
into a non-linear one by forcing the same AAD on both sides.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
