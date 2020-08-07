Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A54C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF5921744
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Z5/pq8pU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHGQWY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:22:24 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:4231
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbgHGQWW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuA9Sog57xtD1bgxEluxFmrMtv2da1OIydOUAPso9j1RybffN9BM/ZHssuUogdO4l0ikbmsorxyZWJyoOrzTbcPCV4u8AzevJUqBhaOaqqHv1kbaLjReJTheRJW/glbjiYnXDh5SXwz9sd3EFSul1dt6Q2HYgVaMXTPCXFqSZO8tAEwPaA0afDRTlU2aPzxrBPCG56MMGSy9qMlgxDstfhVZp5pqFy70NTJq+IuP+EZKZz4gcvgLixjP0ku+Ir5O7K5qLqY28dDw18ep8qBM67A+pk9RQlF+ul0x5eqQ9XPEKB7Te0Ksi7cTib/q51w48/XbTyJmBEuDoH3yaqoBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyoj+usdHlA844XSXduLPXsVx82SRQl3O2nYzVZXzBw=;
 b=cTGjBjTFdMkkc4TJGj+ylEyWHOfc3/5mxw7zBuWI3ejFuFs+Os5nJashjbSiPtmS4W68hub4hM7DckVwKiOtPfgWY31QY4sRUGdOKvBkl5knn9kvM3T6qchN/OonE7+EveDt0594/LAQY9KJp/Ya/N98ax/BBdMTkxdxEZSqvPfGANRZ08iRCVa+zDE7GVXYPSGYLigXgocyDIXLHDxYtrtMU8b5QPnK3DFOl7+2msbHHJwtlFl+OwYPceftifYaJf+sYxpZ8mKBv+zE3oNCYYXnK0IKPldu450ShxhEi/+jNLFdIDkGv77acLhTez1sN+zalqbwCvL8TAv6HHwV1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyoj+usdHlA844XSXduLPXsVx82SRQl3O2nYzVZXzBw=;
 b=Z5/pq8pUjVjS84/f0dNP2Hx3D54NCMjKxAlL6ooC8A24Qzg7/fBypOazdv+n1qEtTWeumh/ZyYH3bkFkMDFEAiLgXyUYugmmGfffwQcJTcq3jr+dkdd58Z7p0s/N4DC4FHHphaulqCbnFhEVM6wi9C83izbxV+sd2XSvcBvqkJA=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:07 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:07 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        George Cherian <gcherian@marvell.com>
Subject: [PATCH 13/22] crypto: cavium/cpt - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:20:01 +0300
Message-Id: <20200807162010.18979-14-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:22:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b56c5c7-ba6f-4854-4786-08d83aee0702
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7359CF793D1FAF5B792D443BB4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pHhOZxVsHBsDZjGxtZ9QAHsn0E3CCI5VMfBlmSz38OadsTIa5Zy2WXMH7z6HMXu9n1KK1/0IQ6o3FZvdATBgXRXjlxNBeafL7eRot1ITfmlGQqY4PcGEGLre4aAUc0le3waIqBGty7g/MSPe/2Rk8y7vkVhTx9ajcnlWrmU6d8WjQzo/5HsEt2Z9W1adCsH4zbvnRf5e/eWFu+qKoiYXnmxWUy7172ybxfCKe8HFpta0s0M22oQEtW74B7uBd1z7gCx8QSZHrliz4SglgP+zd8tAbmWWuGGRsHJzt1KcD3jkL7OiXwkAn9JifixTyQqa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KMbSZQvhdHpq1D6AIPIXP25+1Guszt943ERzp0047FoHCWsYnoW+NN1zZEUgM7lIlH+FGuO05iEY9/DCw1zBphRRAfQjocpZjbRYy3gvMbjcxX6GIoOp+zSWeKoh/B5LizR65tCg4XYSCO9OrW+jRRKpruzv4hIR3rWhgkH8TJYTjPjq1/0uxkNifxCDn8eMeMNLMw9qzR7tyY5GCTxNaRNhfi3x5ZX8Mn9HfkeoTE117LQOZOJX5akO058DTMsIgz0FkO5K/22dqj3N6ZOZIq3W9TIy1uglB2yRiDR7f2e0ICc4aICAQIv6zhlMMT3Pz+rqZzU9ADjZjAKgu9a4jRDIuPamTERV9PThHL5ywoxqroIODkmmcDiTOsdvPJ9FR4/IUtocfteoB5oRtSBoqob3KOuR+JV4P3N5Wd8d5rGMsA81VEcHUa+O8UL4W+umEjIs0qIQWR+DIfFKtAmmqci4fDqxIt5ZEbI5u2pjCU4NqjqAfbu6LpXqKIk+9+TlTqo9eKyZOvmQjfm55B9aZOp0MFjVgg//syU7lJmYtAoqcXS+1rJK1/PDbEo2sIC9eWOQu1OmjNOq29wILwBXPbG60Yg+DKiXUlHurJPSXDhEqR1Lh9N2H8wCB4VFKHQuI6OOfJ4NMvrM/PmqWaNW/Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b56c5c7-ba6f-4854-4786-08d83aee0702
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:06.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yz6Py+9HEi8uLhg1az4GK9uPZTu7SvLFrCfGDA26L20a92ZTAbrSSBQ+TDB55gxuAYhyKAteFK/dPRpT/sDSgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: George Cherian <gcherian@marvell.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 5af0dc2a8909..edc18c8dd571 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -193,6 +193,7 @@ static inline void create_output_list(struct skcipher_request *req,
 static inline int cvm_enc_dec(struct skcipher_request *req, u32 enc)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cvm_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct cvm_req_ctx *rctx = skcipher_request_ctx(req);
 	u32 enc_iv_len = crypto_skcipher_ivsize(tfm);
 	struct fc_context *fctx = &rctx->fctx;
@@ -200,6 +201,9 @@ static inline int cvm_enc_dec(struct skcipher_request *req, u32 enc)
 	void *cdev = NULL;
 	int status;
 
+	if (!req->cryptlen && ctx->cipher_type == AES_XTS)
+		return 0;
+
 	memset(req_info, 0, sizeof(struct cpt_request_info));
 	req_info->may_sleep = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) != 0;
 	memset(fctx, 0, sizeof(struct fc_context));
-- 
2.17.1

