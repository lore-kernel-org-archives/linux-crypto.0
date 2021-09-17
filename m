Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C78C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B01A610A4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 03:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhIQDU3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 23:20:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55242 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243829AbhIQDU1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 23:20:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mR4P3-00069W-Be; Fri, 17 Sep 2021 11:19:05 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mR4P2-0001jg-Vd; Fri, 17 Sep 2021 11:19:05 +0800
Date:   Fri, 17 Sep 2021 11:19:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiggers@kernel.org
Subject: Re: [PATCH v7 0/7] running kernel mode SIMD with softirqs disabled
Message-ID: <20210917031904.GC6559@gondor.apana.org.au>
References: <20210827070342.218276-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827070342.218276-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 27, 2021 at 09:03:35AM +0200, Ard Biesheuvel wrote:
> This is a follow-up to [0], but given that the arm64 architectural
> pieces have been merged for arm64, the only remaining changes are crypto
> specific. Therefore, the audience has been reduced to those people who
> are somewhat more likely to care about these specifics.
> 
> The AEAD and skcipher APIs may only be called from task or softirq
> context. This permits the arm64 AEAD and skcipher code to get rid of all
> scalar fallbacks, given that on this architecture, softirqs are now no
> longer served while the SIMD unit is being used in kernel mode, which
> means that the scalar fallbacks are never needed. These are removed in
> this series.
> 
> Changes since v6:
> - add patch to yield the NEON every 4k of input when processing the AAD
> - add some more acks from Eric
> 
> Changes since v5:
> - add Eric's R-b to patches #1 to #3
> - split CCM changes into 3 separate patches
> 
> Changes since v4:
> - drop skcipher_walk layer change to deal with zero sized walks
> - drop aead/skcipher layer sanity checks on invocations from hardirq
>   context
> - add patch to clean up CCM a bit more after removing the SIMD code path
> 
> Changes since v3:
> - clarify the nature of the issue addressed by patch #1, and apply the
>   same fix to the skcipher walker
> - update patches #2 and #3 so that the failures can be observed by the
>   crypto stats code
> 
> [0] https://lore.kernel.org/linux-arm-kernel/20210302090118.30666-1-ardb@kernel.org/
> 
> Ard Biesheuvel (7):
>   crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
>   crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
>   crypto: arm64/aes-ce - stop using SIMD helper for skciphers
>   crypto: arm64/aes-ccm - yield NEON when processing auth-only data
>   crypto: arm64/aes-ccm - remove non-SIMD fallback path
>   crypto: arm64/aes-ccm - reduce NEON begin/end calls for common case
>   crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data
> 
>  arch/arm64/crypto/Kconfig           |   6 -
>  arch/arm64/crypto/aes-ce-ccm-core.S |  24 +--
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 203 ++++++-------------
>  arch/arm64/crypto/aes-glue.c        | 102 ++--------
>  arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
>  arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
>  6 files changed, 148 insertions(+), 518 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
