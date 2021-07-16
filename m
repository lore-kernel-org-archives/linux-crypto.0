Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3ABC12002
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 23:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F38A613ED
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 23:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGQABL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 20:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhGQABJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 20:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 455C4611BE;
        Fri, 16 Jul 2021 23:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626479893;
        bh=xFU807Rlr0Xhkm1tdcSSaE05dk80+vL9LycoYbKbLJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iW1Ti2r7qjCJPHnx96UiS73IBxi7ewc007dvYIh6Dyj06hWjURZH1R4SVn9ymFFG4
         GmpjGHCVvjlnfmiNDXbt3SFlQQHI3T5eOBPBoUBTLGQDHN0FggeHakd5ww/nLC/+Nk
         FpkSahp0n0kVqZ4K06URjbZrkVl/E4TJZNf8paLip9Cj8+F7UHp+ScHZDCv79P+gvJ
         FvmIOH28sVfJokTM7xHbhV0nCYVoE3ySB5FcUuVFSlANJL1UhzLCib4YIurmybI48n
         eVBKabKLea2jSMovp9M58FN0+/4TAf8o/yaUKK5sOfRraVgAW5gKgMgbTup6o8y1gi
         /hqXVR7zcAIqQ==
Date:   Fri, 16 Jul 2021 18:58:11 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Dave Hansen <dave.hansen@intel.com>,
        syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
Subject: Re: [PATCH] crypto: x86/aes-ni - add missing error checks in XTS code
Message-ID: <YPIdEwVJsOdrpJJH@quark.localdomain>
References: <20210716165403.6115-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716165403.6115-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 16, 2021 at 06:54:03PM +0200, Ard Biesheuvel wrote:
> The updated XTS code fails to check the return code of skcipher_walk_virt,
> which may lead to skcipher_walk_abort() or skcipher_walk_done() being called
> while the walk argument is in an inconsistent state.
> 
> So check the return value after each such call, and bail on errors.
> 
> Fixes: 2481104fe98d ("crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper")

Add Cc stable?

> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Reported-by: syzbot <syzbot+5d1bad8042a8f0e8117a@syzkaller.appspotmail.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
