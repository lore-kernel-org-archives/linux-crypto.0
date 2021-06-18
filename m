Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A2FC49361
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 21:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9770661261
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 21:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhFRVQo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 17:16:44 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:47206
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233725AbhFRVQn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 17:16:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWaYFnjhQOvy2nB3mL7O/XZdz9ohkQzaIlzM5pY1t7Dw7zzaoYH+dMYLrCv15SjKhnN4Dvse7Z8hKzd+K6zgtZ3jPyOzuBAgiok/mGMDM1VEiOwF2vdvgrO1qfK7BUGIPEw/rdWMzgZ6wwEs5595NLhIOzmNdbExLyMEDAWSFlNayjXms47ZUEBDhjXOgmzsVZucBdUewdLnPKZ7vrqJwjV4qgEUQaf9KHVXGR5tvcvs9JCHBSJXKVmmlDn3WqwE9ztEjMbhkqoP2jcIIQlRhiKecUeeA/Kms4bJubP45pzg/a6lN56v/HEoRtSDckyvQeGEaGkiwT0QzWKK3HF4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvxPr0+O//CkYJu24UkFiUkqCz+YfcRGFxO6GsUpURI=;
 b=IihfPu24LmH5x70bwN8n1pmIBguQY63EARFgPaVvTp85MQi+WhN4ubblItA7H7Hsz99rHsK+f8svdjd7lvRh/skBENBaCo27V0TMgmbgd0t2BbF3J2dK1d6dlEHCnHTCYCaCKJtVD2AwSqUQcSYV8QTDRP6nb8xLFBazqNV/u5Rn7wujrhVF2JY9nA2shdV334W/N8hOHAIDWRLRmM89xRL8bqj5ibti6cvqJYQ4UzqYRre/6TJ0DgjrZCzQDGbS/WRYNZgUQ+AET8E+77hD/qRwv3Hdbdz4aikCN3rM9k0XhbaqKICxxtvUGzzTQDGCpZwc/IThx3fA6TE8dRMCCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvxPr0+O//CkYJu24UkFiUkqCz+YfcRGFxO6GsUpURI=;
 b=DU8z+BkAfYHOG/EKKRI8BC3KY0BAOrKmlb8eQw+c8DcNbNR2zcP/hajguTazv8qbUnHWEiz8mB1V5fgG1RySW+nKQMHP66JFZB44VcDQhjstjtiqhSIpKg+IrzcJs9nbNoVh7l7yUs68QUFINNwXdnThk4lbNF+RwRBBx8i8zoo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB7129.eurprd03.prod.outlook.com (2603:10a6:10:206::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 18 Jun
 2021 21:14:30 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4242.019; Fri, 18 Jun 2021
 21:14:30 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 2/2] crypto: mxs_dcp: Use sg_mapping_iter to copy data
Date:   Fri, 18 Jun 2021 17:14:11 -0400
Message-Id: <20210618211411.1167726-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618211411.1167726-1-sean.anderson@seco.com>
References: <20210618211411.1167726-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: BL1PR13CA0244.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::9) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plantagenet.inhand.com (50.195.82.171) by BL1PR13CA0244.namprd13.prod.outlook.com (2603:10b6:208:2ba::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Fri, 18 Jun 2021 21:14:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a845748-870d-4f9f-b958-08d9329e0fb1
X-MS-TrafficTypeDiagnostic: DBBPR03MB7129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB7129016688ABAAC4599FB0C4960D9@DBBPR03MB7129.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 11P6FBPbv3k7DO7bCP7mB669ljctvL90uQT1D+Zvor7VFDpZwxpnYPHAagOgqbtF3NrLpwwwXSRTT6unh0CId3QXpox5ep1CnGkITREPjt/SW/5Xc0I7Kuslp2oAe++VHD8fx6dAuisO/rP0ZIqWQaEFgAkd7hQ2T6//TQ8H2k8Pmxj7aTZ7qw3SQAoL0eSTUKzwL5n8KqwOPfYY96hm2dJQxgDalNtXoTxeac9FrPGtjJuIJnSdcwnKcQoCxKkK6Wuu8OuUVpSNJhzYMtLN7Jh1a6gW52Fn/JwtPCx4YhjPMW2MtoFzwsdSOUsOT1VP8iXBulqxF9ozr9XXPxQ7Nkn1X0jABM72wi5dqHZVqDVOOID8TlN++tYbyRmwgUX6aTtV3Ox/kOnHBNdQs11Q8Eyaqt/XYzXwULRCeEaeIrJP3zqeAeUGP4LPXOestFW4tFa11p3i9/8JXbrdYwlr0xS2Gd+vnUYhCqgpbRuOw1YkDsOJWZeIOxR6iV9O6HNoTC8lhdv+DbbtiCdpTgutcCaoGOSWuPSrDGi0JqI0hudt7WJiwoF103dBCNkwyvMULwdQhFSZtKKFvnPpaH+1K9lRVW1/QUHh/xXTxwOwL1h0NcVPf6DvkIsbk/1bMQ3w5inRmNbvtOR9okpnboOq5HFnIg0nxVLW/+k3tNzS4xk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39830400003)(136003)(396003)(4326008)(110136005)(16526019)(66556008)(66476007)(54906003)(956004)(83380400001)(1076003)(6666004)(36756003)(478600001)(8936002)(8676002)(44832011)(45080400002)(6512007)(316002)(6506007)(5660300002)(52116002)(86362001)(186003)(2906002)(66946007)(2616005)(38100700002)(107886003)(26005)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2Y2Z3NWTENWdE50ckpUN1Z1UW9HemdiZ3ZhMGE4YmdnZnc5QWdCSThpV3Y1?=
 =?utf-8?B?UDU5V3JUd1FBU3J6NklPb0VPZlExWjJVVFRZWDVOcG9nb3BVbGhkaVcyK216?=
 =?utf-8?B?Lys3cGEwQUtHM3ltdlh0MUw5SnI1aGlLK1BJc0JoS1NzNzJVOGVOU2hwQ2lo?=
 =?utf-8?B?MTN6UkVZSmZsZi9lMmppa0RkckdKVnBIVUxFTWljeWtpL1ZjaTVjTjhMZ01P?=
 =?utf-8?B?WktaTGdMaEJ5dTR6TVV0bG9BK0NPU21uN05UMkdtckJGc0k5bXRsdWJyS3Bp?=
 =?utf-8?B?YnFlcE9xVVQ5UzNNaFFZNG5xMGluSUJpTDkwOHhsWWdRU0U5V3pPK3lVUHcv?=
 =?utf-8?B?eFN0SzhodXR3WmFvZisyQWZrMXJpY2Z6NUQra1lJMjRuSnhPb1BzbHJRc1NZ?=
 =?utf-8?B?UExmaVN5NEJVTytXU1VHcHl3VVBRTWZacVJRNHdrT1FxN3VyZlVpWFFzaFhn?=
 =?utf-8?B?dndLMmZrL1pBK3BiOWhPT0gzYXBVdVgxOXY2Z3dDN3lBemZkQmNnQ29KTUxa?=
 =?utf-8?B?RHY1TFRIWHFRcGIzbjVqTEVTbm1INWIzdXZLcGVHcjB5b1FtZ0tLWkpuMktF?=
 =?utf-8?B?VE1SN0RFcmNrRExUaVBwWldqUm5sTkNTUmtvRkZVTGFNYmJIVkdJTmxwQm1F?=
 =?utf-8?B?YzI2MWQ2TEF6aFM4aFRjSi90eFdqU05VYUo2cXpEZmZjSWRCVk5tWUNFcnho?=
 =?utf-8?B?N3hNY09USzNvQXZzQjRFblZ0ZVhJR0wwUHJmaE1MN0tMYk9helZMK0VpKzB3?=
 =?utf-8?B?MGpJcnRIc21tRzlwQTZkTkxQak9XRkZ3N2lPMG1rdjBuRW54VGRrOXNyanI2?=
 =?utf-8?B?S0NuUlR0UnFOK0pzaDNHOTdxYnhRYkFNUlRra3UrWnhaTk55OXNxQTcyNlRh?=
 =?utf-8?B?dWxyYXd0Q3RpdzV2Q2RTWmltNGFJUGtwNFRmREQ1NXhJSXV3Qk1zZVNoNHJV?=
 =?utf-8?B?RURjYktkTUw4MXdZMmlMUjJOTEpJVXZGakNROTJEVXltbGdVbWhQcWg4UXFC?=
 =?utf-8?B?bVRMUGd0cmVvMnJ0c0pUZzhrLzhzR1BtUE55N2V0SDRwQ0I1bW54UkNQN2gx?=
 =?utf-8?B?djV5dnlnT2ZzQ0xVQUREZitpSFZBb2g3a3k1c0laUDZaNlErRkwycDJDMkl0?=
 =?utf-8?B?dGk5d2F4S21qZ1JvRlh0ZmFhRUhIK1JKaE9EcVl0MG0xL2w5anRkUFVSZGcw?=
 =?utf-8?B?VkpwdkZLMVlPN0JGK2YwMExUWkxBc2I5ZWM1Y1hSQTJHcGsxVnZrZ3RnOEJU?=
 =?utf-8?B?L3JudUlGQWRTUk5nRTREd0tHYnVTblZyajhrWkNhVU1DY0JEa1hXYVNsZ1VR?=
 =?utf-8?B?ZHFiMVNNTmxPR0FYOFUwK21hSmJxNGFLUGN2bkdOTHdGMjI4RnhITmxCWHNq?=
 =?utf-8?B?d3hYRlRweG1tdEMyQTV3S1d5dDl3aXhvSXpZZjhjY0hSYkFTQVA1Qy9yb3g2?=
 =?utf-8?B?RElYZGlGenNkTDl6dUt4aDFiV05wY3ZyWTVxbFRmczIzcVNhb0laSzVVZEhY?=
 =?utf-8?B?emwvNHduM3NQYk5MQjNFdFBSSmZYcmhEejRYTmpsTVN1bWNOQWNBUDVHSENl?=
 =?utf-8?B?Vy9xR3Yxa3B3Y2pQK3RKMUdrZW9FTTAvdWp3T0NpYk9EVEJaa1Z3R3lrSlZQ?=
 =?utf-8?B?cURaQzVlbUFEbWY2Yi9ab0VYcmV6ajBlQzZSeGgzSDlrM0swWkluMWl6cEhD?=
 =?utf-8?B?K0JNcFlsQUR3UVNBODI1L0FobncyUHNyMjNXT0o0T1RreVhnc0xQTlZCNDZm?=
 =?utf-8?Q?xm3PGintRMoc9aVpzjWsW5EJDiAHLBNNIs9pgcW?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a845748-870d-4f9f-b958-08d9329e0fb1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 21:14:30.0002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tF7r5nc8rVQcZVTYYkP2OaLd+1urbRYr4cIKy9Uf0TB1C9oUTVnzDawvvnepMXP4POq8yv2UD8iJr1jQJTHqcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7129
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

 drivers/crypto/mxs-dcp.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f397cc5bf102..5d2670a70e46 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -300,20 +300,18 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *src = req->src;
-	const int nents = sg_nents(req->src);
+	struct sg_mapping_iter dst_iter;
 
 	const int out_off = DCP_BUF_SZ;
 	uint8_t *in_buf = sdcp->coh->aes_in_buf;
 	uint8_t *out_buf = sdcp->coh->aes_out_buf;
 
-	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
-	uint32_t dst_off = 0;
+	uint8_t *out_tmp, *src_buf = NULL;
 	uint32_t last_out_len = 0;
 
 	uint8_t *key = sdcp->coh->aes_key;
 
 	int ret = 0;
-	int split = 0;
 	unsigned int i, len, clen, rem = 0, tlen = 0;
 	int init = 0;
 	bool limit_hit = false;
@@ -332,7 +330,8 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, nents, i) {
+	sg_miter_start(&dst_iter, dst, sg_nents(dst), SG_MITER_TO_SG);
+	for_each_sg(req->src, src, sg_nents(src), i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
 		tlen += len;
@@ -357,7 +356,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 			 * submit the buffer.
 			 */
 			if (actx->fill == out_off || sg_is_last(src) ||
-				limit_hit) {
+			    limit_hit) {
 				ret = mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
@@ -365,25 +364,13 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 				out_tmp = out_buf;
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
+
+				while (sg_miter_next(&dst_iter) && actx->fill) {
+					rem = min(dst_iter.length, actx->fill);
+
+					memcpy(dst_iter.addr, out_tmp, rem);
 					out_tmp += rem;
-					dst_off += rem;
 					actx->fill -= rem;
-
-					if (dst_off == sg_dma_len(dst)) {
-						dst = sg_next(dst);
-						split = 0;
-					} else {
-						split = 1;
-					}
 				}
 			}
 		} while (len);
@@ -391,6 +378,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		if (limit_hit)
 			break;
 	}
+	sg_miter_stop(&dst_iter);
 
 	/* Copy the IV for CBC for chaining */
 	if (!rctx->ecb) {
-- 
2.25.1

