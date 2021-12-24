Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9BBC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Dec 2021 03:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbhLXD0T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 22:26:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58464 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351168AbhLXD0J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 22:26:09 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n0bDQ-0006LP-CY; Fri, 24 Dec 2021 14:25:57 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Dec 2021 14:25:56 +1100
Date:   Fri, 24 Dec 2021 14:25:56 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        "David S. Miller" <davem@davemloft.net>,
        Suheil Chandran <schandran@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: octeontx2 - out of bounds access in
 otx2_cpt_dl_custom_egrp_delete()
Message-ID: <YcU9xBEc9kFlm+at@gondor.apana.org.au>
References: <20211217071232.GG26548@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217071232.GG26548@kili>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 17, 2021 at 10:12:32AM +0300, Dan Carpenter wrote:
> If "egrp" is negative then it is causes an out of bounds access in
> eng_grps->grp[].
> 
> Fixes: d9d7749773e8 ("crypto: octeontx2 - add apis for custom engine groups")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
