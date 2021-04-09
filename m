Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1874C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 07:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B79F61179
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 07:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhDIHd7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 03:33:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51784 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhDIHd7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 03:33:59 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lUle2-0005yJ-EQ; Fri, 09 Apr 2021 17:33:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Apr 2021 17:33:34 +1000
Date:   Fri, 9 Apr 2021 17:33:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: hisilicon/hpre - delete redundant log
Message-ID: <20210409073334.GC23134@gondor.apana.org.au>
References: <1617362669-40372-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617362669-40372-1-git-send-email-tanghui20@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 02, 2021 at 07:24:29PM +0800, Hui Tang wrote:
> 'hpre_cfg_by_dsm' has checked and printed error path internally. It is not
> necessary to do it here, so remove it.
> 
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> 
> v1 -> v2:
> - Return immediately when return value of 'hpre_cfg_by_dsm' is non-zero.
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Your patch description is misleading as the patch does moe than
just remove the redundant printk.  Please rephrase so that it is
clear that the patch is in fact changing behaviour.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
