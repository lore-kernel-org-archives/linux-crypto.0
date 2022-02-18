Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55884C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Feb 2022 10:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiBRKQ1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 05:16:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiBRKQ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 05:16:26 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038532AC909;
        Fri, 18 Feb 2022 02:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645179369; x=1676715369;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b6jyNc5TsAM7TWNnI+hOWz6Q72t0GMAoWfyakMBe+ag=;
  b=lcF7sf8RTBUWT2NzSSTqAQvdaiccC/Z+IhL5KuCtqZPuOTbviKoZlAG2
   q1O1c1EsCtGBDIUwfKHxGuErO2T3e7CvEf+CrO21ySEfNcNIRJRJXGo1e
   odPaHGxcRpXPu6iXNXfmo3esuFBc6bVtg+S0of5BYRthjq9+SMWmuFesX
   lfY9/GcUIeX0E1Rv91qzraDkslvMLaG50eSCrWuIbbmeQXnm76/cdVhZD
   pnSZgN4yW/lWRp0b7A1MXqZoImd5z+oUAWs0vNSrIwRNemtmXu53e1+dV
   Wc7vALCRsqExqBzAKEKCm4jX6OKn//b9NsZTJunPF9Tv0CZnYcL1xD/ZV
   A==;
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="146491107"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2022 03:16:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Feb 2022 03:16:06 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Feb 2022 03:16:03 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 0/7] hwrnd: atmel - add runtime pm support
Date:   Fri, 18 Feb 2022 12:17:05 +0200
Message-ID: <20220218101712.530576-1-claudiu.beznea@microchip.com>
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
  hwrnd: atmel - disable trng on failure path
  hwrnd: atmel - rename enable/disable functions to init/cleanup
  hwrng: atmel - move set of TRNG_HALFR in atmel_trng_init()
  hwrnd: atmel - use __maybe_unused and pm_ptr() for pm ops
  hwrnd: atmel - add runtime pm support
  hwrnd: atmel - remove extra line

 drivers/char/hw_random/atmel-rng.c | 148 ++++++++++++++++++-----------
 1 file changed, 91 insertions(+), 57 deletions(-)

-- 
2.32.0

