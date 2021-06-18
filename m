Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16248C48BDF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 21:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D7E61260
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 21:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhFRVQn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 17:16:43 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:47206
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233501AbhFRVQm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 17:16:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAfhi+cRzEFP6MQFhVUcDhgqr9AjxpuPizm4M+m9ZPqDEornjDFD0ymeZtr11mTWJjrMH41mufI3S3oZdQ1S9UN/AOCv/uxB/vM/wsNm2bIiKeCP3695u79C90radvHDpPj/XQXfdIOrRkMzJSHJ6NEnzhw6S6DwjjHb/LhF4+wtma2fC95GKZa5p0GO+3AidMQfy4PdE6aMnphztPPshgCy1cvyk8ZipAO+2teI519zH1sOIqhDn3Kjx85AZa4OTyfWhW7S4qWvnFptzdy1SBHnb8GMSHX7eCUAWWMcLU9lA1kI1tsPD6qAZtV/QeyG2JuDDPa6mVLZtmwZ9TC58A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gK1y8E0HhEKMnSZi0iyyi9TsYQIm4nowwbVB+0nU9PY=;
 b=OWnjfIsV/Q780ElRSVvmLd9a/vk8RtVLKu0zBmNmbxURopt5z6O+bIp3r8aI4jdbBG+ikEv4fyq7Oy0KvH0xUZw8zKFxcpGQf6KlN5R1SpiWyL1pzYaQGTbLaT2Jg6f3pn1NP5hBV9pA6poYuZIzL0Bh6zQCsTXit4rZsNEZCUWB9IulofGWfairj7uXKglCAQeZejhbRCQdjufhx3iIuDCTmD8gWQz5kscN8fKKe3u8T1+TS9nWVECAxlVQB/FsgJ0bGmXkIVczXCisCWFG44RcsTJU8Gx7Y8Bp+VTvxOzd4D5clY1M9ADhWs/ukdLJ24Su5l2ihyhUwDWkeiGFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gK1y8E0HhEKMnSZi0iyyi9TsYQIm4nowwbVB+0nU9PY=;
 b=eEFzhI+Hwgnqj7vFPH9Lm9yC0OCx9QoEmEy9DcGhvCaozr7EnWRqpDO2Kz8qv3onyeV5m3Dv0pn/VqB/o6GI9Suh6sxOg5ZcK3/+gaq4afGjxq98+jhSCNTIbV0HlZhEKle3x5aEkYmazcKSnfdP08MzbVZEgNCDuItAWbwd7Xo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB7129.eurprd03.prod.outlook.com (2603:10a6:10:206::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 18 Jun
 2021 21:14:28 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::40d5:3554:c709:6b1b%5]) with mapi id 15.20.4242.019; Fri, 18 Jun 2021
 21:14:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 1/2] crypto: mxs-dcp: Check for DMA mapping errors
Date:   Fri, 18 Jun 2021 17:14:10 -0400
Message-Id: <20210618211411.1167726-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.195.82.171]
X-ClientProxiedBy: BL1PR13CA0244.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::9) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plantagenet.inhand.com (50.195.82.171) by BL1PR13CA0244.namprd13.prod.outlook.com (2603:10b6:208:2ba::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Fri, 18 Jun 2021 21:14:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68cb1800-f80e-452b-626f-08d9329e0ef5
X-MS-TrafficTypeDiagnostic: DBBPR03MB7129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB71293F8A116B2932F7EF027E960D9@DBBPR03MB7129.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2l0Xloihr+xdzssEEcdbfP1ePxJrOZYJ57mm/wD8eQoo+or+xwsi+goLTjJ6g0gv5gtTpa5Olcnn22MavXB6k5eucv19HFaG6MDHw5HwyZi7eYlO8ac5rJ6ynxRElRHHZdMD6Xe2Ew7sUVL6sLm+PLRltF7K9w1UvPo8Vb3MWwqXQ4NuNHcuw2XJ6ar9Z5kqgWFJmvdkd9aP/h44KfDtWJMBeJZBirUCumT7CGyvn2KDue5X5asqSWEocAaufHZlgTvVgY6Idxy4jXwc/H5po4xgajOr+9iweX5bWGiaGzmfr4dQ7dkKzTtT1VJJBbDjhs5uEfQsGGg/SJGzwBWp+xFVbTvZk6IBPxY8XlRplILl6SMydHlKygcJCWAb/bhafCAHIEHNcQUHID9Z4bU1XIjm3drbWAQ95w50+BXCCttfdXC/ZRKZH+owPEuU+pS8ZY+4escsvMwn4RAPF+q8fMXTvnlJ+0gS9x2X89E4ad6+HdDpd2ZiAc49qrY8fKtNvVIsRaFVfvZ5sUhP003QgbrtrXD61a8YJEzOGB52U04dwqc2zDbDi37Ol4wsJANU2hRHDl0wtT/P7F+aDU+QoaiGO5RmzsYz89Y4/oY6KmQ/BtleMdqlYJ3Nv7UZza1lOs2DMDAvL2vDDYCcilYpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39830400003)(136003)(396003)(4326008)(110136005)(16526019)(66556008)(66476007)(54906003)(956004)(83380400001)(1076003)(6666004)(36756003)(478600001)(8936002)(8676002)(44832011)(6512007)(316002)(6506007)(5660300002)(52116002)(86362001)(186003)(2906002)(66946007)(2616005)(38100700002)(107886003)(26005)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?feSRiWcyvrHOeYvnEJT+Sf3w9oU+VpSjs7hLBxa+nwdn+3arCQABeJaSGN90?=
 =?us-ascii?Q?XvD+BR5pHK74UU01y+/K11gnv+eyqnS31fzaIpDHz5pN3ZQ7JiCl4TsvJtif?=
 =?us-ascii?Q?/TQ2ZE3ubsDZelYq+sLG1RXX488G0bDKa0nDrtiNX4GhxkA8+qiJ3QxZcnBD?=
 =?us-ascii?Q?PzkNGrRl8Tya+xF+oVThhWFyOAsWu431rp8kVwnB1wJ0iNwX8ZaqEhidDY5a?=
 =?us-ascii?Q?w3dwn879Cl9dMatoGsIaCC9ceWpGLRrQ/MVDgLh+CqUqW7jRHvRPkWVuX6Mp?=
 =?us-ascii?Q?yNC0mnc44p/dqHbjJQh2pff1hhR2GRQux38TqxbdOh3qu5CQvXykkwTYY8+/?=
 =?us-ascii?Q?3kBaEnORya90TGcwDHDwvP5hcBGBK8bTI/cvWyHPNxcwzvfsGEU/iiAtNxB8?=
 =?us-ascii?Q?vNonEFPCceTNXznlDAcfP6ACmk4Kv9slkDtYagDaI7DrVHBWJXdnfUMzOZIQ?=
 =?us-ascii?Q?3REabfApRyX95ErDB1iqtpPToYGfjkJMae8uP9NStMiWrbwDCWTN3Zue6RD/?=
 =?us-ascii?Q?HXIA9Y4R97ubRKHjXu3NJCTmqmOLyhHHbExNp5yx5EadQvcMKf/kR8eAVdmO?=
 =?us-ascii?Q?rj7rMgJBD3Rw5RFKS4Ev+JQqLfFtnl/K8o40nMtElUNbn+uks2jGOWnkBP5/?=
 =?us-ascii?Q?WKEfZ3k11Qd/A/i4GYU36AClMfh3mm28pV0qQ4cEUTZGc3iH0+NfhCD70omC?=
 =?us-ascii?Q?1ebWpmdnEYVnVe/JN1Zt5dNUIYO4F+GVTmbHcy39OGiQLgRORQ/Bh+CUrdjW?=
 =?us-ascii?Q?am4WxFiX8bS7pay0k5Ib/cvOq4t80edNDmqQXlp8JPpUG0bVO5j5lBGfGiAz?=
 =?us-ascii?Q?ZLYGXMVDwYQCoEgFNkbbJmu2s85lfsPU9B3wzDPq9IPKXExPcMVQQns7qoJJ?=
 =?us-ascii?Q?ydzUgccu6h0lPWUQvQs2dsGQl+QityypM/7uTODWUSAZ6JKAVKMRnL4nMbkV?=
 =?us-ascii?Q?53Q9sin9lARaPEoKVnqDjaQbh59lD5Kh4ytk6GcSbpnMSWJ/YEd7DA6kY5al?=
 =?us-ascii?Q?8nfSZyXsT8MkuE1dPcbZfefkKpCYcZI4WN6dsFQwhEuwEcKV9oD7u3AYa1WZ?=
 =?us-ascii?Q?exgtO3ukPh+jenPZpT2ElnwaduYcHugU14YKBLXTHf0LICPygnBX8zZvmVLY?=
 =?us-ascii?Q?fg97wwgARIvwKf69D00LZblokgEirI06iPsiJ8vuykt4GmuNcY+nPQfkUQIe?=
 =?us-ascii?Q?9zcKx3uVByOYv9oLWtUnesDtdKe3pDAlEpiMexbgNYvjH12KAce1pND4Ik76?=
 =?us-ascii?Q?wnuuLj0BM2KPILZb3MVEff75g827wbpHqBAkgg11IMswzL+zKNBN04ZtFiv+?=
 =?us-ascii?Q?eEK26Qfps/pBhMPTKEuAgreb?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cb1800-f80e-452b-626f-08d9329e0ef5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 21:14:28.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKFDTcpqxWpDzJw8C6WViST5QqjmGTHdNEa+IOFd+XfJIkOWC4w6MK141bgiifhN29tbF1xMgXBp9tjIe4lzkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7129
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After calling dma_map_single(), we must also call dma_mapping_error().
This fixes the following warning when compiling with CONFIG_DMA_API_DEBUG:

[  311.241478] WARNING: CPU: 0 PID: 428 at kernel/dma/debug.c:1027 check_unmap+0x79c/0x96c
[  311.249547] DMA-API: mxs-dcp 2280000.crypto: device driver failed to check map error[device address=0x00000000860cb080] [size=32 bytes] [mapped as single]

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/crypto/mxs-dcp.c | 45 +++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d6a7784d2988..f397cc5bf102 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -170,15 +170,19 @@ static struct dcp *global_sdcp;
 
 static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 {
+	int dma_err;
 	struct dcp *sdcp = global_sdcp;
 	const int chan = actx->chan;
 	uint32_t stat;
 	unsigned long ret;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-
 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
 					      DMA_TO_DEVICE);
 
+	dma_err = dma_mapping_error(sdcp->dev, desc_phys);
+	if (dma_err)
+		return dma_err;
+
 	reinit_completion(&sdcp->completion[chan]);
 
 	/* Clear status register. */
@@ -216,18 +220,29 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
-	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
-					     2 * AES_KEYSIZE_128,
-					     DMA_TO_DEVICE);
-	dma_addr_t src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
-					     DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
-					     DCP_BUF_SZ, DMA_FROM_DEVICE);
+	key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
+				  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
+
+	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
+				  DCP_BUF_SZ, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, src_phys);
+	if (ret)
+		goto err_src;
+
+	dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
+				  DCP_BUF_SZ, DMA_FROM_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, dst_phys);
+	if (ret)
+		goto err_dst;
 
 	if (actx->fill % AES_BLOCK_SIZE) {
 		dev_err(sdcp->dev, "Invalid block size!\n");
@@ -265,10 +280,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 	ret = mxs_dcp_start_dma(actx);
 
 aes_done_run:
+	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
+err_dst:
+	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
+err_src:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
 
 	return ret;
 }
@@ -557,6 +574,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 
+	ret = dma_mapping_error(sdcp->dev, buf_phys);
+	if (ret)
+		return ret;
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
@@ -589,6 +610,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	if (rctx->fini) {
 		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
 					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
+		ret = dma_mapping_error(sdcp->dev, digest_phys);
+		if (ret)
+			goto done_run;
+
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
-- 
2.25.1

