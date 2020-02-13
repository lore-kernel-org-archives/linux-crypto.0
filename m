Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588D6C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B02620848
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgBMJSk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:18:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42218 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbgBMJSk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 04:18:40 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2Adq-00047h-Sj; Thu, 13 Feb 2020 17:18:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2Adq-0006lR-4N; Thu, 13 Feb 2020 17:18:38 +0800
Date:   Thu, 13 Feb 2020 17:18:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH] crypto: x86/curve25519 - replace with formally verified
 implementation
Message-ID: <20200213091838.fzwu7c7hmld6ajdx@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120171815.994089-1-Jason@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This comes from INRIA's HACL*/Vale. It implements the same algorithm and
> implementation strategy as the code it replaces, only this code has been
> formally verified, sans the base point multiplication, which uses code
> similar to prior, only it uses the formally verified field arithmetic
> alongside reproducable ladder generation steps. This doesn't have a
> pure-bmi2 version, which means haswell no longer benefits, but the
> increased (doubled) code complexity is not worth it for a single
> generation of chips that's already old.
> 
> Performance-wise, this is around 1% slower on older microarchitectures,
> and slightly faster on newer microarchitectures, mainly 10nm ones or
> backports of 10nm to 14nm. This implementation is "everest" below:
> 
> Xeon E5-2680 v4 (Broadwell)
> 
>     armfazh: 133340 cycles per call
>     everest: 133436 cycles per call
> 
> Xeon Gold 5120 (Sky Lake Server)
> 
>     armfazh: 112636 cycles per call
>     everest: 113906 cycles per call
> 
> Core i5-6300U (Sky Lake Client)
> 
>     armfazh: 116810 cycles per call
>     everest: 117916 cycles per call
> 
> Core i7-7600U (Kaby Lake)
> 
>     armfazh: 119523 cycles per call
>     everest: 119040 cycles per call
> 
> Core i7-8750H (Coffee Lake)
> 
>     armfazh: 113914 cycles per call
>     everest: 113650 cycles per call
> 
> Core i9-9880H (Coffee Lake Refresh)
> 
>     armfazh: 112616 cycles per call
>     everest: 114082 cycles per call
> 
> Core i3-8121U (Cannon Lake)
> 
>     armfazh: 113202 cycles per call
>     everest: 111382 cycles per call
> 
> Core i7-8265U (Whiskey Lake)
> 
>     armfazh: 127307 cycles per call
>     everest: 127697 cycles per call
> 
> Core i7-8550U (Kaby Lake Refresh)
> 
>     armfazh: 127522 cycles per call
>     everest: 127083 cycles per call
> 
> Xeon Platinum 8275CL (Cascade Lake)
> 
>     armfazh: 114380 cycles per call
>     everest: 114656 cycles per call
> 
> Achieving these kind of results with formally verified code is quite
> remarkable, especialy considering that performance is favorable for
> newer chips.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> arch/x86/crypto/curve25519-x86_64.c | 3546 ++++++++++-----------------
> 1 file changed, 1292 insertions(+), 2254 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
