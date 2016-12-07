From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: AF_ALG - fix AEAD tag memory handling
Date: Wed, 7 Dec 2016 20:09:14 +0800
Message-ID: <20161207120914.GD20680@gondor.apana.org.au>
References: <2319539.qMqmu7oTgO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59760 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751129AbcLGMJ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 07:09:28 -0500
Content-Disposition: inline
In-Reply-To: <2319539.qMqmu7oTgO@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 05, 2016 at 03:26:19PM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> Changes v4: restore the old behavior -- if the caller does not provide sufficient
> output buffer size, return an error.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
