Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3699EC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Dec 2021 05:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhLKFzi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:55:38 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57708 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhLKFzi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Dec 2021 00:55:38 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mvvM4-0004xw-V4; Sat, 11 Dec 2021 16:55:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Dec 2021 16:55:32 +1100
Date:   Sat, 11 Dec 2021 16:55:32 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel@vivo.com
Subject: Re: [PATCH] crypto: DH: remove duplicate includes
Message-ID: <20211211055532.GA6841@gondor.apana.org.au>
References: <20211129083456.4188-1-guozhengkui@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129083456.4188-1-guozhengkui@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 29, 2021 at 04:34:56PM +0800, Guo Zhengkui wrote:
> Remove a duplicate #include <linux/fips.h>.
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  crypto/dh.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
