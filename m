From: Steve Capper <steve.capper@arm.com>
Subject: Re: [RFT PATCH] crypto: arm64 - implement SM3 secure hash using
 special instructions
Date: Wed, 17 Jan 2018 05:04:59 +0000
Message-ID: <20180117050459.eeszr4tjpaz4ccul@capper-debian.cambridge.arm.com>
References: <20180116082922.19465-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        catalin.marinas@arm.com, will.deacon@arm.com, gilad@benyossef.com,
        nd@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:61616
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750794AbeAQFFW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 00:05:22 -0500
Content-Disposition: inline
In-Reply-To: <20180116082922.19465-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 16, 2018 at 08:29:22AM +0000, Ard Biesheuvel wrote:
> Implement the Chinese SM3 secure hash algorithm using the new
> special instructions that have been introduced as an optional
> extension in ARMv8.2.
> 

Hi Ard,
I've tested this in a model against 4.15-rc8.

The following tcrypt modes were tested for sm3-ce:
52, 326 and 425.

So feel free to add:
Tested-by: Steve Capper <steve.capper@arm.com>

Cheers,
-- 
Steve
