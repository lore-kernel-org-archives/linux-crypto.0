Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4056AC6379D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C48DB2075A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="H2kbGFF0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgKYVOY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:14:24 -0500
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:34107
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgKYVOX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:14:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J81V0ymRbHnz8uckKmOI8JiFdlpMfeil2VDb62eFhnZewfNZfiNkT6gRYDBNn3HV4NgGnk69wRSKwj6IyoYo/TuZcr/vUoniMNUZ9hkgT17RgyMXUHSxTiopqX6+Gc1nH37Nx6JWUwbT0USyMLEXi+h8l3jLl35L7Q+VhWqnP4gW4DBAhx2PAqkJhdyhSatIIlfEtguY9z2he7AaJADTbd79xGSfofJz9iNUtjygC79Lpap0KsJQ/DXHQp/7CTykKVvTtVZu5ZVg+4fF2NyReaFC2sRL18guC0LinONTdCc4QCVs3NvxYWPMBYPdmj9DivLxNZzHWlPbQgrBOzSD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sna9JVzF3Yk8RzWOeiWOX3lyUZsm8G1/adccGe5YY7o=;
 b=ep2Ey7RDN8Ld55xA/5X6Tu8MBMqQ6WY1QtJM8qKooXiKxBhgXcJ2DGQkllXJ0YIbAvJvQWUngyihf+gwLjAHJfneAtKePWdsUFG+gHM5POOvRF4APwyYJXfGB0xtOORMpJe7ji/k0Nge2jYkqoMPctHcrkISFJdDw7djACp7pwN3TegFgV72UcEXOw9WXzfAwdGci9wOuy82WA4tzvv1HhBwN3CDApHzbIBKXn3qaC+JdHSNqwWADiluGSezYkuJjnPwN6pxyENEGcDVoAaoWxXkj1LWdmGmtTXLUcqcPu+UFURs+xE+/n2zhbCiN3JjAsLlc3hBJepKSa0gkG3v2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sna9JVzF3Yk8RzWOeiWOX3lyUZsm8G1/adccGe5YY7o=;
 b=H2kbGFF0lvkgLQfFpGff7NAmWAdn9pbsEI+sQUyovhiC7xGcrJ49SYT+/8BsgQQMxhEqalTE03Jzaytk1nP5uptouw9PLKsgHU8uKwxemlJ1TT7mUU80Ah27sEGLp1Ufan0pgVgy83WcLBB1jDkubiYM01eoKsfpkjIHkPaKldU=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25) by VI1PR04MB6941.eurprd04.prod.outlook.com
 (2603:10a6:803:12e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 21:14:18 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c]) by VI1PR0402MB3712.eurprd04.prod.outlook.com
 ([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 21:14:18 +0000
From:   "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [RFC PATCH 2/4] net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
Date:   Wed, 25 Nov 2020 23:13:09 +0200
Message-Id: <20201125211311.2179-3-iuliana.prodan@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::34) To VI1PR0402MB3712.eurprd04.prod.outlook.com
 (2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15040.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR10CA0117.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Wed, 25 Nov 2020 21:14:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b07eabf-fdc7-4c33-71f8-08d891871229
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941D033B9B54E879AD7AECECDFA0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: goVieeWYCaXVSkz7opzzXIGe1FfpJ/c62RnfifeXF4HCMDl/yMRBvmWxEmUokP5MJaWeJl2ihElvbZhux6XOFdi55yflR62zr85EMxgp31eSUK/aPrikANoKj/WUd29uhvI4rjwhtOP6mPXQ38dOdbC+VlYcFI7ZnKbAYVDPSrJG+nWkd5SLCAz7hlRQgWUvF+skSgPssVkAMDyzaYw5L3k4cgQUCS9A4EUOUovo0pfYmjw4YlKD10YUsXJG6TErXN9y0TTdSsxxF/k7JtDtU3ZPlTMtjMyPOqbSF5KzDqfEfBt01igWFH8QeYIVQwN0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3712.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(316002)(86362001)(5660300002)(66476007)(66556008)(186003)(52116002)(6512007)(66946007)(26005)(110136005)(54906003)(2906002)(8676002)(6486002)(16526019)(4326008)(83380400001)(8936002)(478600001)(1076003)(6506007)(956004)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Lc0geHSkV9/5VMumiA8b51bYar9P2fpAJ4zNRfuQ/pEdrj14BQ7plUMtixYa?=
 =?us-ascii?Q?MnjB7J0UkQXQ84Fp2tDucmlEP4SiYCvaJ0yO6xGGXOQ7t/zl6w22j8E4MD7P?=
 =?us-ascii?Q?pQDuKIWo3N77oDFzYkBuqjJ2KF73ijuJ1duLbWcadIeZXlnaU2idvN2GNbBS?=
 =?us-ascii?Q?5EX/VhjDpYie1sTigG1hiC1nzvFeaQgFMoyIIbOYYXZlrdwTON+4FD30zQJv?=
 =?us-ascii?Q?17Y7E1CkF3NHLBd9TV6nUkbniufPTVFMt4bnUKhz3TZQjNQobamtL6807u2r?=
 =?us-ascii?Q?ZP/kC5ObwTwcMcNZMSpbATjCiG3TpVdKaZ+xPtYVfhMnOid2ZwbHnvGSd1wl?=
 =?us-ascii?Q?o0c56CRTij7qQX/nYNRipezAMqCFBZ3f+M5+EO9lWYZ/c2IEhXO7k3Gbiufk?=
 =?us-ascii?Q?0yhysAFl3RJCjaiKlZLqoUGXO9SgtpivnGcA1bAPpOXKWLbj71GzBdT+SBxw?=
 =?us-ascii?Q?Poo4Awy0DIxUMx2lHAMbrTNUlEjD/VJw8jFUbku29GjJGe6+2zmlxd4EzZnx?=
 =?us-ascii?Q?E3fi1ka8CfHzSQ3owtwLCSZZgEh31Ch306utLEjyiGBpXaceoWxiGmPc/5nz?=
 =?us-ascii?Q?BkZzhiiz3xO9DOx/QUuDNf8nwoxNVnKj56+kwSPTrn7JpJcIM+TU5yR9Uzqp?=
 =?us-ascii?Q?QD6QJCuAfUkNhotP2selIFgjdgP7DKavubzwKuwGD8LUGtXsHY5RHw7Qnpxe?=
 =?us-ascii?Q?SInHpr6lZGT0EgbHK3CX+0HskJdGWPDSOXSIjDEeFwWEPGHXOzihBpRO8A4o?=
 =?us-ascii?Q?04uf2vplVUnMUeSqYYSKruRd1DBiuvz01pybyzgGJJ1y0E28llS/kNZqpGlu?=
 =?us-ascii?Q?m9VtVL55rhdHCaOlyuZoN+DGfbONLS3cMx/rnlqVHoBJ4N0QruzpccgO9snh?=
 =?us-ascii?Q?PBOGnPuACvD/YjlFR0lskDAzYuZDjgjRxGYL72xN1DmxmlsV9TE3dOo6Ketm?=
 =?us-ascii?Q?Odv2ukf0MV4VhLoVxkjQH6/663sSz9RvZaqBOc+37YU=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b07eabf-fdc7-4c33-71f8-08d891871229
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 21:14:18.6042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfZ6RnH5IdbZXDEwdq1JSoXwGS8ESOwBgu+e8Fi9sxYSZDyKk7r43yDNTrj91xQlTD8IWs6ef/wjOxGvhOcSDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Some crypto backends might require the requests' private contexts
to be allocated in DMA-able memory.

Signed-off-by: Horia Geanta <horia.geanta@nxp.com>
---
 net/ipv4/esp4.c | 7 ++++++-
 net/ipv6/esp6.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 8b07f3a4f2db..9edfb1012c3d 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -46,6 +46,7 @@ struct esp_output_extra {
 static void *esp_alloc_tmp(struct crypto_aead *aead, int nfrags, int extralen)
 {
 	unsigned int len;
+	gfp_t gfp = GFP_ATOMIC;
 
 	len = extralen;
 
@@ -62,7 +63,11 @@ static void *esp_alloc_tmp(struct crypto_aead *aead, int nfrags, int extralen)
 
 	len += sizeof(struct scatterlist) * nfrags;
 
-	return kmalloc(len, GFP_ATOMIC);
+	if (crypto_aead_reqsize(aead) &&
+	    (crypto_aead_get_flags(aead) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
+	return kmalloc(len, gfp);
 }
 
 static inline void *esp_tmp_extra(void *tmp)
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 52c2f063529f..e9125e1234b5 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -63,6 +63,7 @@ struct esp_output_extra {
 static void *esp_alloc_tmp(struct crypto_aead *aead, int nfrags, int seqihlen)
 {
 	unsigned int len;
+	gfp_t gfp = GFP_ATOMIC;
 
 	len = seqihlen;
 
@@ -79,7 +80,11 @@ static void *esp_alloc_tmp(struct crypto_aead *aead, int nfrags, int seqihlen)
 
 	len += sizeof(struct scatterlist) * nfrags;
 
-	return kmalloc(len, GFP_ATOMIC);
+	if (crypto_aead_reqsize(aead) &&
+	    (crypto_aead_get_flags(aead) & CRYPTO_TFM_REQ_DMA))
+		gfp |= GFP_DMA;
+
+	return kmalloc(len, gfp);
 }
 
 static inline void *esp_tmp_extra(void *tmp)
-- 
2.17.1

