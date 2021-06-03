Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CBEC47096
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A8016136E
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhFCMd1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:33:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60956 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230262AbhFCMd1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 08:33:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lomVd-00024O-Vo; Thu, 03 Jun 2021 20:31:38 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lomVd-0001gH-Pk; Thu, 03 Jun 2021 20:31:37 +0800
Date:   Thu, 3 Jun 2021 20:31:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - add check before gx modulo p
Message-ID: <20210603123137.GJ6161@gondor.apana.org.au>
References: <1622278699-15092-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622278699-15092-1-git-send-email-tanghui20@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 29, 2021 at 04:58:19PM +0800, Hui Tang wrote:
> The result of gx modulo p is zero if gx is equal to p, so return
> error immediately if gx is equal to p.
> 
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
