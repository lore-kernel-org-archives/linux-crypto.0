Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2BAC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 13:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5884A64F58
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 13:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhBDNEB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 08:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235605AbhBDND5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 08:03:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2296264F45;
        Thu,  4 Feb 2021 13:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612443796;
        bh=vhwG1ypNelpGpaFIN1L6q6EedQagjwzgIociWGaP1SM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aXJ+iydjmHmERSm2iC8XmEzYlOI1bAi2TG6HtkDYvl8hYIbBCPqINZ3DBP+iOv55Y
         MdEKtejDLNJ4Rd1FXMUpTyBWb3OLV2QXFar68TcUp+M+vo1ntSUA636wOZ/pssu9DC
         DkDz0jvqbnbGI1NyNWUifzYH1sanAv9nTqNp2nUHymBifQ19FNVwCs0+hzJ+PgOpth
         WqoRMbjitZNexHsDKcAIaBuTNW6fJ5YWiwYTpPbMOO6SmpNpOoXmR9tySRwcIxw95S
         lBHkRqppVF/wDFfKGXrRt5e7ZzZCzQVqYroBDGgevJQJbPi1qXv4fB0Z1pVaY/O8Ke
         6TxHWMCAqwogw==
Date:   Thu, 4 Feb 2021 13:03:11 +0000
From:   Will Deacon <will@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: (subset) Re: [PATCH v2 0/9] arm64: rework NEON yielding to avoid
 scheduling from asm code
Message-ID: <20210204130311.GD20468@willie-the-truck>
References: <20210203113626.220151-1-ardb@kernel.org>
 <161238528350.1984862.12324465919265084208.b4-ty@kernel.org>
 <20210204024429.GB5482@gondor.apana.org.au>
 <CAMj1kXH6B8jbVk6xMa4H6GOpEgDCS9vbWLxvM0X-cdataoijdA@mail.gmail.com>
 <20210204111026.GA8155@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204111026.GA8155@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 04, 2021 at 10:10:26PM +1100, Herbert Xu wrote:
> On Thu, Feb 04, 2021 at 09:29:16AM +0100, Ard Biesheuvel wrote:
> >
> > Half of the patches in this series conflict with
> > 
> > 0df07d8117c3 crypto: arm64/sha - add missing module aliases
> > 
> > in the cryptodev tree, so that won't work.
> 
> Fair enough.  I'll take the patches.

Cheers, Herbert. Please just leave the final patch ("arm64: assembler:
remove conditional NEON yield macro"), as we can come back to that for
5.13.

Will
