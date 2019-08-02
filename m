Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33208C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 01:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F8B42080C
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 01:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbfHBBfv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 21:35:51 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:16015 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731011AbfHBBfu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 21:35:50 -0400
X-UUID: 8caf567bc513476db8dcba29a9fa4f3c-20190802
X-UUID: 8caf567bc513476db8dcba29a9fa4f3c-20190802
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0707 with TLS)
        with ESMTP id 266494707; Fri, 02 Aug 2019 09:35:43 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 2 Aug 2019 09:35:44 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 2 Aug 2019 09:35:44 +0800
Message-ID: <1564709744.8481.2.camel@mtkswgap22>
Subject: Re: [PATCH v4 0/3] MediaTek Security random number generator support
From:   Neal Liu <neal.liu@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sean Wang <sean.wang@kernel.org>,
        "Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?=" 
        <Crystal.Guo@mediatek.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Neal Liu <neal.liu@mediatek.com>
Date:   Fri, 2 Aug 2019 09:35:44 +0800
In-Reply-To: <1563789042.14676.3.camel@mtkswgap22>
References: <1561361052-13072-1-git-send-email-neal.liu@mediatek.com>
         <1563789042.14676.3.camel@mtkswgap22>
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


> On Mon, 2019-06-24 at 15:24 +0800, Neal Liu wrote:
> > These patch series introduce a generic rng driver for Trustzone
> > based kernel driver which would like to communicate with ATF
> > SIP services.
> > 
> > Patch #1 initials SMC fid table for Mediatek SIP interfaces and
> > adds HWRNG related SMC call.
> > 
> > Patch #2..3 adds mtk-sec-rng kernel driver for Trustzone based SoCs.
> > For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
> > entropy sources is not accessible from normal world (linux) and
> > rather accessible from secure world (ATF/TEE) only. This driver aims
> > to provide a generic interface to ATF rng service.
> > 
> > 
> > changes since v1:
> > - rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs
> > can reuse this driver.
> > - refine coding style and unnecessary check.
> > 
> > changes since v2:
> > - remove unused comments.
> > - remove redundant variable.
> > 
> > changes since v3:
> > - add dt-bindings for MediaTek rng with TrustZone enabled
> > - revise HWRNG SMC call fid
> > 
> > 
> > Neal Liu (3):
> >   soc: mediatek: add SMC fid table for SIP interface
> >   dt-bindings: rng: add bindings for MediaTek ARMv8 SoCs
> >   hwrng: add mtk-sec-rng driver
> > 
> >  .../devicetree/bindings/rng/mtk-sec-rng.txt   | 10 ++
> >  drivers/char/hw_random/Kconfig                | 16 +++
> >  drivers/char/hw_random/Makefile               |  1 +
> >  drivers/char/hw_random/mtk-sec-rng.c          | 97 +++++++++++++++++++
> >  include/linux/soc/mediatek/mtk_sip_svc.h      | 33 +++++++
> >  5 files changed, 157 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rng/mtk-sec-rng.txt
> >  create mode 100644 drivers/char/hw_random/mtk-sec-rng.c
> >  create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h
> > 
> 


