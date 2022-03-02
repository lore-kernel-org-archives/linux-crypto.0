Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A473FC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 00:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiCCABM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCCABK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 19:01:10 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B165BE6F
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 16:00:14 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nPXw4-0006DF-BS; Thu, 03 Mar 2022 09:59:09 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Mar 2022 10:59:08 +1200
Date:   Thu, 3 Mar 2022 10:59:08 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v2] crypto: crypto_xor - use helpers for unaligned
 accesses
Message-ID: <Yh/2vHEt+fGO3DlJ@gondor.apana.org.au>
References: <20220223070701.1457542-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223070701.1457542-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 23, 2022 at 08:07:01AM +0100, Ard Biesheuvel wrote:
> Dereferencing a misaligned pointer is undefined behavior in C, and may
> result in codegen on architectures such as ARM that trigger alignments
> traps and expensive fixups in software.
> 
> Instead, use the get_aligned()/put_aligned() accessors, which are cheap
> or even completely free when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y.
> 
> In the converse case, the prior alignment checks ensure that the casts
> are safe, and so no unaligned accessors are necessary.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2: fix issue in crypto_xor_cpy()
> 
>  crypto/algapi.c         | 24 +++++++++++++++++---
>  include/crypto/algapi.h | 10 ++++++--
>  2 files changed, 29 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
