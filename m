Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1378CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCA4B2089C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394761AbfJRIEk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:04:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37350 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfJRIEk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 04:04:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLNFJ-0001vB-3p; Fri, 18 Oct 2019 19:04:26 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 19:04:25 +1100
Date:   Fri, 18 Oct 2019 19:04:25 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     davem@davemloft.net, ndesaulniers@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ux500: Remove set but not used variable 'cookie'
Message-ID: <20191018080424.GG25128@gondor.apana.org.au>
References: <1570788482-104009-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570788482-104009-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 06:08:02PM +0800, zhengbin wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/ux500/hash/hash_core.c: In function hash_set_dma_transfer:
> drivers/crypto/ux500/hash/hash_core.c:143:15: warning: variable cookie set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit 8a63b1994c50 ("crypto:
> ux500 - Add driver for HASH hardware")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/crypto/ux500/hash/hash_core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
