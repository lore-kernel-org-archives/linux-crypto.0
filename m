Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA55C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346466AbiA1G1P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:27:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60618 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346464AbiA1G1O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:27:14 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKj1-0001Cz-L8; Fri, 28 Jan 2022 17:27:12 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:27:11 +1100
Date:   Fri, 28 Jan 2022 17:27:11 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] crypto: memneq: avoid implicit unaligned accesses
Message-ID: <YfOMv8c4h7MridGH@gondor.apana.org.au>
References: <20220119093109.1567314-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119093109.1567314-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 19, 2022 at 10:31:09AM +0100, Ard Biesheuvel wrote:
> The C standard does not support dereferencing pointers that are not
> aligned with respect to the pointed-to type, and doing so is technically
> undefined behavior, even if the underlying hardware supports it.
> 
> This means that conditionally dereferencing such pointers based on
> whether CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y is not the right thing
> to do, and actually results in alignment faults on ARM, which are fixed
> up on a slow path. Instead, we should use the unaligned accessors in
> such cases: on architectures that don't care about alignment, they will
> result in identical codegen whereas, e.g., codegen on ARM will avoid
> doubleword loads and stores but use ordinary ones, which are able to
> tolerate misalignment.
> 
> Link: https://lore.kernel.org/linux-crypto/CAHk-=wiKkdYLY0bv+nXrcJz3NH9mAqPAafX7PpW5EwVtxsEu7Q@mail.gmail.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/memneq.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
