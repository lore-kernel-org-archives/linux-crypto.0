From: Steve Capper <steve.capper@arm.com>
Subject: Re: [RFT PATCH] crypto: arm64 - implement SHA-512 using special
 instructions
Date: Tue, 16 Jan 2018 08:16:17 +0000
Message-ID: <20180116081617.cq5iok2os6ylgjkc@capper-debian.cambridge.arm.com>
References: <20180109182302.11521-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org,
        steve.capper@linaro.org, herbert@gondor.apana.org.au,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-crypto@vger.kernel.org, nd@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:2112
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750826AbeAPIQt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 03:16:49 -0500
Content-Disposition: inline
In-Reply-To: <20180109182302.11521-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 09, 2018 at 06:23:02PM +0000, Ard Biesheuvel wrote:
> Implement the SHA-512 using the new special instructions that have
> been introduced as an optional extension in ARMv8.2.

Hi Ard,
I have tested this applied on top of 4.15-rc7 running in a model.

For sha512-ce, I verified that tcrypt successfully passed tests for modes:
12, 104, 189, 190, 306, 406 and 424.
(and I double checked that sha512-ce was being used).

Similarly for sha384-ce, I tested the following modes:
11, 103, 187, 188, 305 and 405. 

Also, I had:
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n

So FWIW, please feel free to add:
Tested-by: Steve Capper <steve.capper@arm.com>

Cheers,
-- 
Steve
