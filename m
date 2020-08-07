Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1BAC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9106422CAE
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mGvw3BHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgHGQVU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:21:20 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:55015
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726013AbgHGQVT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:21:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8g65R9CfrEdXEQeAABftpuOHrb0n/UqPfZGI6KBra4qK02QBH5HWKbgJWoHiTKNmurYh1bexfrnWyTZWZWDjMqCAuPIJNFYI9g7e1/D4HesHsJ+nC7H9PyVIoplIr9TI7bjd1mFuLyn9cCAnHEp7kKt4Fhz0LZekkC4jTu5rh7DRVOWhZ0DmoPn639O5R/L+eI+IsJdTXBbInRtxRRL1N7liZC45hMLY7LGtyZWFBOuv2Q3IZCyJa3a6UIiS7HO1RPQ1OPh7tCD6SkV9tPODD7zyEfyXFrcp5dJ3RZ9nRKkfsa3VepUMxHMIE3FboUix8nxfQ3KeWJR8IPfnIEUhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcqcrUjAUMxaI2nLPJUebxNcU/dca8OGyGY+YGmF5vU=;
 b=k9SnnnuhRmnPLiCDU92kyPuGjWb09wQjikVuSxXhQHrcs/pxQeRFumcIIsM2VrBUegrdYBzIj8P7N1h++FIOuXkK2ocfbwrOnenprVZgmRGFNeX4Ucoz2saRxRX9+Q9LdyQjtb39trHcwgVoOAnyoc3xgVMNZTKL0kb/D6rzhc+5/dsVNnkOLLizIZMxpKnHRPkYw/SIU+fvx4pjPg0QNF/nWFYddYJV7bSKqfkgBgg1G2cYAgqIcGh8liHstE9M/MFPLRPSEUhRM2voOs2oHek4QoOfEl2O+BjDeApdNs2xUebpfEZuO+M/HV5u+SNEfEsLBxvNFhE9IsdOgl7XSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcqcrUjAUMxaI2nLPJUebxNcU/dca8OGyGY+YGmF5vU=;
 b=mGvw3BHB0CF6zJH6jvqZpxAkG4V6fRwjgbcc7XAAEJkroD4pRlE0z8sNTfgJa8KXUfsjh4KLNR69o3UzIYzGWMH/gH5FU8XgQFGKEti0S/AahhmcQo/Ua++6sXGzmWbKu6pFYP4mZrt+joJ6SsZwLsLQZtH1lO5VFapdA0dOsZs=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:21:14 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:21:14 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>
Subject: [PATCH 00/22] crypto: add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:19:48 +0300
Message-Id: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:21:12 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ea9c951-8e36-4641-105c-08d83aede778
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB735924CC0DAA1E7C70A9DAFFB4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hVbxiJfrb2E9K7WRh7YTM+08ol2KQjDzXVdK83mOE50ND1UL7FYrMF4Xn3hBvmgKt4VYVeagSYBG5pSiT8t2kIKFKpp2H3Fg9R7A96W1Ia69u3iZ0JDEPOyvMLimRgomKkYcU22Zkzlpr1hvnauthIdm0NPPFr6ZmBH3Dc0Qw8ssaIb+2qm3Lo0hj1m8OS+QZ84N56l/fktIXhUGG4fqCtMjpbkPLxfw8Z/U1yQb9Skq603iSBOT0IP2YtUoHYw9h87lWJVzn+HRLUn1yNLF29ZcLqPcTHdEx2vBxpvM7ShYNicRGV6v40q9IMLEJmv8DT01r0bMOdQYDD+3h6gtLEh5rJIJ9GrSuIHtS/2DDgTMrZuHlZ6LOfyFbeSSezEyEeHPS+Ae6ZuzHnvxN4XBTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(966005)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LWvn+txlT/STlZ/1DshBvAdZA6eG9+g/8/7SRrfU6OlB6fvUgqJM4p6goAzF6d4p0d9vAMBRsZe8KaPXqRWYMsuvNfvnBrKGmVy45BcV4gCRlvYelR4/AHMFJwuvOXROpA72pewj8KTeAlKcE2+1w35fVaQtigU4TKNVIy2GJ4lppG/gWRnuWzgytCm1u1IQKW20Xkkckogn2YfuFXP/DF0WYbL1efam/4tqUpppipnMXoa8Zc1BD2Dhb7CaknEnwF/u0+vB9s21FNtEEKoWjICgx93/aYSimRW8LU4vHJp1Kvmm1/+iAqyCI+uaLzfz4aMp4avZqU7VcWdKd/JxwpFnbLK/r0LZIDThkNGQRUGn8o6IsM3gWu1dabAU/nbhVnfa/mR2A1qBAGfpsXMHWZNVV9SFfs15HVSEGYX5ZaRlI8Kui9Gxb7iooMHZ+mWQb8oDAOrJhSa3p813d9Gp89r5ijoHKGJenYH5OtOmgZ4mzufZWOMm9Z7B0m11NyRkMsrWzxcq7NtKtRfUyxLTcnz/RWBldd9sSp5xmQCsKiqkyJgE/XW9Zgybg5rPp29XkqE8o831LDc407G/VmuFT8Le9xtBiPLOY4W7r8Vw0sviLPnjIaHEXHP/Rz+aua+kP4uUY2NNyzJWgjlO5Va+Aw==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea9c951-8e36-4641-105c-08d83aede778
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:21:14.0669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Bn2syH26TG+nGhWwv66zFYaAuG6z3KRC/MrrYyI/B0EZlMJQxI4RPZgvLcVfEO7c+5PBMAgDFYYnta6apLpMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

This patch set is a follow-up on the previous RFC discussion which can be found
here: https://lore.kernel.org/r/4145904.A5P2xsN9yQ@tauon.chronox.de

This series converts all XTS implementations to return 0 when the input length
is equal to 0. This change is necessary in order to standardize the way
skcipher algorithms handle this corner case. This check is made for other
algorithms such as CBC, ARC4, CFB, OFB, SALSA20, CTR, ECB and PCBC, XTS being
the outlier here.

Although some drivers do not explicitly check for requests with zero input
length, their implementations might be able to deal with this case.
Since we don't have the HW to test which ones are able and which ones are not
we rely on the maintainers of these drivers to verify and comment if the changes
are necessary in their driver or not.

One important thing to keep in mind is that in some implementations we make
this check only for XTS algorithms although probably all skcipher algorithms
should return 0 in case of zero input length.

This fix has been tested only on ARMv8 CE, the rest of the patches have
been build tested *only*, and should be tested on actual hardware before
being merged.

Andrei Botila (22):
  crypto: arm/aes-ce - add check for xts input length equal to zero
  crypto: arm/aes-neonbs - add check for xts input length equal to zero
  crypto: arm64/aes - add check for xts input length equal to zero
  crypto: arm64/aes-neonbs - add check for xts input length equal to
    zero
  crypto: powerpc/aes-spe - add check for xts input length equal to zero
  crypto: s390/aes - add check for xts input length equal to zero
  crypto: s390/paes - add check for xts input length equal to zero
  crypto: x86/glue_helper - add check for xts input length equal to zero
  crypto: xts - add check for block length equal to zero
  crypto: atmel-aes - add check for xts input length equal to zero
  crypto: artpec6 - add check for xts input length equal to zero
  crypto: bcm - add check for xts input length equal to zero
  crypto: cavium/cpt - add check for xts input length equal to zero
  crypto: cavium/nitrox - add check for xts input length equal to zero
  crypto: ccp - add check for xts input length equal to zero
  crypto: ccree - add check for xts input length equal to zero
  crypto: chelsio - add check for xts input length equal to zero
  crypto: hisilicon/sec - add check for xts input length equal to zero
  crypto: inside-secure - add check for xts input length equal to zero
  crypto: octeontx - add check for xts input length equal to zero
  crypto: qce - add check for xts input length equal to zero
  crypto: vmx - add check for xts input length equal to zero

 arch/arm/crypto/aes-ce-glue.c                    |  6 ++++++
 arch/arm/crypto/aes-neonbs-glue.c                |  3 +++
 arch/arm64/crypto/aes-glue.c                     |  6 ++++++
 arch/arm64/crypto/aes-neonbs-glue.c              |  3 +++
 arch/powerpc/crypto/aes-spe-glue.c               |  6 ++++++
 arch/s390/crypto/aes_s390.c                      |  3 +++
 arch/s390/crypto/paes_s390.c                     |  3 +++
 arch/x86/crypto/glue_helper.c                    |  3 +++
 crypto/xts.c                                     |  6 ++++++
 drivers/crypto/atmel-aes.c                       |  4 ++++
 drivers/crypto/axis/artpec6_crypto.c             |  6 ++++++
 drivers/crypto/bcm/cipher.c                      |  3 +++
 drivers/crypto/cavium/cpt/cptvf_algs.c           |  4 ++++
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c   |  6 ++++++
 drivers/crypto/ccp/ccp-crypto-aes-xts.c          |  3 +++
 drivers/crypto/ccree/cc_cipher.c                 | 11 ++++++-----
 drivers/crypto/chelsio/chcr_algo.c               |  4 ++++
 drivers/crypto/hisilicon/sec/sec_algs.c          |  4 ++++
 drivers/crypto/inside-secure/safexcel_cipher.c   |  6 ++++++
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c |  5 +++++
 drivers/crypto/qce/skcipher.c                    |  3 +++
 drivers/crypto/vmx/aes_xts.c                     |  3 +++
 22 files changed, 96 insertions(+), 5 deletions(-)

-- 
2.17.1

