Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B184BC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DBD722CA1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 16:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="HojN2gCt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHGQXF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 12:23:05 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:64918
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727053AbgHGQWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 12:22:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=if/oWe8Mugyxl4Ml4lr1iYoJkkyQFng7ssQBMAGC/ewISZx2KtlXIvxZHjjl6lSh4J0B5hoaZ5runJhYPN/K6oxN+sx6+9VqZkRzBh7qTME1SnxkwzGhnhvM98IyCaCc3wKOqiZFw3b5+nj/yjGToBrUK14Vzq66j6CGaG53ar1r9pRzRnTo6lTeHzKbKtDyjL5Dx9JyTw8r80J387muDn0uCQTv+RBEEd99FEwVCN390chtH619lbxVwgpUGide3/ncyMLM/vOqUGDL5O6E5g4yyYO81fjU/E0OyK+uojEAJQQG6AG9oY6V/nscfWR/t+syNQVqSh3xB8em7/DOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35nYXxgc5w/jBPdSHTsWFo8xWBHcM1pZUwHVX4D9uZE=;
 b=P+luMdzzq39OHtI53pnxT8cy4DR8SR2pA5WfAV8t6lC8XdBJ3DS0Mrie+eQTsfmBH2d4OVmzoFtx6a1VPbXZODr6kdaGB8AGouskAhSEdR40NC69VXBA+KEv0ShmcUMLVHGTOx82i2I/Vv2RO4EBID4zNX9EGbyLx+gZZ778C8B7ndsiS9BlCu/g1Ff2wfoBmNq6tUmJFi4h0A0JNttGzfpH1ACK59fclFrronmRRtWDCujrijWCJj65xWxeLW4GIhjkXvUN1uiIanT3GAMiRdyOvzxsGxxbSJYmYO2Bqh1D8tk7PGa0IsvFJkPKaql32gJka1BcYkDo27mNlrYBvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35nYXxgc5w/jBPdSHTsWFo8xWBHcM1pZUwHVX4D9uZE=;
 b=HojN2gCtNl6S5RfyzhBZVBWfoXHKYAienMjn6EwakqCWfWcwiqYvYmAgxMXorjCQY9pXfQL84J9DgLq2/U3LAuZBfOecjWE18bmnjZc5cqSR87q2Di4oRamkqyY/0USnXsM4G4x2oISJ3KKsodEVAsLa67+2JQxvtpwOH+GtIqY=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com (2603:10a6:803:125::12)
 by VE1PR04MB7359.eurprd04.prod.outlook.com (2603:10a6:800:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 16:22:19 +0000
Received: from VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d]) by VE1PR04MB6608.eurprd04.prod.outlook.com
 ([fe80::a856:c104:11c7:258d%6]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 16:22:19 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 19/22] crypto: inside-secure - add check for xts input length equal to zero
Date:   Fri,  7 Aug 2020 19:20:07 +0300
Message-Id: <20200807162010.18979-20-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0075.eurprd04.prod.outlook.com
 (2603:10a6:208:be::16) To VE1PR04MB6608.eurprd04.prod.outlook.com
 (2603:10a6:803:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0075.eurprd04.prod.outlook.com (2603:10a6:208:be::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15 via Frontend Transport; Fri, 7 Aug 2020 16:22:18 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c7cd3dd9-0f7b-49e6-62c4-08d83aee0ea6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7359:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73592093804EE470D10AD7AEB4490@VE1PR04MB7359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0z6oQzj2lWhbcPu4vGdXr++uIIocc1u8ow8iRIEtJidYje9hVzjactitz4wTpJr/3RUJIQT621jfxF+Q+XPUqpGMC90YUeFqCUZaMkfszbTt/74MnW0tSfa4+roTsnLzCPnDKpLGM2L02ZVByeVv3k2oxeVRpAgNgddBzROayi6LpaVu1BoZ19Qn3V2U42msE0kQSsJxhRBcIPDYIFyQgyZGo2UfZ9fS4DTw2kRaBM+dGWO4NgZ6ldQB4U2kxqBY/oGaf/RQ9IIHLYXCLfKCvw37G94kOd4b3FpGX6GnFnVKLxzF9qhpxhC20PYvvyfVCvw5PwIAozUg/imdUNl6NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6608.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(44832011)(66556008)(66476007)(110136005)(7416002)(54906003)(1076003)(6506007)(4326008)(66946007)(83380400001)(8936002)(316002)(26005)(956004)(186003)(16526019)(478600001)(86362001)(5660300002)(6666004)(6512007)(2906002)(8676002)(2616005)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qJXevP8hK51eLMNEqQiImt1zHckrbOxqUqaAzE+iU5DqfC+wziSBw2KWrW+ecE1fkOqTFxQmkuJKgf7aCBhgmIkmHEsplBuVLLDcaOKR/7R4IJUFCZm8omBypLTGJR/IJ766tkbF0S7wnqWYzrz51qoCaLX6kZ89yrK2c63DdSAPc8vpVzl5vaG8u5LesQ2paVYdyJoPa4FcbuJB8F8hjitijXKcSDKkjk7CMTUtdQxuexiQnbk/GjoGl0NQWshtE2V0MqaLHSIePvfTukQaw3bBOSKUYS0cZGRE33ZLP+wBxIADsT55Q5ClHyMITiS0x+P3NnUCupaZu1zntrAOWMaD+nGgkhC+7E4RtsUR8lsoS9qcNd2vl5v81l8o/lm39u8/oB0OxfBD21JEUq8FfFkjhjYwqXdPuCphJTPl6w58R06NzQwZvCRO2oIML5+uGlPq70YtjxIwO9De0wiaRbUOey2UnlsozDENU+9mKs2PgaaE0cS3zIRKYYZ3jyJmwWftwUrOPMmYzMdLLfI/A+QjN7zIGKXjHnmtGnIoqIw/sc0tqXtPM6n0yxWupDRNuAakqfFwZnVGQSEUM6sBAnlkTY10pWLXAFgb5PtDnO9lSy08TBPvjtKnPu82ldlSmuIQnYmjL2iLTji69xaZ/w==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cd3dd9-0f7b-49e6-62c4-08d83aee0ea6
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6608.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 16:22:19.7636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJiN3F+RoYM3BZo+dugG1oafGdHFOqL2AkQnNAND9yDVLm4DNnbQXItBxB8/gR6Oaw5o1OKRdiO6H4Dba/DImQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7359
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Standardize the way input lengths equal to 0 are handled in all skcipher
algorithms. All the algorithms return 0 for input lengths equal to zero.

Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 1ac3253b7903..03d06556ea98 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2533,6 +2533,9 @@ static int safexcel_skcipher_aes_xts_cra_init(struct crypto_tfm *tfm)
 
 static int safexcel_encrypt_xts(struct skcipher_request *req)
 {
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < XTS_BLOCK_SIZE)
 		return -EINVAL;
 	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
@@ -2541,6 +2544,9 @@ static int safexcel_encrypt_xts(struct skcipher_request *req)
 
 static int safexcel_decrypt_xts(struct skcipher_request *req)
 {
+	if (!req->cryptlen)
+		return 0;
+
 	if (req->cryptlen < XTS_BLOCK_SIZE)
 		return -EINVAL;
 	return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
-- 
2.17.1

