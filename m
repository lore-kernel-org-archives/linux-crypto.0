From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: stm32 - Fix uninitialized data usage
Date: Sat, 7 Oct 2017 12:19:58 +0800
Message-ID: <20171007041958.GF29803@gondor.apana.org.au>
References: <20170912093553.2580986-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lionel Debieve <lionel.debieve@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57408 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdJGEUb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 00:20:31 -0400
Content-Disposition: inline
In-Reply-To: <20170912093553.2580986-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 12, 2017 at 11:35:38AM +0200, Arnd Bergmann wrote:
> The error handling in stm32_hash_irq_thread passes
> uninitialized data into stm32_hash_finish_req, as gcc
> points out:
> 
> drivers/crypto/stm32/stm32-hash.c: In function 'stm32_hash_irq_thread':
> drivers/crypto/stm32/stm32-hash.c:1088:2: error: 'err' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> I could not tell what data should be passed there instead,
> so this changes the code to always pass zero, making it
> well-defined, though possibly still wrong. Please check.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This is already fixed in cryptodev.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
