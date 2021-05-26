Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00822C47088
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 16:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72B3613D7
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 16:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhEZQ71 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 12:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233725AbhEZQ7X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 12:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A9AA613E5;
        Wed, 26 May 2021 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622048271;
        bh=xrw5xQa0Ao9OhAkU/wgbik2nbqFDwxOpP1syqGR6CIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pQcu+jHdCmweZ0e8P5/4hQhB0riBSStq8zh3KBBCGvz5EpTGaEKk7wuG97CNh9EzI
         xX3HpcwHjNrO9xrLnbDmmNSN8D1HQbIZZseciH40KbIr2hQzfpP7lrIjvXch0Djeoi
         gD0FiUDjb/xvmj7CGxsF/2T7So4/HtHQBCDAjaMa6ECTT5ACEXAoe/aIfN6untCXSr
         IEHvyBRJtdmAnbj4Z1Se4EFE8Hc6ToLoWF8sv4QWVUYq8akI1ruKULg/nkZJZ9V1VQ
         meVkisjoT+HnhldTd7PONdXJ5xBJSAvRoQLYZjY9+IMOgMIiu9NDVTyGx9F1SMrF2i
         5FRLOqhU6e4pw==
Date:   Wed, 26 May 2021 09:57:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v6 4/6] crypto: arm64/aes-ccm - remove non-SIMD fallback
 path
Message-ID: <YK5+Dfau6258hulo@gmail.com>
References: <20210526100729.12939-1-ardb@kernel.org>
 <20210526100729.12939-5-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526100729.12939-5-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 26, 2021 at 12:07:27PM +0200, Ard Biesheuvel wrote:
> AES/CCM on arm64 is implemented as a synchronous AEAD, and so it is
> guaranteed by the API that it is only invoked in task or softirq
> context. Since softirqs are now only handled when the SIMD is not
> being used in the task context that was interrupted to service the
> softirq, we no longer need a fallback path. Let's remove it.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 153 ++++----------------
>  1 file changed, 32 insertions(+), 121 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>
