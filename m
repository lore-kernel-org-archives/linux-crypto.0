Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F94EC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 08:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351539AbiDOIpB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351466AbiDOIoM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 04:44:12 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD3BB9188;
        Fri, 15 Apr 2022 01:41:44 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nfHWD-003Ec4-DH; Fri, 15 Apr 2022 18:41:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Apr 2022 16:41:29 +0800
Date:   Fri, 15 Apr 2022 16:41:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/sm4 - Fix wrong dependency of NEON/CE
 implementation
Message-ID: <YlkvuRZXyv2jBTQL@gondor.apana.org.au>
References: <20220411031313.35449-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411031313.35449-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 11, 2022 at 11:13:13AM +0800, Tianjia Zhang wrote:
> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
> moved the sm4 library implementation from the lib/crypto directory to
> the crypto directory and configured the name as CRYPTO_SM4. The arm64
> SM4 NEON/CE implementation depends on this and needs to be modified
> uniformly.
> 
> Fixes: 4f1aef9b806f ("crypto: arm64/sm4 - add ARMv8 NEON implementation")
> Fixes: 5b33e0ec881c ("crypto: arm64/sm4 - add ARMv8 Crypto Extensions implementation")
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/arm64/crypto/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
