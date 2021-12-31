Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BA3C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Dec 2021 11:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhLaLez (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Dec 2021 06:34:55 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58790 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhLaLey (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Dec 2021 06:34:54 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n3GBM-0004t4-VE; Fri, 31 Dec 2021 22:34:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Dec 2021 22:34:48 +1100
Date:   Fri, 31 Dec 2021 22:34:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] crypto: ccp: remove unneeded semicolon
Message-ID: <Yc7q2B7h33z/u6ZM@gondor.apana.org.au>
References: <20211221003828.101022-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221003828.101022-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 21, 2021 at 08:38:28AM +0800, Yang Li wrote:
> Eliminate the following coccicheck warning:
> ./drivers/crypto/ccp/sev-dev.c:263:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
