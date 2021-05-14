Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76840C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53CBB61451
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhENLhv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 07:37:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37326 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232633AbhENLht (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 07:37:49 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lhW7G-00033L-S4; Fri, 14 May 2021 19:36:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lhW7C-0002ZI-HR; Fri, 14 May 2021 19:36:22 +0800
Date:   Fri, 14 May 2021 19:36:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Bixuan Cui <cuibixuan@huawei.com>
Cc:     Haren Myneni <haren@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: nx842: add missing MODULE_DEVICE_TABLE
Message-ID: <20210514113622.vi2n4patdpajlfx2@gondor.apana.org.au>
References: <20210508031455.53541-1-cuibixuan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508031455.53541-1-cuibixuan@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 08, 2021 at 11:14:55AM +0800, Bixuan Cui wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
> ---
>  drivers/crypto/nx/nx-842-pseries.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
