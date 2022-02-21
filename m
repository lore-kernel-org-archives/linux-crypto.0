Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353A6C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Feb 2022 07:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346620AbiBUH6v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Feb 2022 02:58:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346643AbiBUH6r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Feb 2022 02:58:47 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1C1E02B;
        Sun, 20 Feb 2022 23:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645430304; x=1676966304;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kJdv8te93/QoLLMBt8iaiim4AkEZeLxx62y6s6+oHG8=;
  b=fJMOdZ0A6jXptbSgaUkeY4QViJiXGapgLvED19EdDUjXDysjzYWJF+LM
   NS2EjnmMrLvhMq66mft1iyqVYH4xETQGp8AC3C97GVF7NUZzyN0mTFOGI
   RCkHGGyVtPfa7Jbf/Oc+Nv5NvwkT62j1pxXn1Z4AlzKzjc5mtsPJvYOsV
   af+x0ZIT0EQpXPtO/tSiMXu9+Ry/9gnxROYohbi6+gzVhjqufOv04UFfV
   TMmgBN0h63m9lN12AthDsz5olmfsXQ+XSEnyxsxMsxnBDFmAOfFAJl8iQ
   XjLKqz6jzHwMkc0+5jkMj4KT70Zu7eRqxLFAkmr9A0k6xOTfSmZ0CeLB0
   g==;
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="86422597"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2022 00:58:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Feb 2022 00:58:21 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Feb 2022 00:58:19 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 0/7] hwrng: atmel - add runtime pm support
Date:   Mon, 21 Feb 2022 09:59:21 +0200
Message-ID: <20220221075928.563806-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This series adds runtime PM support for atmel-rng driver. Along with
this some cleanup and fixes patches were added to the series.

Thank you,
Claudiu Beznea

Claudiu Beznea (7):
  hwrng: atmel - add wait for ready support on read
  hwrng: atmel - disable trng on failure path
  hwrng: atmel - rename enable/disable functions to init/cleanup
  hwrng: atmel - move set of TRNG_HALFR in atmel_trng_init()
  hwrng: atmel - use __maybe_unused and pm_ptr() for pm ops
  hwrng: atmel - add runtime pm support
  hwrng: atmel - remove extra line

 drivers/char/hw_random/atmel-rng.c | 148 ++++++++++++++++++-----------
 1 file changed, 91 insertions(+), 57 deletions(-)

-- 
2.32.0

