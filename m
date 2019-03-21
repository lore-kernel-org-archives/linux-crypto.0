Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC35C10F00
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 05:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51970218AE
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 05:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553146093;
	bh=bOnPtFW6CKEbqVlyNhOxuY0OW+jFHO19zM9FYs4cq8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IoKvT5/y6eHDUfSzlFgTzn4kM9fX1cwKP6HC/ZpTAJw2pKMDP4miuWNwmvCRqpUec
	 h+NPu1pDWWIvIuUW9XJ8+Ebh0kUnpLJwfUqncsH1uAuAtBnm5TlzLNtxDRNL3Yb1K1
	 msS73wmVCdKE3NXcPWFYupAe92HmeUx6Vdu8/WIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfCUF2M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 01:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfCUF2M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 01:28:12 -0400
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2C002184E;
        Thu, 21 Mar 2019 05:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553146091;
        bh=bOnPtFW6CKEbqVlyNhOxuY0OW+jFHO19zM9FYs4cq8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2PdD93ZOnQZJSGwOHjloxdvlLmj1QdPpN2S2cmdbxC2Hg8t3pzJlnZc9i51aI/OOa
         K37XY47yoH/CBxOt86jfyzqUfd1Jl5FjUwUiaq36cCNRQsbXxsTLOquenqkz56K4Rl
         GHPYz9dGkjDAXPmdVOXDv/StcevYQiWAetweMLe4=
Date:   Thu, 21 Mar 2019 06:28:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.14] crypto: arm64/aes-neonbs - fix returning final
 keystream block
Message-ID: <20190321052808.GC21413@kroah.com>
References: <20190321002725.31056-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321002725.31056-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 20, 2019 at 05:27:25PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 12455e320e19e9cc7ad97f4ab89c280fe297387c upstream.
> 
> The arm64 NEON bit-sliced implementation of AES-CTR fails the improved
> skcipher tests because it sometimes produces the wrong ciphertext.  The
> bug is that the final keystream block isn't returned from the assembly
> code when the number of non-final blocks is zero.  This can happen if
> the input data ends a few bytes after a page boundary.  In this case the
> last bytes get "encrypted" by XOR'ing them with uninitialized memory.
> 
> Fix the assembly code to return the final keystream block when needed.
> 
> Fixes: 88a3f582bea9 ("crypto: arm64/aes - don't use IV buffer to return final keystream block")
> Cc: <stable@vger.kernel.org> # v4.11+
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
> Please apply to 4.14-stable.  This resolves conflicts due to
> "crypto: arm64/aes-bs - yield NEON after every block of input"
> not being present in 4.14, but that has other dependencies.
> 
> Tested using the crypto self-tests from v5.1-rc1 backported to 4.14.
> "rfc3686(ctr-aes-neonbs)" now passes the tests.
> 
>  arch/arm64/crypto/aes-neonbs-core.S | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
