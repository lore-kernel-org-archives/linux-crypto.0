From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 00/13] ARM: sun5i: cryptographic engine support
Date: Mon, 19 Jun 2017 14:43:09 +0800
Message-ID: <20170619064309.GC13800@gondor.apana.org.au>
References: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59718 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdFSGne (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:43:34 -0400
Content-Disposition: inline
In-Reply-To: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 01, 2017 at 09:38:52PM +0200, Antoine Tenart wrote:
> Hello,
> 
> This series adds the cryptographic engine support to sun5i SoCs. This is
> based on top of v4.12-rc1 and was tested on a CHIP. The series begins
> with fixes and improvements. The series is available at:
> https://github.com/atenart/linux v4.12-rc1/sun5i-crypto
> 
> The 8 first patches are reworks and cosmetic improvements.
> 
> Patch 9 moves the cipher part of the sun4i-ss driver from the ablkcipher
> API to the newer skcipher API.
> 
> Patch 10 adds the CRYPTO_ALG_KERN_DRIVER_ONLY flag for ciphers exposed
> by the sun4i-ss driver.
> 
> Patch 11 fixes the crypto framework selftests on the CHIP. It might fix
> other users too.

Patches 1-11 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
