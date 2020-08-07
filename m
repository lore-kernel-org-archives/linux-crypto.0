Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEC6C433E1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3688121744
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="EVCVRKrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHGQW0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:26 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbgHGQWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3RGTk09ygxSQ80DGG+dOz0w/SsPCuRYWB0FuDWDm+UBkQyx/ldJT+NdwTd7JMdqUnY+SEP9IQ6lItMEULEHH0GyFNK2kXre7umfNrXHkWHurozcGi2UjBQPPOSpbtIRoVVJ7Z6rX1+l6V5lUE1OxryeIhacBtf2OdMpC5SSSAl/lu8id2aMNqGjLtJM2/FGqtzPiYsl7aAqe6oqmSsQrt0NCaILYl/NSO1Ybj7gW/dOdvgHK5V4eeyQhuyMwoRwNhfUb9AeCY/rKcOzTkXefq86IatU3Kcfqcy7WmpXkay1N1FrjQeUQxp/TiM8jBTzB1B/V882Szuzk3AHBA55Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGAI0FSQtGa1W7wr/8FAWW6f2InP4ATUurXANDcHZzg=;
 b=npzLdQx+g9LU/KxB/FnKWjVLQLKgbRSW/S2zkzyreH7I6HbE3H+ef+PkYJZdUECixTL1J7MyJGLbJ9kiaS71sG2fLsaLwmfelngqSX7ZvIUq56YCVUpzSj/tS4VF3UOL6ZuvN42PzNrWvbC/Bb1ijsBufVHe5NQ40ZFMQD0mp3QgTtG9P/sQAVk1BQaRf4JoaSaDodG4ezrI311c1kkbReFMBDeP+Z+pel8VCa8E+ZAF0g7AVkfS7uV4Khu84yEJ+b6Xsc/Mt7l9T6eYroO9I00OmAw8wtT+D9rUS3/+W6+kXygyHuyRM9KiS4O9f+VostQVzAoGaS+qwZ06IkniSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGAI0FSQtGa1W7wr/8FAWW6f2InP4ATUurXANDcHZzg=;
 b=EVCVRKrbTVRKFIfjpBj3+RSxR2eSTJQZ+QOyx85Qw4/VH14v0H7nqkSd9Xm3wdFBcBxjixJs+KyOUOXUqWD7c+7mwmYiUGZTMS33b3ow+CnwcS87kJopzkO4NluGhChnSbuG2r17VTDK5TBTRa0vQbDo351PRFcP0Re1o+a8guI=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:00 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:00 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Subject: [PATCH 10/22] crypto: atmel-aes - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:58 +0300
Message-Id: <20200807162010.18979-11-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5371cd09-9f38-4e3d-71f1-08d83aee0317
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73590A1C90F70C0628A19904B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dy3Zhf4iD69DWnLN4d/OC7L53Vl5faPTIvVzC82or9Wmhst9C2xWU7uGqAwk5TS1m1kMbnEmpM8jvb2wUs7f+uRAzozHRVJGfNVQtSP0Ch0vt+Nt1lCRAKbPqKsWGPPZHOdfeYMePJ8yAf0mwKbpwgv5Rhtek2Fo+dmFZVfzsFKd5HO3x/vIfNwB8lbuj5AvmUBRTNo1dxryj8kIhRANHPu3fYa7/hS6g8uhcQFwULO+AUXSHs6E/0va0mEi22EUWC0egBLJGL9acByJcuUUxhXTY8DX6sEQpYL4ERBFvJuKw6D6V7dp+am5dVrE1Ymb5HN6zqHNzm2UWOfiFm/hww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ppMcg92PuluV6w7lwFcacI3tLpRbDdiRaomFZV/EYzg5y6t/ck51G2oGpJHIOTNsMRkgUkkoemOOGQoTlqgGLazRVCheBLsHPmPOB9KfhPEh9Q5ApeUA+uM78XYJGiFNPduHtGJSndd7B6D+qhZaOTPwSmuW4MEMWWr3TtNqENZVCgRplfjHzxsMhRUdovV+9Hyblr3HwL7IrqXlgFRC38Luk+dYX6+GiRiG/r5delHT/7egAvPGUH2ClIoxm7eGzb3Qs7Tmdn8jWRZdHOfu+DPZQe/vlGgWy2Kux3QqxLI2MHvycqo5Cw0NggRT1AxsVi58rTPqFgb+rrjBDQG4K+d9kuqupllA26d6R2sBgX8IsvRR2NmqBW6HVqVp4675spAxA+spGhx++z0hqwJ8g8msLqHajqCoxhUnRB8AaWsgmzjJs4UzApaqAJqdC71wLyRlYAMM2rMJgV9gL8vizQSF4Y4e55lv2CATMWVo0Z+dd123Te2FND5JeZH4yYIaPHtbNhJatrqm0F8ivHnht6JdV9VZK/9TTu9JK4w6tlaTRz/9kRZ9wJR4Py6KYElXKtrRRxZisXnPfQkhunGhqSPmhZJ4BYpUorpNGC8CgqQgKDymmvixgibkPpEdx/NR2wfMtP4kZpJKcbRtmYENaQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5371cd09-9f38-4e3d-71f1-08d83aee0317
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:00.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w66WcXabl6hxYafvlXj5ULkyPevq00owFCnj8B467gsTVEuqqJ/I5lF1apL1zQR6bWDhWuXtE0X2qPE+wdkozQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/atmel-aes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index a6e14491e080..af789ac73478 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1107,6 +1107,10 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 		ctx->block_size = CFB64_BLOCK_SIZE;
 		break;
 
+	case AES_FLAGS_XTS:
+		if (!req->cryptlen)
+			return 0;
+
 	default:
 		ctx->block_size = AES_BLOCK_SIZE;
 		break;
-- 
2.17.1

