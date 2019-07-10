Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1DFC74A35
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 21:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4037320838
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 21:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="TnleHqz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfGJVpj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 17:45:39 -0400
Received: from mail-eopbgr730082.outbound.protection.outlook.com ([40.107.73.82]:47295
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727188AbfGJVpj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 17:45:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDMBjwSH7TwAwJJZVaaXbY8nrDtRsSD1MhPnNnhrgnNGq+myAToOaWLjUh9TVrG9p63/4cjLdvz+2wC8H+fnox4YSpj7ki4jpxIB1M27IDjlMx2TyItWKfnyFTC2OTG4ZKD9JJGeDeIMPlldcJdkUDfUJ161oXHLEGwLknxlvkZpiwk3vH6JqDRyl6dsBhBzHCygsCckJhzBH24edpJFoGOsqi/8SHlYHjyBHpIdcgmLvfdxbK2cxfAYs9jAQHPERO4snIhaoAtPzroks4kvb99Re6ZO5ZSUdFiXauno0AfKJUnQDFFBg41wVpjhy8zwhi0dNsNdeR9PXTTR2Re/YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMDnHu04HhRV8PXhzAJ9KDbu2JuzrSyhOHUXbrK5h+M=;
 b=HgXaAkC/wqOhiU2Q3Ep0WrYGiGrW50R+L4Cn6c5kaa478Yq6DaL3hnvkp1+qZa4JUUBz3X/DCi52jCzlG+qtEIulqMk34xJIQvZhDHqOpw2rDD/Q+YDDO2NO7qR5BtPVm07xdvRXbjpj4AEKzaUtiO2eX6hfZM/9szw0/27Jy52QrHIovl6F1nBxtqTDeOtx3AC6X7HhUOwCtKmlWHjGrQDKbvHqnxF4dFqKkcrhMH3Rp/bjLF7X70xYxQOu+8csF6X8FlCpv40mAe+XV7tDNrogIC66T6BDu3owbmQXN+kAcpjuSM2D8VHInZt9vKMcvnzJqMDJFcEF6RZTVTG9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMDnHu04HhRV8PXhzAJ9KDbu2JuzrSyhOHUXbrK5h+M=;
 b=TnleHqz7p0rBYhI7vXv6BQIp77zy5DE5cOeuDLp2VBa1dphsxW9evhKw3f9tHFKt8MZVwWEDL7gkyPn74x6mR6vHw5edFSC2naWhytKYXxrzcBBUGCPdR1h+vBPTcT+ZtPV8UifZbodSCmtNXRqoCdjsfFFECWRMNaGN7yD8mBE=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1450.namprd12.prod.outlook.com (10.172.33.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Wed, 10 Jul 2019 21:45:37 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 21:45:37 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH 1/2] crypto: ccp - Include the module name in system log
 messages
Thread-Topic: [PATCH 1/2] crypto: ccp - Include the module name in system log
 messages
Thread-Index: AQHVN2jPzLE/a3eleESWpr/+UGvtNg==
Date:   Wed, 10 Jul 2019 21:45:37 +0000
Message-ID: <20190710214504.3420-2-gary.hook@amd.com>
References: <20190710214504.3420-1-gary.hook@amd.com>
In-Reply-To: <20190710214504.3420-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0017.namprd06.prod.outlook.com
 (2603:10b6:805:8e::30) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c870a80-0088-44f6-918b-08d7057ff198
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1450;
x-ms-traffictypediagnostic: DM5PR12MB1450:
x-microsoft-antispam-prvs: <DM5PR12MB14509A7AB7D7553C216BA389FDF00@DM5PR12MB1450.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(189003)(199004)(256004)(6436002)(6486002)(8936002)(5640700003)(68736007)(99286004)(2501003)(2351001)(1076003)(316002)(71200400001)(14454004)(66066001)(8676002)(486006)(386003)(6506007)(81166006)(52116002)(71190400001)(50226002)(66446008)(64756008)(66556008)(66476007)(53936002)(76176011)(54906003)(6512007)(66946007)(2906002)(186003)(102836004)(15650500001)(3846002)(305945005)(36756003)(478600001)(6116002)(7736002)(81156014)(26005)(446003)(4326008)(4744005)(5660300002)(476003)(2616005)(11346002)(25786009)(86362001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1450;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0qmBaBHzEKL/SCz9r32AIftztDHVIbkQNwaDyOsAOLOWS5oCwcY1MEymnLU66uTomd3ZOpoul7D7PFcdhujsYfCdQgN+w679M6hOf5x/Li0lh5bXGNcR0IiWR9HYawLsRZQ6SwagDvt7WhtyUkc/LrZb1co2sSWvS+ZCtpdKmO2DIaPXIJUXAXFnqJq5L3AUu6qkdZqF/ny7Yy2kJ+mOHygus7OXZZJEhBE9/ScLoJSkZ5aop9fCriXkjt7Ix8CGfNOPnCUJq9acs4GWnbnVAa4p3WJdFHsRwhhp3ALuJHJ+d0EqWYGfHfLKw57Z4GH2SaJC0LC1WktyeMMXYjvzJVVpkl+zm+mBHKcwOIFijXH79rtrGPgADzb5Nl9B7K436bE+JGd6LSprTdQXi+dNS+pM9zlbeFNWecTTlxC+Uyo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c870a80-0088-44f6-918b-08d7057ff198
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 21:45:37.0749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1450
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Redefine pr_fmt so that the module name is prefixed to every
log message produced by the ccp-crypto module

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypt=
o.h
index a4a593dddfd6..c5d471b2ac1b 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -24,6 +24,10 @@
 #include <crypto/akcipher.h>
 #include <crypto/internal/rsa.h>
=20
+/* We want the module name in front of our messages */
+#undef pr_fmt
+#define	pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
 #define	CCP_LOG_LEVEL	KERN_INFO
=20
 #define CCP_CRA_PRIORITY	300
--=20
2.17.1

