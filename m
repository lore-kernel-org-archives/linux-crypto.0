Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FC3C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28B5D20645
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="lkp9xvf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfFXTHv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:07:51 -0400
Received: from mail-eopbgr730086.outbound.protection.outlook.com ([40.107.73.86]:12516
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729146AbfFXTHv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urgLOV1FExNoseo8dSa71pKIYiP+PKatEBf1iJSXlnk=;
 b=lkp9xvf5wv8S2b4mEkQrz9wdCyZEqb/S2QDllKkKIpHN5yYG10NkAaHgF648sBECC6vAWDV+ubZQvuHymjt+gOYqEEfad+hoTYhlV7B0eNvs2MD9nHdokwkIA6TxE0iTUtVddDnLbiOT6wpah7zrKr0By7I6el+1nXbzn6r9aoQ=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:07:49 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:07:49 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 2/3] crypto: doc - Describe the crypto engine
Thread-Topic: [PATCH 2/3] crypto: doc - Describe the crypto engine
Thread-Index: AQHVKsAd+xpmsaFX3kCZNKb6odNQPw==
Date:   Mon, 24 Jun 2019 19:07:49 +0000
Message-ID: <156140326736.29777.7751606850237303573.stgit@taos>
References: <156140322426.29777.8610751479936722967.stgit@taos>
In-Reply-To: <156140322426.29777.8610751479936722967.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0044.namprd05.prod.outlook.com
 (2603:10b6:803:41::21) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de92951a-52ed-4e88-a7e9-08d6f8d73fc8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2471;
x-ms-traffictypediagnostic: DM5PR12MB2471:
x-microsoft-antispam-prvs: <DM5PR12MB247195682ACCA587475C070CFDE00@DM5PR12MB2471.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(39860400002)(346002)(366004)(376002)(136003)(199004)(189003)(316002)(64756008)(66066001)(66446008)(186003)(5660300002)(68736007)(486006)(72206003)(6436002)(6512007)(14454004)(9686003)(476003)(86362001)(6486002)(99286004)(33716001)(446003)(76176011)(3846002)(52116002)(6116002)(11346002)(2201001)(66556008)(25786009)(81156014)(4744005)(8676002)(81166006)(110136005)(305945005)(7736002)(2501003)(103116003)(8936002)(478600001)(26005)(73956011)(66946007)(102836004)(2906002)(256004)(386003)(6506007)(71190400001)(71200400001)(66476007)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2471;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pE3kHWos26QjHwFqhJbeVDzJDSZ9PIOct2D0OEZ9XDO3RsmzspQo75uKwZx5aBsgEKTWx/hosTNFvuxL/N8xhyzYZ9kA2JCzfprtSso/szP5K4/v9wI8s3mcWV/ect8altzU1aVGmmHOuS4fwC57g1zZVPkb9VcBNgdDjEQ+QG5QnkH0mgCYzqsWoqMsMk/J5mmSuvTcfvivShW+lJ1DSO61/btFo4I4L2jXTJNL8ZQ3Jia4ggL8DAQi0loonZ5T2cxpfq0Pr7ghlarmAWie+6jWLtuaRGno0ICYsa+ssM5RyNwIY0WQzJXKV/1sv0Ol7U3bju5YJeh+p0C3Mj3SkNhLaJXrXVbPwYnMUXMEb5AlgWRa5b98wDJGSm6/0eLOrp9GI6COGejAjxxdXRnjtHx+zWu7YvZnd/h673cdo9w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31AAA56924FEA34BB0FC183DDB51A70C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de92951a-52ed-4e88-a7e9-08d6f8d73fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:07:49.4518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2471
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a reference to the crypto engine documentation to
the index.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 Documentation/crypto/index.rst |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rs=
t
index c4ff5d791233..37cd7fb0ea82 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -19,6 +19,7 @@ for cryptographic use cases, as well as programming examp=
les.
    intro
    architecture
    devel-algos
+   crypto_engine
    userspace-if
    crypto_engine
    api

