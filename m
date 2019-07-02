Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC24C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 354F920663
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="h7w+7gNS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfGBPlZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:41:25 -0400
Received: from mail-eopbgr750045.outbound.protection.outlook.com ([40.107.75.45]:24708
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbfGBPlZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iMY03FxnNPk9Bvi0MCYQ80rze6xHLN/U7cSyGSkjHA=;
 b=h7w+7gNSugd1vsyDM81hUuWjRpVa4lrMWI8sAswlWRl7CWuVPh728B+lJubjFXLaDkDQwMEvd2DcS4wpd2Arz3RDi4mQ4xROrjYR8D7PwQd81BwVcaW7M8X8TDOd2TkBAKsGWOTH7+TZSkt5n2Yr0Id7AYTQUV58dWK2ClmKRH4=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1483.namprd12.prod.outlook.com (10.172.38.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 15:41:23 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 15:41:23 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Eric Biggers <ebiggers@kernel.org>, Cfir Cohen <cfir@google.com>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp/gcm - use const time tag comparison.
Thread-Topic: [PATCH] crypto: ccp/gcm - use const time tag comparison.
Thread-Index: AQHVMGlxe9at0dFonUmGbCxN6WOFAKa2eHIAgAD/6wA=
Date:   Tue, 2 Jul 2019 15:41:23 +0000
Message-ID: <1eea04e4-ac19-241d-695b-61be43640509@amd.com>
References: <20190702000132.88836-1-cfir@google.com>
 <20190702002522.GA693@sol.localdomain>
In-Reply-To: <20190702002522.GA693@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR0102CA0002.prod.exchangelabs.com (2603:10b6:805:1::15)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a873109a-2af5-4bfc-7700-08d6ff03bc35
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1483;
x-ms-traffictypediagnostic: DM5PR12MB1483:
x-microsoft-antispam-prvs: <DM5PR12MB1483D854CB00EFD28DCD74AEFDF80@DM5PR12MB1483.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(189003)(199004)(11346002)(6512007)(316002)(31696002)(6436002)(6486002)(4326008)(446003)(186003)(36756003)(256004)(3846002)(53936002)(478600001)(2906002)(31686004)(54906003)(6116002)(110136005)(229853002)(66066001)(6246003)(26005)(6506007)(5660300002)(66446008)(66946007)(25786009)(486006)(7736002)(71190400001)(53546011)(8936002)(68736007)(386003)(102836004)(71200400001)(76176011)(81156014)(99286004)(52116002)(8676002)(2616005)(73956011)(81166006)(66556008)(476003)(14454004)(64756008)(305945005)(72206003)(14444005)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1483;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BDVIK6/i6LDK76vYEGSOmtcP95b6Hl743w0DFaA6QIHtQlEyGeX2uenuEmFLVHmVwZYtp3wbqqA9/zVH5Aer8rgEjKaZ9/gANip3ipeaq7axRtNEs/4xfdCrFsDhBCwR4VpYnxT8QrBu0vGtENSCHjuWSMnATmE2Xgroe9TEphcH+1PBKmluTijZxWsGDhfXj4h9CWXBEZNJFmLxzob3wiq8AnvtZnAtffwZ9RMOUDaVfr+hakcxfudCZ2fuD0mZyObJEGpbD9rorpLq+0K9EO91yCoTYclXonN4DqINRB5IdOQo/LeyYcjOmQtpoy+PqjDCU/NVuds7l84a/dVoaJ51X/ZoxxLUOp3atDiwZxi6+3oNplRovL+1Tgu4j0lGoOzUCcnpaaMxjkyoySu4W25Q37eBDna6FNx+Eat1PLg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F13352138BA5964B9EDFB4E7FF36AFBC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a873109a-2af5-4bfc-7700-08d6ff03bc35
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 15:41:23.5115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1483
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xLzE5IDc6MjUgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gT24gTW9uLCBKdWwgMDEs
IDIwMTkgYXQgMDU6MDE6MzJQTSAtMDcwMCwgQ2ZpciBDb2hlbiB3cm90ZToNCj4+IEF2b2lkIGxl
YWtpbmcgR0NNIHRhZyB0aHJvdWdoIHRpbWluZyBzaWRlIGNoYW5uZWwuDQo+Pg0KPj4gU2lnbmVk
LW9mZi1ieTogQ2ZpciBDb2hlbiA8Y2ZpckBnb29nbGUuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZl
cnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMgfCAzICsrLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y3J5cHRvL2NjcC9jY3Atb3BzLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5jDQo+PiBp
bmRleCBkYjhkZTg5ZDk5MGYuLjYzMzY3MDIyMGY2YyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMv
Y3J5cHRvL2NjcC9jY3Atb3BzLmMNCj4+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3Bz
LmMNCj4+IEBAIC04NDAsNyArODQwLDggQEAgc3RhdGljIGludCBjY3BfcnVuX2Flc19nY21fY21k
KHN0cnVjdCBjY3BfY21kX3F1ZXVlICpjbWRfcSwNCj4+ICAgCQlpZiAocmV0KQ0KPj4gICAJCQln
b3RvIGVfdGFnOw0KPj4gICANCj4+IC0JCXJldCA9IG1lbWNtcCh0YWcuYWRkcmVzcywgZmluYWxf
d2EuYWRkcmVzcywgQUVTX0JMT0NLX1NJWkUpOw0KPj4gKwkJcmV0ID0gY3J5cHRvX21lbW5lcSh0
YWcuYWRkcmVzcywgZmluYWxfd2EuYWRkcmVzcywNCj4+ICsJCQkJICAgIEFFU19CTE9DS19TSVpF
KSA/IC1FQkFETVNHIDogMDsNCj4+ICAgCQljY3BfZG1fZnJlZSgmdGFnKTsNCj4+ICAgCX0NCj4+
ICAgDQo+PiAtLSANCj4+IDIuMjIuMC40MTAuZ2Q4ZmRiZTIxYjUtZ29vZw0KPj4NCj4gDQo+IExv
b2tzIGxpa2UgdGhpcyBuZWVkczoNCj4gDQo+IAlGaXhlczogMzZjZjUxNWI5YmJlICgiY3J5cHRv
OiBjY3AgLSBFbmFibGUgc3VwcG9ydCBmb3IgQUVTIEdDTSBvbiB2NSBDQ1BzIikNCj4gCUNjOiA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC4xMisNCg0KDQpZZXMsIGl0IGRvZXMuIEZvciBj
bGFyaXR5LCBkb2VzIHRoYXQgbWVhbiB5b3UndmUgdGFrZW4gY2FyZSBvZiB0aGlzPw0KDQo=
