Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17742C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0BC223E8
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgLaSyy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgLaSyx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F4D12222D;
        Thu, 31 Dec 2020 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609440853;
        bh=zBbbzavQRJPngXxtmFfUoKiQa3cDubAwuV/Ayn+Y4fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5OYGsJ+NI1rcC9Gkv7SR5MeNOrw89YBy2uoxAVKJj6+LnW7ljGcT/Jpabb/KrxLi
         EKiXU6WDhe/asMOhQ8pxQdg9iWIpJN9fsaoM42t0MH3xi9q6of5gYM6Hb2kk5oxTkt
         f/99CxJe8gaoNJe149SXRp4a3MOPSAmZiBLOWCX8dZZfmnkyI/JoDXc/cawYbjCobp
         X6O65ktyFt8BVsFqv8Ny+dpQVVlYbGTju13gux9ocG+e+ylZMjWpBqnfd4VFTAHa4Q
         4BW/EefF+NfNCxNlebi+c2LWSMckegGlz9CoFSeLo6E9DJLpsTaVSgBOECI49F+H34
         TwI73ZJvZSU9A==
Date:   Thu, 31 Dec 2020 10:54:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 08/21] crypto: x86/cast5 - drop CTR mode implementation
Message-ID: <X+4eS+urILsknKN+@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-9-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-9-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:24PM +0100, Ard Biesheuvel wrote:
> CAST5 in CTR mode is never used by the kernel directly, and is highly
> unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
> the accelerated CTR mode implementation, and instead, rely on the CTR
> template and the bare cipher.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/cast5_avx_glue.c | 103 --------------------
>  crypto/Kconfig                   |   1 +
>  2 files changed, 1 insertion(+), 103 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
