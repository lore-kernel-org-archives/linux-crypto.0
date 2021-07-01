Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42972C11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 18:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CE461410
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 18:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhGAS72 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:59:28 -0400
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:26413
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233516AbhGAS7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 14:59:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MreYklSR3+DKNZmlXvVypsS1ihvlC+BRekFbDCInAOH36DaC7djahEKyNxYJ0jWinB6Qnn7aQodvsqm0qylYosx+VjH0BMBcpXnzw0D7nm5Q7N4UXIOxShNEzNqUxCYC+tDKnIvjyDokzPt4yNJoplZeU/UAFi0L6fmbJ/GPpetnON2+XI5GQLywl2pZPfp92DgUgJPJOOLW88JaztmqTMMzEaP64ANFfJ7Klrgt4rHtORNIb4lA2E00GjctyonQZPz9pwq3uVEchQt9809RwPJnUQqrgjkcD2RpHI25rgbSNu2VbeLnG13+sGF/+L6OyFfEc74O6LGl4Ue3fwaTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xh3qEABbhE8vLDtU0XdLAoYlnf2IRmU9F/WPjCprbpU=;
 b=ILbgpDsZdZdR8isxmd65iLyNCzqqQhzaXLs5mrQkQvWYN1Ym/JvTgMNjNATstWHUHapcJMOX1YC2NMsPC1e/hK7i/ilhHHQoiLI6P3xb7QKtJH/Xm8CRCyJBbhwyQ9h5jm/ERSGbj/DmC6qbQthw8N52D5icXI9fj0+B6o2tjTE6u9eV2jqa98EnHqYKhRnBYI0D1fyeZ3joNMgztNdBrpGgaT19JMHuCdClrhTHU1pxrtuJfSvi0T5hbN8I4kZPvPbA8TdbsyJ7khqlcKXt6AqGvHDlORSyxh15CFJ+ttUUK0SM6LOXSpu0jlCnqXmZ9QWNEss96kZN6LPDWHmHUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xh3qEABbhE8vLDtU0XdLAoYlnf2IRmU9F/WPjCprbpU=;
 b=HuWywUeORy+xCTVhZTiwEoeNfSgn2z1+rgTdn9UgjcShD7RB2MMdSRNtRYcVJh/7scHPkRQYXhIgCncnbiwQCesrEcNFOAMntCoEjKGmDb1P23MxkLeAx/RPcOzyPH2XmNZOi0W+4T6+zrpEP3Xp0F+9TsztKbWcNqtRXcw3RCo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4618.eurprd03.prod.outlook.com (2603:10a6:10:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 18:56:52 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 18:56:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v2 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
Date:   Thu,  1 Jul 2021 14:56:38 -0400
Message-Id: <20210701185638.3437487-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210701185638.3437487-1-sean.anderson@seco.com>
References: <20210701185638.3437487-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR15CA0050.namprd15.prod.outlook.com (2603:10b6:208:237::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 18:56:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 831e7b3e-0f94-4570-5c75-08d93cc1fd28
X-MS-TrafficTypeDiagnostic: DB7PR03MB4618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB461869994B49B7B73EE641DF96009@DB7PR03MB4618.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6x5BXGl+lxN+mUFBKAMspm/Jmf8QAldxB8SYT+WNPF+o5Y1gij7C1twZNXCdMdc6E8XFwNab7y6beAmyH0LbiK2JXfJIJHUFgYsA5rb78neCI6RQhuXYWdlZBY8+/245Zvgi4McJmEYJ00775JdWDY2D7o/fsfKfVZ+ng3mmKxIZoaoKQqNAn8G7hSCnYL8v2uZ0ikEI4M8zNYyzbueQwtPg2C2OdzV8k9fuNGtKF+secnhfplXun19RqoRiL7l8ua8y32W0mOUKu39lsPSmRNoWThnmHNEGm0VTuvBbTZ0proHSq2ZoszPBtZqvdA8pe8ClrkLhUuszuAxm/FxrW0Cwhwa8H2fRN0s9NaEeG90WWvgbzJe+6kLs4urnCi0jU9QybwPHsdW7/qi8oUi8U7YU3fPWcKNGWAGhiSlO84S+TW0WFgaR6hgXoTp0jqgsh/k43JFN2LKO1AzlIxU8FhNlfNDu3xWIyuk9sk8tV7E04x1OV2vTfRJXKYzccGvQIF4nGwN/qgHsTFCd495Taies9oEsvzoHFFvVFZiaACDEauL+Zx3sBWAMxN8YZmbiAKIEPbDWeWJuVb0SJBkv2mRM14jzYxFqMWQqZWbJrQlq8cMx0k9tBmTPKnmzqkxgZMFVEd0q7RzyjB83Cw/ABvD5xZOO6fhlKVGPJCB8IsMzWtfyhsgG6QCUdAkrsH1V0zHu7yKREYKyK1LkYTGiKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(39830400003)(396003)(54906003)(6486002)(110136005)(6666004)(316002)(8676002)(66556008)(38350700002)(83380400001)(38100700002)(956004)(6506007)(66476007)(186003)(26005)(66946007)(16526019)(45080400002)(2616005)(478600001)(86362001)(2906002)(8936002)(1076003)(4326008)(5660300002)(6512007)(52116002)(44832011)(36756003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3dyaHNtUDIrMW55Y2NwUzZkeFV1c2hCaHNVM28vcHNzMTNOQ1FUYWhzYi85?=
 =?utf-8?B?VHB0djBiRHpYbURubTJkNTJBaEJSYW9QbjFacHFaREdBeGZSZzJJS1lhaTFy?=
 =?utf-8?B?bDA5NHNwRXFkN0gvM29rZTVyVjNNQXdINHFudEM5aU52cmRWdmVEQk44WHBo?=
 =?utf-8?B?TGZEMDFsSE9URXU1bXZjQVAvYnJSVEplMTUyd3BpWmdwYjFVMTJuTmNGSVNF?=
 =?utf-8?B?TmFBV1lBMXllTExyOStyVnNzclNyMjZ0Wkd6MmJuOHYwNk5SUjN4R1FYWGZ6?=
 =?utf-8?B?MEtTMi91RVEvN2pjUzNVWGVaVnR2NnR2VnYyUUlwWE9XVnZyckFTckN5dXJ5?=
 =?utf-8?B?VXR4YXpwLzNhY050anE1alAzVDh6RGxSTkNYQTJOTklLVi80RUdZVFZyU0w5?=
 =?utf-8?B?bU96TXhRMTRpYTZ0V3hKcnduY0pTV3ZKbVNaaW8xUHpkS1hEMVhKV1RtdkhF?=
 =?utf-8?B?TStNOXdMZVlwNkJTbWlodFpjR2tGU21ENTB1WTd4YTdvaklBU01KWG1LY3VB?=
 =?utf-8?B?SUhnR2h3Z2pHMkJKUS9uWEFNdkxrWlJVancrNE8zVEFQQWJWUWRhdk5MQnN5?=
 =?utf-8?B?eFlQQVFKZEZSZzJYSk9rcDN3UWxzenljUkY3YkxGbERoNVdGYmt4U3BFTkgz?=
 =?utf-8?B?d0x6Q1lQeUhwb0hxUjVibTFRRGk2Q0pDLzdmNk5uMmVzYnplaGMvNFMrcXhV?=
 =?utf-8?B?VVFwb2RxNU9mclAwYU9ZdmlJZnRuQXdMRDAxQVVoUnFXajdZR0QvQXN3Wk5K?=
 =?utf-8?B?aTF3V3BKZDlVdnM2VDMvS09lQ1RRQXZEM0xJVmVMNG1JbnFiaG1IaWJQd01s?=
 =?utf-8?B?ejVoUmx4YjhGUG1ZUFVTS0NUanBGU1BhbGdzMWJwUVdWazF5MzJVWGdYcGV3?=
 =?utf-8?B?NzA1aXlpOC9CZ0JDWnd2RFkwQ1YrSkdKNVIzMjdHeVVrMFZwWTQrTmtHY3ZK?=
 =?utf-8?B?TnBmVXFWNkw5ZzBMZ0dBK2xEZ0VjUFRQdW1VcG1NYW82cEF4NUZnQ0lxd1h4?=
 =?utf-8?B?elJpNTZOK1VOUDI0a3EzV1BQMVJWOGVZVEVHaUMwQzlQWlJjcUw4Q2NLWjRK?=
 =?utf-8?B?NlllRFZGTVNQZldZdUI1clJHbUhVT0QzVzdobzRWRGwvYjBLaWxXdmlWaGxZ?=
 =?utf-8?B?Y2pnNkFxc1dOWjZKSmhJeVRrcVUrYVhQOVRsZzlYSko1SXJYdzFNdnhHeU9I?=
 =?utf-8?B?bzJHQTJXVmt4VmJUa3RDdzVsK0xhNlNIMXF0Nld6SXpqUzVVMk1jVUZxdmdI?=
 =?utf-8?B?Um1vZUNKS3dWSVNGUG9ZZzNURGdZdEZiRWltTEdvSGs0NEtrZFYyNnViU1Vs?=
 =?utf-8?B?dXJEVXBCMlpJc2F0WjBIbHdMZnJSclpKTGJHMUVGSE5qeEdnRjRjcjlENlhp?=
 =?utf-8?B?dDBEYXY1Y2VoSzZjazdYNnhGdEkxMFNEcXpLSko3YUtEL1dVWFZGUDJjdDFM?=
 =?utf-8?B?RFZlaDdmeHhIa0VITlBDN1BxTllNRTU0MmNreTl3YzZvbUVsdzZPcGFrMjRK?=
 =?utf-8?B?V0RNZzFQSHNjLzhYRHhUaUJQNmY4bGtRUFovT05jem12a3RLYnE1K1VpMG0r?=
 =?utf-8?B?azRiVFJ2MWZNQk5BRnR2dFBzUlRneHJiK2gzVFJuQ29yTDd0YitHYnBHWENJ?=
 =?utf-8?B?V1FmSUNJbk5DNURwazFYZmxjQ2lYc3VmZmZnQmVBS1VmbW81Z1NSSEVkNy9Z?=
 =?utf-8?B?R0xkS3V0Tm9zY01ROWVxeVZLa21oVEFqT1VrM0dXelgyblBCUHY2RUM2YjRQ?=
 =?utf-8?Q?eyZoJXSPsCFCq/DkJ5FbJV8VGO0g66NcXT6Dwp/?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831e7b3e-0f94-4570-5c75-08d93cc1fd28
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 18:56:52.4640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHZM0tNOxcHsqS7EKsaDvj/U1rgfA0v4sJBKzQe7cRswr+zL2x+SBPANk+G7LIe8wsNwUNoOenNQpJGCuEjyrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4618
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This uses the sg_miter_*() functions to copy data, instead of doing it
ourselves. Using sg_copy_buffer() would be better, but this way we don't
have to keep traversing the beginning of the scatterlist every time we
do another copy.

In addition to reducing code size, this fixes the following oops
resulting from failing to kmap the page:

[   68.896381] Unable to handle kernel NULL pointer dereference at virtual address 00000ab8
[   68.904539] pgd = 3561adb3
[   68.907475] [00000ab8] *pgd=00000000
[   68.911153] Internal error: Oops: 805 [#1] ARM
[   68.915618] Modules linked in: cfg80211 rfkill des_generic libdes arc4 libarc4 cbc ecb algif_skcipher sha256_generic libsha256 sha1_generic hmac aes_generic libaes cmac sha512_generic md5 md4 algif_hash af_alg i2c_imx i2c_core ci_hdrc_imx ci_hdrc mxs_dcp ulpi roles udc_core imx_sdma usbmisc_imx usb_common firmware_class virt_dma phy_mxs_usb nf_tables nfnetlink ip_tables x_tables ipv6 autofs4
[   68.950741] CPU: 0 PID: 139 Comm: mxs_dcp_chan/ae Not tainted 5.10.34 #296
[   68.958501] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
[   68.964710] PC is at memcpy+0xa8/0x330
[   68.968479] LR is at 0xd7b2bc9d
[   68.971638] pc : [<c053e7c8>]    lr : [<d7b2bc9d>]    psr: 000f0013
[   68.977920] sp : c2cbbee4  ip : 00000010  fp : 00000010
[   68.983159] r10: 00000000  r9 : c3283a40  r8 : 1a5a6f08
[   68.988402] r7 : 4bfe0ecc  r6 : 76d8a220  r5 : c32f9050  r4 : 00000001
[   68.994945] r3 : 00000ab8  r2 : fffffff0  r1 : c32f9050  r0 : 00000ab8
[   69.001492] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   69.008646] Control: 10c53c7d  Table: 83664059  DAC: 00000051
[   69.014414] Process mxs_dcp_chan/ae (pid: 139, stack limit = 0x667b57ab)
[   69.021133] Stack: (0xc2cbbee4 to 0xc2cbc000)
[   69.025519] bee0:          c32f9050 c3235408 00000010 00000010 00000ab8 00000001 bf10406c
[   69.033720] bf00: 00000000 00000000 00000010 00000000 c32355d0 832fb080 00000000 c13de2fc
[   69.041921] bf20: c3628010 00000010 c33d5780 00000ab8 bf1067e8 00000002 c21e5010 c2cba000
[   69.050125] bf40: c32f8040 00000000 bf106a40 c32f9040 c3283a80 00000001 bf105240 c3234040
[   69.058327] bf60: ffffe000 c3204100 c2c69800 c2cba000 00000000 bf103b84 00000000 c2eddc54
[   69.066530] bf80: c3204144 c0140d1c c2cba000 c2c69800 c0140be8 00000000 00000000 00000000
[   69.074730] bfa0: 00000000 00000000 00000000 c0100114 00000000 00000000 00000000 00000000
[   69.082932] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   69.091131] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   69.099364] [<c053e7c8>] (memcpy) from [<bf10406c>] (dcp_chan_thread_aes+0x4e8/0x840 [mxs_dcp])
[   69.108117] [<bf10406c>] (dcp_chan_thread_aes [mxs_dcp]) from [<c0140d1c>] (kthread+0x134/0x160)
[   69.116941] [<c0140d1c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
[   69.124178] Exception stack(0xc2cbbfb0 to 0xc2cbbff8)
[   69.129250] bfa0:                                     00000000 00000000 00000000 00000000
[   69.137450] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   69.145648] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   69.152289] Code: e320f000 e4803004 e4804004 e4805004 (e4806004)

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Fix warning when taking the minimum of a u32 and a size_t
- Use sg_pcopy_from_buffer to properly deal with partial reads.

 drivers/crypto/mxs-dcp.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f397cc5bf102..d19e5ffb5104 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -300,21 +300,20 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *src = req->src;
-	const int nents = sg_nents(req->src);
+	int dst_nents = sg_nents(dst);
 
 	const int out_off = DCP_BUF_SZ;
 	uint8_t *in_buf = sdcp->coh->aes_in_buf;
 	uint8_t *out_buf = sdcp->coh->aes_out_buf;
 
-	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
 	uint32_t dst_off = 0;
+	uint8_t *src_buf = NULL;
 	uint32_t last_out_len = 0;
 
 	uint8_t *key = sdcp->coh->aes_key;
 
 	int ret = 0;
-	int split = 0;
-	unsigned int i, len, clen, rem = 0, tlen = 0;
+	unsigned int i, len, clen, tlen = 0;
 	int init = 0;
 	bool limit_hit = false;
 
@@ -332,7 +331,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, nents, i) {
+	for_each_sg(req->src, src, sg_nents(src), i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
 		tlen += len;
@@ -357,34 +356,17 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 			 * submit the buffer.
 			 */
 			if (actx->fill == out_off || sg_is_last(src) ||
-				limit_hit) {
+			    limit_hit) {
 				ret = mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
 				init = 0;
 
-				out_tmp = out_buf;
+				sg_pcopy_from_buffer(dst, dst_nents, out_buf,
+						     actx->fill, dst_off);
+				dst_off += actx->fill;
 				last_out_len = actx->fill;
-				while (dst && actx->fill) {
-					if (!split) {
-						dst_buf = sg_virt(dst);
-						dst_off = 0;
-					}
-					rem = min(sg_dma_len(dst) - dst_off,
-						  actx->fill);
-
-					memcpy(dst_buf + dst_off, out_tmp, rem);
-					out_tmp += rem;
-					dst_off += rem;
-					actx->fill -= rem;
-
-					if (dst_off == sg_dma_len(dst)) {
-						dst = sg_next(dst);
-						split = 0;
-					} else {
-						split = 1;
-					}
-				}
+				actx->fill = 0;
 			}
 		} while (len);
 
-- 
2.25.1

