Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81C2C433E1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F6222CA1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="LhrBDwX5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgHGQXA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:23:00 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:64918
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbgHGQWd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4ALIdoQm4CTK5iSbXqPQ0xCdH7ZxtRFo2d9ZE5wURi1sOlSe7wscvMV4AH7U/yIINkxvx39Dl1Dc3hE2/rXiO9jqitQGY7poElkrt7jqB90h9erMi47KJcJKQAdfEhmha7hhEJKofMcc7nt4BjoTcCCMrpy5XB5JcSZha/f2QLsykIn3NhyWrUFwBH/O6LaAImLisDgrXh3rMnwgkQa8CnwzVLoTiMzBbAr1SgG1ewxofFfPH9aAuNjexHeb0MdTN4wirHIBIcJHT9EIs7yARN8UWygSYAMIO6128TJCbw9C7BgRuemYPvgYrNN9H6Ffnhz04VA6ndxOGWnTC4cAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OywlflLaTp9YE+9gBdrpahq7EstoKZVbIkvjWl/hGg=;
 b=E7jin5ow6AZR+e+190n+prudjwpscgJKe9uIh5OUs+9cXZTEYUC8GDjZKESq47QtBvgQ5s5xQx5cARJ3H+ZTrlexNQLimdI4vUiltecc4wrdOJ4mjhxEAzS67G75CE5db/ypXpc3veTdHkBnJkQmnK7P/9/Syn7xnaKdDUTCIlCTGTwS7VfRM3eEFEApT0h16hGeicB5R5Fx83NTC04So2XtRRS84+2p8Fxm1Fqk8SazqvwZG2yYvyyrszT6YUIa6Hw4oCZVXpr6n0y1jOfb8x7WeeQlh8D5i9nUAo/pQCmuUTaDoYImJIRMOQi3z8W/vix/k2dypCl8IItYJ0M4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OywlflLaTp9YE+9gBdrpahq7EstoKZVbIkvjWl/hGg=;
 b=LhrBDwX5RpQfoz28eG01vZsT2256QwnbUl1nat+KsFDTHON4nXjTybObLk5T0OXGEY+gvww9cZo3VI2pYWFuSlxqL6zAZu4jpoLWqhXq8LF8Gm5deNGBYM8fHGHIxJV+jHcNID0LCHvxMpGOaQKwr4V1oITP5wG75GyKJdJUbyg=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:23 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:23 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>
Subject: [PATCH 21/22] crypto: qce - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:20:09 +0300
Message-Id: <20200807162010.18979-22-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:22:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ea583b0-22ff-43cf-0f56-08d83aee110a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7359633CCBA32B2B27A72F5CB4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +CooaNppBbKgOcXG+DP8tuCn8Eo+SVunIxoYwi4PYcJ6ySOHzicFc1yUA1tMPRfCS0J/hGhOCpYv9lerXrBCzd087xFqrGU4lxHnqW1I3zH111NXaz3RLFNTjTTxL2H3ns6kniW6MUl1qSJ4M4TfRvtnlXp/tePlR4jgIbXFN4/xZAFByT6EGDDzoJLZ8w50PsMx864ECby/+Faha1X5STP19Cb7DHTiyeVh0d6Z11bBM/erRJgLUjV+eWsMk5NwGiUdE3QYzltl0w2LSsHuVNKet0CtYvh3DtD9TyKyI6TfPAVqkbe7+boDo7WWuxs/jmiyDVXcAjfZTakBGP8dXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WiNBNO3jcD1IBNEu077iHhe7Un1WBkR3knNyivjOrWw9ahbPMBCDi9o4MCO8MadIfwZ6y5Wq0m6/h9ISBou6seaCdRvaw+fhSYQjQmAc9X7ThfjWNq4hC1cmMKimM32Abo6Oh0ri1GTedSbCZG6oHGqM/fzHw4zwkLUT7fFis7uOf+zBDlwaxv7srMw65GenH6fwTRLEgRGudX4dLVg1gY+j6Ys4KkX96INdzP47YAJZUXcdtX8yEXknJwWLfKK7e5gR5k2th9htrU2EgOQ/wxivz9IBYRUUbC4+kphsnxQfBnThNmPia9AgW2Jhakj8gfWDrsetU6TmLhfJbZQQ8uY1F/Ujb1ZIItFBaWNOWX+00BcVl7zlSMfWNO+DtJBDb9JYb9B6GHikaO23bRTds8hdQP+KltasEhd0PpwCn+cdFWqH8qRwNL3s8PY1DSfVUY7fC2vWP22bzCWpk5IDrbHh1zKqAFt4Za+ubYkFJ/mylknh87E9JMSTObHu4ahHB5TLow1wQ/JdZhM5xKsMXbn9nZqonOh6e9+G5Lg3vCY/tgW72y/qM1/DMcUMxb9rLOQMb4S/oN5VKYDVV1DejQhkfRytTjAiu8HTEVIvQxz3vkQN2vlUtzUfB+6UbGTzLNV88L5Ot1O+oDRrPd8Zcg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea583b0-22ff-43cf-0f56-08d83aee110a
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:23.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzbEyMeJc9jq8uZhfidfFMzQYV7+UYnnaCtmXGOKFs/lJZGmuOZmghAY0p0O2iwvMSWX3yW/BdYNyVgr93/XJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 5630c5addd28..887fd4dc9b43 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -223,6 +223,9 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	int keylen;
 	int ret;
 
+	if (!req->cryptlen && IS_XTS(rctx->flags))
+		return 0;
+
 	rctx->flags = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
-- 
2.17.1

