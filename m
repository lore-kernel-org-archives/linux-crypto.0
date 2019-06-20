Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E35C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2747120449
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 08:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbfFTIGF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 04:06:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43574 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfFTIGF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 04:06:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hds56-0002CU-Ak; Thu, 20 Jun 2019 16:06:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hds54-0007OE-Da; Thu, 20 Jun 2019 16:06:02 +0800
Date:   Thu, 20 Jun 2019 16:06:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH 0/2] crypto: caam - update IV using HW support
Message-ID: <20190620080602.kavsw7ns4sanqhuz@gondor.apana.org.au>
References: <20190610133059.1059-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190610133059.1059-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 10, 2019 at 04:30:57PM +0300, Horia Geantă wrote:
> This patch set updates the drivers to rely on HW for providing
> the output IV in case of skcipher algorithms.
> 
> It's both an improvement, as previously mentioned here:
> https://lore.kernel.org/linux-crypto/VI1PR0401MB2591C51C446CFA129B50022298D20@VI1PR0401MB2591.eurprd04.prod.outlook.com
> and a fix for the currently broken ctr(aes) IV update.
> 
> Horia Geantă (2):
>   crypto: caam - use len instead of nents for bulding HW S/G table
>   crypto: caam - update IV using HW support
> 
>  drivers/crypto/caam/caamalg.c      | 119 ++++++++++++----------
>  drivers/crypto/caam/caamalg_desc.c |  31 ++++--
>  drivers/crypto/caam/caamalg_desc.h |   4 +-
>  drivers/crypto/caam/caamalg_qi.c   | 122 ++++++++++-------------
>  drivers/crypto/caam/caamalg_qi2.c  | 152 ++++++++++++++---------------
>  drivers/crypto/caam/caamhash.c     |  15 ++-
>  drivers/crypto/caam/caampkc.c      |   4 +-
>  drivers/crypto/caam/sg_sw_qm.h     |  18 ++--
>  drivers/crypto/caam/sg_sw_qm2.h    |  18 ++--
>  drivers/crypto/caam/sg_sw_sec4.h   |  18 ++--
>  10 files changed, 262 insertions(+), 239 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
