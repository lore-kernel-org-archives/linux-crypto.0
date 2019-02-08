Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE90EC169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FE9721917
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 07:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfBHHqV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:46:21 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:34172 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHqV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 02:46:21 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs0rb-0000k2-V3; Fri, 08 Feb 2019 15:46:20 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs0ra-0002RR-EF; Fri, 08 Feb 2019 15:46:18 +0800
Date:   Fri, 8 Feb 2019 15:46:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/3] crypto: crct10dif assembly cleanup and
 optimizations
Message-ID: <20190208074618.bpass2jz3axu5fv2@gondor.apana.org.au>
References: <20190131044242.31591-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131044242.31591-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 30, 2019 at 08:42:39PM -0800, Eric Biggers wrote:
> The x86, arm, and arm64 asm implementations of crct10dif are very
> difficult to understand partly because many of the comments, labels, and
> macros are named incorrectly: the lengths mentioned are usually off by a
> factor of two from the actual code.  Many other things are unnecessarily
> convoluted as well, e.g. there are many more fold constants than
> actually needed and some aren't fully reduced.
> 
> This series therefore cleans up all these implementations to be much
> more maintainable.  I also made some small optimizations where I saw
> opportunities, resulting in slightly better performance.
> 
> This is based on top of the pending patches from Ard Biesheuvel.
> 
> These all pass the new extra self-tests.
> 
> Changed since v3:
> - Added '.arch armv7-a' to arm32 assembly file to fix a build error.
> - Removed support for len < 16 from the x86 assembly.
> 
> Changed since v2:
> - Removed the unnecessary '__LINUX_ARM_ARCH__ < 7' case.
> - Added Ard's Acked-by.
> 
> Changed since v1:
> - Moved constants in arm implementation to .rodata.
> - Eliminated a few instructions from the x86 implementation.
> - Tweaked a few comments.
> 
> Eric Biggers (3):
>   crypto: x86/crct10dif-pcl - cleanup and optimizations
>   crypto: arm/crct10dif-ce - cleanup and optimizations
>   crypto: arm64/crct10dif-ce - cleanup and optimizations
> 
>  arch/arm/crypto/crct10dif-ce-core.S     | 553 ++++++++---------
>  arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
>  arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++--------
>  arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
>  arch/x86/crypto/crct10dif-pcl-asm_64.S  | 782 +++++++-----------------
>  arch/x86/crypto/crct10dif-pclmul_glue.c |  12 +-
>  6 files changed, 729 insertions(+), 1120 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
