Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3467C3F2D1
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 10:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E77D2146E
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 10:23:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="VV6L61Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCEKXe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 05:23:34 -0500
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:42574
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725897AbgCEKXe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 05:23:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYX+a8Rb77I3E0wwuCpEqmGW4sfKQ+y1W9+fgp7WYnHWT5h9IQN+KCbWfQaHHkmRliFnV4/eJD+qS/Fe+h5+CG0Bh2cp8aIWYZCRCn7oYMfg2VXQZswvvouJ8xUys9VIOVRnRB0tKqSc4+TYYqsbaOX41D0a9FBA9hIti3SCQIu6q0YRNvg39tXQ5kHECJYljhSpAMQWXMfF1ndPWx/kNqfdhHmvPgl0SPEIwvcfRwwXTqdNDlgvgdr/AIMx+AlEG25MiGgqcY6BbTpC4BdiYmKb4ULpI0rDRDNFqFJoFOLCRUIsyGLzV/RYdG4jDOwOnY3ag08BvRtTFRF99h7u0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0exbbkXHQ2cHuzFW/2uOKkV9aNQc1rpgKk7uwG5zUvg=;
 b=YFcjMCtN6coyk0V/3bEfqCNbh1jjGUU0U2EycUl28567I0hqQL91hESnXqn48PEZbXNuTBhp8bXSFwuO6bgEvy5OpUU54pMZpjFazUI7KVEDnDBk9JcpJRhkbEbvuMt0kESeilIDyCRh2HAHpCKM7hHeqZPLrM+zEZGvXoeYSKtbCfEXJuNjjhbIbuIAXrL3gUSr6AU8HwsBCBxcvSWf8n7/GuX66kgZoDx/ss/zvDVWy/cl+WlqiIS/Xfguv4k9EF2CBW8PgFkWqPujm4b9jnextYpyd4TLx/3oV2inMpctvYpDlbiZk84lKd4LqRuPjLs5zDEIOM/nVImKOhh+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0exbbkXHQ2cHuzFW/2uOKkV9aNQc1rpgKk7uwG5zUvg=;
 b=VV6L61JzUQ1l1T7ZFoQThMYEam/K5CCsBs285bD3wL4OixmBWvyVANlzIiTwWJVhsydLmSJcIATns4yp3GIcuh1e5zAypnxpyzzUBOVlr6g4xHVXp5hadxaEzopHaANZoGB7tjsDu+NgmYnC+DBEucH3UIMm6QfjvdsvVlQGZpc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=andrei.botila@oss.nxp.com; 
Received: from VI1PR04MB5437.eurprd04.prod.outlook.com (20.178.124.33) by
 VI1PR04MB5408.eurprd04.prod.outlook.com (20.178.121.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 10:23:30 +0000
Received: from VI1PR04MB5437.eurprd04.prod.outlook.com
 ([fe80::4c6d:1d2f:bcd9:e639]) by VI1PR04MB5437.eurprd04.prod.outlook.com
 ([fe80::4c6d:1d2f:bcd9:e639%4]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 10:23:30 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] crypto: xts - add check for input length equal to zero
Date:   Thu,  5 Mar 2020 12:22:55 +0200
Message-Id: <20200305102255.12548-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0055.eurprd07.prod.outlook.com
 (2603:10a6:203:2::17) To VI1PR04MB5437.eurprd04.prod.outlook.com
 (2603:10a6:803:d8::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (212.146.100.6) by AM5PR0701CA0055.eurprd07.prod.outlook.com (2603:10a6:203:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.6 via Frontend Transport; Thu, 5 Mar 2020 10:23:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 827c5279-dae9-4f4a-5106-08d7c0ef402b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5408:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB54087E2D96155250BAE7871DB4E20@VI1PR04MB5408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(199004)(189003)(66556008)(66946007)(956004)(66476007)(186003)(16526019)(26005)(44832011)(2616005)(86362001)(2906002)(81166006)(110136005)(316002)(6486002)(81156014)(1076003)(6666004)(8676002)(8936002)(52116002)(5660300002)(478600001)(6506007)(6512007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5408;H:VI1PR04MB5437.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63fQ3EhkzEfDVuwdeii5lX+6BhFXCkL2wReibdkbGywj+eLPo8q1xvuEImtyuVTYHqrKBdYATGoE2xgXnykR/40PIIDK7PWP4VapKRhaIgLEOoVIR9YEVsQAd6LUsBKSFaGcELIK8soD7VOfYBvs4XMLpgCUCVTZ7Gk4lv/2NotFWrGkapeVfWd8p2cIe05zQRaO8EUakIIh0PO2nQYey0k1D5JW4wdssIzbkWQeljCb3MMmH/W34jZwNC9sY7qhmjBAqNojvJ3WXouuvmwQzs0Bo+T6mTQIkSku9NUSZCou8zBoN69KMuu+rJ1BsYJAuGUuPEq5LCZJQ//UYwh2zt24lX6ucMCr8caDJjLjdi/QPr+56iXMVpxKWi9zO0zw4vhIabYd1nv+KbLNH2BmBpUNTXvpvPvrqe0zhsq8lq2MpG96vAYWpjKbAA4i1JRT
X-MS-Exchange-AntiSpam-MessageData: zq3RTYpl2VnShqNMHxK5pewOB+vmulzIc2jKZHKfZnG0Qv8GyKrhc6US6zuHOfaylp75+9IllSZezNNZXxEoRQ0mLLVIEsa7BJQumTY9zrY/hXn/DPaIQRElzxPX7BwtO3X7QTsVYLeks/b8cUI/0A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827c5279-dae9-4f4a-5106-08d7c0ef402b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 10:23:30.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6NWq9G72N+C7CxnPz3IHSZnBGSnyTpN6xOFqjyB7sYL9j4FOgQg6m7pqorNIqqqBkn2+IQGapm1xxKjh4BdBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5408
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Through this RFC we try to standardize the way input lengths equal to 0
are handled in all skcipher algorithms. Currently, in xts when an input
has a length smaller than XTS_BLOCK_SIZE it returns -EINVAL while the
other algorithms return 0 for input lengths equal to zero.
The algorithms that implement this check are CBC, ARC4, CFB, OFB, SALSA20,
CTR, ECB and PCBC, XTS being the outlier here. All of them call
skcipher_walk_virt() which returns 0 if skcipher_walk_skcipher() finds
that input length is equal to 0.
This case was discovered when fuzz testing was enabled since it generates
this input length.
This RFC wants to find out if the approach is ok before updating the
other xts implementations.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 crypto/xts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/xts.c b/crypto/xts.c
index 29efa15f1495..51eaf08603af 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -258,6 +258,9 @@ static int encrypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	err = init_crypt(req, encrypt_done) ?:
 	      xor_tweak_pre(req, true) ?:
 	      crypto_skcipher_encrypt(subreq) ?:
@@ -275,6 +278,9 @@ static int decrypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	int err;
 
+	if (!req->cryptlen)
+		return 0;
+
 	err = init_crypt(req, decrypt_done) ?:
 	      xor_tweak_pre(req, false) ?:
 	      crypto_skcipher_decrypt(subreq) ?:
-- 
2.17.1

