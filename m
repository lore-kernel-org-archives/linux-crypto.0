Return-Path: <SRS0=Ubkd=C7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709C3C4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1FE52399A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Sep 2020 16:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="fAzZZ/fe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIVQEC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:04:02 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:40665
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbgIVQEB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Sep 2020 12:04:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOvDaxcoAyVJr87jZJ888u4zlYJbIfCXpwqTOWxgi1sRfK4HV/uJcZ7dDFYGwziQ62JyJ8J2V7J30UVOinHay7J+RnIs5pPtjwiqTnXOtYi5mxmB0FZ0zyZRRylgJWCMa1COxI53e754cZkkygl4hhLhe1pQrK9QTwJYxVrbbSubfxPoeO6CLzj2tEXJ82ZyjfFp/5gkv/qYxpOlIgIsyGJh1lp+/nVynCX5mJVxXTOK4ABB5wwMJv9sSrev41y+rWjveuC5q7e1c+qMgY+WKr04Aqpa8oWUe3RSUnD8rInWrJvN666nq1T8Q8n3Eru55/o8kYeHV02ZRMdsWdmckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5kYkQEHiasdXGOex/JhfBPIwqHf/hfNb8hO3jDT6uo=;
 b=nh3rqGG7GoWQCLZNUy5DciDrtGlIyI2pWlO8O+QEkrS3Pt7ZAbpOqq/+6UoX4kSB77g6J4+/+PU2JkTGyE1WkP73BgZ8vavURWX3rszs9dwCJH2+tJiP1yrFQwTrZPDJ7MsqBpBUU8yPtz4aYrqCa2Imt6e2G0xSEdp/3KEeX2d1NEp81G8Esj7O9Z1tR7V7piYVMK5+e7ZCB5lPNNLNCvpystI4Xyl223552aZEHW27LPx2lNZ1jBI/CVqtVkgFbtTFNs2vP081rEPJ3i4omvUPQUE10/fi/+elvpAGHOIwSbzRTipCSyOCT7JEI9+E3SQ+XhtRH4GczuUuy79lFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5kYkQEHiasdXGOex/JhfBPIwqHf/hfNb8hO3jDT6uo=;
 b=fAzZZ/fegqWp6Ug15I0LQX21ra2usSBx411uDbQAN5OMvkkoo6BitFSgqw4T4GwRFo55EjYWh5YddhueJ1ghchBFwCKRWmSMmIaetTjkU0IA3mjgMvwQroJyoofCbaWRCZCJE3UoOBAJTKaBR/VuneJ5BCtVcVNfprXJEelFEWo=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 22 Sep
 2020 16:03:58 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.027; Tue, 22 Sep 2020
 16:03:58 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/10] crypto: caam - xts(aes) updates
Date:   Tue, 22 Sep 2020 19:03:18 +0300
Message-Id: <20200922160328.28926-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:205:2::35) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM4PR0302CA0022.eurprd03.prod.outlook.com (2603:10a6:205:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Tue, 22 Sep 2020 16:03:57 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1e8e75b-eb02-4eba-201e-08d85f111d52
X-MS-TrafficTypeDiagnostic: VI1PR04MB7072:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7072DFA651241B62BB6FD701B43B0@VI1PR04MB7072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: me6qmSQnWrPh4tURFvUauV3J0g9In0ihebckPUbiT1ax1j90pPOB4nMxLfrCt67HREyRZijKN1sXdI9Nase+IsT5RMzZs7WpwLzKGrPnCfr7seL6w6lyRc33ieub0hWfE//0qwiWu4oCpcCZWE2PuSqjdt8grkuq6sFl1kazDwHuYskHZ8TQxZqnv0HZIKsNMr/v437IXCDFRyeW6dsox3jG1z/TOjL4ihi9MSCGOaND5mUKGirHQdjP32hfKHi6R2SxXk6rcnEt3BfVlQ+7UBUAknvOYpRKV3fzgQGyBH20MQuPulJlCgY3z9sB6dds
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(1076003)(4326008)(2616005)(6512007)(83380400001)(186003)(16526019)(2906002)(956004)(5660300002)(66556008)(66476007)(8936002)(316002)(6506007)(44832011)(66946007)(52116002)(6486002)(478600001)(110136005)(8676002)(26005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: atf3fLT9lYMl6qkD1JKqmXIID8IHXzTPtvrvORpM3vsxbXUFNx+qx+e+S1W3DmuLkY/lMyl+6ts0e/+rcBk+Jjp5B0Li9jRkQ+FH9ggFyNTj7hapWUnm6YVyc7JxNgVEAURMfj5iGUGwL9PPQJTz6SDdppCbVvf131LYxZ74wLNhqxtE9xd23sjYb0pXp0f9fut6yuX7wJy9QdXxs9PPDwmp4+kvDj42SoLXi2BkuxBJ6yuSByqJABa/N6S0N9dfRJDz+8/KX0Dx4mqped7YCBH7wB9MKWEPVblkPCCXYg21c2xKjT2LM8AF6/2UgIkxKhyjY2gBGBrIV6hbTs1cde61JBsaWUuyEEiEAxNZ0fzsdzMxQ3feG/zPctnn2w8keub7nH96LR2Hx3dqtVXRcion1wQ1kXNzWNPz4RIJ9uQIYga536X+POIoIF1cJgipyuat91f+qNl+9J34O6n+UFhhZYXmb9meqabEi6AY4LSyzGAJp6djsvEaRs9YktR5ubELbAZlt2coZWpbgVu28sD12tdLf+LunmuwWsm4pfSgdOeZkgdR7Nx6JGW2dGy0G/RlB7V2YlWwZMOrDTG84TD2BkbQTsTOTkx/ZwPkM8S4wY3arq4Xm10Ibgi59mCsmomCARhjj5WZtvBWmXGHhQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e8e75b-eb02-4eba-201e-08d85f111d52
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 16:03:58.7447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nCNp1E/axKOWG8h1kIoUe9t0YEuaOPnGPp8nwNurw6/kL4tFAWFWfc1kJP3TZF+YxGTOXZ8/JVIOhiB+9oH53Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

This patch series fixes some problems in CAAM's implementation of xts(aes):
 - CAAM until Era 9 can't process XTS with 16B IV
 - CAAM can only process in hardware XTS key lengths of 16B and 32B
 - These hardware limitations are resolved through a fallback
 - CAAM used to return 0 for XTS block length equal to zero

This patch series also adds a new feature in CAAM's xts(aes):
 - CAAM is now able to process XTS with 16B IV in HW

Changes since v2:
- modified xts_skcipher_ivsize() based on comments
- squashed the previous 7-9/12 commits

Changes since v1:
- use only get_unaligned() for calculating XTS IV size
- fixed the double calling of crypto_skcipher_set_reqsize() in case of XTS
- added a patch which modifies the return value for XTS when block length
  is equal to zero

Andrei Botila (10):
  crypto: caam/jr - add fallback for XTS with more than 8B IV
  crypto: caam/qi - add fallback for XTS with more than 8B IV
  crypto: caam/qi2 - add fallback for XTS with more than 8B IV
  crypto: caam/jr - add support for more XTS key lengths
  crypto: caam/qi - add support for more XTS key lengths
  crypto: caam/qi2 - add support for more XTS key lengths
  crypto: caam - add xts check for block length equal to zero
  crypto: caam/jr - add support for XTS with 16B IV
  crypto: caam/qi - add support for XTS with 16B IV
  crypto: caam/qi2 - add support for XTS with 16B IV

 drivers/crypto/caam/Kconfig        |   3 +
 drivers/crypto/caam/caamalg.c      |  94 +++++++++++++++++++++---
 drivers/crypto/caam/caamalg_desc.c |  27 ++++---
 drivers/crypto/caam/caamalg_qi.c   |  94 +++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.c  | 111 ++++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.h  |   2 +
 6 files changed, 293 insertions(+), 38 deletions(-)

-- 
2.17.1

