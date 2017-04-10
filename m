From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to
 ASM_EXPORT
Date: Mon, 10 Apr 2017 19:22:30 +0800
Message-ID: <20170410112230.GA8800@gondor.apana.org.au>
References: <20170405183458.193068-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Greg Hackmann <ghackmann@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Matthias Kaehlcke <mka@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51924 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753557AbdDJLW7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 07:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20170405183458.193068-1-mka@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 05, 2017 at 11:34:58AM -0700, Matthias Kaehlcke wrote:
> The operand is an integer constant, make the constness explicit by
> adding the modifier. This is needed for clang to generate valid code
> and also works with gcc.
> 
> Also change the constraint of the operand from 'I' ("Integer constant
> that is valid as an immediate operand in an ADD instruction", AArch64)
> to 'i' ("An immediate integer operand").
> 
> Based-on-patch-from: Greg Hackmann <ghackmann@google.com>
> Signed-off-by: Greg Hackmann <ghackmann@google.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
