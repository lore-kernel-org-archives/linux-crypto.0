Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EADC11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 18:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500E661411
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 18:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhGAS7X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:59:23 -0400
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:32839
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232626AbhGAS7W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 14:59:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KI4PQT8VPAc/WOWnWFkeneoOC6CbfVzIcfpo7HiHzPW4ay3Z6QF5+o6iHnAspDGx+FR67VepUAcHSp1B/vWu7OKtmtCmD2dktUaQ+NGBfthuDsfFT47YZYVvww9CxlaCi5ijMhEiStiIPc2CqQX1kvNw/ye78kdKyQ2twFrAXKneovSWVgss4crMmBtoT/GiJ9r7kwXBsmzlD1GM6LYmIvgBISKENtXQP9DGcxOQxcCh37LXMf3xr7bKp/UaI0tulg6bDmU1NK8nZ8i6djWBGpgbhMh/lcTyKQwqLsFsd0zSf1TsAxIuze2XRkCLLQLtTFav9KOXJURNK14xOvo2GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXaNT5h8x65Ho0MMGx4L1WZRy2MK9iFCupo1trGdKeo=;
 b=ABxlsmTYgRX7wYsBOcpXyGw8yS1nRF6L5Ejuu3yz6C8qRrleKMZ4oLzgxqVtUJoJjgfiIAfGy5D7v1ClcaSxgE1KNnyXkT4BUfAIrOGgLpC1biYdnTPETv2aVbvgK+SaLqQLdTCavGsoNUhZQVyTZhYeJ6IomRCRu4swqFL/yeqoGWdFIMx0p8ppsZ42/e9mhJTBYynYPZ3YN8aMbz8KZ/DPB8HJhx9sh6dZdBP64jjW1bYCKM2tvsEPrfrY2MZ74xtIQghwnmJeP2mi5Fs91e0QOPAMYmKltJOid6mCYpcReWSVgCsS42raeRS0dGxYfDC0hpJacbwWQJg//hdJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXaNT5h8x65Ho0MMGx4L1WZRy2MK9iFCupo1trGdKeo=;
 b=oNgkY0zzprzQYMfG5nldGSWAHerZEc8+gZbproDZa3KxPabwXIewjzeL9pSTc4f7xkX4tUT6seG6Yjt29nvooMWTzkcoIYXmEHLujUS+umqyZKYMlVNVA7s0+K1z6aYtNzQ6SbXo0sO97tiZNGMLbs+JJHgdPDM1xoC8yrBSEVw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5144.eurprd03.prod.outlook.com (2603:10a6:10:f5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Thu, 1 Jul
 2021 18:56:49 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 18:56:49 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
Date:   Thu,  1 Jul 2021 14:56:36 -0400
Message-Id: <20210701185638.3437487-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR15CA0050.namprd15.prod.outlook.com (2603:10b6:208:237::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 18:56:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 083a80a4-29bc-46a1-0429-08d93cc1fb44
X-MS-TrafficTypeDiagnostic: DBBPR03MB5144:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB5144D7462A1A1433AF8EA07996009@DBBPR03MB5144.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bz0kdIuKRAyKMMj6Ltikx9Uk1ua83iOEZyj+VgssMv0kO4bmtAdHPXt9wKYKrB9h0ZsQrcS0YuWZWSrKZTXu5tJJBRuBm/L/xoOQhWVIFeNXiA0uDEUHdM2VugPOmvIe7x6FKzU2gYmUKyyTNrOaRJCPhlEw0mKQvm04vw2tMRGBfMHPgC85c+Ct2AFygRfXda2J1zNOhKbzzJMsExQXgzT41eQnWnOZnnV34joq5EAF5Zn1vVU733lvQVKdKrcMuBMcPDgyDe2DxDcB83Wi1vBYqvyHNPAVniI+OTVgR058dcD29Fk+lJpVomUuS1FGRl3TuvfpoY1qSC9OY+H1SvxvMgK8sEN4NmHEjJkSBnJv8nXX7tpHu0zTNjxR6w5WaBhfxxneBzgPpgeeA3sedKyRw8fb4tL70Z+kG7L/Q6kBG4xF+18qyq5gW7B4965/99Q+H3TNUypcJpXhwCAsk+vktFC/EFs5KbvN6AGI0fuw0HlBI/xYIhD9oUtXbRvYl+cXweLc5UjE6BRhm02CN53UCz9H0OYlRlLci6+uc9CriyQaDEtqTUeWzWu/8Lhd8KCaCIyLJrxexzAXoV8KLur4oZtgIRj7uHmTq1dUu/nqEdOrajydMo03SadtwUKmakKP+Msnwjvi8isoeftHhFANT2LaqorC6pcHweHWo3B+xeYOJzSqfFfp17DaCNC51nUO9epWKIQwcra5draVlX/94KO2S70Rwh/bGdOycK+9e6BmuXJXgyj/4u71o60qQhLAKAph7CiagZuy9v4tP4l52KZCc9dcNepcrDk8sysbYQl78GEmW4ebHQWTNQBGiC4MdHR1rXTIuPMS0XBC9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(39840400004)(376002)(5660300002)(45080400002)(16526019)(66556008)(66946007)(83380400001)(316002)(38100700002)(38350700002)(66476007)(478600001)(26005)(110136005)(4326008)(6666004)(186003)(86362001)(44832011)(54906003)(36756003)(966005)(1076003)(6506007)(956004)(52116002)(8676002)(2616005)(2906002)(107886003)(8936002)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2JEcmFaSEhPb3FYMGx6MklWeEdUbWJDdFlHVGpoQmJPMDFvT0ZpeFR2Nlky?=
 =?utf-8?B?VFBGcjd6QkMybWJwdXRoU01xSXp3OTlLT2Q1U1F1MEF6b244MEhQV0p3STNi?=
 =?utf-8?B?R1BOMjRzK1ovb1Bick1XMVhUMUdwZk5VekFlVTRQNTMzS21tQ2YySW43OUdu?=
 =?utf-8?B?WnoyWkhBVEFVUCs0WlJXc29vbU94YS9tck1CK0RjTWhLTVpYeU95bzRxUmZO?=
 =?utf-8?B?eFhOMVZ4TGdIWkVPQUpuUHp6cXpmM3dadzM2NmxKZTFIMWhLcTJVTkFRMEdD?=
 =?utf-8?B?SDZBVzcvWXZyQXdnQ1E0dyt6Ky9OUU8vbVYrTlVKOTd5cU0wK3JSYk1kY0dq?=
 =?utf-8?B?bUJNTVpnRXpwbXRTVzJRc3FUaFJNcmtNcGI1R1MzNXRJM1hWNzBmaXBWUHQ3?=
 =?utf-8?B?aHkxNWczUHp4ellHOFdRVEdaYkREaTd5YkYrTjVpU2VPQW9jcVdDTXFVOFVv?=
 =?utf-8?B?WVhsRjBLd003MUxjMFducmdrQUQ4aU4zeXdQYlNaV0pudVdUMnFyWXlZR0lp?=
 =?utf-8?B?aW9EY3lnbmwvZWdBa2VpZnR2cjFTYlJ4bXVIWjBtbUo1ZGFhSWhxTnJwNmZ0?=
 =?utf-8?B?cEhRRlJMU2pWOWgwMFZiOFpSaWhMNmM0Sm1TdVpYMklsM09iQVNTWHBjaWJa?=
 =?utf-8?B?ZDkydGQ5WXNpWVczY3pGbzBSWUlSVzNHQ09ESUVwbzVVNlFkOHRwYWVkK0s1?=
 =?utf-8?B?em55eVkxSU5nM091RVBOWlN4NUFDY0k2WGFNb051TkJzUXR4dkJNd1owYVVx?=
 =?utf-8?B?cmpMbEV6Qm9TNVh5ZURsZGZiYmFOU2dnZVJPR3B1ckIzR3lqRnZLL1U1aVZI?=
 =?utf-8?B?VEFMaldvSjBKWDZiNmlqQ3VMWlZiSEtUdmpNa3B2aXYyb1J5TFcwalRNSjdC?=
 =?utf-8?B?SmE4WVFQUmdRcHBlc29Za0p6aDh5djA4UHBjQWprbEhuTE11QnFrR0RqREN1?=
 =?utf-8?B?QndaM2taTFNtajdlc2kyUWlzbE5lN2F0NkxWMjNUU2k3QnBuVGtkMDJPaWlz?=
 =?utf-8?B?RnVYQm9CQWFnV0N5UGlkMk9rRWpEamN3WkNPVjVHdnlOSy9NMVhKNW5vaFhi?=
 =?utf-8?B?QzZGVFo0RXJnT240TnRTSndJU29mWjhMSDd4WE9rdW5NOG5kYVpGTnQzM0R4?=
 =?utf-8?B?bldmSEUwaTljdUk1YmtYQ0JkSXlXUWdKdW1NYzJ4MEZyMVN1K2xUMFNRZm8w?=
 =?utf-8?B?SGxHaHV0aUtEWjVCUnR1SW16cnFWR0xvL3BwN3dWalpWL25qck9OMEwyYlAr?=
 =?utf-8?B?WkYxRmErOGIzemRyNTN1MXlZK0diZGEvNHhaM1Y2S1UyV0J1TjA4NUs5TFVq?=
 =?utf-8?B?T2U2NUJCd09lR1ZaWnQrbmNZRStlZ3FiTWIzMDJMcE82dlVJdHV4a2EwaGpU?=
 =?utf-8?B?TUd1M3A5RFVlMWlvK0hmZS9VdTZKeVIwUW5sc0ZPWEJsWG8ycVVFVFF0WVFP?=
 =?utf-8?B?RmIwQ0txR3h5R2QyNU4yQlFjWlA4UU94NXg0NGlFNUFEVVVBQW1abjVUemdt?=
 =?utf-8?B?c2QzRVdvSmpxK28vaHFPRjFiTzJUamRWMmo2M3lBSWVObU03czV5OHF6VmpG?=
 =?utf-8?B?OEtUQnJZbldpYzBKaVAzN3JQblJ4bFZwdGtaL2dwUjZqN3FtcGlRTXFxK1Ix?=
 =?utf-8?B?MWhtdVpjSUFEbUtJREhjVU9lWUtCd3h3QTdLTGE4d21zVDl5OXp4UTQxWlRl?=
 =?utf-8?B?NEVTZGpMbWdpalNzUjRYR3Nudm1UdUtBYURKN2dmWUJKUVN2N29zZ1JqeG9C?=
 =?utf-8?Q?lEpdCGDQJN8Rvzu2tp0X80N67mAfeu+uNOhx0uj?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 083a80a4-29bc-46a1-0429-08d93cc1fb44
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 18:56:49.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dggxTvLJnDwLtAS+dgMDpMsWueyB513HTZoZmftz5P4nahy9al67Pr3+M+BGyF9YtmkQ/nSD+s57xWTZOoIAjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5144
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes at least one oops when using the DCP on ULL. However, I got
another Oops when running kcapi-dgst-test.sh from the libkcapi test
suite [1]:

[ 6961.181777] Unable to handle kernel NULL pointer dereference at virtual address 000008f8
[ 6961.190143] pgd = e59542a6
[ 6961.192917] [000008f8] *pgd=00000000
[ 6961.196586] Internal error: Oops: 5 [#1] ARM
[ 6961.200877] Modules linked in: crypto_user mxs_dcp cfg80211 rfkill des_generic libdes arc4 libarc4 cbc ecb algif_skcipher sha256_generic libsha256 sha1_generic hmac aes_generic libaes cmac sha512_generic md5 md4 algif_hash af_alg i2c_imx ci_hdrc_imx ci_hdrc i2c_core ulpi roles udc_core imx_sdma usb_common firmware_class usbmisc_imx virt_dma phy_mxs_usb nf_tables nfnetlink ip_tables x_tables ipv6 autofs4 [last unloaded: mxs_dcp]
[ 6961.239228] CPU: 0 PID: 469 Comm: mxs_dcp_chan/ae Not tainted 5.10.46-315-tiago #315
[ 6961.246988] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
[ 6961.253201] PC is at memcpy+0xc0/0x330
[ 6961.256993] LR is at dcp_chan_thread_aes+0x220/0x94c [mxs_dcp]
[ 6961.262847] pc : [<c053f1e0>]    lr : [<bf13cda4>]    psr: 800e0013
[ 6961.269130] sp : cdc09ef4  ip : 00000010  fp : c36e5808
[ 6961.274370] r10: cdcc3150  r9 : 00000000  r8 : bff46000
[ 6961.279613] r7 : c36e59d0  r6 : c2e42840  r5 : cdcc3140  r4 : 00000001
[ 6961.286156] r3 : 000008f9  r2 : 80000000  r1 : 000008f8  r0 : cdc1004f
[ 6961.292704] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[ 6961.299860] Control: 10c53c7d  Table: 83358059  DAC: 00000051
[ 6961.305628] Process mxs_dcp_chan/ae (pid: 469, stack limit = 0xe1efdc80)
[ 6961.312346] Stack: (0xcdc09ef4 to 0xcdc0a000)
[ 6961.316726] 9ee0:                                              cdc1004f 00000001 bf13cda4
[ 6961.324930] 9f00: 00000000 00000000 c23b41a0 00000000 c36e59d0 00000001 00000010 00000000
[ 6961.333132] 9f20: 00000000 00000000 c13de2fc 000008f9 8dc13080 00000010 cdcc3150 c21e5010
[ 6961.341335] 9f40: cdc08000 cdc10040 00000001 bf13fa40 cdc11040 c2e42880 00000002 cc861440
[ 6961.349535] 9f60: ffffe000 c33dbe00 c332cb40 cdc08000 00000000 bf13cb84 00000000 c3353c54
[ 6961.357736] 9f80: c33dbe44 c0140d34 cdc08000 c332cb40 c0140c00 00000000 00000000 00000000
[ 6961.365936] 9fa0: 00000000 00000000 00000000 c0100114 00000000 00000000 00000000 00000000
[ 6961.374138] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 6961.382338] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[ 6961.390567] [<c053f1e0>] (memcpy) from [<bf13cda4>] (dcp_chan_thread_aes+0x220/0x94c [mxs_dcp])
[ 6961.399312] [<bf13cda4>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d34>] (kthread+0x134/0x160)
[ 6961.408137] [<c0140d34>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
[ 6961.415377] Exception stack(0xcdc09fb0 to 0xcdc09ff8)
[ 6961.420448] 9fa0:                                     00000000 00000000 00000000 00000000
[ 6961.428647] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 6961.436845] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ 6961.443488] Code: e4808004 e480e004 e8bd01e0 e1b02f82 (14d13001)

where dcp_chan_thread_aes+0x220 is the line

	memcpy(in_buf + actx->fill, src_buf, clen);

in mxs_dcp_aes_block_crypt. I also tried with the following patch
instead of the one included in this series:

---
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f397cc5bf102..54fd24ba1261 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -367,6 +367,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
                                last_out_len = actx->fill;
                                while (dst && actx->fill) {
                                        if (!split) {
+                                               kmap(sg_page(dst));
                                                dst_buf = sg_virt(dst);
                                                dst_off = 0;
                                        }
@@ -379,6 +380,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
                                        actx->fill -= rem;

                                        if (dst_off == sg_dma_len(dst)) {
+                                               kunmap(sg_page(dst));
                                                dst = sg_next(dst);
                                                split = 0;
                                        } else {
--

but got the same oops. Unfortunately, I don't have the time to
investigate this oops as well. I'd appreciate if anyone else using this
device could look into this and see if they encounter the same errors.

[1] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-dgst-test.sh

Changes in v2:
- Fix warning when taking the minimum of a u32 and a size_t
- Use sg_pcopy_from_buffer to properly deal with partial reads.

Sean Anderson (2):
  crypto: mxs-dcp: Check for DMA mapping errors
  crypto: mxs_dcp: Use sg_mapping_iter to copy data

 drivers/crypto/mxs-dcp.c | 81 ++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

-- 
2.25.1

