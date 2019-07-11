Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C1AC74A35
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 15:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28A4620872
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 15:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="WwinmF9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfGKPZD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 11:25:03 -0400
Received: from mail-eopbgr790079.outbound.protection.outlook.com ([40.107.79.79]:58252
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728438AbfGKPZD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 11:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6e+nCAYrjJDWyoMk1Hk13wIfHzFHpvi/tGHBKVpMjTw=;
 b=WwinmF9WPfwInVmxp8Fe7otVz9MaUd0+akz03W7vBwnWsjROSzzMqv+Gb2sKy38yBvWVZGeot+Dpjgx1HgktDFEAeQCusGhhRODYq8rPwQYFhqDHbRfHgdkx9TWgZ9h+qrUJwAoGJHqzQ9jaroHQsmdSnoELafsw9rfsalaIzwc=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1769.namprd12.prod.outlook.com (10.175.89.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 15:25:01 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 15:25:01 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Topic: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVNrO6m+NQJFdJik6RYa0T/lhkoKbDGDyAgACXVICAAKDHgP//0i2AgAB0LYCAAPWBgA==
Date:   Thu, 11 Jul 2019 15:25:00 +0000
Message-ID: <7a4dfdce-41ca-2047-f9f2-77e0b7abedb3@amd.com>
References: <20190710000849.3131-1-gary.hook@amd.com>
 <20190710015725.GA746@sol.localdomain>
 <2875285f-d438-667e-52d9-801124ffba88@amd.com>
 <20190710203428.GC83443@gmail.com>
 <d4b8006c-0243-b4a4-c695-a67041acc82f@amd.com>
 <20190711004617.GA628@sol.localdomain>
In-Reply-To: <20190711004617.GA628@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0032.prod.exchangelabs.com (2603:10b6:804:2::42)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41143925-8a80-44ca-da3b-08d70613f090
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1769;
x-ms-traffictypediagnostic: DM5PR12MB1769:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR12MB17691BB557955B7BE4E9CD3DFDF30@DM5PR12MB1769.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(8676002)(8936002)(966005)(81166006)(4744005)(478600001)(2201001)(99286004)(52116002)(31696002)(76176011)(229853002)(66446008)(71200400001)(68736007)(64756008)(256004)(3846002)(316002)(71190400001)(110136005)(66476007)(81156014)(66556008)(36756003)(305945005)(31686004)(14454004)(66946007)(7736002)(6436002)(6486002)(53936002)(186003)(26005)(6116002)(6246003)(6306002)(6636002)(6512007)(5660300002)(102836004)(2616005)(11346002)(2501003)(476003)(25786009)(446003)(53546011)(66066001)(486006)(2906002)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1769;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8TNzS+dGF2/smcm7ule4rVOxap5ddKAmfg+kle6pEd/z4MlMgtKCtFe824IuYlMU/uWHNwrnrYnp4IpwyQ5yEW8RSzcjLTdpv9CSqk3MILT3YveKbaxJ1yC+u338AKjHAMkTonC9rep/JSJG5l20X/nCSiWRF5aJuzJeCHFheoOP4ZUg6ScT4X8OrlHAr7ifTCL9jjS3q9m1gIFkVI/ybNoNHu3vtiB9ichepEgmDvwJ///FqV79t/hHzRBdbViqEyIDRgIQnhOtxZUmjfpfiPAnWCfzO3Ir2dy9kB8DCOfwoer7aOo/hTpJ/mATGeUjrFQtAWZ2hjutbN2xDZnfJr8BWMerYysC8ZA6WNZ+wW/hnt1BfrC9lzam6lJ5dZ1CGxrwfJbV+WBbxNPpLKYSIBr7Tbyte4Lq2IivEzjxX7g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95A04282416FEF42B39559D16439721E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41143925-8a80-44ca-da3b-08d70613f090
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 15:25:00.9927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1769
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xMC8xOSA3OjQ2IFBNLCBFcmljIEJpZ2dlcnMgd3JvdGU6DQo+IA0KPiBUaGUgZ2VuZXJp
YyBpbXBsZW1lbnRhdGlvbiBhbGxvd3MgYXV0aGVudGljYXRpb24gdGFncyBvZiA0LCA4LCAxMiwg
MTMsIDE0LCAxNSwNCj4gb3IgMTYgYnl0ZXMuICBTZWUgY3J5cHRvX2djbV9zZXRhdXRoc2l6ZSgp
IGluIGNyeXB0by9nY20uYywgYW5kIHNlZQ0KPiBodHRwczovL252bHB1YnMubmlzdC5nb3Yvbmlz
dHB1YnMvTGVnYWN5L1NQL25pc3RzcGVjaWFscHVibGljYXRpb244MDAtMzhkLnBkZg0KPiBzZWN0
aW9uIDUuMi4xLjIgIk91dHB1dCBEYXRhIi4gIElmIHlvdSBkaXNhZ3JlZSB0aGF0IHRoaXMgaXMg
dGhlIGNvcnJlY3QNCj4gYmVoYXZpb3IsIHRoZW4gd2UgbmVlZCB0byBmaXggdGhlIGdlbmVyaWMg
aW1wbGVtZW50YXRpb24gdG9vLg0KDQpJdCdzIGJlZW4gYSB3aGlsZSwgYW5kIHRoZSByZWZyZXNo
ZXIgd2FzIG5lZWRlZCwgYW5kIGlzIGFwcHJlY2lhdGVkLg0KDQpPdXIgZGV2aWNlIG9ubHkgYWxs
b3dzIDE2IGJ5dGUgdGFncy4gU28gSSBoYXZlIHRvIGZpZ3VyZSBvdXQgaG93IHRvIHNldCANCnVw
IHRoZSBkcml2ZXIgdG8gZXhwb3NlL2VuZm9yY2UgdGhhdCBsaW1pdGF0aW9uLiBUaGF0J3Mgd2hl
cmUgd2UgZ28gYXdyeS4NCg0KVGhhbmtzIG11Y2ghDQoNCg==
