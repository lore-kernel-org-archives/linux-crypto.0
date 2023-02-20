Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC46FC05027
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Feb 2023 04:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBTEoh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 23:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTEog (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 23:44:36 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8475AA5E2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 20:44:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pTy2P-00DEiA-Tj; Mon, 20 Feb 2023 12:44:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Feb 2023 12:44:29 +0800
Date:   Mon, 20 Feb 2023 12:44:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB
 mode
Message-ID: <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
References: <20230217144348.1537615-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217144348.1537615-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 17, 2023 at 03:43:48PM +0100, Ard Biesheuvel wrote:
> Implement AES in CFB mode using the existing, mostly constant-time
> generic AES library implementation. This will be used by the TPM code
> to encrypt communications with TPM hardware, which is often a discrete
> component connected using sniffable wires or traces.
> 
> While a CFB template does exist, using a skcipher is a major pain for
> non-performance critical synchronous crypto where the algorithm is known
> at compile time and the data is in contiguous buffers with valid kernel
> virtual addresses.
> 
> Tested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Link: https://lore.kernel.org/all/20230216201410.15010-1-James.Bottomley@HansenPartnership.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v1 was sent out by James and is archived at the URL above
> 
> v2:
> - add test cases and kerneldoc comments
> - add memzero_explicit() calls to wipe the keystream buffers
> - add module exports
> - add James's Tb/Rb
> 
>  include/crypto/aes.h |   5 +
>  lib/crypto/Kconfig   |   5 +
>  lib/crypto/Makefile  |   3 +
>  lib/crypto/aescfb.c  | 257 ++++++++++++++++++++
>  4 files changed, 270 insertions(+)

Could we remove the crypto/cfb.c implementation after this work
is complete?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
