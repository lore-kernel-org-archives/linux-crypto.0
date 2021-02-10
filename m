Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FE5C4332D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8910F64E45
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhBJH0J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:26:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50370 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232539AbhBJHZV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:25:21 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jrS-0001J0-4X; Wed, 10 Feb 2021 18:24:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:24:30 +1100
Date:   Wed, 10 Feb 2021 18:24:30 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     mpm@selenic.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hw_random: timeriomem_rng: Use device-managed
 registration API
Message-ID: <20210210072429.GO4493@gondor.apana.org.au>
References: <1612665545-43612-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612665545-43612-1-git-send-email-tiantao6@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 07, 2021 at 10:39:05AM +0800, Tian Tao wrote:
> Use devm_hwrng_register to get rid of manual unregistration.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/char/hw_random/timeriomem-rng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
