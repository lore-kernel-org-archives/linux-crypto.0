Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38992C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BAC20870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfBAGuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:50:51 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56978 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGuv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:50:51 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSf3-0000CR-V9; Fri, 01 Feb 2019 14:50:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSf3-0005nS-8E; Fri, 01 Feb 2019 14:50:49 +0800
Date:   Fri, 1 Feb 2019 14:50:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH 0/3] crypto: arm64/aes-ccm - various bug fixes
Message-ID: <20190201065049.bpv5c2nrwy22mheo@gondor.apana.org.au>
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 05:33:44PM +0100, Ard Biesheuvel wrote:
> Fix a couple of bugs found by Eric's new testing code, and another
> issue found by inspection.
> 
> Ard Biesheuvel (3):
>   crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
>   crypto: arm64/aes-ccm - fix bugs in non-NEON fallback routine
>   crypto: arm64/aes-ccm - don't use an atomic walk needlessly
> 
>  arch/arm64/crypto/aes-ce-ccm-core.S | 5 +++--
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 8 +++-----
>  2 files changed, 6 insertions(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
