From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - reduce stack size with KASAN
Date: Fri, 22 Dec 2017 20:06:36 +1100
Message-ID: <20171222090636.GC32542@gondor.apana.org.au>
References: <20171211120712.3806351-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46402 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933935AbdLVJGs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 04:06:48 -0500
Content-Disposition: inline
In-Reply-To: <20171211120712.3806351-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 11, 2017 at 01:07:00PM +0100, Arnd Bergmann wrote:
> Passing the register value by reference here leads a large amount of stack being
> used when CONFIG_KASAN is enabled:
> 
> drivers/crypto/qat/qat_common/qat_hal.c: In function 'qat_hal_exec_micro_inst.constprop':
> drivers/crypto/qat/qat_common/qat_hal.c:963:1: error: the frame size of 1792 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
> 
> Changing the register-read function to return the value instead reduces the stack
> size to around 800 bytes, most of which is for the 'savuwords' array. The function
> now no longer returns an error code, but nothing ever evaluated that anyway.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
