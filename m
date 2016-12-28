From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: xts(ecb(aes-asm))
Date: Wed, 28 Dec 2016 17:01:08 +0800
Message-ID: <20161228090108.GB11904@gondor.apana.org.au>
References: <4308953.jQs16UQPE9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34671 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751108AbcL1JBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:01:15 -0500
Content-Disposition: inline
In-Reply-To: <4308953.jQs16UQPE9@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 09, 2016 at 07:02:25AM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> while testing the current cryptodev-2.6 tree, I noticed that instead of the 
> driver name of xts(aes-asm) (which used to be there), I now see xts(ecb(aes-
> asm)).
> 
> Is that intentional?

Yes this is a result of the xts template switching over to skciphers
instead of simple ciphers as its base.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
