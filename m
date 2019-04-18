Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1708C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8665C20675
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388996AbfDROXt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:23:49 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55108 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388806AbfDROXs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:23:48 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7x5-0004kY-Cy; Thu, 18 Apr 2019 22:23:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7x2-0004BZ-DP; Thu, 18 Apr 2019 22:23:44 +0800
Date:   Thu, 18 Apr 2019 22:23:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam/jr - Remove extra memory barrier during job
 ring dequeue
Message-ID: <20190418142344.3fgmtfvvw2tbcwxq@gondor.apana.org.au>
References: <20190409063505.16664-1-vakul.garg@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409063505.16664-1-vakul.garg@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 09, 2019 at 06:38:08AM +0000, Vakul Garg wrote:
> In function caam_jr_dequeue(), a full memory barrier is used before
> writing response job ring's register to signal removal of the completed
> job. Therefore for writing the register, we do not need another write
> memory barrier. Hence it is removed by replacing the call to wr_reg32()
> with a newly defined function wr_reg32_relaxed().
> 
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> ---
>  drivers/crypto/caam/jr.c   | 2 +-
>  drivers/crypto/caam/regs.h | 8 ++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
