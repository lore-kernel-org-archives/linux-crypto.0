Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD0AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 752BE6117A
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhJ2ODQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:03:16 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:48920 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230036AbhJ2ODM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:03:12 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDE7K001315;
        Fri, 29 Oct 2021 15:55:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=selector1;
 bh=mCiDR+gsoKv33aVNbx/ppRXPMERKyfh5jwIF1keIFKM=;
 b=LWn+sHwm8cXD81nuGYL0rN6/Vcf/98bIOtXh+UnbEViS5Gc1B+jjiVknkG69EaH1ytwz
 PvTTz/YQwGrHG85WdusecAijrsIiPv3OvGTBailxLaFUrwfxwvJR4Nlk89lwxDFLXuaP
 CILeFVcYoEySNLu1T/EXnQ/V9UcBcrIZMJgvbIAH0tujk9cbApRIE11Bz0drEtAf1R6W
 YvSLrX1heC9NGt3ESObPhdPfwvN7Yam+qyIF8FmOqjLQq5NoXqA9kmd4AwGJj4VsXPiw
 ipMZTHluecxDHCjsT5kysBg3lkd70kZKLBlWicBcgjgKIrMc4+XAvwebHUu6VFzHiUzv Ng== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c07xgkp6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:55:49 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CEECD10002A;
        Fri, 29 Oct 2021 15:55:45 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 78CE024C73D;
        Fri, 29 Oct 2021 15:55:45 +0200 (CEST)
Received: from localhost (10.75.127.48) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 15:55:45
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] STM32 CRYP driver: many fixes
Date:   Fri, 29 Oct 2021 15:54:46 +0200
Message-ID: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

This set of patches update the STM32 CRYP driver.

First two update about EPROBE_DEFER management.
Then many fixes to success the cryptomanager EXTRA_TESTS.
And finally we reorder the initialization to set the key as last step.

This patch series applies to cryptodev/master.

Etienne Carriere (2):
  crypto: stm32/cryp - defer probe for reset controller
  crypto: stm32/cryp - don't print error on probe deferral

Nicolas Toromanoff (6):
  crypto: stm32/cryp - fix CTR counter carry
  crypto: stm32/cryp - fix race condition
  crypto: stm32/cryp - check early input data
  crypto: stm32/cryp - fix double pm exit.
  crypto: stm32/cryp - fix bugs and crash in tests
  crypto: stm32/cryp - reorder hw initialization

 drivers/crypto/stm32/stm32-cryp.c | 977 ++++++++++++------------------
 1 file changed, 401 insertions(+), 576 deletions(-)


base-commit: 3ae88f676aa63366ffa9eebb8ae787c7e19f0c57
-- 
2.17.1

