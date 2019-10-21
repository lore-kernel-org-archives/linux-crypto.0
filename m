Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B649ECA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 13:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C9B82053B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 13:44:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="itReZvjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfJUNok (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:44:40 -0400
Received: from mail-eopbgr790041.outbound.protection.outlook.com ([40.107.79.41]:60825
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728479AbfJUNoj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 09:44:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvy19iK97Z/gBtXvzTNhU7IVAVNRS1OA5Vk12qxLVdr5z+hjV6eEECc8AmpmZDyPULNZO9eiMEt+kJHyluUO+iowDTHToiA60Tj30MkKzNBpp4hPqdKzzLu8W83UabvX3XNxRgeStVUwUrIcFblD9WkIxXKuA9B4QauxHN01WUacrKhNkFcq4+LcHN8hD1+ulOj6s1FfsYkhrRQxEaOLqp2dFeKpNkF820ak28XNvqxV3SrR7lXNumBX3Ueq6sjQSLo7e7uGLfROcK+bG3btheWn49J+lk0MvPs0kms84Md7MBJO1rwN8o+XFAdOeCw9ivnewZPMeYXtspEnWFan5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skyMGkl3ByZeOrzPzFgagHHqr8QUs07P0SXIA4BN0uo=;
 b=cnvhb2xssMyZ1sX8LYcz+oCSUQF0Zy68YhCAKVNLH0bvaYUyn1CaAPRPnUueCzrs/6DjcCnwfTCvvsW0niHKn8OW6e8GKPtNSZE50eZ3Nml9mLePfMqJDBTXwLzmf8tFqm5L8lxL14f13WDRDWKbmlYiwG9XK9wW6ZTl15dZbVTaEVLAjYe0FURnQJDreNgmvWOZHb+pp/QA3L7l5tatS4TAWy4uMtb3ThgytIhdCFdK5xf4E2pedVSnjI8D8Fvn1WqUAXQcb3CCtmxpnFpXl9Cxqum2PKNT5mGW81dMTwuRb8hJzijDj3VdFCORbUsKsGFN2YtaO/qsX7WDay9DUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skyMGkl3ByZeOrzPzFgagHHqr8QUs07P0SXIA4BN0uo=;
 b=itReZvjsDSDSlt5PvBUMjywOO0L/mDS2Hs2iJqW78EiLooWNT1xOs+cU1eMhJrp4HQit0qAoIid5zurjyH6vAOPzDIvF2nm+mRrNWh7hxzU1RM6bJyR/5QTntUph3eckNlPeC83LZrtQ0rL7LsGZp4ZNBaSIFOqGlLpPfuT39No=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2582.namprd12.prod.outlook.com (52.132.141.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 21 Oct 2019 13:44:37 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 13:44:37 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 1/2] crypto: ccp - Change a message to reflect status
 instead of failure
Thread-Topic: [PATCH v2 1/2] crypto: ccp - Change a message to reflect status
 instead of failure
Thread-Index: AQHViBWuWuW34VDWakCQjOR5yJQ1Ww==
Date:   Mon, 21 Oct 2019 13:44:37 +0000
Message-ID: <157166547584.28287.382040905784783121.stgit@taos>
References: <157166543871.28287.16899240336796713483.stgit@taos>
In-Reply-To: <157166543871.28287.16899240336796713483.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0005.namprd04.prod.outlook.com
 (2603:10b6:803:21::15) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baf816b3-14db-454a-2b5e-08d7562cd070
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB2582:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB25821FB3C27A79C7661728D7FD690@DM5PR12MB2582.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(189003)(199004)(25786009)(54906003)(6436002)(15650500001)(71200400001)(5660300002)(66946007)(64756008)(66446008)(66476007)(6916009)(86362001)(66556008)(71190400001)(52116002)(446003)(99286004)(76176011)(186003)(2351001)(2501003)(103116003)(486006)(66066001)(386003)(6506007)(26005)(4326008)(8936002)(256004)(9686003)(14444005)(6512007)(8676002)(305945005)(14454004)(316002)(478600001)(7736002)(2906002)(81156014)(81166006)(102836004)(3846002)(476003)(11346002)(6116002)(33716001)(6486002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2582;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OuvL/AUYltfTxC76KVcnR+NdUmDBMFOXBmDpe5lv1gWQjntijAdE/4FLsKw/HcBIiL+CxDy+I5vAiKjWQjMk/St/jbAXw4DdHLMK+WTx/UyF2L7y5C9rO0GLPmBGCMIG7gKunahAKCpRyznjTW9yC1qB6XltKQk/5EJbI4D80ICCblDhgVghGt58KGCdGgga8sf318WOcGz54KEplYiWbW0apF/pzaDJPZGRy2BkrQfcjxE/yZ/yJG5+0xTjk9ExiNZIKO6G6S2FqxzHBWZwkwybXDucvOTEn8a0+JExMmC+1zIdqFklcYKXOCOotXIM1imUcRpACgBDYI7kxjeSX2E7AdwrsqAF4meC4balhznKoRxDFoQSzlpoJJx/SEaImqInSgLz1ne0emZpBe0qN1RMAkVpHmo7HcKWG+U71QrsqqF5iWbsCP/CePU2n4V1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61BFAB1A9F18FC4683CDF033579D224A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf816b3-14db-454a-2b5e-08d7562cd070
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 13:44:37.3195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MJS5dMVD8XMWsHfxhY0xh92oEYCzqmWpweZ0IqOWh7QoR12JYEsQndoVRn0sUYXN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If an AMD BIOS makes zero CCP queues available to the driver, the
device is unavailable and therefore can't be activated. When this
happens, report the status but don't report a (non-existent)
failure. The CCP will be unactivated.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    2 +-
 drivers/crypto/ccp/ccp-dev.c    |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v=
5.c
index 57eb53b8ac21..2937ba3afb7b 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -854,7 +854,7 @@ static int ccp5_init(struct ccp_device *ccp)
=20
 	if (ccp->cmd_q_count =3D=3D 0) {
 		dev_notice(dev, "no command queues available\n");
-		ret =3D -EIO;
+		ret =3D 1;
 		goto e_pool;
 	}
=20
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 73acf0fdb793..19ac509ed76e 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -641,18 +641,27 @@ int ccp_dev_init(struct sp_device *sp)
 		ccp->vdata->setup(ccp);
=20
 	ret =3D ccp->vdata->perform->init(ccp);
-	if (ret)
+	if (ret) {
+		/* A positive number means that the device cannot be initialized,
+		 * but no additional message is required.
+		 */
+		if (ret > 0)
+			goto e_quiet;
+
+		/* An unexpected problem occurred, and should be reported in the log */
 		goto e_err;
+	}
=20
 	dev_notice(dev, "ccp enabled\n");
=20
 	return 0;
=20
 e_err:
-	sp->ccp_data =3D NULL;
-
 	dev_notice(dev, "ccp initialization failed\n");
=20
+e_quiet:
+	sp->ccp_data =3D NULL;
+
 	return ret;
 }
=20

