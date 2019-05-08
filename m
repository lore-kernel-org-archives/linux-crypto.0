Return-Path: <SRS0=esIh=TI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6098AC04AAD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 03:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B425216C4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 03:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEHD7Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 23:59:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56862 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726653AbfEHD7Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 23:59:25 -0400
X-UUID: 0cfb95ceea894084a9e5b33ba1b50eef-20190508
X-UUID: 0cfb95ceea894084a9e5b33ba1b50eef-20190508
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1803992658; Wed, 08 May 2019 11:59:19 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 May 2019 11:59:17 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 8 May 2019 11:59:17 +0800
From:   <neal.liu@mediatek.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <matthias.bgg@gmail.com>
CC:     <wsd_upstream@mediatek.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 0/3] MT67XX random number generator support
Date:   Wed, 8 May 2019 11:58:54 +0800
Message-ID: <1557287937-2410-1-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: CE048B95ABCC1571DC2B35A1121169CE7F25B8DED925862DF515DB4EE21190BF2000:8
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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
 drivers/char/hw_random/mt67xx-rng.c               |  104 +++++++++++++++++++++
 include/linux/soc/mediatek/mtk_sip_svc.h          |   55 +++++++++++
 5 files changed, 186 insertions(+), 3 deletions(-)
 create mode 100644 drivers/char/hw_random/mt67xx-rng.c
 create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h

-- 
1.7.9.5

