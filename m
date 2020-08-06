Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C9CC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7A2221E2
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RZUIL7or"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgHFRqy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:46:54 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:26854
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729030AbgHFQhA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 12:37:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZvct1R6KLd8OPWQrQIpIB8MT8VuiUu5v7ngohL7kUUR8pnndkZT0Nul59csru+Vng0GGWQ43tK+vXQJf0hO7oWg0j0UAx1ce5JoO/1rDSk+ZljY/yaFCJUHdppNMpdmeutatBHLVpV7svjG67DF49DFrVpY9fxKsil24DStg+nhi94CsS7iSnkSdVDBkw0FcYbtEm4JDsbSziTC4+kIL8Fr+k5/jJ36thvem/5wWzT110UCvps82WRRVdmI029esywx5RftUZc3taN3t7eon4WEiYV9+eWAdlUEv/rj/A5OEiuWSqI5wZPU1dFap+3SsoES/3ehJ0AFEBggkN0MYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urPjv9fTmZtbvL6r9luusqrWaOLZDao2i/7anILQAGg=;
 b=QnlfcQCCctp8M29i0PvpQU0HmnnuQN7i4MQMV4KJGS3tdPofamJN+fm+d/0vx41twsPyAz1VKPNB2TOpRcswMuhqcayIDSmZUw59Hy7sQt8awJTEodO0n1IYSXGNzwHsLsZkQFeU8Xpf8BIuftZ1Bzd1nzdMNq3ypoVTyv185Y/ZOiT2QJWlXK4EZxZ5DIMohcdhZvafffNhII9uOuBtMF9+WY/xpn6ELYvK0AhLaR1I2Rj8p98ghsuP74hAA7Bwtb/yvTuMt143oqy+kQwu0xpA+mJhCQElAqN7t/fpo/gJeWwkzZCRZl12axcgRHpOiaazlHS3wA95lvUYrPcF2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urPjv9fTmZtbvL6r9luusqrWaOLZDao2i/7anILQAGg=;
 b=RZUIL7ormLpZEAToHMe7BgJ7PCB9sHg8Ba1fCEVylGsqF6oywKuDcpYT+p4K+4QYgDeK+2XP/EJhn81lW+rjezlJfmpn89JGkS1tNuy4tWnrI6XWzxWaMMRwgCRNu2UwFlK6ZMlMHYgoMLvZV2xH7ht5jc5WdGOGfXhI1TerJrQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB4992.eurprd04.prod.outlook.com (2603:10a6:803:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 6 Aug
 2020 16:36:08 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 16:36:08 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 0/9] crypto: caam - xts(aes) updates
Date:   Thu,  6 Aug 2020 19:35:42 +0300
Message-Id: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0902CA0015.eurprd09.prod.outlook.com (2603:10a6:200:9b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Thu, 6 Aug 2020 16:36:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 024bc6c1-111b-4143-b475-08d83a26d210
X-MS-TrafficTypeDiagnostic: VI1PR04MB4992:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB49928F5CA0EBA5A63E0D833AB4480@VI1PR04MB4992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WInvrV6T1vL93z3oJ2Nbiairy27OHY78mTy+R0R07NCUURxd5PrxOGpKfQ+M0rrju9zRfMRHAwbs4vOLtZmkjCQ6vAstXXVj3UlDhBOiuGwyfgCOcYIRAKqZb7wrJhJzLDu3q59tN3oyKIzKRnA2lx7uge6gYJj//7MVv/Bgj6VN3UMJVBl1RaHtxEZGTB0JQkdx9d4EvIHNSd2K9LrLP7DH6D2/WR74PKF+vLPZwhU8MqLFEwI5yy1xIRuQQ2zAtRwHZd1TW31d7Dtc4tMgV+Hmy87EYMUybthxVpP5EGEwcvBiFK2k58Juxd4I8E8d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(66476007)(86362001)(26005)(6512007)(16526019)(186003)(66556008)(66946007)(1076003)(110136005)(8936002)(316002)(8676002)(478600001)(2906002)(6506007)(4326008)(44832011)(2616005)(956004)(83380400001)(6486002)(6666004)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /7AM0QKTwVLEjH6+goo+DF0eHjlmlMwxPm1p8oNIcyZkAns5pf/JdcI9G9UfQj7Ppp4fwdCj0bHHG00A6ViMz2+d5hrqluXhw7sj3F+ec7TydA4DyvAkrBtfPb5TErnRhKzDiVZN88vVFFj/N4tFqiTI+3J9cKwlU/Vuk1ZPQtu9Qf+9V8Uftwsq3okXGNyDJpq6pITMOrBFNKdu1p8hf02W/yTbCSrnsX88gWvcwt0IsTebP6u1G2uSRmkniPYlQND02tvWQsjgNLlQHxPBb792ojMZeoMs3nsd9vcmgIZHN3HossOt79YcOIou0ju2Zxc/XeQNFXks9FsqQXNKzCet6IiAPGxlGNzfQDsL4HpVdgEvMb+KOKFaeVADG6FMSWlW/USYDSi0cfpbh7mY1ZbbubrrlI4cwK2q7/8nyltMTe1MHkhQcd8NB4GPKupjrhHym6dsRYB4aXm7zGrWe8QCbZA37ZF4eKr3+W0LgfjUzpF6tcezd3t5dDJoEiCbSTyxi7eobU6izRWwV57wIM27u/ZlGdJEXyRqEttZDzcwsVpEKx+mQq5Q+2osgJPuTKoVXaWlen2Af7VU63GE0dEoq+w/DV2SwxLLBl81NzZhbQw+WVfHKDXv61CrY0blJiuO1zuzQnv5hLcD2b+pDw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024bc6c1-111b-4143-b475-08d83a26d210
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 16:36:08.1642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDu97+0Gmx7eIT6Djq3jh765fSTS8ByLX3hYcP/+3minQse3HTBEZB8TnTSLHe3kTxnT6GC/y2jM2F4R2WP9wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4992
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

Resending the patch series because it didn't reach the linux-crypto,
linux-kernel mailing lists.

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

