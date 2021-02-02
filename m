Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E04DC433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 22:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 008DF64F67
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 22:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhBBWWz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 17:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235093AbhBBWUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 17:20:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C69F64F4D;
        Tue,  2 Feb 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612304409;
        bh=pvcuDCyLzz1d9KO0mS2YN4zSrCWwtFkggEXXYXzj5SM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V0XzC+3fNHKl7QTu4Iiwyzqc9ffefvQwGPSqpfXEfu/8qgkDBzdGGqefBQl8MFQHI
         JvHeKs5r0Y30fSBS25Dom80/HXOIWTMGJrBPO/ozAhxtGlSIA882Opcp5V5weCjcn1
         Vx6eg8N5vbknIoA88ZcoOlPweIxFiQynq58Ou0hcCE8e9VaO6+XOmojqND3hpHioTC
         m5/F4Kq8eu+p/Q0hj9G2hGuVyCzfB7BaAfjYVRykqkWsitIpMYyOalUjD3lTpWOO+W
         mirtZgdxOhEJZbPAly3Cf67iCq0Jk635uZqsvH7RqwJuko8ONR4NPkIf5PNYgBG0wY
         WB1weKeSE3GrA==
Date:   Tue, 2 Feb 2021 14:20:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH 0/9] crypto: fix alignmask handling
Message-ID: <YBnQF3KU9Y5YKSmp@gmail.com>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 01, 2021 at 07:02:28PM +0100, Ard Biesheuvel wrote:
> Some generic implementations of vintage ciphers rely on alignmasks to
> ensure that the input is presented with the right alignment. Given that
> these are all C implementations, which may execute on architectures that
> don't care about alignment in the first place, it is better to use the
> unaligned accessors, which will deal with the misalignment in a way that
> is appropriate for the architecture in question (and in many cases, this
> means simply ignoring the misalignment, as the hardware doesn't care either)
> 
> So fix this across a number of implementations. Patch #1 stands out because
> michael_mic.c was broken in spite of the alignmask. Patch #2 removes tnepres
> instead of updating it, given that there is no point in keeping it.
> 
> The remaining patches all update generic ciphers that are outdated but still
> used, and which are the only implementations available on most architectures
> other than x86.
> 
> 
> 
> Ard Biesheuvel (9):
>   crypto: michael_mic - fix broken misalignment handling
>   crypto: serpent - get rid of obsolete tnepres variant
>   crypto: serpent - use unaligned accessors instead of alignmask
>   crypto: blowfish - use unaligned accessors instead of alignmask
>   crypto: camellia - use unaligned accessors instead of alignmask
>   crypto: cast5 - use unaligned accessors instead of alignmask
>   crypto: cast6 - use unaligned accessors instead of alignmask
>   crypto: fcrypt - drop unneeded alignmask
>   crypto: twofish - use unaligned accessors instead of alignmask
> 
>  crypto/Kconfig            |   3 +-
>  crypto/blowfish_generic.c |  23 ++--
>  crypto/camellia_generic.c |  45 +++----
>  crypto/cast5_generic.c    |  23 ++--
>  crypto/cast6_generic.c    |  39 +++---
>  crypto/fcrypt.c           |   1 -
>  crypto/michael_mic.c      |  31 ++---
>  crypto/serpent_generic.c  | 126 ++++----------------
>  crypto/tcrypt.c           |   6 +-
>  crypto/testmgr.c          |   6 -
>  crypto/testmgr.h          |  79 ------------
>  crypto/twofish_generic.c  |  11 +-
>  12 files changed, 90 insertions(+), 303 deletions(-)

Thanks for fixing this up!  These patches all look good to me, and all the
self-tests still pass.  You can add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
