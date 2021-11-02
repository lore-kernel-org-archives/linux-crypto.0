Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90453C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78A1B60F24
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhKBQup (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:50:45 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51346 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231708AbhKBQun (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 12:50:43 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A2G39sv025654;
        Tue, 2 Nov 2021 17:47:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=selector1;
 bh=E6cFgMQ5mYO6zhL9efbx4Y+zk1mNlk4o4AVLdYE5S0k=;
 b=heKgWNQVhkvD/DGGQ8wyXn3uWdT1ryCdBTCRMMC63Nhp05tzLsmocaiCXLExnxS35MgA
 sZbqdddNYdBtUW/YM7makKPSHKBaPQYCQ81MZ2n3X1LXVQK1X1Z8gqQBn70PPhObeqpi
 HW76NpxggcwfMr+5clVW5VQbhDxKYeswpS3l++aQjbEymhNj2KTDmMWLRh4VlhoxCgVc
 xbqXXFcU4bUBRsuPJ1BB8ceVDfktuGfRQcJKH3uKCM/hO5edIw03ys30l51pNxpeVH8M
 BSo8R5vjCzG7irGgc5oaKx5EN8j8yljKoaokJwJptEFvm6Lj9BYmlru6h7kq1cIB0vgJ 4A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3c30vnbqe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 17:47:49 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 484FC10002A;
        Tue,  2 Nov 2021 17:47:45 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 0FAE623480D;
        Tue,  2 Nov 2021 17:47:45 +0100 (CET)
Received: from localhost (10.75.127.46) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 2 Nov 2021 17:47:44
 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/8] STM32 CRYP driver: many fixes
Date:   Tue, 2 Nov 2021 17:47:21 +0100
Message-ID: <20211102164729.9957-1-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

This set of patches update the STM32 CRYP driver.

First two update about EPROBE_DEFER management.
Then many fixes to success the cryptomanager EXTRA_TESTS.
And finally we reorder the initialization to set the key as last step.

This patch series applies to cryptodev/master.

v1 -> v2 :
  - use crypto_inc() in "crypto: stm32/cryp - fix CTR counter carry".
  - more explicit commit description.
  - with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y all tests pass, at boot 
    if built into kernel, at insmod if in module. (as v1)

Etienne Carriere (2):
  crypto: stm32/cryp - defer probe for reset controller
  crypto: stm32/cryp - don't print error on probe deferral

Nicolas Toromanoff (6):
  crypto: stm32/cryp - fix CTR counter carry
  crypto: stm32/cryp - fix race condition in crypto_engine requests
  crypto: stm32/cryp - check early input data
  crypto: stm32/cryp - fix double pm exit.
  crypto: stm32/cryp - fix bugs and crash in tests
  crypto: stm32/cryp - reorder hw initialization

 drivers/crypto/stm32/stm32-cryp.c | 983 ++++++++++++------------------
 1 file changed, 403 insertions(+), 580 deletions(-)


base-commit: 3ae88f676aa63366ffa9eebb8ae787c7e19f0c57
-- 
2.17.1

