From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Thu, 16 Mar 2017 17:08:23 +0800
Message-ID: <20170316090823.GA11924@gondor.apana.org.au>
References: <2523592.mde6d2a8Lg@positron.chronox.de>
 <16908830.B9gcyeAhPX@positron.chronox.de>
 <20170316083922.GA11653@gondor.apana.org.au>
 <13069331.7r3bo5pPcW@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48575 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751182AbdCPJIa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 05:08:30 -0400
Content-Disposition: inline
In-Reply-To: <13069331.7r3bo5pPcW@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 16, 2017 at 09:55:17AM +0100, Stephan Müller wrote:
>
> With this approach I thought that the while loop could be a thing of the past, 
> considering that this is also the approach taken in skcipher_recvmsg_async 
> that is present in the current upstream code base.

The reason there is a limit is so that user-space doesn't pin down
unlimited amounts of memory.  How is this addressed under your
scheme?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
