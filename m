Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6441DC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 13:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D41F2063F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 13:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="x4JdtJm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbfFXNEf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 09:04:35 -0400
Received: from mail-eopbgr770075.outbound.protection.outlook.com ([40.107.77.75]:49031
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728822AbfFXNEf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 09:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JLlDlvFhCcJIQzpydKJY3hau2buvTHM+an3PjEdCz4=;
 b=x4JdtJm87JoO93ZIIbj6YdUtFtwRuJe8wlAKyqFtcVQCkw5wOkQx9+3xXkMC43+zsn+EERGwxdcfMFYz7zp6/IH6DY+GoUgrf9COozziF30mYK1xOV4PrvLR83jFA0OfTJ59oAIrwY8KTU+yW9NcnSWz7xxiIo1gH/cLbZMo2dw=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3561.namprd12.prod.outlook.com (20.178.199.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 13:04:31 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 13:04:31 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     David Rientjes <rientjes@google.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Cfir Cohen <cfir@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [patch] crypto: ccp - Free ccp if initialization fails
Thread-Topic: [patch] crypto: ccp - Free ccp if initialization fails
Thread-Index: AQHVKfh8QDLnRCzIJUeFMXpiNi6AOKaqxsWA
Date:   Mon, 24 Jun 2019 13:04:30 +0000
Message-ID: <15049ef5-c705-037b-b63e-09aa6f098bdf@amd.com>
References: <alpine.DEB.2.21.1906231217040.15277@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1906231217040.15277@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:3:9a::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb96e752-000b-43d4-14b4-08d6f8a47eb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3561;
x-ms-traffictypediagnostic: DM6PR12MB3561:
x-microsoft-antispam-prvs: <DM6PR12MB3561DB9525224AB72225D86DECE00@DM6PR12MB3561.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(53546011)(76176011)(14444005)(71200400001)(71190400001)(5660300002)(6512007)(6486002)(72206003)(6436002)(229853002)(316002)(14454004)(11346002)(256004)(446003)(53936002)(4744005)(476003)(66066001)(486006)(86362001)(66946007)(31696002)(6246003)(73956011)(2616005)(66556008)(64756008)(66446008)(66476007)(478600001)(3846002)(386003)(7736002)(2906002)(305945005)(8676002)(6506007)(6116002)(99286004)(81156014)(81166006)(26005)(102836004)(25786009)(68736007)(186003)(4326008)(54906003)(36756003)(110136005)(31686004)(52116002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3561;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pBCGS5aS06A3PFXKhAyTNLpYf5H493eazOZMVAUwhVJ+r9WNoH/Qyo6n9uPjihuEYZU5X3dveZmZ5Rh4/Y1dT7Yy5NufoWdPp6K3Lno14Jnz2ulAPKQ1gsu6BEYEvTGtsQ6xGyc3WjUcdSkezWNDQ7KlwiXsdIxi+TnuMyk5N05GCtmzDJIwE07OEtkEfiEyIWem/oRV+xVdp0YuS2uT5J2WcXU/iBPNWvC/j0hGqfvA0rLgLavDqbRSzb/w2xVCr4C2tNh7f1vcQsJST/CtkzFqUP8d++sEaGoTXbq/pP7JKQNscNLrUHjtJFdwuqUaEl6oy0edev7jMC6lLSIrWVZVJuDWLHsHAjY/fV4ZoUvy28MKVC8LzoUXi43uZEhXZJp4ESji3txrWVZBYOyk5uiu5QA0A98uTB4mNpAwstE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F6D18AC9BAAC448B018795FAD544990@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb96e752-000b-43d4-14b4-08d6f8a47eb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 13:04:31.1137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3561
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yMy8xOSAyOjE4IFBNLCBEYXZpZCBSaWVudGplcyB3cm90ZToNCj4gSWYgY2NwX2Rldl9p
bml0KCkgZmFpbHMsIGtmcmVlKCkgdGhlIGFsbG9jYXRlZCBjY3Agc2luY2UgaXQgd2lsbCBvdGhl
cndpc2UNCj4gYmUgbGVha2VkLg0KDQpOb3QgbmVlZGVkLiBJdCdzIGFsbG9jYXRlZCB3aXRoIGRl
dm1fa3phbGxvYygpLCBzbyBpdCB3b24ndCBiZSBsZWFrZWQuDQoNClRoYW5rcywNClRvbQ0KDQo+
IA0KPiBGaXhlczogNzIwNDE5ZjAxODMyICgiY3J5cHRvOiBjY3AgLSBJbnRyb2R1Y2UgdGhlIEFN
RCBTZWN1cmUgUHJvY2Vzc29yDQo+IGRldmljZSIpDQo+IA0KPiBSZXBvcnRlZC1ieTogQ2ZpciBD
b2hlbiA8Y2ZpckBnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBSaWVudGplcyA8
cmllbnRqZXNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRl
di5jIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jIGIvZHJpdmVycy9jcnlwdG8vY2Nw
L2NjcC1kZXYuYw0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jDQo+ICsrKyBi
L2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmMNCj4gQEAgLTYwOSw2ICs2MDksNyBAQCBpbnQg
Y2NwX2Rldl9pbml0KHN0cnVjdCBzcF9kZXZpY2UgKnNwKQ0KPiAgDQo+ICBlX2VycjoNCj4gIAlz
cC0+Y2NwX2RhdGEgPSBOVUxMOw0KPiArCWtmcmVlKGNjcCk7DQo+ICANCj4gIAlkZXZfbm90aWNl
KGRldiwgImNjcCBpbml0aWFsaXphdGlvbiBmYWlsZWRcbiIpOw0KPiAgDQo+IA0K
