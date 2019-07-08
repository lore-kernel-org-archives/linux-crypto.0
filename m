Return-Path: <SRS0=KAtS=VF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3871C606BD
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 17:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9608021479
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 17:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="uj+jsllU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfGHRIM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:08:12 -0400
Received: from mail-eopbgr780042.outbound.protection.outlook.com ([40.107.78.42]:27040
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728323AbfGHRIM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jul 2019 13:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXyyrwNPph9qS1pNK/xUppy4I0eajQuYeHJbvuEJJlU=;
 b=uj+jsllUQvfDA3gjVpLNmFPMSocY6NZaZO+ikUG939co8iFu59VzTEpcxf4Mhf/qcyXGKVFc2mFIaG86fuWr/4Xl67Qlu01M6S08oMR1n8ImRhWoEPHFhQ4hxx/fVCD8q86QI8S0+AIB15d1MyAPlkVUCp4Rw1TXRut9gpFb9bg=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1708.namprd12.prod.outlook.com (10.175.89.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 17:08:09 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Mon, 8 Jul 2019
 17:08:09 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Hook, Gary" <Gary.Hook@amd.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Topic: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVMdSCRv0gts48Gk+YiLK37j85MKa8b1UAgASMbQA=
Date:   Mon, 8 Jul 2019 17:08:09 +0000
Message-ID: <2cc5e065-0fce-5278-9c38-3bdd4755f21f@amd.com>
References: <156218168473.3184.15319927087462863547.stgit@sosrh3.amd.com>
 <20190705194028.GB4022@sol.localdomain>
In-Reply-To: <20190705194028.GB4022@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:2d::24) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73272329-07f7-4734-533b-08d703c6d9ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1708;
x-ms-traffictypediagnostic: DM5PR12MB1708:
x-microsoft-antispam-prvs: <DM5PR12MB170829CD500A2F8745860213FDF60@DM5PR12MB1708.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(386003)(31696002)(6506007)(76176011)(110136005)(102836004)(316002)(54906003)(6246003)(52116002)(99286004)(72206003)(53936002)(31686004)(66556008)(4744005)(71190400001)(5660300002)(305945005)(66476007)(14444005)(36756003)(64756008)(2906002)(26005)(73956011)(66066001)(66446008)(53546011)(71200400001)(186003)(6512007)(14454004)(3846002)(6116002)(229853002)(8676002)(25786009)(11346002)(446003)(7736002)(81166006)(8936002)(68736007)(2616005)(4326008)(81156014)(6486002)(6636002)(66946007)(486006)(256004)(6436002)(476003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1708;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Kc7AncsZ+1Tb4oR2WFh2KaJlQKmjWrQKERa921FZt862XufTxQt3ROIM2WfcX35S3NeZvKuj8tisOv6W8Q8yMGb9JO6hFopaKujpBbQLiftlyTaK93NRmo2hwSoBI2Vduh5eO6fuGN7H612od5UNz6BgiLgoGHgGlJp3ddLUQthLhkkO3eF7kWYUpVKn6HSdvWNdQetxVj5utvHqXk/u2ESQOmiHc5JaLZXhl53c/kcbieMuS3OPDMDnD1mT1TzsANoUzGns4um+LLOwi4LbHfpsdJPC4QQhyu7x3PzpjMwuYH9DAbZhNCDySo4m03woL/GoCeCt2lwkBVy0FjSEzbKnbSXL0VG4c7TZ/3GctnGCfT3iDfKTeyDNYZwFBBJ/MBPCTRmYsRvE0eMtOujk4L30T6ok/MZH9NDAsSvnQGo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0005E7DB6715444FAA7B57771CFD0994@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73272329-07f7-4734-533b-08d703c6d9ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 17:08:09.7021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1708
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy81LzE5IDI6NDAgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gSGkgR2FyeSwNCj4gDQo+
IE9uIFdlZCwgSnVsIDAzLCAyMDE5IGF0IDA3OjIxOjI2UE0gKzAwMDAsIEhvb2ssIEdhcnkgd3Jv
dGU6DQo+PiBUaGUgQUVTIEdDTSBmdW5jdGlvbiByZXVzZXMgYW4gJ29wJyBkYXRhIHN0cnVjdHVy
ZSwgd2hpY2ggbWVtYmVycw0KPj4gY29udGFpbiB2YWx1ZXMgdGhhdCBtdXN0IGJlIGNsZWFyZWQg
Zm9yIGVhY2ggKHJlKXVzZS4NCj4+DQo+PiBGaXhlczogMzZjZjUxNWI5YmJlICgiY3J5cHRvOiBj
Y3AgLSBFbmFibGUgc3VwcG9ydCBmb3IgQUVTIEdDTSBvbiB2NSBDQ1BzIikNCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+PiAtLS0NCj4+ICAg
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYyB8ICAgMTIgKysrKysrKysrKystDQo+PiAgIDEg
ZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBJcyB0
aGlzIHBhdGNoIG1lYW50IHRvIGZpeCB0aGUgZ2NtLWFlcy1jY3Agc2VsZi10ZXN0cyBmYWlsdXJl
Pw0KDQpZZXNzaXIsIHRoYXQgaXMgdGhlIGludGVudGlvbi4gQXBvbG9naWVzIGZvciBub3QgY2xh
cmlmeWluZyB0aGF0IHBvaW50Lg0KDQpncmgNCg0KDQo=
