Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76681C282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 08:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB312173B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 08:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfE0Ij1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 04:39:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:30690 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725869AbfE0Ij1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 04:39:27 -0400
X-UUID: 82d828f1785c4f68b51bf35d6d3c0b4a-20190527
X-UUID: 82d828f1785c4f68b51bf35d6d3c0b4a-20190527
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1990578935; Mon, 27 May 2019 16:39:15 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 27 May 2019 16:39:07 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 27 May 2019 16:39:07 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>
Subject: [PATCH v2 0/3] MediaTek Security random number generator support
Date:   Mon, 27 May 2019 16:38:43 +0800
Message-ID: <1558946326-13630-1-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 230D15169F03B83C7C0D95C59BE03E1101255BC24DBD91EF7AD4844FB1453F612000:8
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These patch series introduce a generic rng driver for Trustzone
based kernel driver which would like to communicate with ATF
SIP services.

Patch #1 initials SMC fid table for MediaTek SIP interfaces and
adds HWRNG related SMC call.

Patch #2..3 adds mtk-sec-rng kernel driver for Trustzone based SoCs.
For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
entropy sources is not accessible from normal world (linux) and
rather accessible from secure world (ATF/TEE) only. This driver aims
to provide a generic interface to ATF rng service.


changes since v2:
- rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs
can reuse this driver.
- refine coding style and unnecessary check.

Neal Liu (3):
  soc: mediatek: add SMC fid table for SIP interface
  dt-bindings: rng: update bindings for MediaTek ARMv8 SoCs
  hwrng: add mtk-sec-rng driver

 .../devicetree/bindings/rng/mtk-rng.txt       | 13 ++-
 drivers/char/hw_random/Kconfig                | 16 +++
 drivers/char/hw_random/Makefile               |  1 +
 drivers/char/hw_random/mtk-sec-rng.c          | 97 +++++++++++++++++++
 include/linux/soc/mediatek/mtk_sip_svc.h      | 51 ++++++++++
 5 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 drivers/char/hw_random/mtk-sec-rng.c
 create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h

-- 
2.18.0

