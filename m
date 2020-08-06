Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D6DC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75C5823119
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 16:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="bh3odnxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgHFQq1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgHFQpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:45:44 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-am5eur03on0609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe08::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FE6C002160;
        Thu,  6 Aug 2020 09:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOzo3G5Nutbs/ulohseR341BK8C2yMJ6sgmF1xc7xG3jK+rmMTMUVMdhCYYuYMQ4wBzHjY1yQyvq8VZO541qQBPzdRnszaC/8L9uflQKQz8ccpriYqfnP4toCyBWG7qmjMXvpZRHyR9xh4dahcaZee0SEP/JxCVML7rjxmT6u2uTAlrTE0I61G1pvepXiQAUn/HBOmf5ZizY1k8bdsbgM6l+NQuIT7xzk54JRCQQgWDtBWwaEq2kEC0As7zBWoTmq0aXpZEb3AuXGTZv0vZ7ZsvWUUbUkggR6zYkhDD9SccjMAIoi0g4Qw6kwHU+V+WeZHayx7BNaqJoQ6unCtibkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+k2D6/qcFMdpyoRIaVnXgzL/A/qtdVYBZNVBR/cfX0=;
 b=JpF0n5G+BMsTu2izhS0fRHu/brIN/Q3jujPzwPCLs9dx0p5nsYq6GzQsFLPfmXcORvHPjLFjHB4+vtWOJYIDNAk1Ci7//gvwr/NqyILO9gzpQOdB/Fx5jJ/di9isAoSeYdgePGBXfmYTjhaHYp0RJsZjF5F/2hC2Mnmlrw0QTxj8Peki9tpbCdmBiGjzM20B6uQbJHk4eKfFFKjRb8lqYgfEcwbE6eo4e+0DgDDN/2CJCwP4pyB/4EYi/djOIzSRO0IdhpVc6QgXQ2TmoxLzYidN04FSjSFcvWVp4dmMM4oO1xdHbKe/LSX9+SLzy5w1qTLYtD1Y+uOYA4dHI5jW7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+k2D6/qcFMdpyoRIaVnXgzL/A/qtdVYBZNVBR/cfX0=;
 b=bh3odnxA3YQGg4aZPwB7UQC1X2TxnC6rXCjEoAGLUnAQdXGNKM6ioeRKJewIF9Ge1i+sdeep7fEllaPtYxmWH7rKQKunKHBJ/ycUcfQuoCEXiewh0qCtFEt6YW3GKQ7h+RW030kl3N+aeL8bBNXlrRqMbI6GmIL4Mn51O8o5l0w=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB3022.eurprd04.prod.outlook.com (2603:10a6:802:9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Thu, 6 Aug
 2020 11:41:44 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:41:44 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] crypto: caam - xts(aes) updates
Date:   Thu,  6 Aug 2020 14:41:18 +0300
Message-Id: <20200806114127.8650-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0101.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::42) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR06CA0101.eurprd06.prod.outlook.com (2603:10a6:208:fa::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Thu, 6 Aug 2020 11:41:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5de1b927-6578-4be9-b611-08d839fdb1b4
X-MS-TrafficTypeDiagnostic: VI1PR04MB3022:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3022DABEED586C69715F7C2EB4480@VI1PR04MB3022.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4mogo3Ly+MWSs/3HtGylV5Xfl0dnt7+7oI4NBUxfXOtJ0yKcn/7biXVofwzqRNyWEFRVF40mWQl9x60XXMYCypXqIBfTedrG3nqBrlze/dCN09oYGZqMj0+iUrEuMOH3yf3J2khFuCcOHCoW0+qLZLTSiIiYVe8Fnbrc5yo6BUc+wvtJTlHpslbMnbb1vXVvQNiI/rxOR9v95IGu2L/YncGFbJzY4K6/iBV/e8A/YUL7UORRsYpuAft0i+7Kw4CRQUYiZTsp1soaYS/hHK7wKRK5EQPGYZf0nZuFWVjWMwvL/M1c6llgg/QL+x4COzd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(5660300002)(1076003)(478600001)(6512007)(2906002)(83380400001)(16526019)(6486002)(956004)(26005)(186003)(44832011)(2616005)(6506007)(86362001)(8676002)(316002)(66476007)(66946007)(66556008)(8936002)(4326008)(52116002)(6666004)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pW5j9aRWBEQPKLeDDlFVtPBqe64zKOmEXh1mZ7yUzvwn0fED/G4t7NNZoVDWAabH96Y5lIdM2aMWfFSWRMxH6xKqXcfQgXi/46RkKcUbUo4qZdXb0S0KQ1mrMIJitRduTGyfbYpX7UxVf7QwfeUVtE9VKNB4OrSDhrPYOdTVFJMWM8JXk8oklLjc+fub8dKjRlFRIoQJiV0vcWQ14JTIEnKm5X2VS0XB/ua7ALIduOlzAoQ3A7BiRS9Ee1pvvD7Wh8Zl9of8oPZny2ub5q3j1ox5mGrNKEX8fxd9tvTBFRSOCjkv3LhaxBnNATjZVkleb2mTKAo7J6WekAPA240uNJe+krDgA+PGgrmlrDFV4ELdUDj8hUy/zaMQxlYh3wgt+dC0v+szAEBwN7BPncph5ltjN75M7QZpiPaRjehUHeh5QLeIkmrGKQ0rCJG6g8IkzafbAMxs0THfUrdEgwBsC65VnkQm/qvnR8p1Se4OqvXIxFc7NewqphzsQTkDFXSzAtus/D1JoH263DYkhnmTBJQgcN74e80Dbo3WTdZokp3FWGKhXqIFcnCujNYkHIBzYbIISgHp6VubxbZq54nBUAFcz9+fgT7YNrnn0BP9jj5Y7u2g8AsnGejL9+YtU9yq2lum5Qh39sjOXveBacxDKQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de1b927-6578-4be9-b611-08d839fdb1b4
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 11:41:44.5933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kB1MkpFYOQSRlR87Bux+pmuK5cQld9+EqPHZ+8SsTH1e7kTR2VjqjkmTwkdCP0yl38lTO7UuyGMnyOZrfOYGxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3022
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

This patch series fixes some problems in CAAM's implementation of xts(aes):
 - CAAM until Era 9 can't process XTS with 16B IV
 - CAAM can only process in hardware XTS key lengths of 16B and 32B
 - These hardware limitations are resolved through a fallback

This patch series also adds a new feature in CAAM's xts(aes):
 - CAAM is now able to process XTS with 16B IV in HW

Andrei Botila (9):
  crypto: caam/jr - add fallback for XTS with more than 8B IV
  crypto: caam/qi - add fallback for XTS with more than 8B IV
  crypto: caam/qi2 - add fallback for XTS with more than 8B IV
  crypto: caam/jr - add support for more XTS key lengths
  crypto: caam/qi - add support for more XTS key lengths
  crypto: caam/qi2 - add support for more XTS key lengths
  crypto: caam/jr - add support for XTS with 16B IV
  crypto: caam/qi - add support for XTS with 16B IV
  crypto: caam/qi2 - add support for XTS with 16B IV

 drivers/crypto/caam/caamalg.c      | 81 +++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_desc.c | 27 +++++----
 drivers/crypto/caam/caamalg_qi.c   | 86 ++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.c  | 95 ++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_qi2.h  |  2 +
 5 files changed, 261 insertions(+), 30 deletions(-)

-- 
2.17.1

