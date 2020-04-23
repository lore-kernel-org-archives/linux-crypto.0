Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E7CC55192
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 20:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D93920784
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587674348;
	bh=jE7SsWlKBqk/30mPotAmzWK2sf+p/KaDsfUqeXnE3Do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lTYvEZiVDlcuiTNuys4nxVaNdmzgr35gtqFvczNIA8rgufOCmDp7y3BjIDQ6DiycV
	 CnNxicZF7FTVyGLU8PQPybbUDSnUTpDtXd9bxXrbeqmSWjH1lC+HHzbYLhFy/k2xaS
	 38enl0iCvM4v6DdEcjH6R9d0/6XstNsjH8ECy6WA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDWUjE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 16:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgDWUjE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 16:39:04 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAB8320781;
        Thu, 23 Apr 2020 20:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587674344;
        bh=jE7SsWlKBqk/30mPotAmzWK2sf+p/KaDsfUqeXnE3Do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dRXb+68p7mQAR864QnlDZTq69BIIXvXnaVmsgLieLCY+j4B6bjQhz5eYPiubUyUOc
         0a8iU1t63C7jbtmxMs94/kQu6Ab/SFXKyxJN83I1AHzuMlp15ucGjeZ4jnAVhFDrbI
         oDBd+GqiW2KatasCiARUXzKwR3CtT/t+o+lzPeB4=
Date:   Thu, 23 Apr 2020 13:39:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH crypto-stable v3 2/2] crypto: arch/nhpoly1305 - process
 in explicit 4k chunks
Message-ID: <20200423203902.GB2796@gmail.com>
References: <20200422200344.239462-1-Jason@zx2c4.com>
 <20200422231854.675965-1-Jason@zx2c4.com>
 <20200422231854.675965-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422231854.675965-2-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 22, 2020 at 05:18:54PM -0600, Jason A. Donenfeld wrote:
> Rather than chunking via PAGE_SIZE, this commit changes the arch
> implementations to chunk in explicit 4k parts, so that calculations on
> maximum acceptable latency don't suddenly become invalid on platforms
> where PAGE_SIZE isn't 4k, such as arm64.
> 
> Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
> Fixes: 012c82388c03 ("crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305")
> Fixes: a00fa0c88774 ("crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305")
> Fixes: 16aae3595a9d ("crypto: arm/nhpoly1305 - add NEON-accelerated NHPoly1305")
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

arm64 normally uses PAGE_SIZE == 4k, so this commit message is a little
misleading.  Anyway, I agree with using 4k, so:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
