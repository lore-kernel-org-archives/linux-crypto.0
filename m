Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07495C433E3
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63BE21744
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="LXoLMKEX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHGQWP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:15 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:64918
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbgHGQWM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KX7sryQlQO2e1hAbuttsLhTZKmCuz2t0aqYGwnGdNpSC43H+siTaFmqzb8rlks8NgeH+xurFIC0vALRNqDeo9UhFSwLtIsi5jl4kU9pQtjj+duIbRBcdcpL+VMt5EtnMNBMXryhnsORbWqN9w5MGvICfTEPaIvzmUxDLah8bFOn1Xn3FJZ539x1pZGOpF/FCQ4JRd8CVU3sGSlld07lwvxsTQXwzE7HE/wkA9glZcVGEQhdEYcIn4HeKbh85coi4O9owZg9S0J9NXv8u7oAn8yBBUUQFQzoCWe+/2C+vmgS4mI7pLka6z4XFLRVliyItvEzUL688ZoOyz7ytDjJ5Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9jsp/YcTj0VhTgO0wBAaJOiNFq7VMGPAkrV1siP1WA=;
 b=CEkJbcjifxTbMC4bnZUEswB8SZ3BuNqqUK3UNiuVssquDpQOje9O22wSt3I1xYBa5qfyJbp2jEEC4EiGLGt1F90bZsT5/880PlyRpXcUWO5IDbg63ZpyBJ9d2ZXoWMCv8BBMcBfcEFx40oK0uOqlnqrUpdGo0JbSVnaHD8mxUhZOCCkPUEhSklpjWABxhAY62YEPZikEDwCvXknznVdZm40AFwR/5SozHJolRGSHJcKtXg4PbhXxxVDTnzRl/1m1lPTAsHlm1yjNHCQ0vj7g/JT9Gng8vXt4OaG4v2e3nRwlW3Cb44Fr9qsxSDwQsB5LllYrC9NMprLAWeNzGKXpbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9jsp/YcTj0VhTgO0wBAaJOiNFq7VMGPAkrV1siP1WA=;
 b=LXoLMKEXVUc9rsGAChB7B0OYug5HQUupJ47KZ89QRhEwGXmN4LNDYIvBPJkDTlBYyjIDu1DyT34tjMekUMbZvCqSY49sNg+DvytL805gPQccf6q2TU1+PhchRn3i0XMRfMzXU9/qWGrDNriQ5AQwirWMpJMTzySpO9eurIE1zqc=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:58 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:58 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>
Subject: [PATCH 09/22] crypto: xts - add check for block length equal to zero
Date:   Fri,  7 Aug 2020 19:19:57 +0300
Message-Id: <20200807162010.18979-10-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ad53ed7-587f-40a5-45ad-08d83aee01bd
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73594F9175A3E0D172D15333B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rOh5w+s9PqbXc2jcZ1BQLHyncDirxVRD4jdekA7Syfswt/w/ROIwz/cJnzIzH4WUvJiZDv0QulE7Htc5MIKD602XM1VY8VMzU0g80LoPLGYHzt7/7UJVAFxNq5eIR5GcWId6Zb3M58Nca7paq3+lYFbCCFfNxd7vcU9NSI47TynJBU1d1DR7jgluWq3DOFc7pUyZ9H0briBJCZOHMoyzxDevONO8tskb9XLuh+i6ExZN1GEtzW4bQ+14PZZ2detPLy2CqGUuAA6DrTIHkaOiM+uXccbLMucwAWRh69r9e7LJ/iBmTZo+Zm5Tgu6L5rWlbZeVZ+MGCpIscCuREStLzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KaITC/4v2sf7hi3vwd2JC2khaf5a+VUGJVbtTSg1JvE+/UgxSV0teMtOWwpmFdj6PK4SsqmbfsrWQMoGStJCx5ciuBlGCOI6wfJqjVUfxOpYVLa+pXYuzuDrM3Y/R4eMsA80UUPvbMOK3MEb1hMo6Q11G6n65UOZ/bKt0QQLIEnDN6ps/gP8Jrxdyt6hefAddwhcrLnxqJEHIRipw9s0SfBMoLKUnAsXCE2h7KnuLwdddY5aqCDw7kgKaJ6A0D54YrhdzDY9YHfQcUCJzhiQnzW1r7Q3OEhjJwKkFyuc9DyKtg2U4g+T0cbxXUZuphI0RMXRz7dsbcKEYggaj/f6jvio15VSnw1nIV5Z5ay7I1LdmarIb+twu8m7sBVKhc9w4FrPZdcjPwpO9iDl3zx6C9724YEW/Mt664ZnGnYMdP6iuJ2Z4X9oPUlsUffm5bzdBNA4md4EMHFpEDpmJxBq/1zIJcMHKWfnZlkywYSrWvcth3d9N0RQCAA+nMQsEBpP2kXq0wa+kxfNlg7kZsYqXA/fp0xwGOz9cmfMQjUmbTrgU4Z3Xc3P80P1Z2q+p99Zq4dS7vAWHEj18/whPxfTTwHJk/6dW79jHXDLfNCT2XyC2NMPMKBrYv+oVvKD0puy3g5I16KT82UffZZsLWDvCw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad53ed7-587f-40a5-45ad-08d83aee01bd
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:58.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtzUDYpUxJDKeTHPmLQUJkyRjx+dqPhfHgSxMbe+Yb8h5Sh/MODD5fjBLixfwETkmiHrs/8IXe3CM5PEtXreTQ==
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
 crypto/xts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/xts.c b/crypto/xts.c
index 3c3ed02c7663..7df68f52fddc 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -263,6 +263,9 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	err = xts_init_crypt(req, xts_encrypt_done) ?:
 	      xts_xor_tweak_pre(req, true) ?:
 	      crypto_skcipher_encrypt(subreq) ?:
@@ -280,6 +283,9 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	err = xts_init_crypt(req, xts_decrypt_done) ?:
 	      xts_xor_tweak_pre(req, false) ?:
 	      crypto_skcipher_decrypt(subreq) ?:
-- 
2.17.1

