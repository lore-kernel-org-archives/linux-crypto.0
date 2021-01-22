Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D13BC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 06:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC39235FF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 06:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbhAVGVg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 01:21:36 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54108 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbhAVGVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 01:21:36 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l2poT-00021X-6r; Fri, 22 Jan 2021 17:20:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Jan 2021 17:20:53 +1100
Date:   Fri, 22 Jan 2021 17:20:53 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/sha - add missing module aliases
Message-ID: <20210122062053.GB1217@gondor.apana.org.au>
References: <20210114181010.17187-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114181010.17187-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 14, 2021 at 07:10:10PM +0100, Ard Biesheuvel wrote:
> The accelerated, instruction based implementations of SHA1, SHA2 and
> SHA3 are autoloaded based on CPU capabilities, given that the code is
> modest in size, and widely used, which means that resolving the algo
> name, loading all compatible modules and picking the one with the
> highest priority is taken to be suboptimal.
> 
> However, if these algorithms are requested before this CPU feature
> based matching and autoloading occurs, these modules are not even
> considered, and we end up with suboptimal performance.
> 
> So add the missing module aliases for the various SHA implementations.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/sha1-ce-glue.c   | 1 +
>  arch/arm64/crypto/sha2-ce-glue.c   | 2 ++
>  arch/arm64/crypto/sha3-ce-glue.c   | 4 ++++
>  arch/arm64/crypto/sha512-ce-glue.c | 2 ++
>  4 files changed, 9 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
