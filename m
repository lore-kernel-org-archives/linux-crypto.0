Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18807C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8D320870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfBAGwL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:52:11 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57096 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGwL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:52:11 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSgL-0000HV-RG; Fri, 01 Feb 2019 14:52:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSgL-0005pM-Nc; Fri, 01 Feb 2019 14:52:09 +0800
Date:   Fri, 1 Feb 2019 14:52:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v3 0/4] crypto: fix crct10dif for ARM and arm64
Message-ID: <20190201065209.l233elgxjuicpm7o@gondor.apana.org.au>
References: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190127091655.6262-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jan 27, 2019 at 10:16:51AM +0100, Ard Biesheuvel wrote:
> Fix the issues in both NEON implementations of the CRC-T10DIF routines,
> that were reported by Eric's new testing code.
> 
> v3:
> - fix commit log to state 'at least 16 bytes' not 'more than 16 bytes' (#1-#2)
> - add Eric's R-b to all patches
> 
> v2:
> - keep alignment specifiers where possible (#1)
> - clarify/fix commit log (#2)
> - add fixes/cc-stable/etc tags
> - add patches that drop the now unreacheable code (#3 - #4)
> 
> Ard Biesheuvel (4):
>   crypto: arm/crct10dif - revert to C code for short inputs
>   crypto: arm64/crct10dif - revert to C code for short inputs
>   crypto: arm/crct10dif - remove dead code
>   crypto: arm64/crct10dif - remove dead code
> 
>  arch/arm/crypto/crct10dif-ce-core.S   | 27 +++++---------------
>  arch/arm/crypto/crct10dif-ce-glue.c   | 23 +++++------------
>  arch/arm64/crypto/crct10dif-ce-core.S | 11 --------
>  arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++-------------
>  4 files changed, 19 insertions(+), 67 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
