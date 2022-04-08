Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFDFC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Apr 2022 08:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiDHIct (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiDHIcd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Apr 2022 04:32:33 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A12FF508
        for <linux-crypto@vger.kernel.org>; Fri,  8 Apr 2022 01:30:30 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nck0g-000SDC-3t; Fri, 08 Apr 2022 18:30:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Apr 2022 16:30:26 +0800
Date:   Fri, 8 Apr 2022 16:30:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
        ebiggers@kernel.org
Subject: Re: [PATCH] crypto: move sm3 and sm4 into crypto directory
Message-ID: <Yk/yomWIIL8ZnPHp@gondor.apana.org.au>
References: <20220314031101.663883-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314031101.663883-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 13, 2022 at 09:11:01PM -0600, Jason A. Donenfeld wrote:
> The lib/crypto libraries live in lib because they are used by various
> drivers of the kernel. In contrast, the various helper functions in
> crypto are there because they're used exclusively by the crypto API. The
> SM3 and SM4 helper functions were erroniously moved into lib/crypto/
> instead of crypto/, even though there are no in-kernel users outside of
> the crypto API of those functions. This commit moves them into crypto/.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/arm64/crypto/Kconfig    |  4 ++--
>  crypto/Kconfig               | 18 ++++++++++++------
>  crypto/Makefile              |  6 ++++--
>  {lib/crypto => crypto}/sm3.c |  0
>  {lib/crypto => crypto}/sm4.c |  0
>  lib/crypto/Kconfig           |  6 ------
>  lib/crypto/Makefile          |  6 ------
>  7 files changed, 18 insertions(+), 22 deletions(-)
>  rename {lib/crypto => crypto}/sm3.c (100%)
>  rename {lib/crypto => crypto}/sm4.c (100%)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
