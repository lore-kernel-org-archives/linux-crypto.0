Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE1FC3F2D1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA8EA2073B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCFBsy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:48:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:45994 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFBsy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 20:48:54 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA26D-0005ix-9t; Fri, 06 Mar 2020 12:48:26 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 12:48:25 +1100
Date:   Fri, 6 Mar 2020 12:48:25 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        davem@davemloft.net, will@kernel.org, ebiggers@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: arm64: CE: implement export/import
Message-ID: <20200306014825.GB30653@gondor.apana.org.au>
References: <1582555661-25737-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582555661-25737-1-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 24, 2020 at 02:47:41PM +0000, Corentin Labbe wrote:
> When an ahash algorithm fallback to another ahash and that fallback is
> shaXXX-CE, doing export/import lead to error like this:
> alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\"
> 
> This is due to the descsize of shaxxx-ce being larger than struct shaxxx_state
> off by an u32.
> For fixing this, let's implement export/import which rip the finalize
> variant instead of using generic export/import.
> 
> Fixes: 6ba6c74dfc6b ("arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions")
> Fixes: 2c98833a42cd ("arm64/crypto: SHA-1 using ARMv8 Crypto Extensions")
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Changes since v1:
> - memcpy directly &sctx->sst instead of sctx. As suggested by Eric Biggers
> 
>  arch/arm64/crypto/sha1-ce-glue.c | 20 ++++++++++++++++++++
>  arch/arm64/crypto/sha2-ce-glue.c | 23 +++++++++++++++++++++++
>  2 files changed, 43 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
