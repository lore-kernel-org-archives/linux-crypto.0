Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E02AC43461
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 07:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E90BB610E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 07:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhDIHyI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 03:54:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52050 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232005AbhDIHyH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 03:54:07 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lUlxV-0006Jm-5v; Fri, 09 Apr 2021 17:53:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Apr 2021 17:53:41 +1000
Date:   Fri, 9 Apr 2021 17:53:41 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        heiko@sntech.de, linux-rockchip@lists.infradead.org,
        shenyang39@huawei.com
Subject: Re: [PATCH] crypto: rockchip/rk3288_crypto_ahash - delete unneeded
 variable initialization
Message-ID: <20210409075340.GG31447@gondor.apana.org.au>
References: <1617246099-2157-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617246099-2157-1-git-send-email-yekai13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 01, 2021 at 11:01:39AM +0800, Kai Ye wrote:
> Delete unneeded variable initialization
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
