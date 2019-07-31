Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C8DC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 00:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E0E12089E
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 00:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="SDhLnPyV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfGaADb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 20:03:31 -0400
Received: from mail-eopbgr730046.outbound.protection.outlook.com ([40.107.73.46]:47328
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728130AbfGaADb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 20:03:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAvc3v4Av73w4LPWb5GI+7NlGUsWS+H6B5UNyYhiIa22IcBgQP+Q8s89bpdcIBRtU3e5pVHYeyjH6ytX/oq60+XuCGmNjK6+uwDYGGdy0ew/xgyxrgp03C5dCIiSPnHgTcoaPw2/H9Tder9qaULEUxj4aMmmOK8f4RoSwmxbg4SURby5jxhHIvD7+R1H5XCgkrp9RcGzB19mKmsU65W/APCwssNyZZCSsiYlzTjSb+j2+AXceqA7eYpkdbO22Y2hJsjOWUfAZk5LaEMhTXiuWZh8xkSR5QIU7aA3WrrQis49aPAOtdumdX2wy1hmqh7ihcgDdqWsGogyvDZ9unsIVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aO1XjK3kBdNI7AwuFzLTvx5UH3uuCa6EzJc6Wp7nrnM=;
 b=hOTI/tkSrEMcC5DKPxHEORmYji5ZhjXte0ECodhufFZy7E4dNht1TM33U3IkhpBkOqLY7hUhXpsD/VUOQmWJaGJIv3znrsPNo0QIZ8w9HXWaosYJGQLMbl5dna3yq98XhVA6abUbFYW4j141i+87tKFtm/fFmD2UQ5z5PZ1dJugoJsqrkhW73+HxPajAtJ9zPfisSK9XoZl/vC7+S3sfIYxgSYHQ4R2tx81Q2jxbcfHZNvaUT1rhFDOgS5+Q8DtvOGDFrxseybw9LUS69sXYVFrWNaRbX7tJl/jRZc3IYXLmPHTmX+Danrb1sIRFv54vuNOVcVIh9wHWVwzBoaMwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aO1XjK3kBdNI7AwuFzLTvx5UH3uuCa6EzJc6Wp7nrnM=;
 b=SDhLnPyVC39dtfOJIFsMK97hF/gwF/2Ba5/tUSDb+f2f0BPVe/R33MvuVEh4aie5r6uktoqG9QTIDnajI0IlvzAbl8ie7WVDW22JnGxiJRY56RQYG+c8XElqXLkysc3UE3PeFOASanw231Iir8nJujgT+TDBwffuU1iHCBHsmsA=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1386.namprd12.prod.outlook.com (10.168.238.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 31 Jul 2019 00:03:26 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 00:03:25 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH v2] crypto:ccp - Clean up and exit correctly on allocation
 failure
Thread-Topic: [PATCH v2] crypto:ccp - Clean up and exit correctly on
 allocation failure
Thread-Index: AQHVRzNgbmg25gCgCUSZnKfafgHhkQ==
Date:   Wed, 31 Jul 2019 00:03:25 +0000
Message-ID: <20190731000314.2839-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:805:a2::28) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8639538-0706-472b-a73d-08d7154a8267
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1386;
x-ms-traffictypediagnostic: DM5PR12MB1386:
x-microsoft-antispam-prvs: <DM5PR12MB138601339B4FABB0815ACCB7FDDF0@DM5PR12MB1386.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(189003)(199004)(50226002)(186003)(14454004)(6916009)(2351001)(305945005)(36756003)(26005)(6116002)(256004)(8936002)(2906002)(7736002)(71200400001)(71190400001)(66066001)(3846002)(1076003)(6436002)(81156014)(81166006)(8676002)(2616005)(66476007)(64756008)(5660300002)(6512007)(2501003)(486006)(316002)(86362001)(66946007)(53936002)(4326008)(6506007)(386003)(99286004)(54906003)(476003)(66446008)(6486002)(25786009)(478600001)(66556008)(52116002)(5640700003)(102836004)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1386;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5Ny0/9kmxyasFPUmSuntvZrsGfPiAhRl9t5qfLf/8CkQW7cmm+etYIBUaLiKEGgcL4QO7oV8Xs0HQ8NvtUGVmL7AJ6cSNVgYTzBAaZ9AIvaIM0bHBfu8GstIVnnLd/MOn7VF8kOUCXimVWQt36BqMqbAA7luzjxOdwR/GZz/RxWOP9Qb7KHOliHbS+PTLLdU4TjASVfjyOMfqMYYjfx7oed/Q9M/yciYInLjcqAVhUQ2d+P1z+BgDrYsGD8SefyJY9Ns8Lafa2Idey+AlxVoWaYScdJ5bpmk01VgRe/QhZcM3RtPDf8CDGNGFK6bItqMuL6gtZN8o860xkk/kXwHlgY0u0b49DrGWThiGGVczXXsd7Lo/KywoxoWSotSWax3CHHbLInGcniPnZt5iCPzDM8DMN0N9AOFZ0qBBZbLSCg=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <B3DA028353B47F45B076C1825001D207@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8639538-0706-472b-a73d-08d7154a8267
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 00:03:25.8611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1386
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

Return and fail driver initialization if a DMA pool or coherent memory
can't be allocated. Be sure to clean up allocated memory.

Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function =
as v3")

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---

Changes since v1:
 - Switch to devm allocation where appropriate

 drivers/crypto/ccp/ccp-dev-v5.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v=
5.c
index f146b51a23a5..9ee72cf46a0f 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -803,6 +803,7 @@ static int ccp5_init(struct ccp_device *ccp)
 		if (!dma_pool) {
 			dev_err(dev, "unable to allocate dma pool\n");
 			ret =3D -ENOMEM;
+			goto e_pool;
 		}
=20
 		cmd_q =3D &ccp->cmd_q[ccp->cmd_q_count];
@@ -816,9 +817,9 @@ static int ccp5_init(struct ccp_device *ccp)
 		/* Page alignment satisfies our needs for N <=3D 128 */
 		BUILD_BUG_ON(COMMANDS_PER_QUEUE > 128);
 		cmd_q->qsize =3D Q_SIZE(Q_DESC_SIZE);
-		cmd_q->qbase =3D dma_alloc_coherent(dev, cmd_q->qsize,
-						  &cmd_q->qbase_dma,
-						  GFP_KERNEL);
+		cmd_q->qbase =3D dmam_alloc_coherent(dev, cmd_q->qsize,
+						   &cmd_q->qbase_dma,
+						   GFP_KERNEL);
 		if (!cmd_q->qbase) {
 			dev_err(dev, "unable to allocate command queue\n");
 			ret =3D -ENOMEM;
@@ -994,7 +995,6 @@ static int ccp5_init(struct ccp_device *ccp)
=20
 static void ccp5_destroy(struct ccp_device *ccp)
 {
-	struct device *dev =3D ccp->dev;
 	struct ccp_cmd_queue *cmd_q;
 	struct ccp_cmd *cmd;
 	unsigned int i;
@@ -1037,12 +1037,6 @@ static void ccp5_destroy(struct ccp_device *ccp)
=20
 	sp_free_ccp_irq(ccp->sp, ccp);
=20
-	for (i =3D 0; i < ccp->cmd_q_count; i++) {
-		cmd_q =3D &ccp->cmd_q[i];
-		dma_free_coherent(dev, cmd_q->qsize, cmd_q->qbase,
-				  cmd_q->qbase_dma);
-	}
-
 	/* Flush the cmd and backlog queue */
 	while (!list_empty(&ccp->cmd)) {
 		/* Invoke the callback directly with an error code */
--=20
2.17.1

