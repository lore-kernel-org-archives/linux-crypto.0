Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA169C31E4A
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C999E20644
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 16:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392743AbfFMQkO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:40:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50086 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730577AbfFMG5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 02:57:24 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hbJfm-0006Hp-9j; Thu, 13 Jun 2019 14:57:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hbJfl-00057M-Hh; Thu, 13 Jun 2019 14:57:21 +0800
Date:   Thu, 13 Jun 2019 14:57:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-crypto@vger.kernel.org, horia.geanta@nxp.com
Subject: Re: [PATCH 1/2] crypto: mxs-dcp - Use
 devm_platform_ioremap_resource()
Message-ID: <20190613065721.pgnoperyk2nersud@gondor.apana.org.au>
References: <20190606161349.5227-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606161349.5227-1-festevam@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 06, 2019 at 01:13:48PM -0300, Fabio Estevam wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/crypto/mxs-dcp.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
