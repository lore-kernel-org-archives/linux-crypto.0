Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E8AC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45FCE2133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="pfCM7MWb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfF1L1Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 07:27:25 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:27578 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfF1L1Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 07:27:25 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SBPqOZ020529;
        Fri, 28 Jun 2019 13:27:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=gTP6fqkfQDGZanlx4ouycdMtZDyDqTFhDA9SvwI/c5k=;
 b=pfCM7MWbb6FtekqDKmEJxtxRuMl5sVREDBBbAUCkXYhErunReAjYqiMpSMvhITzG5L/Z
 eIP+yhhT9zDlSQ3m62Uxh68JS520Mf59RwAa4G//G/S+hREqF1hGjyrGcztZvlBnAj12
 LAsP+fDrggFcBXASrXRPJTlwSGDCzwVExRohoEE6EzGPd8B4pnQQjQ1HJvkLatpNYoRs
 lwsEbMAKPlI23IU9aZehrSBQ/NiGDJ321gvpL9xLd/EL9S4fjkNx2w3zfs/OJ3oyVk/j
 ey5tF80ep/TGpZbOzeLes48gMKHSKYYMr2Xi10RyxnnbNU6mnoZRDLxhTovCPalf3vJb Gw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2tcyq0e4kq-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 28 Jun 2019 13:27:13 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 48DE031;
        Fri, 28 Jun 2019 11:27:13 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 275CF27A5;
        Fri, 28 Jun 2019 11:27:13 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 28 Jun
 2019 13:27:13 +0200
Received: from localhost (10.201.23.65) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 28 Jun 2019 13:27:12
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 0/2] crypto: stm32/hash: Fix bug in hmac mode
Date:   Fri, 28 Jun 2019 13:26:53 +0200
Message-ID: <20190628112655.9341-1-lionel.debieve@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_04:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series fixes issues discovered while using libkcapi library. Some
more tests show wrong key management in hmac mode. It is fixes by these 
patches and prevent a potential issue in case of interrupt while processing
in dma mode.

Lionel Debieve (2):
  crypto: stm32/hash: Fix hmac issue more than 256 bytes
  crypto: stm32/hash: remove interruptible condition for dma

 drivers/crypto/stm32/stm32-hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.17.1

