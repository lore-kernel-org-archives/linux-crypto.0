Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6BEC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C522085B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgIYIPV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:15:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53260 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgIYIPV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:15:21 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLisx-0007Co-5H; Fri, 25 Sep 2020 18:15:20 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:15:18 +1000
Date:   Fri, 25 Sep 2020 18:15:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: arm/aes-neonbs - some polish
Message-ID: <20200925081518.GH6381@gondor.apana.org.au>
References: <20200916123642.20805-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916123642.20805-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 03:36:39PM +0300, Ard Biesheuvel wrote:
> Some polish for the ARM bit-sliced NEON implementation. No functional
> or performance changes anticipated.
> 
> Ard Biesheuvel (3):
>   crypto: arm/aes-neonbs - avoid hacks to prevent Thumb2 mode switches
>   crypto: arm/aes-neonbs - avoid loading reorder argument on encryption
>   crypto: arm/aes-neonbs - use typed init/exit routines for XTS
> 
>  arch/arm/crypto/aes-neonbs-core.S | 54 +++++++++-----------
>  arch/arm/crypto/aes-neonbs-glue.c | 12 ++---
>  2 files changed, 31 insertions(+), 35 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
