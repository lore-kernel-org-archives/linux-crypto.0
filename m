From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: fix type mismatch warning
Date: Tue, 1 Nov 2016 08:44:14 +0800
Message-ID: <20161101004414.GA7465@gondor.apana.org.au>
References: <20161025212923.2452320-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Catalin Vasile <cata.vasile@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34023 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948319AbcKAAo2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:44:28 -0400
Content-Disposition: inline
In-Reply-To: <20161025212923.2452320-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 25, 2016 at 11:29:10PM +0200, Arnd Bergmann wrote:
> Building the caam driver on arm64 produces a harmless warning:
> 
> drivers/crypto/caam/caamalg.c:140:139: warning: comparison of distinct pointer types lacks a cast
> 
> We can use min_t to tell the compiler which type we want it to use
> here.
> 
> Fixes: 5ecf8ef9103c ("crypto: caam - fix sg dump")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
