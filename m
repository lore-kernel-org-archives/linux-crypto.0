Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD487C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F6D20645
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="hWqaQAxQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfFXTHk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:07:40 -0400
Received: from mail-eopbgr690066.outbound.protection.outlook.com ([40.107.69.66]:10901
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729146AbfFXTHk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDHl/ow0p12RlyOd7AWbf6yJkIx2+b/2EtqT8cEyGt4=;
 b=hWqaQAxQauOBU7fb1GBntEEVu8oLZ47qoTst4H9O3b8qc+PwZyiiWcsN3RGPU/s0SLXSvDxGuwImrllh6k/Togcvm+lH3jJ/1Qh44EMawF17zEb6QdPcx4HvoUp1AOpVebsJvb6X7tF5RHSY9cZ0YKkIhD3w9hgwqSZCs8RZei8=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2584.namprd12.prod.outlook.com (52.132.141.167) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:07:35 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:07:35 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 0/3] Clean up crypto documentation
Thread-Topic: [PATCH 0/3] Clean up crypto documentation
Thread-Index: AQHVKsAU8eHDVMznu0yUy7vS0v5gPA==
Date:   Mon, 24 Jun 2019 19:07:35 +0000
Message-ID: <156140322426.29777.8610751479936722967.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0057.namprd05.prod.outlook.com
 (2603:10b6:803:41::34) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d51d68f2-d2c5-435e-9758-08d6f8d7373d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2584;
x-ms-traffictypediagnostic: DM5PR12MB2584:
x-microsoft-antispam-prvs: <DM5PR12MB2584697E64A5F609F31AED77FDE00@DM5PR12MB2584.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(136003)(366004)(39860400002)(396003)(346002)(199004)(189003)(99286004)(6436002)(25786009)(52116002)(72206003)(33716001)(9686003)(6512007)(256004)(68736007)(110136005)(6116002)(3846002)(476003)(316002)(2906002)(26005)(186003)(102836004)(6486002)(4744005)(386003)(14454004)(5660300002)(486006)(81156014)(86362001)(103116003)(305945005)(81166006)(478600001)(8676002)(66946007)(73956011)(8936002)(66066001)(66446008)(64756008)(66556008)(66476007)(2501003)(71190400001)(71200400001)(6506007)(53936002)(7736002)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2584;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ddut3xfvm1Olag0PX8C5lVF4NpXGI3hnHYWPTMkBIcnnfONHY5EXZ3CrBFodwfFdt4ZBs6W7m9fq9rSZ+jbIPFS0ydlX9t99wyjdbhMY0ZnXg/+DutHWippge4bUkMl8L1ESavUNmnlRJTXr35XulS3L2FvzBum3geTzVUwo6PANKZKU4ayjxySbqz7Yc5Gm4vpT5AAeNOrvCn5jcWIb1JhUBf+kaOIuyad9yCoRoUWEspV1v6oiysFLEAj9Xx1ZHr8boJg0/z4THljmxbwl0nA24O6/2wtuZlSSjKJwQYPba3LxBgozRtEfy7tZbKHaB3eYxvKx9l2OviYtxtcsudr0z7CFOcV21Rshvja0urTHY26K4t+Cc2x28O+1bnkfiZt1qT23nJfTVGEhJpEQSCFKshVxrbahQ11UnVZNrE0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EDCC4146E658804FB59FA6996DBBAA6B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51d68f2-d2c5-435e-9758-08d6f8d7373d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:07:35.1427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2584
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tidy up the crypto documentation by filling in some variable
descriptions, make some grammatical corrections, and enhance
formatting.

---

Gary R Hook (3):
      crypto: doc - Add parameter documentation
      crypto: doc - Describe the crypto engine
      crypto: doc - Fix formatting of new crypto engine content


 Documentation/crypto/api-skcipher.rst  |    2 -
 Documentation/crypto/crypto_engine.rst |  120 ++++++++++++++++++++++------=
----
 Documentation/crypto/index.rst         |    1=20
 include/linux/crypto.h                 |   11 +++
 4 files changed, 95 insertions(+), 39 deletions(-)

--
