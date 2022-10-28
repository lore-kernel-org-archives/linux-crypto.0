Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EB9C38A02
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Oct 2022 05:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJ1FD0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Oct 2022 01:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJ1FD0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2022 01:03:26 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F461AFA92;
        Thu, 27 Oct 2022 22:03:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ooHW2-007UwT-3a; Fri, 28 Oct 2022 13:03:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Oct 2022 13:03:22 +0800
Date:   Fri, 28 Oct 2022 13:03:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] crypto: hisilicon/qm - some misc-fixes by fuzz
 test
Message-ID: <Y1timkXylbTlaZ9O@gondor.apana.org.au>
References: <20221022011746.27197-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022011746.27197-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 22, 2022 at 01:17:43AM +0000, Kai Ye wrote:
> Resolve stack overflow risks for algqos api. Invalid parameter checking is
> added. And simplify some code.
> 
> changes v1->v2:
>         - modify a comment.
> changes v2->v3:
> 	- document the stack overflow cause.
> 
> Kai Ye (3):
>   crypto: hisilicon/qm - increase the memory of local variables
>   crypto: hisilicon/qm - add pci bdf number check
>   crypto: hisilicon/qm - delete redundancy check
> 
>  drivers/crypto/hisilicon/qm.c | 43 +++++++++++------------------------
>  1 file changed, 13 insertions(+), 30 deletions(-)
> 
> -- 
> 2.17.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
