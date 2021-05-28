Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6B1C47087
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97FE261005
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbhE1H3Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 03:29:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50332 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235999AbhE1H3O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 03:29:14 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lmWu2-0003ix-34; Fri, 28 May 2021 15:27:30 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lmWu1-00020y-UD; Fri, 28 May 2021 15:27:29 +0800
Date:   Fri, 28 May 2021 15:27:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: nx - Fix typo in comment
Message-ID: <20210528072729.GM7392@gondor.apana.org.au>
References: <1621586507-22178-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621586507-22178-1-git-send-email-zhangshaokun@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 04:41:47PM +0800, Shaokun Zhang wrote:
> Fix typo '@workmem' -> '@wmem'.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/crypto/nx/nx-common-powernv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
