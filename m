Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4450BC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C9820786
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgHRIYO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:24:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42286 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRIYO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:24:14 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k7wug-0000cQ-Bq; Tue, 18 Aug 2020 18:24:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2020 18:24:10 +1000
Date:   Tue, 18 Aug 2020 18:24:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
Message-ID: <20200818082410.GA24497@gondor.apana.org.au>
References: <20200802090616.1328-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802090616.1328-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 02, 2020 at 12:06:16PM +0300, Ard Biesheuvel wrote:
> Ben reports that CCM using AES-NI instructions performs pathologically
> poorly, which is due to the overhead of preserving/restoring the SIMD
> state, which is repeated after every 16 bytes of input when executing
> the CBCMAC portion of the algorithm.
> 
> So let's clone the arm64 implementation of cbcmac(aes), which takes
> care to only preserve/restore the SIMD state after processing the
> whole input. Since cmac(aes) and xcbc(aes) can reuse most of the code,
> let's expose those as well.
> 
> Cc: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/Makefile           |   2 +-
>  arch/x86/crypto/aesni-intel.h      |  39 +++
>  arch/x86/crypto/aesni-intel_glue.c |  42 +---
>  arch/x86/crypto/aesni-intel_mac.c  | 257 ++++++++++++++++++++
>  4 files changed, 306 insertions(+), 34 deletions(-)

We should just use the accelerated cbc skcipher.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
