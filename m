Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F975C3F2D1
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8E6246B9
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cnZAWY1p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgCBIQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:16:55 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:41195
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726674AbgCBIQz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHf75m/hdOT+nOoY9y+mtTMDhfIIODD2VqNad+Fb8ZhpTrGPwMX9L9nVTZFjz9xQwbV5xhqu2pYEUORhZHtbusbYe5nQYCEDw2UuIeLAT5+w7JMYEYl0cW+haXDF9PRzSyDBMnuC6bi8hC0Dj61FquPv9wI9eemr0eqd33uIfb/Sh+XVSDuTyM9ROZhagPBxKaWPwuESHempO4/a5i4Xdm8A4RTCwEfXev0S43CyQTqpmf5u3dUn7bLmf5dsy6Nu3m/2ccpPyUt4f8jUDA6F7jJ4Izjd+uuY3HpSmOnQr68pafcReagaFw5kIoEu6lX4eoHR63AXYZoOxphAcxYR5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXpvb8NL8AR/keyslRQVJFUQhjkTvzvkAAGG/Lws8xw=;
 b=C/muIpZkcXAe5tN9+W4dnIGbc8vY4/GGg3H6psgKmaw2eAVL/gLotDAmYpwUQiFA9O92vsEsC0OiRnqupxAAqlDGA6Znw0jdhudsenZhdcRx0q2b5+ufGNkTu/mdleEzXfWThxTagGbarLFb3n1PNUFuAAcHoCju/t6UDESBRJmtoJDB8mSuUPi+tv8rRKg10YuKCnF2xRQNSRlNb2jGsmSWxGg+tU7qTAw9UmCzUdlMJdEonzC7j+d/xiEZp3MdAqks7am8k71OpkOaPq7v/85vm205VfRv6ZAaP6NZaQPmMj1vE7BMDfldXNWfFRn3K6R4iDOsAR6Ar8dZ8NYOOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXpvb8NL8AR/keyslRQVJFUQhjkTvzvkAAGG/Lws8xw=;
 b=cnZAWY1pOTsUd7JVzQwMMNWTbfotrDETaUd5k9Hba6l+5QoaTZNjv6DUHrKyAjBt6cx4E2Naa88I7YqmKWXKj1IZDR30HyLnlaPBohl5Cricn/qLck6Qb36PkTdBvaOdCX7q2v/fP1wHTCyq6A6gEPsBmoJSJEMwlc9qIEYEBXg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=andrei.botila@oss.nxp.com; 
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com (20.178.92.210) by
 AM6PR04MB6328.eurprd04.prod.outlook.com (20.179.5.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.16; Mon, 2 Mar 2020 08:16:48 +0000
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e]) by AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e%3]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 08:16:48 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] crypto: xts - limit accepted key length
Date:   Mon,  2 Mar 2020 10:16:29 +0200
Message-Id: <20200302081629.17831-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0066.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::43) To AM6PR04MB5430.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (212.146.100.6) by AM0PR02CA0066.eurprd02.prod.outlook.com (2603:10a6:208:d2::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 08:16:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e288297-fe12-49c1-fab0-08d7be820de4
X-MS-TrafficTypeDiagnostic: AM6PR04MB6328:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB6328A6E25AB4DF1FDF7F60EDB4E70@AM6PR04MB6328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(81166006)(8936002)(6486002)(44832011)(6506007)(52116002)(81156014)(8676002)(1076003)(16526019)(2616005)(110136005)(186003)(316002)(956004)(26005)(5660300002)(2906002)(86362001)(66476007)(66946007)(66556008)(4326008)(6666004)(478600001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB6328;H:AM6PR04MB5430.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7TIO/NXWTOO9fA5z+i/huxAbfNlYm71F1jaMvmHCq3QzP0fqu0gybYnjq0h4YIeAvbLAqIaiqpNS3h4WNMCE5aS2puczkjtRAuaBsDOtBQWdiCVIpJ3DLfgsfdjyeSCYHLqXXuQq/0+9MrbFJP69GmhE+VqkGpzCUkCdVlQPgaBct7eLwD3x3dakynxQJQMTaEC7dFHUhgOTkOFVS+9/eP652+VzzBD8hD8DlJNoFSLc7/y0LNJFr5C9dG1xWFvSdzgklKjWKSjKOfy+VEougm2TmcSWRC8ucJqaEYejMD5a7MTfnFysAGTpviMxhUQY8+EG17ZdyGUmAQ2OkBQdlzmAL/0ebrnFTfVJf+r6ponjg1pankxxluAFvsIhuF+kQt0AMwHVQoc8fpszhzX9+JBoe5ET90Pt4R4U5XYC4ud42uWeTqUIxFcUQtcdTvFw
X-MS-Exchange-AntiSpam-MessageData: 0vfrcNSixwLH3UECtre4DShik5ACP8jHc223z+dUJLNBlC2Ha6XRk/11+UD9kpNks4TP1zGktw+VjsWE45kWaXP+3UMED46YGxGvardLCyHtYAM/VtSGsZndgRmJ5SM9B3IYhv+vmMqf3jayLv+00Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e288297-fe12-49c1-fab0-08d7be820de4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 08:16:48.6829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSdSv9BwQnHFLjuUBVgT6iTie4SNmehM9GtSaGpFKUpsJ/k+yqXohAtwPKmtXH4xsixKfcrG3+L+RC3Gd2pT5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6328
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Currently in XTS generic implementation the valid key length is
repesented by any length which is even. This is a deviation from
the XTS-AES standard (IEEE 1619-2007) which allows keys equal
to {2 x 16B, 2 x 32B} that correspond to underlying XTS-AES-{128, 256}
algorithm. XTS-AES-192 is not supported as mentioned in commit
b66ad0b7aa92 ("crypto: tcrypt - remove AES-XTS-192 speed tests")) or
any other length beside these two specified.

If this modification is accepted then other ciphers that use XTS mode
will have to be modified (camellia, cast6, serpent, twofish).

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 include/crypto/xts.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 0f8dba69feb4..26e764a5ae46 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -4,6 +4,7 @@
 
 #include <crypto/b128ops.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/aes.h>
 #include <linux/fips.h>
 
 #define XTS_BLOCK_SIZE 16
@@ -12,10 +13,10 @@ static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
 	/*
-	 * key consists of keys of equal size concatenated, therefore
-	 * the length must be even.
+	 * key consists of keys of equal size concatenated, possible
+	 * values are 32 or 64 bytes.
 	 */
-	if (keylen % 2)
+	if (keylen != 2 * AES_MIN_KEY_SIZE && keylen != 2 * AES_MAX_KEY_SIZE)
 		return -EINVAL;
 
 	/* ensure that the AES and tweak key are not identical */
@@ -29,10 +30,10 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
 {
 	/*
-	 * key consists of keys of equal size concatenated, therefore
-	 * the length must be even.
+	 * key consists of keys of equal size concatenated, possible
+	 * values are 32 or 64 bytes.
 	 */
-	if (keylen % 2)
+	if (keylen != 2 * AES_MIN_KEY_SIZE && keylen != 2 * AES_MAX_KEY_SIZE)
 		return -EINVAL;
 
 	/* ensure that the AES and tweak key are not identical */
-- 
2.17.1

