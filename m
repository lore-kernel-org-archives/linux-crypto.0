Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FB9C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8ECF2187F
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGCNZg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:25:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50034 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfGCNZf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 09:25:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hifGQ-0007aN-HH; Wed, 03 Jul 2019 21:25:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hifGO-0003qy-Ck; Wed, 03 Jul 2019 21:25:32 +0800
Date:   Wed, 3 Jul 2019 21:25:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@google.com,
        ard.biesheuvel@linaro.org
Subject: Re: [RFC/RFT PATCH] crypto: aes/generic - use unaligned loads to
 eliminate 50% of lookup tables
Message-ID: <20190703132532.n4zi66shnsq5ft5k@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624133042.7422-1-ard.biesheuvel@linaro.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> +config CRYPTO_AES_REDUCED_TABLES
> +       bool "Use reduced AES table set"
> +       depends on CRYPTO_AES && HAVE_EFFICIENT_UNALIGNED_ACCESS
> +       default y
> +       help
> +         Use a set of AES lookup tables that is only half the size, but
> +         uses unaligned accesses to fetch the data. Given that the D-cache
> +         pressure of table based AES induces timing variances that can
> +         sometimes be exploited to infer key bits when the plaintext is
> +         known, this should typically be left enabled.

I don't think this option should exist at all, and certainly
not as a user-visible option.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
