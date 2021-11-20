Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F9CC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhKTEcW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:32:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56906 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236836AbhKTEcW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:32:22 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moI04-0001JX-UA; Sat, 20 Nov 2021 12:29:16 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moI04-0006ks-M8; Sat, 20 Nov 2021 12:29:16 +0800
Date:   Sat, 20 Nov 2021 12:29:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     davidcomponentone@gmail.com
Cc:     xuzaibo@huawei.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] crypto: hisilicon/hpre -  use swap() to make code cleaner
Message-ID: <20211120042916.GG25752@gondor.apana.org.au>
References: <20211104061910.1505738-1-yang.guang5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104061910.1505738-1-yang.guang5@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 04, 2021 at 02:19:10PM +0800, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
