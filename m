Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17887C46460
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 02:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AFB27AFA
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 02:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfFCCjk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Jun 2019 22:39:40 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44256 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726270AbfFCCjk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Jun 2019 22:39:40 -0400
X-UUID: d9b9fdf348414a908333ce071f8181ea-20190603
X-UUID: d9b9fdf348414a908333ce071f8181ea-20190603
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 491747659; Mon, 03 Jun 2019 10:39:34 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 3 Jun 2019 10:39:33 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 3 Jun 2019 10:39:33 +0800
Message-ID: <1559529573.6663.12.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/3] soc: mediatek: add SMC fid table for SIP
 interface
From:   Neal Liu <neal.liu@mediatek.com>
To:     Sean Wang <sean.wang@kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Crystal Guo =?UTF-8?Q?=28=E9=83=AD=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>,
        "linux-arm Mailing List" <linux-arm-kernel@lists.infradead.org>
Date:   Mon, 3 Jun 2019 10:39:33 +0800
In-Reply-To: <CAGp9LzpkhDhSHL=go3fvzn2Oh8DrsW8F=1YKP4ne9TDvWQVq6Q@mail.gmail.com>
References: <1558946326-13630-1-git-send-email-neal.liu@mediatek.com>
         <1558946326-13630-2-git-send-email-neal.liu@mediatek.com>
         <CAGp9LzpkhDhSHL=go3fvzn2Oh8DrsW8F=1YKP4ne9TDvWQVq6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sean,


On Fri, 2019-05-31 at 06:50 +0800, Sean Wang wrote:
> Hi Neal,
> 
> On Mon, May 27, 2019 at 1:39 AM Neal Liu <neal.liu@mediatek.com> wrote:
> >
> > 1. Add a header file to provide SIP interface to ARM Trusted
> > Firmware(ATF)
> > 2. Add hwrng SMC fid
> >
> > Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> > ---
> >  include/linux/soc/mediatek/mtk_sip_svc.h |   51 ++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >  create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h
> >
> > diff --git a/include/linux/soc/mediatek/mtk_sip_svc.h b/include/linux/soc/mediatek/mtk_sip_svc.h
> > new file mode 100644
> > index 0000000..f65d403
> > --- /dev/null
> > +++ b/include/linux/soc/mediatek/mtk_sip_svc.h
> > @@ -0,0 +1,51 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (c) 2019 MediaTek Inc.
> > + */
> > +
> > +#ifndef _MTK_SECURE_API_H_
> > +#define _MTK_SECURE_API_H_
> > +
> > +#include <linux/kernel.h>
> > +
> > +/* Error Code */
> > +#define SIP_SVC_E_SUCCESS                      0
> > +#define SIP_SVC_E_NOT_SUPPORTED                        -1
> > +#define SIP_SVC_E_INVALID_PARAMS               -2
> > +#define SIP_SVC_E_INVALID_RANGE                        -3
> > +#define SIP_SVC_E_PERMISSION_DENY              -4
> > +
> > +#ifdef CONFIG_ARM64
> > +#define MTK_SIP_SMC_AARCH_BIT                  0x40000000
> 
> #define MTK_SIP_SMC_AARCH_BIT                  BIT(30)
> 
> > +#else
> > +#define MTK_SIP_SMC_AARCH_BIT                  0x00000000
> 
> #define MTK_SIP_SMC_AARCH_BIT                  0
> 
> > +#endif
> > +
> > +/*******************************************************************************
> > + * Defines for Mediatek runtime services func ids
> > + ******************************************************************************/
> 
> It would be good if remove the trivial and below all unused comments.

Okay, I'll keep the necessary parts, thanks

> 
> > +
> > +/* Debug feature and ATF related SMC call */
> > +
> > +/* CPU operations related SMC call */
> > +
> > +/* SPM related SMC call */
> > +
> > +/* Low power related SMC call */
> > +
> > +/* AMMS related SMC call */
> > +
> > +/* Security related SMC call */
> > +/* HWRNG */
> > +#define MTK_SIP_KERNEL_GET_RND \
> > +       (0x82000206 | MTK_SIP_SMC_AARCH_BIT)
> > +
> > +/* Storage Encryption related SMC call */
> > +
> > +/* Platform related SMC call */
> > +
> > +/* Pheripheral related SMC call */
> > +
> > +/* MM related SMC call */
> > +
> > +#endif /* _MTK_SECURE_API_H_ */
> > --
> > 1.7.9.5
> >
> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek


