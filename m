Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12D7C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 969BE20709
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="KGeOpOB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIUHc0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:32:26 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:47332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbgIUHcZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:32:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTO2K64WoiwzbyMEAzapD1qiu2AFkfI2RHQZS9wGf8oRGwNzhrXS3l90sCzkYoZV7Tc3q0F5gEr1FH6Adp5oouWGZCSDoUjrtEJqShhsS29OBEeLE48rTpExV4CDkt6nwQ23EK+6oPmc7uBHQl8UKrYjTZonn3yQPFui8ASIRO1lWTP3qjrexzQvn67ZtTGpZ2JlvqNQ5N9OocAsdpem8pyd5CrKU+nm9MAQYDkU9uv4dcLOB9hYdxKjXzkna2Az5/lits2BDJCZRrjGjggUUiwWFyQheF4q7qrKXaxTcDJEV5S9P3Oay55o1m94X8IlXUVI16WXeV+hiE/mZFAwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOUAGVtAb+aX2v6Lc/rxx/quBJiQimCOUb6rFXzTO70=;
 b=VHNZXPpH/Q/HiZ5FRpIj5AqVv1AXdsw8ywJRZF718v45oEQGz4akvWIieK3DVCU/d0kujYxvyhqD5u48LcTB9RtPEFRvyvZoq+OUWwz0/fyzGWEORZljHNaenMOwpJnQyKqnRCTZVnEXaGLtQOSoyydgnbeJNg23/GXs2JtMMbKJZEQ8fVJ9MWz/9H6mYM9kQxuBfAz3NgC4eCbzbyJQvZcU2+7s691oSRQCUUJK2OZJG65Zhiq1CZCcgyH8a6ChLLuMevLXF/VnC7t9dnIVKcHLekxmVRjlSALsM5Oy+q2Jc+Nm+iAMNTROH4Y1yX38f5tdURTyZVrZ8enuz/7vDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOUAGVtAb+aX2v6Lc/rxx/quBJiQimCOUb6rFXzTO70=;
 b=KGeOpOB5WyAYzzfuoCemafxnMJbpfP3FxJCTdSyCQM9YbdIeP1W+TYbDwatpwPuPeOPKWj139xscY12XGAfnxCVH18OVYd3GPc9ohoCWMCSzZNgaHEO3mwnIzY9Sed2Cxkx24QhKV8MDXsCpvDYUwFHSnBeh99g0EJk+7CndRpg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VI1PR0402MB3903.eurprd04.prod.outlook.com (2603:10a6:803:21::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 07:32:21 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::34b6:beed:6762:a67c%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 07:32:21 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/12] crypto: caam - xts(aes) updates
Date:   Mon, 21 Sep 2020 10:31:53 +0300
Message-Id: <20200921073205.24742-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Mon, 21 Sep 2020 07:32:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ff13932-a602-46f6-556e-08d85e007a22
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3903:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB39034ABB35ECEB5D4BA4CF6BB43A0@VI1PR0402MB3903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GviO7rdfRdK5f0omcOz4jBcEZKfN+URSzWw7EdZb0rcuedg8ofs7lZK9LOMVzKx8x+qfI9fAmaUOQoOn5Mnf/NChZCL6RAnunUHtl3gl+WAEhEwoSDveBANmw1iiuoDp9A1Z9pjBJ2nql/FsHnrgjfz/DNctTKe/4UMs1GYww2p9Xcpu3jubeF3OdHek+DqP7VH+ZJbTC/YqiawD+tXz6Q2a8+/6HPPToRdjJauz2vDM8jOz1VWKUI6jGMxoDgtc4R/NiOU2CuSUL8qxM/UPnmEVhjZUgjgJw6UbGEf54ARdp6PSOaeUYecKE6WeyaJv0w2W7nmQHtJWmTFoUMFZQipXHSunFdmtZ6YKTTWrHvHmY9AG3BmH+4KSerspOQnA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(66476007)(66556008)(2906002)(4326008)(44832011)(956004)(2616005)(6512007)(1076003)(8936002)(8676002)(6666004)(52116002)(66946007)(478600001)(316002)(5660300002)(6506007)(6486002)(83380400001)(186003)(16526019)(26005)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7uZzyt7FEWiOg4lFX6ulurflP/BZ3xPJ0uZU/R0uzrieh9KyHjepy5QbnrJWXs2wpPdsB2lIln7AUK/GElMBkBrnItRXbhK76J/D5/AaBMhkw8be7KCa2TdFi7BNVnusOXge4PTB4bxqVs3TrUyJb6Qx7qr+b/mix71KP1JDmaT0UqLCRFEbAvgAOxCjLAPu2nUdJU5c+y7uLhC396r47kU8CoiEp/z5rPU/DTorfFTUJUa6bDWW5kYdFrzL4BJ3b2uegY0es/dAu+ZaquKNS4qtW7dcl4WD3lknXGH3vkbwHTneVEhacATh9pSPSKU+zQzV4AcIpWjYiqbKN44To3cMgndYLtaAijcPVM0UDlODF6s8k/nfnPyAEe+08f/4u7c6LxVxNQNz16rVoEpWlmJG5YnOujfJzngR1/JsGLP6p2IeOALxzgOFEdeAVII8xUJDY80W0oD9UQE8FIUSeOu7g758wKmFNIgwRI/LZFrN/UGZJ3Uc2zS8onC9i20cAAZj4IiND5ZofpExGhrCkxGmKquMTkDEaGwT/wygwpJfpjLXpGfTtpfejRjFUbEh4mcURx5wYdK1zWMfTrE2czN6T0l7ngmvWKH5HANb4CcPKB8xfYTzApqzVhy58AzbjqjKl/9VWE8VFtBJfRckkg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff13932-a602-46f6-556e-08d85e007a22
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 07:32:21.7934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDnF+7MugtR5bebeJ3geyxNzWFa17BQkONjguaozJMZELICIeiFwelsCLBklbJADAduygZPFbCGVglL3W0vGAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
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

Changes since v1:
- use only get_unaligned() for calculating XTS IV size
- fixed the double calling of crypto_skcipher_set_reqsize() in case of XTS
- added a patch which modifies the return value for XTS when block length
  is equal to zero

Andrei Botila (12):
  crypto: caam/jr - add fallback for XTS with more than 8B IV
  crypto: caam/qi - add fallback for XTS with more than 8B IV
  crypto: caam/qi2 - add fallback for XTS with more than 8B IV
  crypto: caam/jr - add support for more XTS key lengths
  crypto: caam/qi - add support for more XTS key lengths
  crypto: caam/qi2 - add support for more XTS key lengths
  crypto: caam/jr - add xts check for block length equal to zero
  crypto: caam/qi - add xts check for block length equal to zero
  crypto: caam/qi2 - add xts check for block length equal to zero
  crypto: caam/jr - add support for XTS with 16B IV
  crypto: caam/qi - add support for XTS with 16B IV
  crypto: caam/qi2 - add support for XTS with 16B IV

 drivers/crypto/caam/Kconfig        |   3 +
 drivers/crypto/caam/caamalg.c      |  92 +++++++++++++++++++++---
 drivers/crypto/caam/caamalg_desc.c |  27 ++++---
 drivers/crypto/caam/caamalg_qi.c   |  92 +++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.c  | 109 ++++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.h  |   2 +
 6 files changed, 287 insertions(+), 38 deletions(-)

-- 
2.17.1

