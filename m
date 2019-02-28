Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0573AC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D36DB20842
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfB1G36 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:29:58 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39802 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1G35 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:29:57 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFCe-0005jC-7G; Thu, 28 Feb 2019 14:29:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFCb-0001d8-80; Thu, 28 Feb 2019 14:29:53 +0800
Date:   Thu, 28 Feb 2019 14:29:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/3] crypto: caam/jr - DMA API fixes
Message-ID: <20190228062953.cvtsfipkxhbxbuw2@gondor.apana.org.au>
References: <20190219145657.2267-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190219145657.2267-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 19, 2019 at 04:56:54PM +0200, Horia Geantă wrote:
> This patch set fixes issues uncovered when testing the Job Ring interface
> with CONFIG_DMA_API_DEBUG=y.
> 
> First patch ("crypto: caam - fix hash context DMA unmap size") has to be
> sent to -stable, according to "Fixes" tag.
> 
> Franck LENORMAND (1):
>   crypto: caam - fix hash context DMA unmap size
> 
> Horia Geantă (2):
>   crypto: caam - fix DMA mapping xcbc key twice
>   crypto: caam - generate hash keys in-place
> 
>  drivers/crypto/caam/caamhash.c | 51 ++++++++++++++++--------------------------
>  drivers/crypto/caam/key_gen.c  | 30 +++++++++----------------
>  2 files changed, 29 insertions(+), 52 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
