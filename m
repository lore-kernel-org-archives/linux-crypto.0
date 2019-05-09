Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E30C04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 14:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EF120989
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 14:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEIOyy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 10:54:54 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57765 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726192AbfEIOyy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 10:54:54 -0400
X-UUID: 4d68c5eb26f54662a2d978ecfc2af531-20190509
X-UUID: 4d68c5eb26f54662a2d978ecfc2af531-20190509
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1440209227; Thu, 09 May 2019 22:54:49 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 May 2019 22:54:46 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 9 May 2019 22:54:46 +0800
Message-ID: <1557413686.23445.6.camel@mtkswgap22>
Subject: Re: [PATCH 3/3] hwrng: add mt67xx-rng driver
From:   Neal Liu <neal.liu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Stephan Mueller <smueller@chronox.de>, <mpm@selenic.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <matthias.bgg@gmail.com>, <wsd_upstream@mediatek.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <Crystal.Guo@mediatek.com>
Date:   Thu, 9 May 2019 22:54:46 +0800
In-Reply-To: <20190509052649.xfkgb3qd7rhcgktj@gondor.apana.org.au>
References: <1557287937-2410-1-git-send-email-neal.liu@mediatek.com>
         <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
         <12193108.aNnqf5ydOJ@tauon.chronox.de>
         <1557311737.11818.11.camel@mtkswgap22>
         <20190509052649.xfkgb3qd7rhcgktj@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: DAF1C2FB982B2A5BC6E4832EA14731AB2E44B177010654C3FE819CDBF77FEEAE2000:8
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2019-05-09 at 13:26 +0800, Herbert Xu wrote:
> On Wed, May 08, 2019 at 06:35:37PM +0800, Neal Liu wrote:
> > Hi Stephan,
> > 	We think the cast is fine, and it cannot guarantee the buf is
> > word-align.
> > 	I reference multiple rng driver's implementation and found it's common
> > usage for this. So it might be general usage for community. Is there any
> > suggestion that is more appropriate?
> 
> If you don't know whether it's unaligned or not then you should
> do an unaligned operation.

Hi Stephan/Herbert,
	My mistake. This buffer is allocated by kmalloc with larger than 32
bytes. So yes, it's word-align for sure.
	reference:
https://elixir.bootlin.com/linux/latest/source/drivers/char/hw_random/core.c#L590

	Thanks
Best Regards,
-Neal Liu


