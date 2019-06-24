Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E773C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323FB205C9
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 14:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="C1y1JvQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfFXO6X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 10:58:23 -0400
Received: from mail-eopbgr720046.outbound.protection.outlook.com ([40.107.72.46]:64128
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbfFXO6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 10:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5g9c1pcvu0CGtYJyY4OOQfApvVNzvtMWOG441d/AwDw=;
 b=C1y1JvQcJbagRg950i9jbBzyLR1qw75CavkR8k3mnn4o+427xYzh3CIi/3BQ59X8aPT57/UKiaPBFNYceaf/zuPPC54vvYCxdbMA9xs5HWa4Fs1TjfWxfNSRZ1AvCWWt53KNMkTL179kG5nvdKLyKRyYlPshmZuZUUMcb5h7PH4=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2344.namprd12.prod.outlook.com (52.132.140.167) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 14:58:18 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 14:58:18 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Cfir Cohen <cfir@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [patch] crypto: ccp - Free ccp if initialization fails
Thread-Topic: [patch] crypto: ccp - Free ccp if initialization fails
Thread-Index: AQHVKfh+FSctFRz9hkibcYHBC/MasaaqxscAgAAflAA=
Date:   Mon, 24 Jun 2019 14:58:17 +0000
Message-ID: <3e08ed08-11a5-6955-5f56-31d0e2f2b8a0@amd.com>
References: <alpine.DEB.2.21.1906231217040.15277@chino.kir.corp.google.com>
 <15049ef5-c705-037b-b63e-09aa6f098bdf@amd.com>
In-Reply-To: <15049ef5-c705-037b-b63e-09aa6f098bdf@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR11CA0036.namprd11.prod.outlook.com
 (2603:10b6:5:190::49) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6679e9a9-45c3-4465-62f6-08d6f8b463fa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2344;
x-ms-traffictypediagnostic: DM5PR12MB2344:
x-microsoft-antispam-prvs: <DM5PR12MB2344A83BA5238A8B06FC9297FDE00@DM5PR12MB2344.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:580;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(110136005)(8936002)(5660300002)(14454004)(229853002)(3846002)(81156014)(81166006)(6116002)(71190400001)(71200400001)(6486002)(6512007)(6246003)(36756003)(72206003)(478600001)(66946007)(2906002)(73956011)(4744005)(6436002)(31696002)(66556008)(64756008)(66446008)(66476007)(7736002)(68736007)(53546011)(4326008)(25786009)(66066001)(76176011)(386003)(53936002)(486006)(14444005)(99286004)(54906003)(476003)(6506007)(102836004)(8676002)(26005)(52116002)(446003)(11346002)(2616005)(186003)(305945005)(256004)(31686004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2344;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5r/ggOJ19q6pJtJEUTr0V4pQbYtKvAaI1uPo6NCQvJSkhG7MmVBn6T94HA3V6DC16ZgXx0BHHdLRc5XNJcPrXgmW8k388OPZkatt2NYyogaJ86p+to6tZX1kwMFQ49xoCi7LQXKsnilQZQlBdHIKS9Lfd6fg39r7t95wJSXMJ/AnjfmolWsdTuYWI1AOGsj+awaymUfiGZ1IZrNs2XYWeaj876PEhGbQGpe3oIxu8DpBNjfPv4rAQ8VCizfbEmmbVCzshFnhqZoqWh0llW+yZ9PhXQUy/+dbhes6cu58zWP87EgziFyd+vpkwf+D7bcyVcIlgMAW3xGCaiztiP0cy64aqQwWfXWh6LbOcVhZ8A+Aa9Wm++69nAOPAHqP3jK4YHUYj5UAmi0mHf1WvKpwW7+XXdodG4cWBp9xGz7NgNM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <279AF1D2087FFB4D8E4DFD0A0FE6D431@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6679e9a9-45c3-4465-62f6-08d6f8b463fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 14:58:17.8502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2344
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSA4OjA0IEFNLCBMZW5kYWNreSwgVGhvbWFzIHdyb3RlOg0KPiBPbiA2LzIzLzE5
IDI6MTggUE0sIERhdmlkIFJpZW50amVzIHdyb3RlOg0KPj4gSWYgY2NwX2Rldl9pbml0KCkgZmFp
bHMsIGtmcmVlKCkgdGhlIGFsbG9jYXRlZCBjY3Agc2luY2UgaXQgd2lsbCBvdGhlcndpc2UNCj4+
IGJlIGxlYWtlZC4NCj4gDQo+IE5vdCBuZWVkZWQuIEl0J3MgYWxsb2NhdGVkIHdpdGggZGV2bV9r
emFsbG9jKCksIHNvIGl0IHdvbid0IGJlIGxlYWtlZC4NCj4gDQo+IFRoYW5rcywNCj4gVG9tDQoN
Ck5hY2tlZC1CeTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KDQo+IA0KPj4NCj4+
IEZpeGVzOiA3MjA0MTlmMDE4MzIgKCJjcnlwdG86IGNjcCAtIEludHJvZHVjZSB0aGUgQU1EIFNl
Y3VyZSBQcm9jZXNzb3INCj4+IGRldmljZSIpDQo+Pg0KPj4gUmVwb3J0ZWQtYnk6IENmaXIgQ29o
ZW4gPGNmaXJAZ29vZ2xlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IERhdmlkIFJpZW50amVzIDxy
aWVudGplc0Bnb29nbGUuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3At
ZGV2LmMgfCAxICsNCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+Pg0KPj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmMgYi9kcml2ZXJzL2NyeXB0
by9jY3AvY2NwLWRldi5jDQo+PiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jDQo+
PiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jDQo+PiBAQCAtNjA5LDYgKzYwOSw3
IEBAIGludCBjY3BfZGV2X2luaXQoc3RydWN0IHNwX2RldmljZSAqc3ApDQo+PiAgIA0KPj4gICBl
X2VycjoNCj4+ICAgCXNwLT5jY3BfZGF0YSA9IE5VTEw7DQo+PiArCWtmcmVlKGNjcCk7DQo+PiAg
IA0KPj4gICAJZGV2X25vdGljZShkZXYsICJjY3AgaW5pdGlhbGl6YXRpb24gZmFpbGVkXG4iKTsN
Cj4+ICAgDQo+Pg0KDQo=
