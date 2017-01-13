From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 19:26:23 +0800
Message-ID: <20170113112623.GB23928@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <1593277.7QY5i6DVS0@positron.chronox.de>
 <20170113111406.GB23800@gondor.apana.org.au>
 <2328881.s8hPz576Kn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39267 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751505AbdAML0a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:26:30 -0500
Content-Disposition: inline
In-Reply-To: <2328881.s8hPz576Kn@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:19:48PM +0100, Stephan Müller wrote:
> 
> That is correct, but I thought that playing with pointers is always faster 
> than doing memcpy. Are you saying that this assumption is not true when we 
> somehow have the code to try to perform an in-place operation?

If you're doing crypto the overhead in copying the AAD is the
last thing you need to worry about.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
