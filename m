Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F63C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80120222BB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgLaSz1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgLaSz0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 358DC223E4;
        Thu, 31 Dec 2020 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609440886;
        bh=lT//v79JH8IXqV+dBGY9HwpHHMgJgtD8aP47dWzMyVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ide4HQBdQDRnRXEfw2UmyJ18sGodmdNO3nnRtP7sLIXjCVc53axh5tuyktETIvzFO
         bsW6EG5qGOP0E2mqD5BxVkBCYWaOzERuJ9kmTBfKeOMQxc6F6IILDFIJTCXXqJl6y4
         mPCp9Xcc2YDYiXIv8GIEmI6r/r1KsX3McEi1VOH745oJj+IISaxUqk8pYetwoEEBRj
         KRzh1Nx/OuKSA0Z77s4cjBz5ZzZCZuAKV6E6yukARr1aWjesJ4MlP8be3r10qJk5YC
         cFMm/Xc3Sd7l8MK/XypG0EculuczxVXQyLxXT1rGUmtCFCrSilT0YFHKcPw1Nb1/Y1
         rIqetvU2lAzEg==
Date:   Thu, 31 Dec 2020 10:54:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 13/21] crypto: x86/blowfish - drop CTR mode implementation
Message-ID: <X+4edEWBEyTlXiQP@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-14-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-14-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:29PM +0100, Ard Biesheuvel wrote:
> Blowfish in counter mode is never used in the kernel, so there
> is no point in keeping an accelerated implementation around.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/blowfish_glue.c | 107 --------------------
>  crypto/Kconfig                  |   1 +
>  2 files changed, 1 insertion(+), 107 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
