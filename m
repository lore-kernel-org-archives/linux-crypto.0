Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E245BC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E7CE222BB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgLaS7t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:59:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A925222BB;
        Thu, 31 Dec 2020 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441148;
        bh=I6MoSPTY0vTCxdLtPz0IYdvCI+SoRzlTYTYf0l2iNdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VfvYOe9XvSJI3Ch3qJrLcnSgcQ0Xc/TjyIspncyQaMcH28zQhdxuAAupinVEJ1+o6
         QfK2KbqbqYrsdKw7Q3WS84shhMBOWraUG7NDMQxGG7LyFS+ZbxPxmVodr5rqDTW2Ao
         IolO+pX+kscr/DUYqR+1Mhc6cRpxKSLghCi54mfrrDLBLkpZahG6ZoC7J+1b61ZTLx
         UNGuoF+a142PVwx/QLBvi+7C619Svh0eCHCSwSYwY4iEs0ZY6lE2wteP53VQ1SR0O5
         1kLZ9STBRmuS2wfKy4C6B1x1CIPPNCsgVJgH6ffUZXlB/OH2W2AAibdsB2aduwDLEB
         UtdZaANpviikw==
Date:   Thu, 31 Dec 2020 10:59:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 21/21] crypto: x86 - use local headers for x86 specific
 shared declarations
Message-ID: <X+4fesS/E+fu6f6p@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-22-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-22-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:37PM +0100, Ard Biesheuvel wrote:
> The Camellia, Serpent and Twofish related header files only contain
> declarations that are shared between different implementations of the
> respective algorithms residing under arch/x86/crypto, and none of their
> contents should be used elsewhere. So move the header files into the
> same location, and use local #includes instead.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/{include/asm => }/crypto/camellia.h     | 0
>  arch/x86/crypto/camellia_aesni_avx2_glue.c       | 2 +-
>  arch/x86/crypto/camellia_aesni_avx_glue.c        | 2 +-
>  arch/x86/crypto/camellia_glue.c                  | 2 +-
>  arch/x86/{include/asm => }/crypto/serpent-avx.h  | 0
>  arch/x86/{include/asm => }/crypto/serpent-sse2.h | 0
>  arch/x86/crypto/serpent_avx2_glue.c              | 2 +-
>  arch/x86/crypto/serpent_avx_glue.c               | 2 +-
>  arch/x86/crypto/serpent_sse2_glue.c              | 2 +-
>  arch/x86/{include/asm => }/crypto/twofish.h      | 0
>  arch/x86/crypto/twofish_avx_glue.c               | 2 +-
>  arch/x86/crypto/twofish_glue_3way.c              | 2 +-
>  12 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
