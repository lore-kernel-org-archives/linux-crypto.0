Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A88C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 07:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D156207BB
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 07:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgHaHcZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 03:32:25 -0400
Received: from gw.c-home.cz ([89.24.150.100]:41464 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgHaHcX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 03:32:23 -0400
Received: from ubuntu1804.c-home.cz (intra-239.c-home.cz [192.168.1.239])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 07V7VPlG005879;
        Mon, 31 Aug 2020 09:31:30 +0200 (CEST)
From:   Martin Cerveny <m.cerveny@computer.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 0/3] crypto: sun4i-ss: add support for V3s
Date:   Mon, 31 Aug 2020 09:30:58 +0200
Message-Id: <20200831073101.3608-1-m.cerveny@computer.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for "sun4i-ss" (crypto engine) for Allwinner V3s.
Simmilar problem like A33.

Changes since v1:
- splited to patch series

Martin Cerveny (3):
  dt-bindings: crypto: add new compatible for V3s
  ARM: dts: sun8i: v3s: Enable crypto engine
  crypto: sun4i-ss - add the V3s variant of SS

 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml    |  5 ++++-
 arch/arm/boot/dts/sun8i-v3s.dtsi                       | 10 ++++++++++
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c      |  7 +++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

-- 
2.17.1

