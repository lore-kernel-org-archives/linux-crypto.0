Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E9DCA9EA9
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 19:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C247D222C2
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 19:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ubM9TlHK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505992AbfJRTkK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 15:40:10 -0400
Received: from mail-eopbgr750043.outbound.protection.outlook.com ([40.107.75.43]:51307
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2505977AbfJRTkJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 15:40:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDg9aN0Zi9atuBlwsyqOxfk8knX2LwZHeEdhJYjTw+u9hOXNYxtN/qx8a2eA/g0kivlS/wkTc+KPXe7CoP7OKpY0z5CQ90MNcgFomCEcxMnhTT6konlXpXFJaltebcp95XCwLpaTBEmLD43+eCF7VeQ6cxYRyaaUypXKv3U7S2H7UGMtYXYtq+DmdSNkoPDHbpacljscNcX9Kedj+mwhsF71Pwis0COjurwXh4H3HFVkFs/Vp6EwZo6OUy09TEKC31CH/Hdbieo7bznE5W3VvASsIivy/950fUQgEv/v8dFwOPC0lhwXM3BKbXxnNm0WMamPLgcaJsbtu5L5EOQLyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skyMGkl3ByZeOrzPzFgagHHqr8QUs07P0SXIA4BN0uo=;
 b=cmZ8OHG29m1HDrG/vTnwaEMFknXP3QMWv+OEu0YnISLaYqlzzzfbFjDcpm4BslZ4pMnNlS0VxRCwwH4A0Qd1hSy6Dit5w9OTtmEsex06uvi8T8Q5WMrxj/4xJ6PJLoy41vOLHWrrRNfv8X9xJ4xaCzecTUhSEg16wfQ1veavyqUlbM2WMskyJIEGkSkek1rQwg/qa8TRTnDcy6D92EZRsYy+lB3uI21qGY/1pReFIIh0GZYH/fHbLuoElsRHgQI2ir/AjQPIa4il6tbAkpDbTpRb5w4ZMEEF72qkBhcXGCGoHs7xkYd7Zp6gGG+jlyVF4nfIWyseFMRH+9JYdq6Oug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skyMGkl3ByZeOrzPzFgagHHqr8QUs07P0SXIA4BN0uo=;
 b=ubM9TlHKB/H9WC4sCXodY0vJcbCNf8SDAjoN8I+WI62nkipWbzhw4sGRjr/2Ve3OJgcRqxBwLOCz7pJlDMXNgBLMXpZhmQ4Ma6bfps3hfppjI6V+uu43QKnHeatT7gZ3wFIXiWxwLUawrrMi0qJB5cOUG9M1Jf3wbp7LDsJMYlM=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1593.namprd12.prod.outlook.com (10.172.40.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Fri, 18 Oct 2019 19:40:06 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:40:06 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 1/2] crypto: ccp - Change a message to reflect status instead
 of failure
Thread-Topic: [PATCH 1/2] crypto: ccp - Change a message to reflect status
 instead of failure
Thread-Index: AQHVhevY9UUckwKsBkigLMOBqOqS1Q==
Date:   Fri, 18 Oct 2019 19:40:06 +0000
Message-ID: <157142760519.6869.16051058025986432861.stgit@taos>
References: <157142758885.6869.11882127817423670946.stgit@taos>
In-Reply-To: <157142758885.6869.11882127817423670946.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0064.namprd12.prod.outlook.com
 (2603:10b6:802:20::35) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 080bf7e1-dab8-407b-8913-08d75402fa62
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB1593:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1593BC3264B17963762FB151FD6C0@DM5PR12MB1593.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(189003)(199004)(14454004)(25786009)(26005)(86362001)(66446008)(186003)(8936002)(8676002)(81156014)(81166006)(71190400001)(71200400001)(478600001)(386003)(76176011)(102836004)(52116002)(316002)(2501003)(99286004)(6506007)(54906003)(103116003)(66066001)(5660300002)(305945005)(3846002)(486006)(14444005)(256004)(2906002)(6486002)(15650500001)(11346002)(446003)(476003)(6116002)(6916009)(4326008)(6512007)(9686003)(2351001)(64756008)(66556008)(66476007)(66946007)(33716001)(7736002)(6436002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1593;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iiurRPL6kondLkFnpq3SKl1qmgiSJNxV38Lt0+RUmH6WmQYDUjgQrm0A++bGuqm2tzkmxgLxqj/MG1ewXp3CWOu5cdmvSHxSZqq5pqNSJIIaXaqLRoV1VFAWwwDn8y0fh8VKHuyyjI4MrBWVRral9lLykuKdqIq4SkZabfA/WGD/8TC9nWAqwUjWMOIyRnwNvFC1tDNLU+L2U2T/d7ytVg6IYsUoexouZmBQ0JgBdPnYFoIvOlq3UcTlpaLGXpbzRbEeykgfUlGplo76hEBzyC76VcnWRTWMLylfPNV8PjM3LPAzafbk/lO3qBww5tQJi9QEWPR0fRUS5Y+7hZlX60zdZAS8axQhEFkoQUgUJS7+5/RVcpKds4Qs1ui5/hHCUxR3yN+349lEgoYctYVUNITiNylyzpMCh1B1tWr7bpo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A96D266BD48368409F10A9B53F14E7A7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080bf7e1-dab8-407b-8913-08d75402fa62
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:40:06.5733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7bWgi39sYgRzm8iZOcjUTXTD6vP1tbiB6FYnUIpopWGmOFc9Nb8A7ps/fJ43+AT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1593
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

