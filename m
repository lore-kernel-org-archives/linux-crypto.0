Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0ECC433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379337AbiBEEat (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:30:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34020 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379317AbiBEEar (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:30:47 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCiU-00020B-0l; Sat, 05 Feb 2022 15:30:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:30:29 +1100
Date:   Sat, 5 Feb 2022 15:30:29 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com, "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: octeontx2: CN10K CPT to RNM workaround
Message-ID: <Yf39ZZmNWKFJgSpO@gondor.apana.org.au>
References: <ab2269cb3ef3049ed0ab73f28be29f6669a06e36.1643134480.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab2269cb3ef3049ed0ab73f28be29f6669a06e36.1643134480.git.sthotton@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 25, 2022 at 11:56:22PM +0530, Shijith Thotton wrote:
> From: Srujana Challa <schalla@marvell.com>
> 
> When software sets CPT_AF_CTL[RNM_REQ_EN]=1 and RNM in not producing
> entropy(i.e., RNM_ENTROPY_STATUS[NORMAL_CNT] < 0x40), the first cycle of
> the response may be lost due to a conditional clocking issue. Due to
> this, the subsequent random number stream will be corrupted. So, this
> patch adds support to ensure RNM_ENTROPY_STATUS[NORMAL_CNT] = 0x40
> before writing CPT_AF_CTL[RNM_REQ_EN] = 1, as a workaround.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> Signed-off-by: Shijith Thotton <sthotton@marvell.com>
> ---
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 43 ++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
