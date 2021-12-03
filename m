Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98885C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 05:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhLCFLG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 00:11:06 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57380 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234984AbhLCFLB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 00:11:01 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mt0n4-00029X-A8; Fri, 03 Dec 2021 16:07:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Dec 2021 16:07:22 +1100
Date:   Fri, 3 Dec 2021 16:07:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - uninitialized variable in
 kvf_limits_store()
Message-ID: <20211203050722.GC20393@gondor.apana.org.au>
References: <20211127141027.GC24002@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211127141027.GC24002@kili>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 27, 2021 at 05:10:27PM +0300, Dan Carpenter wrote:
> If kstrtoint() fails then "lfs_num" is uninitialized and the warning
> doesn't make any sense.  Just delete it.
> 
> Fixes: 8ec8015a3168 ("crypto: octeontx2 - add support to process the crypto request")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
