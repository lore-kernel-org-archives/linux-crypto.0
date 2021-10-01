Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6941DC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 06:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44ADA615A4
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 06:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352219AbhJAGrI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Oct 2021 02:47:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55762 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231165AbhJAGrH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Oct 2021 02:47:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mWCIC-0006lE-DJ; Fri, 01 Oct 2021 14:45:12 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mWCI8-0003W2-IH; Fri, 01 Oct 2021 14:45:08 +0800
Date:   Fri, 1 Oct 2021 14:45:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecc: fix CRYPTO_DEFAULT_RNG dependency
Message-ID: <20211001064508.GB13451@gondor.apana.org.au>
References: <20210920100551.1568868-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920100551.1568868-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 20, 2021 at 12:05:35PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ecc.c file started out as part of the ECDH algorithm but got
> moved out into a standalone module later. It does not build without
> CRYPTO_DEFAULT_RNG, so now that other modules are using it as well we
> can run into this link error:
> 
> aarch64-linux-ld: ecc.c:(.text+0xfc8): undefined reference to `crypto_default_rng'
> aarch64-linux-ld: ecc.c:(.text+0xff4): undefined reference to `crypto_put_default_rng'
> 
> Move the 'select CRYPTO_DEFAULT_RNG' statement into the correct symbol.
> 
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
