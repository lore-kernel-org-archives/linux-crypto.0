Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C934C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52840611C2
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350740AbhESLa4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:30:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54000 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350685AbhESLa4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:30:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ljKOL-0002kJ-Op; Wed, 19 May 2021 19:29:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ljKOI-00076p-DX; Wed, 19 May 2021 19:29:30 +0800
Date:   Wed, 19 May 2021 19:29:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiggers@kernel.org, will@kernel.org, kernel-team@android.com
Subject: Re: [PATCH v4 2/7] crypto: aead - disallow en/decrypt for non-task
 or non-softirq context
Message-ID: <20210519112930.sgy3trqczyfok7mn@gondor.apana.org.au>
References: <20210519112239.33664-1-ardb@kernel.org>
 <20210519112239.33664-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519112239.33664-3-ardb@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 19, 2021 at 01:22:34PM +0200, Ard Biesheuvel wrote:
>
>  	crypto_stats_get(alg);
> -	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> +	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
> +	    WARN_ONCE(!in_task() && !in_serving_softirq(),
> +		      "synchronous call from invalid context\n"))
> +		ret = -EBUSY;

I don't think we've ever supported crypto in hard IRQ contexts.
So this should be done regardless of ASYNC.

Then again, do we really need this since the assumption has
always been that the crypto API can only be invoked in user or
softirq context?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
