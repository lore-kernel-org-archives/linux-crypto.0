Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E4AC54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E8672072D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="bLig6qxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgD0GnT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 02:43:19 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:14368 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbgD0GnT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 02:43:19 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03R6cO6F024040;
        Mon, 27 Apr 2020 08:42:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=TDbaAq8nLSxL5Pn2AoB6X1/THDI0mod6aKQma53bdKU=;
 b=bLig6qxKvGEjnGtaOjXzq4zAdvJpIBkSWQGyLqRnITGmh1KUYDrkQ91y4yc8aBWZXhzt
 Lk2kWh7WqbhJoeUXkVfvXfVnxt5mG29rwMm5Qef2/zG075ECyiHF+aH2qZgAIEJ8nuAV
 5YhFcY8gS1ElPReEOHOZm5rpq68OjSJ1I+vj8ssZXSLLiGSy+AsVery+AlDehfAqW+wW
 3usr1bNMVWCV6gI1mj7CQ/w+87cJhQ4xYP1TfjldvV32qLs7ih7SZ8JUvIYt/2LFPVzm
 PrkvlX4Zl6sR3EBrEYEpKu1xSxXAd1wYVzu2IGttUs/AJi1HVgtfwZNbTXnpokZeX94+ kQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30mhq5r2h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 08:42:58 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 5B03B100034;
        Mon, 27 Apr 2020 08:42:55 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag7node2.st.com [10.75.127.20])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 0E63021F679;
        Mon, 27 Apr 2020 08:42:55 +0200 (CEST)
Received: from localhost (10.75.127.44) by SFHDAG7NODE2.st.com (10.75.127.20)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Apr 2020 08:42:54
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 0/3] crypto: stm32/hash: Defer probe management
Date:   Mon, 27 Apr 2020 08:42:23 +0200
Message-ID: <20200427064226.6991-1-lionel.debieve@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG8NODE2.st.com (10.75.127.23) To SFHDAG7NODE2.st.com
 (10.75.127.20)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_03:2020-04-24,2020-04-27 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These patches manage properly the defer probe for STM32 Hash driver.
It allows the driver to be probed later if clock, reset or dma return
a defer error.
It also removes the error print messages in such cases.

Etienne Carriere (2):
  crypto: stm32/hash - defer probe for reset controller
  crypto: stm32/hash - defer probe for dma device

Lionel Debieve (1):
  crypto: stm32/hash - don't print error on probe deferral

 drivers/crypto/stm32/stm32-hash.c | 38 ++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 11 deletions(-)

-- 
2.17.1

