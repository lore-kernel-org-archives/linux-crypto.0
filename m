Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E13C76195
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 09:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AA582147A
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 09:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfGVJvc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 05:51:32 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:58112 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729367AbfGVJuw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 05:50:52 -0400
X-UUID: c45950b4dc394bb492ec60abafe0491e-20190722
X-UUID: c45950b4dc394bb492ec60abafe0491e-20190722
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 208432879; Mon, 22 Jul 2019 17:50:44 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 22 Jul 2019 17:50:43 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 22 Jul 2019 17:50:42 +0800
Message-ID: <1563789042.14676.3.camel@mtkswgap22>
Subject: Re: [PATCH v4 0/3] MediaTek Security random number generator support
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>, Rob Herring <robh+dt@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Sean Wang" <sean.wang@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>
Date:   Mon, 22 Jul 2019 17:50:42 +0800
In-Reply-To: <1561361052-13072-1-git-send-email-neal.liu@mediatek.com>
References: <1561361052-13072-1-git-send-email-neal.liu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dear Matthias, Rob, Mark,
	Just gentle ping.
	Thanks


On Mon, 2019-06-24 at 15:24 +0800, Neal Liu wrote:
> These patch series introduce a generic rng driver for Trustzone
> based kernel driver which would like to communicate with ATF
> SIP services.
> 
> Patch #1 initials SMC fid table for Mediatek SIP interfaces and
> adds HWRNG related SMC call.
> 
> Patch #2..3 adds mtk-sec-rng kernel driver for Trustzone based SoCs.
> For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
> entropy sources is not accessible from normal world (linux) and
> rather accessible from secure world (ATF/TEE) only. This driver aims
> to provide a generic interface to ATF rng service.
> 
> 
> changes since v1:
> - rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs
> can reuse this driver.
> - refine coding style and unnecessary check.
> 
> changes since v2:
> - remove unused comments.
> - remove redundant variable.
> 
> changes since v3:
> - add dt-bindings for MediaTek rng with TrustZone enabled
> - revise HWRNG SMC call fid
> 
> 
> Neal Liu (3):
>   soc: mediatek: add SMC fid table for SIP interface
>   dt-bindings: rng: add bindings for MediaTek ARMv8 SoCs
>   hwrng: add mtk-sec-rng driver
> 
>  .../devicetree/bindings/rng/mtk-sec-rng.txt   | 10 ++
>  drivers/char/hw_random/Kconfig                | 16 +++
>  drivers/char/hw_random/Makefile               |  1 +
>  drivers/char/hw_random/mtk-sec-rng.c          | 97 +++++++++++++++++++
>  include/linux/soc/mediatek/mtk_sip_svc.h      | 33 +++++++
>  5 files changed, 157 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/mtk-sec-rng.txt
>  create mode 100644 drivers/char/hw_random/mtk-sec-rng.c
>  create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h
> 


