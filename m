Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AFAC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8253222D2C
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="jx77oLku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHGQWA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:00 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgHGQV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:21:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mouT2c/u1+DBJKizOBD5TQZvVpExZTTcNpdMnz/DyMRLCJMWPOLJNRXhG0NhT4LiVsQv6cch2wXZr2QxVT/yAUDu6/HkwZENkRKUserg3WwiC65Gf6bIm9qmeu3PLbZ6ZKBzJ/WyldJ3V8fZgvsdGgrkzVe0wvsXtig2ych6nMWk/87kx72JB67YgenhrVzAfUKXcvnKw4QJL53Za0Uq+AFAto3xewZ+atThiVs8A7pPwJhwXiCTTGpTg0FHalNSkrpNbKUhMwwfnbwL9P9P0CQSkjVl+8TWcYHBPtmfR6rHBnfkmQZVW3teDDeFrrXuBsRheItnVM+2yVzi29UQxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOsgevlBUBBEz/eyig9c+f8iUh8LaYgPHgmviFsTopA=;
 b=GQVZ1F235EiAIhkgbsKOZ/o+IAG8BBYVbKfLCgUma0IcKXMvkTyz4cR6pi/qCDML0pRj6GK9Y46uGCWYLjVhpG8+dDgAw8pahylXz/SQY3QKekpN3oPXpbNG2B7xxbbKcNYIAoZXCpQ51o0CbpPseRoE76YNoOeaOS4NsYtvaALm/ODJH6TNwbKQCrxZrIoJmBYxrC/9qgcuKYqQtcklbXcus7ZX4e6Bo1jYyCB4VSiMz2q4FKxDDMPyEIUgQ202oLETZWB0n6Pn79Vm0kJxJlSUQ92vxshSJ9wWGoRoqd1DsXAWeZW/QQZKDSnqTk4wIgh1TbYJZdunn3odHQ0tKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOsgevlBUBBEz/eyig9c+f8iUh8LaYgPHgmviFsTopA=;
 b=jx77oLkuH7NJl8eqRmB4U/hjfz/9Z3qv8/vgGCgnGLlCuMyKBjQjgn0yJVZtKlvnM1yLsIcnMQ+s+RtDKjzropnC1rNJvB4Ih7whfJ1djRKuzMi0r/uN8YdezQwZJWyoZm16cIDLr5mkpOZbgvhuVVjsgLV0ap34rH1WIuD/AVE=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:48 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:48 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 05/22] crypto: powerpc/aes-spe - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:53 +0300
Message-Id: <20200807162010.18979-6-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0a2904b-c726-48b8-9361-08d83aedfc29
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73594315CFF915A6ADD48C55B4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlMo3UkERYXaNTRbHivDoBTwPH2QHtZ7DPiFvk3FsRAWLh4olJS+ji9JgECPxsiD11bRJe2wGeU2VKcaP+TbbG/EZ/n713cVOTy1g6iSb5UqRRZ+Ij387Hn17bc2PD/qQTTvo7RYUDqSQcyr6pRKQvv1vzzGvSHYyvZn4Leuq2Sk86auB9j4nN38GyX+5z9DakNuvkaQ3UORdHV+StQvDZe2Pvloh8JvYpXxEjwUnew65U3ykop5R15MXFWm2DpM5vgokgcDrEnE6B4CRv6227rGtelcKAybNUYVWlEygZXOh2uF8irDccBo+OeaxI2/cXI7OHYdglpzrF7PN1BMLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 80uQ+mR8lo2leMv25PYS5ntfEGVoPyFwoHUYixix5va1WNCMacazOP/oLi0GOdc5OvAyh7n+evnfZySeeui3U27gAdNCkAYKTnSTP3wKclOcM85BQ4p0ghjjA9hDobwqYxIoxAWK3rlH4pSjkoYYQ8IUwrz4+JgTh9cH33Wo0dpSCmEcWVTgCOk+yCkJTtXMcuAb6FB7bHqld7IgP2ij993rvSh/+IzrNKa0X7KjNS8i+5wBmOSTsH+Yr/b1kfwnCob/2feZnuZuemwGvsPHrkRyD8YFDI1tnBbUfl+4Ludaznp0FRgfNfAu7x+llofMIwife3RWkHMdLMcUY1XKfeHDGOfgH3mg7G952MC/U7g4CMRqAL7BZJZ4sHP4ouFbjhbTzV7v/yF31XHTXuHUuv0jyivC5lOszeD6eBV0vwkH9GEPwf64+fPHAj5GvvXhqkigPN7qdsL9tS9+WLuSGkbd7BefI/iAlKqPj8B/ie6iWIPqvkjg6/bXn6Vyu8UDvUHJQ56pU65K27V7OaK6SzhJdO2ktxptqUGHieBqDSEyRfpDsOarMTKRWQHjmXi1wpF0V7awBD5nR6Diy1FOT4kUY0dCdF/1bK9Pq0O44NNdNGZwmWuG08ttx3TJEGBDWn4M+Pbi/tKBlpKn/46LqA==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a2904b-c726-48b8-9361-08d83aedfc29
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:48.7117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWHxSCJHobGip8nPC0v3p21ehJjwuTt23qqmeX0HUXHPpJzfyhLcYIs6M/hgIzqJgpG5ODKSmBV457M3B56+rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 arch/powerpc/crypto/aes-spe-glue.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index c2b23b69d7b1..f37d8bef322b 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -327,6 +327,9 @@ static int ppc_xts_encrypt(struct skcipher_request *req)
 	u8 b[2][AES_BLOCK_SIZE];
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
@@ -366,6 +369,9 @@ static int ppc_xts_decrypt(struct skcipher_request *req)
 	le128 twk;
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
-- 
2.17.1

