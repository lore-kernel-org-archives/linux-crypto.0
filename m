From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: arm - enable module autoloading
Date: Thu, 1 Jun 2017 13:06:41 +0800
Message-ID: <20170601050641.GA12973@gondor.apana.org.au>
References: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:59248 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751152AbdFAFHA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 01:07:00 -0400
Content-Disposition: inline
In-Reply-To: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 21, 2017 at 10:23:35AM +0000, Ard Biesheuvel wrote:
> Now that the prerequisite changes are in place, we can modify the
> various accelerated crypto modules that use special instructions to
> expose the CPU feature they depend on. This allows udev to autoload
> the module at boot.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
