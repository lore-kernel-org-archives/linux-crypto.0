Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF19C433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379349AbiBEEau (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:30:50 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34024 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235751AbiBEEat (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:30:49 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCig-00020R-A1; Sat, 05 Feb 2022 15:30:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:30:42 +1100
Date:   Sat, 5 Feb 2022 15:30:42 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com, "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: octeontx2: increase CPT HW instruction queue
 length
Message-ID: <Yf39cvi1hYEg5Qdm@gondor.apana.org.au>
References: <ab2269cb3ef3049ed0ab73f28be29f6669a06e36.1643134480.git.sthotton@marvell.com>
 <2088adbb37511e84b963fbcd6eff16c62610e2d2.1643134404.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2088adbb37511e84b963fbcd6eff16c62610e2d2.1643134404.git.sthotton@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 25, 2022 at 11:56:24PM +0530, Shijith Thotton wrote:
> From: Srujana Challa <schalla@marvell.com>
> 
> LDWB is getting incorrectly used in HW when
> CPT_AF_LF()_PTR_CTL[IQB_LDWB]=1 and CPT instruction queue has less than
> 320 free entries. So, increase HW instruction queue size by 320 and give
> 320 entries less for SW/NIX RX as a SW workaround.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> Signed-off-by: Shijith Thotton <sthotton@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
