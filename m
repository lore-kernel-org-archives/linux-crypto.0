From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 19:39:06 +0800
Message-ID: <20170113113906.GA24096@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <1704568.lHqrOxcchT@positron.chronox.de>
 <20170113113324.GA24021@gondor.apana.org.au>
 <2829634.RJknVxGPvY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49709 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751733AbdAMLjN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:39:13 -0500
Content-Disposition: inline
In-Reply-To: <2829634.RJknVxGPvY@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 12:36:56PM +0100, Stephan Müller wrote:
>
> I thought I understood that you would not want to see it in any 
> implementation. But, ok, if you want to leave it.

If you remove it from authenc then authenc will be broken.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
