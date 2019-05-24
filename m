Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA1AC282E3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 07:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEAEA217F9
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 07:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389030AbfEXHmv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 03:42:51 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:27286 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388960AbfEXHmv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 03:42:51 -0400
X-UUID: d50e7404e6a24342ab317cff1f4924c2-20190524
X-UUID: d50e7404e6a24342ab317cff1f4924c2-20190524
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1760047958; Fri, 24 May 2019 15:42:37 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 May 2019 15:42:34 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 May 2019 15:42:34 +0800
Message-ID: <1558683754.5671.4.camel@mtkswgap22>
Subject: Re: [PATCH 3/3] hwrng: add mt67xx-rng driver
From:   Neal Liu <neal.liu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Stephan Mueller <smueller@chronox.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>, Neal Liu <neal.liu@mediatek.com>
Date:   Fri, 24 May 2019 15:42:34 +0800
In-Reply-To: <20190510063915.kwqy3e5urs6j7ity@gondor.apana.org.au>
References: <1557287937-2410-1-git-send-email-neal.liu@mediatek.com>
         <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
         <12193108.aNnqf5ydOJ@tauon.chronox.de>
         <1557311737.11818.11.camel@mtkswgap22>
         <20190509052649.xfkgb3qd7rhcgktj@gondor.apana.org.au>
         <1557413686.23445.6.camel@mtkswgap22>
         <20190510063915.kwqy3e5urs6j7ity@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 89ED3B40815DB6F837B8DBB2E0E3948F37DDFAA36A07D69CF4F4116AD8AC13F82000:8
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
	Could you kindly help to review our patches?
	Thanks

From	Neal Liu <>
Subject	[PATCH 0/3] MT67XX random number generator support
Date	Wed, 8 May 2019 11:58:54 +0800
share
These patch series introduce a generic rng driver for Trustzone
based kernel driver which would like to communicate with ATF
SIP services.

Patch #1 initials SMC fid table for Mediatek SIP interfaces and
adds HWRNG related SMC call.

Patch #2..3 adds mt67xx-rng kernel driver for Trustzone based SoCs.
For Mediatek SoCs on ARMv8 with TrustZone enabled, peripherals like
entropy sources is not accessible from normal world (linux) and
rather accessible from secure world (ATF/TEE) only. This driver aims
to provide a generic interface to ATF rng service.

Neal Liu (3):
  soc: mediatek: add SMC fid table for SIP interface
  dt-bindings: rng: update bindings for MT67xx SoCs
  hwrng: add mt67xx-rng driver

 Documentation/devicetree/bindings/rng/mtk-rng.txt |   13 ++-
 drivers/char/hw_random/Kconfig                    |   16 ++++
 drivers/char/hw_random/Makefile                   |    1 +
 drivers/char/hw_random/mt67xx-rng.c               |  104
+++++++++++++++++++++
 include/linux/soc/mediatek/mtk_sip_svc.h          |   55 +++++++++++
 5 files changed, 186 insertions(+), 3 deletions(-)
 create mode 100644 drivers/char/hw_random/mt67xx-rng.c
 create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h

-- 
1.7.9.5

Best Regards,
-Neal Liu


