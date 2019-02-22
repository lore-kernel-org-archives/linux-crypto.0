Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED222C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF4220818
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 12:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfBVMBY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:01:24 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54866 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfBVMBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 07:01:24 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9W6-0000eT-78; Fri, 22 Feb 2019 20:01:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9W0-0007Er-6d; Fri, 22 Feb 2019 20:01:16 +0800
Date:   Fri, 22 Feb 2019 20:01:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiggers@kernel.org
Subject: Re: [PATCH 0/2] SHA fixes for 32-bit ARM
Message-ID: <20190222120116.wh54vvfrovyb4z4u@gondor.apana.org.au>
References: <20190216135126.17290-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190216135126.17290-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 16, 2019 at 02:51:24PM +0100, Ard Biesheuvel wrote:
> A couple of fixes for a crash bugs in the scalar SHA code for ARM,
> taken from the OpenSSL project. This is triggered by a binutils
> change, and so they should probably be tagged for all stable (v4.4+) 
> 
> Ard Biesheuvel (2):
>   crypto: sha256/arm - fix crash bug in Thumb2 build
>   crypto: sha512/arm - fix crash bug in Thumb2 build
> 
>  arch/arm/crypto/sha256-armv4.pl       | 3 ++-
>  arch/arm/crypto/sha256-core.S_shipped | 3 ++-
>  arch/arm/crypto/sha512-armv4.pl       | 3 ++-
>  arch/arm/crypto/sha512-core.S_shipped | 3 ++-
>  4 files changed, 8 insertions(+), 4 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
