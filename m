Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9B7C433E1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E2222CF6
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="NUZOsrO4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgHGQWF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:05 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgHGQWA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9uDsvtZFmHf3sotPRdQTAYXr0uYiZSTWK4qSK/gTloBuOTpETZfcgti+tb8RQH1icI6w/fM5Deu3vSLaddkmZc4k73BZyJViF0YJacD9DTLuay5B+/++9ukkRlAe7RWcpmVB8TbTxr8JBPTm7kSndf5m/eySDqqbA+rwZxAvrvmVio3ar+KvElqL6sbJj4/20G7Qy4koV2TOq6nwXXfAuOX4od3YH1NHj3iqLNqIb4xAO7u4yuGqO2i3PXWsk3mSJzGRM5S9nTCK0s/rHZZjCrqBlUB/RAAlSOaG6YqIKnDNVhQj5I1yEZ5j4knm4siEPcLIz190XCYXt0cOuwC7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9hlijDnz8pnw2mzudwtNwqJgqpFIk4v3HEQ3z7pw40=;
 b=OJO8TLXIR8S/+EkvMzxz4KqDyyc3dJXuO53sTNfa9d3PSUF6pjDzk8/pYKXk45FzhrX4T4tJAUCApTVQPsteig8UaY2PtECi1/6hd0z4nsxpazaZIkVnS6zspHF7RzDnX0retT/6LYoK6Hp5GTLdXVItU4VC0qj6Z7TbhZZ4CDKXVuSvNmq3JQe5g2HM7Tx1QZKopFjTcUaRzqcQObtnpVxQi2frqCSXKXn085csKMlc6TwdNuEcxDeFBokJzBIybpJcJZV0ykQ8bCdbZlCyR3G1V5+B3dnHRnKg4TAS3kQmukR7LgcWpNPPSBuNdzmokIninRPbtTdVsBXhPlAIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9hlijDnz8pnw2mzudwtNwqJgqpFIk4v3HEQ3z7pw40=;
 b=NUZOsrO4/KzSWiOgnFFMz5qXnYIw0zmVztwQ5mUjM8qHn5bFnOWB1Eog1vEoyTA/SYJiZm6gBN9NlgTRXZzfKa2TSHn4vSH3zpkNa7Gx7SbhnSdumfC8BoWzfGx/cZ1QZsjQx9GKzvYIBRT0r+SwA7rED/XAlQH70i/+TEOgavk=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:51 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:51 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 06/22] crypto: s390/aes - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:54 +0300
Message-Id: <20200807162010.18979-7-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cfe6a72a-e408-4c51-8bc5-08d83aedfd80
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB735919F4F00224DC3A421D54B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/PCkoMd0af76YS7jWZejJkp33gEgXWqNkYIQWVO8VUQxzq+1fXEC6OB6jt9YTvowgHnv7fGTvKAr6gSbBexQfYcm6P5e3NUQhWzVUBccJ583WJo1Rr2vjJxfLj7uZLrfh9+PipT67fkWRTGkRr1Hc9K9Cg90epzfoJKEmol34FqbEd0GNoe6XyHFU9f5BIsvv3zeW59aAOSd5Wm7aHY/rfoL9A5ZrjLN/+cf2Fd1UZTSvOX1iMCgOBHvz6V8uCYZDxH4BDyFydOLE+RnVbjlKIR19+yMEpwAYvi0EwlhmXQREwBxwsqp0v70y0uTlHrgWmxDjtNBKdIGcESI8WOkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(4744005)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nUbB9ZnKEY5sR6dWoiCeS03naqTgOjkQnnarNXA3gbv8Fz6EfcB2ysU/DkIJAjBuhu3IF6Hq94Bw+BefrtjAvDjv1HzHtW9dQOfF22BIEJtdJgxAgIrE1xxrEsOyam8K6X2dYGf+JI55Bp9fZnrmI1JDRhXGZrFWDK33HHq0z8auub+xCXGVi6/gHeOG84RbaE5RDF8+yhaahQ8eKggMoKzT3YpHJ20+vJMfnT+xIc+mXE47cAJ/Rc7zPQhlgJkBVuWvCAt3QrzTAh3yoh03nj1AQmzW6bQlaGkS6I8i6LvAWjJyyB/gZFuWYZwfm8U3dacNA8TVQtpvumpo/w5PjhZ6wTBxLBqgtZLpKXQmI82e/VtmUlHiE4NuFexY1zezevEmTZy3A/SD3dyqnfvAsVUOx709mB81GKpqlUaTfUP/n/g0IRVh3iCF9ii31oO/UIlNpNG2+Xg6VUb07hGnBChdkk8jO3L/sIFUAbgOTE88ErkZbFeq4fOuYFcjo4lO3CWMZfI6bGU9rcioB1oBumOxN3FDhi6YnSMZmb0a89aFRUiiX1GuZBAQG3ECahq1E/TRFTpvaurlhoUXomSqHxduAKkR1ltEwNuXlDCXpztMK3M8XP8pQeK3NZdktA4ATP65kOzv7/Bf07EJ6xKprw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe6a72a-e408-4c51-8bc5-08d83aedfd80
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:51.0014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBmdYFxa54fj5jfShT5KzqId889iqWDSIlEUKYwxlF/yRX60pXnFSKaheR1hxY6XwbCmSGxDGAnkAaBgGIaU7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 arch/s390/crypto/aes_s390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 73044634d342..bc8855f4b7d1 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -437,6 +437,9 @@ static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		u8 init[16];
 	} xts_param;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
-- 
2.17.1

