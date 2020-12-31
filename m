Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FCEC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E348222BB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgLaS6Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS6Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:58:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B1D9222BB;
        Thu, 31 Dec 2020 18:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441065;
        bh=KuFZILUu2suaMWIrfGhG02srj1HB9yYMGJZ+Hji52v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XFR4ER5Hhz729k8MqpfMFnOCnuEF5K+AgKSbgEsD0NOgzotR4UkLFYls5eoix2OaI
         sTdWUbuhc2PLZ9ydiR7rQl27StbWZhPgOM0K9wkuwxI1KTRVtZBXpb69gshG71UBVg
         ewViggqn1lgi9F7L+IP/4RDcrhy52e+DoZ4jm7QwmXUq2psxzThf1EqZG/yq/O54vf
         7MnLIGTA+erNhmYKmPHiHmYo8RwOeEs+p0L78i0+gEXMf/2nBs6ANNMLXj7g/+6RYk
         7eQCXyNB/bgl3vLLauXAeUFezizUuWumK3643sTNm6KEewb0sLDV+ByKvu28mZgla/
         bGtH5A3f+6L9A==
Date:   Thu, 31 Dec 2020 10:57:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 19/21] crypto: x86/twofish - drop dependency on glue
 helper
Message-ID: <X+4fJ/qOuC6bRhmf@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-20-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-20-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:35PM +0100, Ard Biesheuvel wrote:
> Replace the glue helper dependency with implementations of ECB and CBC
> based on the new CPP macros, which avoid the need for indirect calls.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/twofish_avx_glue.c  | 73 +++++-------------
>  arch/x86/crypto/twofish_glue_3way.c | 80 ++++++--------------
>  crypto/Kconfig                      |  2 -
>  3 files changed, 44 insertions(+), 111 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
