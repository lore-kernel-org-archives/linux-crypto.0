Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F13C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jul 2022 07:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGBHOp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jul 2022 03:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiGBHOo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jul 2022 03:14:44 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948BA19017
        for <linux-crypto@vger.kernel.org>; Sat,  2 Jul 2022 00:14:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2626lSts001704;
        Sat, 2 Jul 2022 00:14:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=V6Z/MZ447naQiEttg1Nfx03E8o9HlePZIKzInzO1To8=;
 b=e9CDMdKB7EJnW0tFASRvc9obe9RYFWzFJf1ZKO9lxs6bPN431SBEEW8K1RMtnXtln1wJ
 WFauK0iPCwB1+3SarQWMj382r4kp1T1KCR0pic3yQRXkCbLu/a4+XQgmdTR5Q2sugPb1
 Mmf+XMiDNSqhkzmdhfQam9akLDQlXKdCe3Q+dpneZweMiys+pnxTCmUuYNh6xrFBx07Q
 PlNUzKKBJWbqLZk4tvfrWBJ/+gusBcK+QNBVJlfzn+JRD+f7C7Hoh90R+7Nc+BmbY6sY
 wEAbTyP4DAn7GKsasSHhfLmZc2TvQT5baLELqznk7pdUsrJJYCM1U2m/IQ12PBz8BLxl 3Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h17nq8gqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 02 Jul 2022 00:14:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 2 Jul
 2022 00:14:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sat, 2 Jul 2022 00:14:28 -0700
Received: from pingu.marvell.com (unknown [10.5.24.1])
        by maili.marvell.com (Postfix) with ESMTP id B13D23F7084;
        Sat,  2 Jul 2022 00:14:27 -0700 (PDT)
From:   <oferh@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <atenart@kernel.org>
Subject: [PATCH] crypto: inside-secure: fix packed bit-field result descriptor
Date:   Sat, 2 Jul 2022 10:14:26 +0300
Message-ID: <20220702071426.1915429-1-oferh@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: CTyBl0kVQGj1tM0zXcKDzUJwRRTnQ__2
X-Proofpoint-ORIG-GUID: CTyBl0kVQGj1tM0zXcKDzUJwRRTnQ__2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-02_05,2022-06-28_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ofer Heifetz <oferh@marvell.com>

When mixing bit-field and none bit-filed in packed struct the
none bit-field starts at a distinct memory location, thus adding
an additional byte to the overall structure which is used in
memory zero-ing and other configuration calculations.

Fix this by removing the none bit-field that has a following
bit-field.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
---
 drivers/crypto/inside-secure/safexcel.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index ce1e611a163e..797ff91512e0 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -497,15 +497,15 @@ struct result_data_desc {
 	u32 packet_length:17;
 	u32 error_code:15;
 
-	u8 bypass_length:4;
-	u8 e15:1;
-	u16 rsvd0;
-	u8 hash_bytes:1;
-	u8 hash_length:6;
-	u8 generic_bytes:1;
-	u8 checksum:1;
-	u8 next_header:1;
-	u8 length:1;
+	u32 bypass_length:4;
+	u32 e15:1;
+	u32 rsvd0:16;
+	u32 hash_bytes:1;
+	u32 hash_length:6;
+	u32 generic_bytes:1;
+	u32 checksum:1;
+	u32 next_header:1;
+	u32 length:1;
 
 	u16 application_id;
 	u16 rsvd1;
-- 
2.25.1

