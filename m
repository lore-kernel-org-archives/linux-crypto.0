Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816A0C433E9
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 21:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339FC22D06
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 21:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbhAKVFq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 16:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbhAKVFp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 16:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84A022D01;
        Mon, 11 Jan 2021 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610399105;
        bh=U2Z0n9n5q+L6qLnTZ7cJnV9Ic9JRiEPBtDOWAt5u8VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ji9qEAvSzibe/82toj10olXK5ef4jN1vWLCq/P73YqaI+wqYSXpaElYY4NRWVjsRv
         Zy/fxQVewaDSQbqF9VgcDGn6zERbW399h8/4MDyJ3ilfk0jMw/weuZillQQoMtmdK1
         DEaOpjwKiXTDO1a8aETGpoo/lPlpoPu62HmrfV0qfIDH/nf+hHrJpuUNLde9EfATZc
         qa+tdlOakIVCNhRb3TD5Qa3aNvDw9wg+ExZuF+G3K0TzBSNlZBTRQ0FJJ3tA3pSmXU
         YlBW6vfO0fCrBxpR03XZe651M8qNppWHL4SbmMMqxIHEdRvlFm+ShS0qhUWf/dLB5Y
         fZXh2klTTNuaQ==
Date:   Mon, 11 Jan 2021 13:05:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
Message-ID: <X/y9f4vbJwqfKZh5@sol.localdomain>
References: <20210111165237.18178-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 11, 2021 at 05:52:30PM +0100, Ard Biesheuvel wrote:
> CRC-T10DIF is a very poor match for the crypto API:
> - every user in the kernel calls it via a library wrapper around the
>   shash API, so all callers share a single instance of the transform
> - each architecture provides at most a single optimized implementation,
>   based on SIMD instructions for carryless multiplication
> 
> In other words, none of the flexibility it provides is put to good use,
> and so it is better to get rid of this complexity, and expose the optimized
> implementations via static calls instead. This removes a substantial chunk
> of code, and also gets rid of any indirect calls on architectures that
> obsess about those (x86)
> 
> If this approach is deemed suitable, there are other places where we might
> consider adopting it: CRC32 and CRC32(C).
> 
> Patch #1 does some preparatory refactoring and removes the library wrapper
> around the shash transform.
> 
> Patch #2 introduces the actual static calls, along with the registration
> routines to update the crc-t10dif implementation at runtime.
> 
> Patch #3 updates the generic CRC-T10DIF shash driver so it distinguishes
> between the optimized library code and the generic library code.
> 
> Patches #4 to #7 update the various arch implementations to switch over to
> the new method.
> 
> Special request to Peter to take a look at patch #2, and in particular,
> whether synchronize_rcu_tasks() is sufficient to ensure that a module
> providing the target of a static call can be unloaded safely.
>  
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> 
> Ard Biesheuvel (7):
>   crypto: crc-t10dif - turn library wrapper for shash into generic
>     library
>   crypto: lib/crc-t10dif - add static call support for optimized
>     versions
>   crypto: generic/crc-t10dif - expose both arch and generic shashes
>   crypto: x86/crc-t10dif - convert to static call library API
>   crypto: arm/crc-t10dif - convert to static call library API
>   crypto: arm64/crc-t10dif - convert to static call API
>   crypto: powerpc/crc-t10dif - convert to static call API
> 
>  arch/arm/crypto/Kconfig                     |   2 +-
>  arch/arm/crypto/crct10dif-ce-glue.c         |  58 ++------
>  arch/arm64/crypto/Kconfig                   |   3 +-
>  arch/arm64/crypto/crct10dif-ce-glue.c       |  85 ++---------
>  arch/powerpc/crypto/crct10dif-vpmsum_glue.c |  51 +------
>  arch/x86/crypto/crct10dif-pclmul_glue.c     |  90 ++----------
>  crypto/Kconfig                              |   7 +-
>  crypto/Makefile                             |   2 +-
>  crypto/crct10dif_common.c                   |  82 -----------
>  crypto/crct10dif_generic.c                  | 100 +++++++++----
>  include/linux/crc-t10dif.h                  |  21 ++-
>  lib/Kconfig                                 |   2 -
>  lib/crc-t10dif.c                            | 152 +++++++++-----------
>  13 files changed, 204 insertions(+), 451 deletions(-)
>  delete mode 100644 crypto/crct10dif_common.c

There is already a library API for two other hash functions, BLAKE2s and
Poly1305, which takes advantage of architecture-specific implementations without
using static calls.  Also, those algorithms are likewise also exposed through
the shash API, but in a different way from what this patchset proposes.

Is there a reason not to do things in the same way?  What are the advantages of
the new approach that you're proposing?

- Eric
