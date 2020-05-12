Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3947FC54E4A
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19AC6206F5
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="KTiDZr5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgELONe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 10:13:34 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:2330 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730282AbgELONY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 10:13:24 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CEC6Nl020352;
        Tue, 12 May 2020 16:12:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=/cK62abs1ZOEPd483Fs6vDPdjcVo6tdi3F8yjd7dwk0=;
 b=KTiDZr5bXPQ1ht4Sn0aTqssoSiATVAB6OvUCqHuvtHDJWH/2ga4oo/VQn6vj/L8sIbUx
 E4Honl7oWMa8wczDu+Httq4wd6aiUXW7acBRNFc/ZyyeVwlpmfo5QSrhvhRfgkXr1zHD
 GPJow8LcS3EWe4JrFtdfwI/9xYuQaRtPnnTT2NFLqVyuaYs7VnSf/0Je0tDOsEEae20l
 WI0TLo0dqictsY16T419hWRkJRqiRWswe8q/B0z3GBUVLpmaBbmd0MbeCbNY/l1dxwo/
 lQYob5ZuDSCPkUQsCIMW2lfNetp0Lqy3//gfqPgIYZXveiFUb7HBjo7hSBvWvRNn2NvC 3A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30whn9gw5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 16:12:06 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4D5E810002A;
        Tue, 12 May 2020 16:11:56 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id F2EB22AA608;
        Tue, 12 May 2020 16:11:55 +0200 (CEST)
Received: from localhost (10.75.127.47) by SFHDAG6NODE1.st.com (10.75.127.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 May 2020 16:11:55
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
CC:     Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] STM32 CRC update
Date:   Tue, 12 May 2020 16:11:08 +0200
Message-ID: <20200512141113.18972-1-nicolas.toromanoff@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG8NODE2.st.com (10.75.127.23) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set of patches update the STM32 CRC driver.
It contains bug fix.

First fixes issue if we enable STM32 CRC32 hardware accelerator with
ext4 (with metadata-chksum enable) and other fs that use same direct
access to update crc32 API without previous init.
Second fixes some issues raise by the extra self-test.
Third fixes wrong hw usage if there is multiple IP on the SOC.
Forth fixes "sleep while atomic" in tcrypt test, and some other places
(ext4)
Last fixes concurrent accesses. As state is saved in the hardware cell
and not in stack as other CRC32 drivers, we need to create atomic
section to protect concurrent CRC32 calculus.

This patch series applies to cryptodev/master.

Nicolas Toromanoff (5):
  crypto: stm32/crc: fix ext4 chksum BUG_ON()
  crypto: stm32/crc: fix run-time self test issue.
  crypto: stm32/crc: fix multi-instance
  crypto: stm32/crc: don't sleep in runtime pm
  crypto: stm32/crc: protect from concurrent accesses

 drivers/crypto/stm32/stm32-crc32.c | 230 ++++++++++++++++++++---------
 1 file changed, 161 insertions(+), 69 deletions(-)

-- 
2.17.1

