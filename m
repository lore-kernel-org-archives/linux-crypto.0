Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096DCC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8D52206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbfDROYY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:24:24 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55136 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388806AbfDROYY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:24:24 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7xI-0004kl-5V; Thu, 18 Apr 2019 22:24:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7xF-0004C1-5d; Thu, 18 Apr 2019 22:23:57 +0800
Date:   Thu, 18 Apr 2019 22:23:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: remove set but not used variable 'fini'
Message-ID: <20190418142356.rhdw5ysxvf6aehox@gondor.apana.org.au>
References: <20190410024742.2103-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410024742.2103-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 10, 2019 at 02:47:42AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/mxs-dcp.c: In function 'dcp_chan_thread_sha':
> drivers/crypto/mxs-dcp.c:707:11: warning:
>  variable 'fini' set but not used [-Wunused-but-set-variable]
> 
> It's not used since commit d80771c08363 ("crypto: mxs-dcp - Fix wait
> logic on chan threads"),so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/mxs-dcp.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
