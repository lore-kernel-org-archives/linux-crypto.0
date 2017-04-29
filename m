From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: stm32 - fix building as a module
Date: Sun, 30 Apr 2017 01:54:41 +0800
Message-ID: <20170429175441.GA11834@gondor.apana.org.au>
References: <20170427110907.2515229-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Fabien DESSENNE <fabien.dessenne@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40088 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032534AbdD2RzH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Apr 2017 13:55:07 -0400
Content-Disposition: inline
In-Reply-To: <20170427110907.2515229-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 27, 2017 at 01:07:07PM +0200, Arnd Bergmann wrote:
> The names in the MODULE_DEVICE_TABLE and the actual array don't match:
> 
> drivers/crypto/stm32/stm32_crc32.c:309:21: error: 'sti_dt_ids' undeclared here (not in a function); did you mean 'stm32_dt_ids'?
> 
> This changes the reference that was evidently copied incorrectly from
> another driver.
> 
> Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This has already been fixed by

https://patchwork.kernel.org/patch/9698299/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
