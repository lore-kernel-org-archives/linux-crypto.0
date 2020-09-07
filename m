Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267D9C43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 16:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002DD207DE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 16:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgIGQ0F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:26:05 -0400
Received: from gw.c-home.cz ([89.24.150.100]:42059 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgIGQZ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 12:25:59 -0400
Received: from ubuntu1804.c-home.cz (unifi.c-home.cz [192.168.1.239])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 087GP1f1019439;
        Mon, 7 Sep 2020 18:25:07 +0200 (CEST)
From:   Martin Cerveny <m.cerveny@computer.org>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v3 0/2] ARM: dts: sun8i: v3s: Enable crypto engine
Date:   Mon,  7 Sep 2020 18:24:56 +0200
Message-Id: <20200907162458.23730-1-m.cerveny@computer.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for crypto engine (sun4i-ss) for Allwinner V3s.
Functionality like A33 so add only compatible and enable
in device tree.

Regards.

Changes since v2:
- reduced to device tree only with A33 compatibility

Changes since v1:
- splitting to patch series

martin Cerveny (2):
  dt-bindings: crypto: Add compatible for V3s
  ARM: dts: sun8i: v3s: Enable crypto engine

 .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml   |  3 +++
 arch/arm/boot/dts/sun8i-v3s.dtsi                      | 11 +++++++++++
 2 files changed, 14 insertions(+)

-- 
2.17.1
