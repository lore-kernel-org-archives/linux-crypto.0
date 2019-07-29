Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99C9C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 12:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBFBE206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 12:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="cDFiZhm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfG2M4L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 08:56:11 -0400
Received: from mail-eopbgr730061.outbound.protection.outlook.com ([40.107.73.61]:25738
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727865AbfG2M4L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 08:56:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3RvZNu+eS0plEjf2XeiNDufBuGsvzkYmgYndtxANrf2vpY/zEC0+N1RukKNcMhaWHnvdWhtH1MqxgIl+xL+/YQFQdxTlNJyDi8xiA4pAm9WmD8mXFPv5kWidFkXIkA9ctOU0K7+KtCiYh6Gkk5rC3E34oKNmgfBQdu6wkg2YBaHb0nWixJoy9caAa84pljNNnXwDZTb/VZ3y64kCYlx6FZ2CIGeVv2rdw3/3VXGdwALf2QU/HW50CuIMatCSPcYiwkV//URuSBlTAf+4ffLd36KiN3tmOL21uHHmkpdiKxau3lgFKtq7iUzkd6+0jFolxfFQTBrdm1eksORj25vLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlgyQqgrLnGzsclqXWCDBHttBEIj5bDClC4bZRBQaEo=;
 b=I01pz0eEqr0fwRAZewbKaixSDdsd5ZiSH4JWbAyoKZsEtcJ5AC/C9MjSCiWDn+I52youJQS5L0FAOn2YxU4jIVyJB/9eMSm+NiM3BWInqOFP9mPC3+JvRoK6br/ixmIuWvs97DoxxGIWxbxlrmfOPKUjdgHS8Pd+BIOUieIeFqd5+HfjxLgZj3IuXKAtQ0ZKW9sdV1gvOPPdju0ioA9lCIM/xcWdUAUzG9HL+65akRez/ClcxPkhQIMO2FnUM/Nepbjo8bG1SDD5+eUVcggpqf6RmSABw3V2Dg1bdokskg7QyFyyWgCYB3Xuds0Ps0lpJlUG++iWNc/KERepXVfhcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlgyQqgrLnGzsclqXWCDBHttBEIj5bDClC4bZRBQaEo=;
 b=cDFiZhm8LqtT02GMr3RZ+Dmi83yX4n2JK/sMjOyGTano7ikUqVZKGEuAoxdYT4NkJIWZ0KJsXDkmZIGljLvAvFJm4/9GeHQr4Ht3Qb8B3A42AMgoAGXoAYP+MbfKGTPq7dvVtkTbh34ariRTvuKOlkcF+OmRPtfFv7uJZiUJuIg=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1337.namprd12.prod.outlook.com (10.168.234.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Mon, 29 Jul 2019 12:56:08 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 12:56:08 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH v2] crypto: ccp - Log an error message when ccp-crypto fails
 to load
Thread-Topic: [PATCH v2] crypto: ccp - Log an error message when ccp-crypto
 fails to load
Thread-Index: AQHVRgz9I9H9lUWDekeVLb1XngPdWg==
Date:   Mon, 29 Jul 2019 12:56:08 +0000
Message-ID: <20190729125543.6255-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0044.namprd04.prod.outlook.com
 (2603:10b6:803:2a::30) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f7e38d5-f6a9-465c-b94c-08d71424201a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1337;
x-ms-traffictypediagnostic: DM5PR12MB1337:
x-microsoft-antispam-prvs: <DM5PR12MB13374F5877E4A01D0A961132FDDD0@DM5PR12MB1337.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(189003)(199004)(486006)(256004)(15650500001)(71190400001)(68736007)(8676002)(6506007)(6116002)(2616005)(476003)(36756003)(102836004)(3846002)(14444005)(81156014)(71200400001)(386003)(52116002)(81166006)(14454004)(2906002)(1076003)(6486002)(186003)(26005)(86362001)(8936002)(66476007)(6436002)(64756008)(66556008)(66946007)(66446008)(50226002)(99286004)(53936002)(305945005)(316002)(7736002)(478600001)(25786009)(54906003)(2351001)(6916009)(2501003)(4326008)(66066001)(5660300002)(5640700003)(6512007)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1337;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gFVy4oGuGaYED6vpNPw3knAsS5MSTE9T68faKWfWYATBG4QiC8ldKrPl0+S5rES6q5xiYE7aCUaDgxM+T8g+sLqfYBTqkHi85+iXyj1ddmmLqsNQro/ncogKf2fXkTKQX8sHD8btZO158dUAUGvQqMtpqyX8qmzTSbADl8YhGNA2OXlCDLIMkJ/ds9GkA4Rt6bUbOE752B/2OhvjpvUT21IiXB/eosrj4prFWjdW1LVnokKAZ6+K2H0GHo9BUgLVNsO1WzveIWyWBgRjrvxJEa8yrPVUW7etC74EnWG4eNiqUa5DZg6sT8gHkjCs6RB40Kmjs6mQNVHdO+h8qPRq/Vr+sC3V/zfYoT10dd9LZwpOWrDC/7NV3ni2u2DRwDmINFNQYp8Rsgaq1MysgmtEZ4bSCeZAEjz1A866X29Xxmg=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6C76F6D46CFE3640B3A8CED9CDF0936F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7e38d5-f6a9-465c-b94c-08d71424201a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 12:56:08.7906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1337
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

If there are no CCP devices on the system, ccp-crypto will not load.
Write a message to the system log clarifying the reason for the failure
of the modprobe operation

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---

Changes since v1:
 - Add missing signed-off-by

 drivers/crypto/ccp/ccp-crypto-main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-=
crypto-main.c
index 818096490829..8ee4cb45a3f3 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -405,8 +405,10 @@ static int ccp_crypto_init(void)
 	int ret;
=20
 	ret =3D ccp_present();
-	if (ret)
+	if (ret) {
+		pr_err("Cannot load: there are no available CCPs\n");
 		return ret;
+	}
=20
 	spin_lock_init(&req_queue_lock);
 	INIT_LIST_HEAD(&req_queue.cmds);
--=20
2.17.1

