Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E816C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDDBF20700
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfC1GIh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 02:08:37 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:53924 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfC1GIg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 02:08:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h9ODK-0003sR-ON; Thu, 28 Mar 2019 14:08:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h9ODK-0007oa-Em; Thu, 28 Mar 2019 14:08:34 +0800
Date:   Thu, 28 Mar 2019 14:08:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - limit AXI pipeline to a depth of 1
Message-ID: <20190328060834.zma7jgxca7xlixyo@gondor.apana.org.au>
References: <1553261968-5766-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553261968-5766-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 22, 2019 at 03:39:28PM +0200, Iuliana Prodan wrote:
> Some i.MX6 devices (imx6D, imx6Q, imx6DL, imx6S, imx6DP and imx6DQ) have
> an issue wherein AXI bus transactions may not occur in the correct order.
> This isn't a problem running single descriptors, but can be if running
> multiple concurrent descriptors. Reworking the CAAM driver to throttle
> to single requests is impractical, so this patch limits the AXI pipeline
> to a depth of one (from a default of 4) to preclude this situation from
> occurring.
> This patch applies to known affected platforms.
> 
> Signed-off-by: Radu Solea <radu.solea@nxp.com>
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  drivers/crypto/caam/ctrl.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Patch applied.  Thanks.
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
