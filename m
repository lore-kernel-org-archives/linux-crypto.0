Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E910C48BD6
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 23:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25302086D
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 23:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ETDkH+Sg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfFYXnp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 19:43:45 -0400
Received: from mail-eopbgr740050.outbound.protection.outlook.com ([40.107.74.50]:41394
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFYXnp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 19:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13Sl8mF6O63R0DMug/w9E0Qgshwu1JbpMmKNbx/I+Nc=;
 b=ETDkH+SgSfkAEYx0U5QSi6oLiUTSbm3huSgRdRA+a/13MTsRnV5xvuFxYnfLwQQagJUvHprrHvmjSr+VVdaQuNcWn1fKf9kS81FbOd5PuE6iz0MqVrmR0WLy2n7k+9JcT3p/LbVmkbYPYXAo3MKtJ8HI0LPo1mfZwA88T902v5E=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1818.namprd12.prod.outlook.com (10.175.92.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 23:43:37 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 23:43:37 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 0/2] Clean up crypto documentation
Thread-Topic: [PATCH v2 0/2] Clean up crypto documentation
Thread-Index: AQHVK6/O2ulgN25geEeArre8s+tJHg==
Date:   Tue, 25 Jun 2019 23:43:36 +0000
Message-ID: <156150616764.22527.16524544899486041609.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:805:a2::25) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 407acde8-a9e7-4143-2e10-08d6f9c6f14f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1818;
x-ms-traffictypediagnostic: DM5PR12MB1818:
x-microsoft-antispam-prvs: <DM5PR12MB18187B19F7A945C7D709474DFDE30@DM5PR12MB1818.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(136003)(39860400002)(366004)(396003)(346002)(199004)(189003)(4744005)(25786009)(99286004)(33716001)(81166006)(2201001)(81156014)(5660300002)(8936002)(53936002)(7736002)(66066001)(9686003)(6116002)(6512007)(3846002)(6486002)(305945005)(8676002)(6436002)(2501003)(66946007)(256004)(73956011)(478600001)(14454004)(68736007)(2906002)(316002)(64756008)(102836004)(386003)(6506007)(72206003)(66476007)(186003)(71200400001)(52116002)(103116003)(476003)(71190400001)(110136005)(486006)(66556008)(66446008)(26005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1818;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AXrBk6GoNW0GSLGxKmgmxZUS1NedZBzJvDPnC5+0kBF3qyzko1H9tPF9YLCy9tUMpWOdUw7s6EDjG4aOkXX/7STs5IA1a2AHsLj30QgXA/o3pZWkZhnnxBVObCYs7a82knn6fT8qFZhGE73zW9/mcdGpYl03odNOadCArPYUa3gxOJNbNs4pbCYvq2DrIkjHc1ould5K1cLvc/ktYNOF+y00m7DyEnIMy8u6jNIZ0sITFerqM09doWzumM9Rva3erHeRjeEDEAW4UqEgwr9ef9/Aet/ans9pLLr0qQmeKC4nGT4I+NVbEZejLXpzpDaFwTK2c+r3dh35sC3Fwbs1bf68+HsqM9NjIkHiN8YXIrKND4VXZtQLY4ujaltOT+2U6ZDbJocE0k23ZcIBgCpfJm/uTKkW4oTmE+z8ZBjiH2I=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C9E199BDD620C49AF80CBEA8317743B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407acde8-a9e7-4143-2e10-08d6f9c6f14f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 23:43:36.9585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1818
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tidy up the crypto documentation by filling in some variable
descriptions, make some grammatical corrections, and enhance
formatting.

Changes since v1:
 - Remove patch with superfluous change to index (patch 2)
 - Remove unnecessary markup on function names in patch 3
 - Un-add extraneous white space (patch 3)

---

Gary R Hook (2):
      crypto: doc - Add parameter documentation
      crypto: doc - Fix formatting of new crypto engine content


 Documentation/crypto/api-skcipher.rst  |    2 -
 Documentation/crypto/crypto_engine.rst |  111 +++++++++++++++++++++-------=
----
 include/linux/crypto.h                 |   11 +++
 3 files changed, 85 insertions(+), 39 deletions(-)

--
