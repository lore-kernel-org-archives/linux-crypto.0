Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C567C433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D13207A5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhABWJF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:09:05 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37360 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbhABWJF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:09:05 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp4L-0000bj-Gw; Sun, 03 Jan 2021 09:08:18 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:08:17 +1100
Date:   Sun, 3 Jan 2021 09:08:17 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: arm64/aes-ctr - improve tail handling
Message-ID: <20210102220817.GN12767@gondor.apana.org.au>
References: <20201217185516.26969-1-ardb@kernel.org>
 <20201217185516.26969-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217185516.26969-2-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 07:55:16PM +0100, Ard Biesheuvel wrote:
> Counter mode is a stream cipher chaining mode that is typically used
> with inputs that are of arbitrarily length, and so a tail block which
> is smaller than a full AES block is rule rather than exception.
> 
> The current ctr(aes) implementation for arm64 always makes a separate
> call into the assembler routine to process this tail block, which is
> suboptimal, given that it requires reloading of the AES round keys,
> and prevents us from handling this tail block using the 5-way stride
> that we use for better performance on deep pipelines.
> 
> So let's update the assembler routine so it can handle any input size,
> and uses NEON permutation instructions and overlapping loads and stores
> to handle the tail block. This results in a ~16% speedup for 1420 byte
> blocks on cores with deep pipelines such as ThunderX2.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-glue.c  |  46 +++---
>  arch/arm64/crypto/aes-modes.S | 165 +++++++++++++-------
>  2 files changed, 137 insertions(+), 74 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
