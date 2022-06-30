Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA81C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 08:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbiF3IQv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiF3IQV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 04:16:21 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF0143ADC
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 01:13:04 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6pIH-00Cy5N-OU; Thu, 30 Jun 2022 18:12:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 16:12:58 +0800
Date:   Thu, 30 Jun 2022 16:12:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lib/crypto: blake2s: reduce stack frame usage in self
 test
Message-ID: <Yr1bCsv2jnRK9OjL@gondor.apana.org.au>
References: <202206200851.gE3MHCgd-lkp@intel.com>
 <20220620075243.686177-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620075243.686177-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 20, 2022 at 09:52:43AM +0200, Jason A. Donenfeld wrote:
> Using 3 blocks here doesn't give us much more than using 2, and it
> causes a stack frame size warning on certain compiler/config/arch
> combinations:
> 
>    lib/crypto/blake2s-selftest.c: In function 'blake2s_selftest':
> >> lib/crypto/blake2s-selftest.c:632:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>      632 | }
>          | ^
> 
> So this patch just reduces the block from 3 to 2, which makes the
> warning go away.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/linux-crypto/202206200851.gE3MHCgd-lkp@intel.com
> Fixes: 2d16803c562e ("crypto: blake2s - remove shash module")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  lib/crypto/blake2s-selftest.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
