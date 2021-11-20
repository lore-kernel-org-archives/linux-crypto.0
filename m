Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34876C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhKTEec (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:34:32 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56916 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232053AbhKTEec (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:34:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moI24-0001Kg-Nw; Sat, 20 Nov 2021 12:31:20 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moI21-0006nL-4e; Sat, 20 Nov 2021 12:31:17 +0800
Date:   Sat, 20 Nov 2021 12:31:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     cgel.zte@gmail.com
Cc:     bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        davem@davemloft.net, lbartosik@marvell.com, chi.minghao@zte.com.cn,
        schandran@marvell.com, ebiggers@google.com,
        ovidiu.panait@windriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] crypto:otx2_cptvf_algs: use swap() to make code cleaner
Message-ID: <20211120043117.GL25752@gondor.apana.org.au>
References: <20211109083503.131468-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109083503.131468-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 09, 2021 at 08:35:03AM +0000, cgel.zte@gmail.com wrote:
> From: chiminghao <chi.minghao@zte.com.cn>
> 
> Fix the following coccicheck REVIEW:
> ./drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c:1688:16-17 use swap() to make code cleaner
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
