Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86981CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C8FF2084B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="hssw3pL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404836AbfJWL12 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:27:28 -0400
Received: from mail-eopbgr710046.outbound.protection.outlook.com ([40.107.71.46]:52334
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732149AbfJWL11 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:27:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtFLtBbdkiBx2EPL9gi7Fz6XuqDUfQMck7qrQ3wJejX/pJLlJ0qPJXHuvKoNHjV+5+n6+UBjVENQPahQtgxj+M5oIQXviIDhl/jLdbGJabMI8WG302HqBOZJh64PZXoLxoGFrM7Jx1BgITsAo65XFVGvKP+N9fKqMGkGNU6EExXcI+f7iR3zrUNtIvk0kwaf0ecd3rZw0qjK6sJjg6fczoo0wmB85lbf1q66dkxVsQwnON54tqBrlJR3/a7wcadL0ZeN00kRrwYzV3SrT0DZtShreUTPP++S6mO845apUfISqnSoJWxw2z5YyEA6+ITtinEvWWkpOy+IZ0Q0h6+/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qmRK8maJHnezCvIVfNmV9ShS4rXYewXTogomNUlqSI=;
 b=AMxFev0ArTKETV+ZZShE+TcySqvoT+qZ82kprY1K8/qRNplHNHn+Zov149ddBKF0byj2ik1S2YlRdr1PXi8ICpBgkQLd083WWEQXtx99moDEl3IaV+wDIPDb8KVNmgP95oDJ/KS7+ysOB95J/5dpA2HiHemxnnsN6UNnaTeajPdw4w0hnMQZLnsAI0+h/o4Yta5alcclrGlz/r53AjBifJRg5xO0KbyHUnyndD664y7RokylI8R7q5DzcqYc22ahlzHIkVI2dAdjWyKP2A69YAlHbP0Nzv/YbbYV5920VgkV9s8jtDcO5myEIAdCn0zu5aGnhhafbRn2u6wgMdsMOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qmRK8maJHnezCvIVfNmV9ShS4rXYewXTogomNUlqSI=;
 b=hssw3pL1p139ErSje/P/KCQJh2yTFm924BVUT/2niVAzUi/gXup+mb3/Zo50TO6Cs4sI4bzmmvlj1xTLxyCB9dOcwNtPh4iCN6ZZMLnMZbHCrN0FQwuMV+nAaatkhJGIXXtbKByy+iIJXX8bGMwWV8mcqD7dxgA3yzX7QU/DL60=
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1527.namprd12.prod.outlook.com (10.172.66.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 11:27:25 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::a1f5:6f09:5c0d:78f1%11]) with mapi id 15.20.2387.019; Wed, 23 Oct
 2019 11:27:25 +0000
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Easow, Nimesh" <Nimesh.Easow@amd.com>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>
Subject: [RFC PATCH 0/5] Add TEE interface support to AMD Secure Processor
 driver
Thread-Topic: [RFC PATCH 0/5] Add TEE interface support to AMD Secure
 Processor driver
Thread-Index: AQHViZTX3R3UO0PPhkOgyRS+vzwoTA==
Date:   Wed, 23 Oct 2019 11:27:24 +0000
Message-ID: <cover.1571817675.git.Rijo-john.Thomas@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::23) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.9.1
x-originating-ip: [165.204.156.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0c8c265e-eb56-42e0-e31b-08d757abfa05
x-ms-traffictypediagnostic: CY4PR12MB1527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR12MB152791B28FAAF5ACDA9C80FDCF6B0@CY4PR12MB1527.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(476003)(81156014)(386003)(6486002)(6506007)(14454004)(26005)(81166006)(305945005)(86362001)(5660300002)(186003)(102836004)(7736002)(50226002)(66946007)(6436002)(478600001)(316002)(6116002)(3846002)(99286004)(6512007)(71190400001)(25786009)(71200400001)(8676002)(110136005)(54906003)(2906002)(8936002)(486006)(256004)(14444005)(66476007)(66556008)(64756008)(66066001)(2201001)(52116002)(66446008)(36756003)(2501003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1527;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kcVWR5c2pkiDLU7TXlMMqK5INeAxkLOvvmYzxRXNyEcbLQWbFs/KWoSuHG/AOIgXWjfHKY6GamBUGQ1zWuSXYKzsv3+XPFImt3RUZ3MJwCXDOWLs2tpvY5Wc1GdsXp2jtvRA+YkwE2Ug7RdUFHzE+Yja4lfSt355yFWhBGwM9ti/reSBrr+cUnnQRl2W7ZtmSAhUTGevH/lwcWNf9W4FcMme2dawJPybdxEnHC8iPlPWL2dYZoj3EHHvN0EHwWaSIktBCFmgoWN2w8msH3uX5e7GWPYZjD59Rl+6ETLQPcpNzpuQmviGPlBdG/5Eobrz9FaSwRwumvycuM0Ev214BANNSd+lvqxyKvWwaWr6AAC7ok1sbgN46GXHkRo8yEdkAxBoDXIEN+Bk7YA8i7iaSTuKimYYHMmZSnNaBh8UM+ODg89YrsbJ9+eK/4DkQ9gj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8c265e-eb56-42e0-e31b-08d757abfa05
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:27:24.5906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sffVItuywTbNeZp+mHiG9rzgwUit6SB65TPdufioLkpImRsDM42DWf1/RoBATpVQz5tsNkV6faV70Ehj8DpvOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1527
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The goal of this patch series is to introduce TEE (Trusted Execution
Environment) interface support to AMD Secure Processor driver. The
TEE is a secure area of a processor which ensures that sensitive data
is stored, processed and protected in an isolated and trusted
environment. The Platform Security Processor (PSP) is a dedicated
processor which provides TEE to enable HW platform security. It offers
protection against software attacks generated in Rich Operating System
(Rich OS) such as Linux running on x86.

Based on the platform feature support, the PSP is capable of supporting
either SEV (Secure Encrypted Virtualization) and/or TEE. The first three
patches in this series is about moving SEV specific functions and data
structures from PSP device driver file to a dedicated SEV interface
driver file. The last two patches add TEE interface support to AMD
Secure Processor driver. This TEE interface will be used by AMD-TEE
driver to submit command buffers for processing in PSP Trusted Execution
Environment.

Rijo Thomas (5):
  crypto: ccp - rename psp-dev files to sev-dev
  crypto: ccp - create a generic psp-dev file
  crypto: ccp - move SEV vdata to a dedicated data structure
  crypto: ccp - add TEE support for Raven Ridge
  crypto: ccp - provide in-kernel API to submit TEE commands

 drivers/crypto/ccp/Makefile  |    4 +-
 drivers/crypto/ccp/psp-dev.c |  983 +++-----------------------------------=
-
 drivers/crypto/ccp/psp-dev.h |   50 +-
 drivers/crypto/ccp/sev-dev.c | 1041 ++++++++++++++++++++++++++++++++++++++=
++++
 drivers/crypto/ccp/sev-dev.h |   62 +++
 drivers/crypto/ccp/sp-dev.h  |   17 +-
 drivers/crypto/ccp/sp-pci.c  |   43 +-
 drivers/crypto/ccp/tee-dev.c |  363 +++++++++++++++
 drivers/crypto/ccp/tee-dev.h |  109 +++++
 include/linux/psp-tee.h      |   72 +++
 10 files changed, 1796 insertions(+), 948 deletions(-)
 create mode 100644 drivers/crypto/ccp/sev-dev.c
 create mode 100644 drivers/crypto/ccp/sev-dev.h
 create mode 100644 drivers/crypto/ccp/tee-dev.c
 create mode 100644 drivers/crypto/ccp/tee-dev.h
 create mode 100644 include/linux/psp-tee.h

--=20
1.9.1

