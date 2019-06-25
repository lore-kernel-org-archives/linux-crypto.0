Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BF4C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731A7214DA
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="LGr9Jw+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfFYNFJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 09:05:09 -0400
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:1924
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729440AbfFYNFJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 09:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wReQ+sPyOfw/5/jld0bgD9yhadk4anxbkoD1Hgt1YA4=;
 b=LGr9Jw+YdOoWQGdWRM1H4f5D40vjP/qWhp1QvjVrICWeNcGbu4/CRWGU2WfrClZndfn5xyQYbKgEv4Qi8cXeduM4zKw15MMec81HP1A1suuoCGpS/k7sWm2yoU+4vwBYDRtuFJquLU4hGTaOOHnApk/bG225foNLX0R/ElckU+0=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1436.namprd12.prod.outlook.com (10.168.239.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 13:05:04 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 13:05:04 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Hook, Gary" <Gary.Hook@amd.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: doc - Describe the crypto engine
Thread-Topic: [PATCH 2/3] crypto: doc - Describe the crypto engine
Thread-Index: AQHVKsAd+xpmsaFX3kCZNKb6odNQP6arW70AgAD79IA=
Date:   Tue, 25 Jun 2019 13:05:04 +0000
Message-ID: <9e89535a-f3c8-43fe-be77-d2e972dd2503@amd.com>
References: <156140322426.29777.8610751479936722967.stgit@taos>
 <156140326736.29777.7751606850237303573.stgit@taos>
 <20190624220313.GB237341@gmail.com>
In-Reply-To: <20190624220313.GB237341@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR15CA0013.namprd15.prod.outlook.com
 (2603:10b6:805:16::26) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7c606bc-77e0-47bd-51e6-08d6f96dbd08
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1436;
x-ms-traffictypediagnostic: DM5PR12MB1436:
x-microsoft-antispam-prvs: <DM5PR12MB1436FBD3D774E1D34E193F27FDE30@DM5PR12MB1436.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(136003)(396003)(366004)(189003)(199004)(4744005)(6116002)(8936002)(7736002)(53936002)(3846002)(6486002)(305945005)(486006)(446003)(2616005)(476003)(72206003)(186003)(66476007)(64756008)(110136005)(66446008)(6512007)(11346002)(229853002)(54906003)(66556008)(5660300002)(73956011)(256004)(26005)(66946007)(6636002)(6436002)(52116002)(31686004)(478600001)(99286004)(66066001)(36756003)(4326008)(53546011)(102836004)(6506007)(386003)(71190400001)(14454004)(8676002)(81156014)(76176011)(81166006)(316002)(68736007)(25786009)(31696002)(2906002)(6246003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1436;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7U2/Pis5C1S5ZejbajkCwNgP3Ov+WF3BadWi3eKv8c0DNzVYdhhJtkFnvPersJd5CxJWVH0liHYYspE0VhoQOdVSA2KL82Ukth3e9F297TA2ZMlHV+3DuljWiOblMDipXitjtIk9qNly7MGohYegw8/4rwS8eZS18KcEX1BTAbJW9mPHjtVjUxRoi/CZx2xG3UgWL4vikUUjRbIaHoBI86NFTwPvAy9WtZw1DEARI3dBT3/cny+yhO2HfGXmxPRTVsU/Ef4WIXcwbTRnkxwx3jeCnYutCeYaXaVtd8iN0NbnIeQCYuc6B3e8VSJybZF0REc3XsP34gNvRHyw0pi8ERjAWtvUEKeZogbl+Fg/BaZI8i5DvohuPfgvHLdE0ODOjaDSJbcx7qEL4dNVGTeo9v1I7zRQ2uM7s7N7HdQUQd0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73EFC7EE0FD28E4B8A4BDB6770E1637E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c606bc-77e0-47bd-51e6-08d6f96dbd08
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 13:05:04.1837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1436
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSA1OjAzIFBNLCBFcmljIEJpZ2dlcnMgd3JvdGU6DQo+IE9uIE1vbiwgSnVuIDI0
LCAyMDE5IGF0IDA3OjA3OjQ5UE0gKzAwMDAsIEhvb2ssIEdhcnkgd3JvdGU6DQo+PiBBZGQgYSBy
ZWZlcmVuY2UgdG8gdGhlIGNyeXB0byBlbmdpbmUgZG9jdW1lbnRhdGlvbiB0bw0KPj4gdGhlIGlu
ZGV4Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNv
bT4NCj4+IC0tLQ0KPj4gICBEb2N1bWVudGF0aW9uL2NyeXB0by9pbmRleC5yc3QgfCAgICAxICsN
Cj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L0RvY3VtZW50YXRpb24vY3J5cHRvL2luZGV4LnJzdCBiL0RvY3VtZW50YXRpb24vY3J5cHRvL2lu
ZGV4LnJzdA0KPj4gaW5kZXggYzRmZjVkNzkxMjMzLi4zN2NkN2ZiMGVhODIgMTAwNjQ0DQo+PiAt
LS0gYS9Eb2N1bWVudGF0aW9uL2NyeXB0by9pbmRleC5yc3QNCj4+ICsrKyBiL0RvY3VtZW50YXRp
b24vY3J5cHRvL2luZGV4LnJzdA0KPj4gQEAgLTE5LDYgKzE5LDcgQEAgZm9yIGNyeXB0b2dyYXBo
aWMgdXNlIGNhc2VzLCBhcyB3ZWxsIGFzIHByb2dyYW1taW5nIGV4YW1wbGVzLg0KPj4gICAgICBp
bnRybw0KPj4gICAgICBhcmNoaXRlY3R1cmUNCj4+ICAgICAgZGV2ZWwtYWxnb3MNCj4+ICsgICBj
cnlwdG9fZW5naW5lDQo+PiAgICAgIHVzZXJzcGFjZS1pZg0KPj4gICAgICBjcnlwdG9fZW5naW5l
DQo+PiAgICAgIGFwaQ0KPj4NCj4gDQo+IEl0J3MgYWxyZWFkeSBpbiB0aGUgbGlzdC4NCg0KR2Fo
ISBBbmQgYXQgdGhlIG1vbWVudCBJIGNhbid0IHJlbWVtYmVyIHdoeSB0aGF0IGV2ZW4gZ290IHB1
dCB0aGVyZS4NCg0KQXBvbG9naWVzLg0KDQpncmgNCg==
