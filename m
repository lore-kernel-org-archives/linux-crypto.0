Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05B3C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA2786120C
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhGTIRb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:31 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41167 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbhGTIPO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771352; x=1658307352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O4c1MZdz3w2v44NOm3cz4feeg7svwtP+OQBMnAdlLtk=;
  b=fNGMWklq7ky91p/BlTs03Eyt2Dj73HjXn+zB43jsaNkRKdc32PcwHBnZ
   ZSneluVNFfSk6lu5mZwqiknOtwVtBrCaTD8uUXZxlsiflKYffzexczKoB
   Y7B/PgXfpy2NtGYXrwfGTQlP8/gDTpUlYBMu80e3KVEEl9hN1bkLKoRkk
   dOAsLtRPMNMiGFyonFQKqqUALUU2vSzvbkgKHxNMSdDjFSWrm2N94LU/M
   aRYVKvWDE+PiB1Z9ANNrFQvZoG/Ghh+e2ni2y/mhzvwiuNYMbeYXf4qsq
   nm368fXq1J3THWyYEMDyOkAftQa5vIe+ILIez5xuliNksrCJ/AFyuIDMK
   A==;
IronPort-SDR: Ytk+/ayBCHigX7kcDMt8gAyPF7xzX+gf+MbFCpptvDSFL7PrTLQQbqhwS6SWIPblix+RzKHikK
 jbgRVl8MiQ2ft2JY1U7qArbauB485Z53LGZUJ0BK1fFVkDrdZbGgwzumy7/OyijCIT0uWVhuHp
 MdcdqaDaR7ru+NLl5To0hahnhTnIMJA2JtJ9St34/UHX6qMrcgGZqWv4Nul2PuFJbDUelU+BEo
 qvEAPkcw8BaV+hAuzbDQS3lqsD7/G2MySRmoURzuHhnUfJTHRzaq8kMq8voyg61HW+0iCCkmM5
 JsIv+gMmww+waf/NH0AIh7ik
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="122687300"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:55:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:39 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:37 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 0/9] crypto: atmel-{aes, tdes}: Fix corner cases - crypto self tests 
Date:   Tue, 20 Jul 2021 11:55:26 +0300
Message-ID: <20210720085535.141486-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The extra run-time crypto self tests hit some corner cases that were            
not handled in the drivers. Fix some corner cases. Propose some cleaning        
patches.      

Tudor Ambarus (9):
  crypto: atmel-tdes: Clarify how tdes dev gets allocated to the tfm
  crypto: atmel-tdes: Handle error messages
  crypto: atmel-aes: Add blocksize constraint for ECB and CBC modes
  crypto: atmel-aes: Add XTS input length constraint
  crypto: atmel-aes: Add NIST 800-38A's zero length cryptlen constraint
  crypto: atmel-tdes: Add FIPS81's zero length cryptlen constraint
  crypto: atmel-{aes, tdes}: Set OFB's blocksize to 1
  crypto: atmel-aes: Add fallback to XTS software implementation
  crypto: atmel-aes: Allocate aes dev at tfm init time

 drivers/crypto/atmel-aes.c  | 146 +++++++++++++++++++++++++++---------
 drivers/crypto/atmel-tdes.c |  66 +++++++---------
 2 files changed, 138 insertions(+), 74 deletions(-)

-- 
2.25.1

