Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E5CC433ED
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C099611C0
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbhDFCfz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:35:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15911 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbhDFCfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 22:35:55 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FDs6J37KyzkZBj;
        Tue,  6 Apr 2021 10:34:00 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 10:35:35 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <wangzhou1@hisilicon.com>,
        <yumeng18@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ecc: delete a useless function declaration
Date:   Tue, 6 Apr 2021 10:32:59 +0800
Message-ID: <1617676379-18079-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function declaration has been added in 'ecc_curve.h',
delete it in 'crypto/ecc.h'.

Fixes: 4e6602916bc6(crypto: ecdsa - Add support for ECDSA ...)
Signed-off-by: Meng Yu <yumeng18@huawei.com>
---

v1 -> v2: Modify the 'Fixes tag' from '14bb76768275' to '4e6602916bc6 '.

---
 crypto/ecc.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/crypto/ecc.h b/crypto/ecc.h
index 46aa9bc..a006132 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -56,14 +56,6 @@ static inline void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits
 }
 
 /**
- * ecc_get_curve()  - Get a curve given its curve_id
- * @curve_id:  Id of the curve
- *
- * Returns pointer to the curve data, NULL if curve is not available
- */
-const struct ecc_curve *ecc_get_curve(unsigned int curve_id);
-
-/**
  * ecc_is_key_valid() - Validate a given ECDH private key
  *
  * @curve_id:		id representing the curve to use
-- 
2.8.1

