Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E21C4363C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B5A6613E6
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345779AbhELVIR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344521AbhELUMa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 16:12:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA43613FB;
        Wed, 12 May 2021 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620850281;
        bh=3TFHlYbgs5TDv6kvL2Z+EmWCUhN1bJEXciDXrAKpvaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rdka4BjJS9gRKT1s96RPLFKpXqumhSWbtmiAwgtAtPvQBzC/DfutQrh8nkBo2UIX5
         x5g9EWu3Kqo6bj5PIyBhaLECP60eGeLX2tdfHlH8+K4BWCCVQX1FQEuxYdsS5bkfy/
         YDg5LXXyZzD0yewhKXuVaodgEHmWPgfiyaRTPac0RHhAoC6gDV4qugtg1rqKo6Y29w
         y40ut5X3jLWoqBiCKBgG8F8kNxd7cJ5cCkLOtMQf/ZQRCbbWFEmoZlmwL67nS6PDOB
         /YVZT/Mqlhj2h3tb7cHCRpBaeRsBGT0vZzhVaMnInn+rPX2+9PQrHhnJonvnwgdPeH
         /4nJqPHRhQt5w==
Date:   Wed, 12 May 2021 13:11:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 0/7] running kernel mode SIMD with softirqs disabled
Message-ID: <YJw2Z5zlFtAx9koA@gmail.com>
References: <20210512184439.8778-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512184439.8778-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 08:44:32PM +0200, Ard Biesheuvel wrote:
> This is a follow-up to [0], but given that the arm64 architectural
> pieces have been merged for arm64, the only remaining changes are crypto
> specific. Therefore, the audience has been reduced to those people who
> are likely to care about these specifics.
> 
> Patch #1 addresses an issue in the skcipher walker which doesn't handle
> zero sized AEAD inputs entirely consistently, which is uncovered by the
> change in patch #7.
> 
> Patches #2 and #3 add some sanity checks to the public AEAD and skcipher
> APIs to limit their availibility to either task or softirq context
> (which is the only way in which they are currently being used). Adding
> this restriction permits the arm64 crypto code to get rid of all scalar
> fallbacks, given that on this architecture, softirqs are no longer
> served while the SIMD unit is being used in kernel mode, which means
> that the scalar fallbacks are never needed. These are removed in the
> remaining 4 patches.
> 
> [0] https://lore.kernel.org/linux-arm-kernel/20210302090118.30666-1-ardb@kernel.org/

Did you check whether any updates to the self-tests in testmgr.c are warranted?
Specifically, is disabling the use of SIMD for testing still something that
makes sense?

- Eric
