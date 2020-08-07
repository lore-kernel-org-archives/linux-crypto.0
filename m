Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA501C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 854EA21744
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="MvyMCRnl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgHGQVp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:21:45 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbgHGQVn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:21:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gg/i1CQ5kjyQ5Or1+Zay3AmsZnMD55UWypqe6QaLPscTX3Qk750PlqjpxA0qUMdNzqWx67jQmZ/hbUxnfOMPNbdSvpqvk2ItXbNEMQVBgjWWS1wWL/4mAZ0fQfbqajbMLjLrMRf7CwNfn7Fq1oqSojHVVkwagOqOfyrAfxANRQRtzIWNNRhkBMmA+8MpGDGehWYU9WphBxf1H0efz9hIeKmkKxQecRSuofhsXaJCAxOmjAk4iSt2We2B7sRG26MEz2EbZkY9gvApPaoTpMfhVxCSY0CrLErVAbWbUMP0b+OpraSnFwNxTVuf8SUVxZykLWYL3mIgcaw2caaN9ssNcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPYv2itGQcwrWyNwsRoUTLKkbMT1wg5R2IXe3MyBWv8=;
 b=jMn1yAQBi66+f0j34wrBqwOaxX0ao6vmpB6BUl4LgW0r/i9psuct5tOA+zAdrD1y3f/8+o2SvcC+88HCyAwRQs6kh3teNyt6Vmt66bIa7xhjPS+0Y0nrbEMMQ1BoAs+BNYKbLueaCT1onm+s32/oNA7CHgZcPSbkcmAiJdlQcLFuC46Da90ah+13j3xSeFGPJ8WKx6FSViNXrnYhdI7ooQR17S+ZvBs0hS1SXlqQ4fQpvykhZPTWDYIOOk6dEh0Hm0LHbqZJTZaHfjRg7xXHyiD8tSnLITXWQk5DNMkM6byJiE99wiHXelrF8zP6hu3xfwLTSuV5ZLA3dr/KNzwgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPYv2itGQcwrWyNwsRoUTLKkbMT1wg5R2IXe3MyBWv8=;
 b=MvyMCRnlc70HAU5RLwJ8qe3LZzra/0l/CVqqmo3S/fqRLXkZ1OQKIVoRjcDxyA/WYu6tvcP4RP61G2+NLAorOVBXRze4pnU/T+CPqtycInc030lnS6BHtonwIPIGI/WuYI8DF4R900AqWlC2xpgTkwGdRGq1pXoVrZCqHG/W47g=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:39 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:39 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 01/22] crypto: arm/aes-ce - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:49 +0300
Message-Id: <20200807162010.18979-2-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52d27dcb-7553-4d1b-c25f-08d83aedf69a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7359AEA7C3B697F3C9E8D661B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7826N4gn8oUxpE+6mblzB6xT1VKKyGvJhIknb/XgfNUr9TrICKw8gWjxbm96XqAkJMK62iG3ehJxpsII3Nq2yiJiOyakvRiKOM9AO/vjyZ3UiN4VYCVuKp3mWHcTSWtyDQihDUpke3xzPk1LmPXtXgM26vv8McKfd5jun9rOeqlEpapSMhbBoaJrUzuih1+zJ5/uQAM3xxQE3BgUxD+HbTTQu6nNNxZ0TNYZKo5TsBExRNTbhuxIoKbuvSaFtin5DbrO7Jb47K1sS6t3UXS7Kl65a2l/15AhjOlTLXQAw3Ca/cNUTKnOAc+4jKxBq5SMUO2tMCPyPBJTH+ew2jhZ0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /TNIYmfFIgyhtULMYTgFAsGfScfkFq7YD0b+JNnaQSdr+5blOz2mRjm3NND7/tZ5FjoGu83/8B/DQi86HVOGb1wt8VZ0R9ljdmWX8JQXnwWNADhFRGGIi1qiz1S6ot/WrbIMTpa1UlMP+bk68oLmjFmKf+CMmEdwrUkLWyC1W6dFjuzaIfuCRlMei3wZHUE18Tlr4KWXe/Z2VpjyIRJ8x+VIBKzbD4WHTvF5oyzZe1EyCRL7SehC1cULdyyQ+udfoIg2kclsgj+OIh2aT852m+RvLHbnz9I5DquD8PBdoW6Tng2fLbSdhJRVAmXd0RD0lMifEjZoAaH9YlnSYnjCAlBRWTACGDTj0LZXSU91IGcmeyZGNckdgxB1x8xQLMdaQoPngl8IiYaO3tMSi21Ein4Au9nlFCQpuvN/mpHJOFppmfjY80vfJaNP6tJEq7fMkspzABPryxvnZevvjGmGFQ4/mH84geZjVAjG6aiOQJ8GPcaWpYFwVE6JNYiR1c6PubkfIjZq+63n6K6M5Q81eG1bawclZmWiPGkHhYK72yK9ummsAKT5kUl2yooQKrNxQ4xMu8wW/kN7OUcJE/LbpLPKEacjfxhjAaB665TQLi79PozzStocrPkvkdbKNnDKff8MkAa9e3RwsGYk5nDxYQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d27dcb-7553-4d1b-c25f-08d83aedf69a
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:39.4441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HcmITPa+uegEfalX5ZDVKgdRcXHxD872TJKI65R2puY8uuaCk78SWqGstYoEGa/YSzGXHiM8lvnr3kZj/KD0QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 arch/arm/crypto/aes-ce-glue.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index b668c97663ec..57a9cf7fe98a 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -452,6 +452,9 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
@@ -524,6 +527,9 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
-- 
2.17.1

