Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A2FC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 06:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2040218D9
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 06:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548398541;
	bh=o6N3bqKcjF+nKRpi9aezFDdbCpJ+L7mamGCF5Ju+pDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ft7cqH3PHdf32JwvKswzFY569Hb6tiCYCMenjcAkSM8mj1d1cL3Eq6jEqCqUglxNE
	 VAGKdrGyOeevKoIPU/lhyZvIFaIl+b0vMgy7MbT2BdTblp+i9RiDzxB/0b4IMHBnzy
	 208ylVo02D08UdvkXcln2VyRhm3kTW3lLtAJQ9Qs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfAYGmV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbfAYGmU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 01:42:20 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFAF218D0;
        Fri, 25 Jan 2019 06:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548398540;
        bh=o6N3bqKcjF+nKRpi9aezFDdbCpJ+L7mamGCF5Ju+pDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IqpPLAOzg7/V8xIOQtYZ9OQkzOwH0doA7S9FuN3PsvygcswiQpL9OejWF/m0jlgdv
         9gmQZL8YorEUpyTPPUFHYyJEPxOKT1JoFWXCn9COi3dgmkjLf0noexf0FPp6aLZjKU
         MarjAI0hdDtw1KCQiqSsJKTs6L7fIX5On1hds7sg=
Date:   Thu, 24 Jan 2019 22:42:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH 0/3] crypto: arm64/aes-ccm - various bug fixes
Message-ID: <20190125064217.GA700@sol.localdomain>
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 05:33:44PM +0100, Ard Biesheuvel wrote:
> Fix a couple of bugs found by Eric's new testing code, and another
> issue found by inspection.
> 
> Ard Biesheuvel (3):
>   crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
>   crypto: arm64/aes-ccm - fix bugs in non-NEON fallback routine
>   crypto: arm64/aes-ccm - don't use an atomic walk needlessly
> 
>  arch/arm64/crypto/aes-ce-ccm-core.S | 5 +++--
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 8 +++-----
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 

Thanks Ard.  For all three patches:

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

However, can you add Cc stable to the first two?

BTW: I notice the !may_use_simd() case is still not covered by the self-tests.
Do you happen to have any suggestion for how to do it?  If there is a way to
make may_use_simd() temporarily return false, I can easily put a flag in 'struct
testvec_config' that makes the self-tests sometimes use that context to execute
the actual encryption/decryption/hashing.

It looks like on arm64, wrapping the operation in local_irq_{disable,enable}()
or kernel_fpu_{begin,end}() would be sufficient?  But x86 it doesn't look as
easy as x86 needs a context where 'in_interrupt() && !interrupted_user_mode() &&
!interrupted_kernel_fpu_idle()'.  Likewise arm32 requires 'in_interrupt()'.

It would be worth doing just for arm64, but ideally it would work on most/all
architectures.

- Eric
