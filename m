Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E960C04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1883E600CD
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhEXVxV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 17:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhEXVxV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 17:53:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90DC6140F;
        Mon, 24 May 2021 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621893113;
        bh=JwMiFlepZGdEM/tdol4UXFMcLZi3bjn72+O7tDFU0Do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jAHeNEXojAa3f0L/BAj6/GjWI6Su8ad7XgOWUW7i3e+A/Pl/U7lMgoh/HQW/iaTAT
         JEPgzHGvBEom9m7oPCrrgGykdjwgiWO3PwUAD2/kiGhNPmBUEsY6d+DoEruT4oujTv
         +YRklIxgG6AmSBZ/2heUh30UxSRx+3bv0tlco1rtUIu3HXamxM1JUPZdTBDSDQePGa
         /bZGgYyOhhSk3jMm5QDlF9OgcsWiaDj9Q17lgbH/0NffMp+6ZuLNFAm1sWLM92UNNl
         Twhp0oeaNAMETeHeENHUBd2rmy/v61DLDS2x2dlmeOm2v12Uc9ctDca39nafp/AYu2
         xT4Lrwhyjm6vQ==
Date:   Mon, 24 May 2021 14:51:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v5 4/5] crypto: arm64/aes-ccm - remove non-SIMD fallback
 path
Message-ID: <YKwf9wmioRxrKOGO@gmail.com>
References: <20210521102053.66609-1-ardb@kernel.org>
 <20210521102053.66609-5-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521102053.66609-5-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 12:20:52PM +0200, Ard Biesheuvel wrote:
> AES/CCM on arm64 is implemented as a synchronous AEAD, and so it is
> guaranteed by the API that it is only invoked in task or softirq
> context. Since softirqs are now only handled when the SIMD is not
> being used in the task context that was interrupted to service the
> softirq, we no longer need a fallback path. Let's remove it.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce-ccm-core.S |   1 +
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 181 ++++++--------------
>  2 files changed, 53 insertions(+), 129 deletions(-)

This doesn't just remove the no-SIMD fallback, but it also does some
refactoring.  Notably, it starts to process all the authenticated data in one
kernel_neon_begin() / kernel_neon_end() pair rather than many.  Can you explain
why that is okay now when previously it wasn't, and also split this into two
separate commits?

- Eric
