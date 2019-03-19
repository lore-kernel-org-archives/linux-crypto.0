Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F67C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 18:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B717220811
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 18:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="BPIH7qym"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfCSSjG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:39:06 -0400
Received: from mail-eopbgr770077.outbound.protection.outlook.com ([40.107.77.77]:36233
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbfCSSjG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 14:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDWNT5ZqH82SeoEY+Q4G+44H2sk0nwdhJLWcgtYgzLE=;
 b=BPIH7qym84Si+nYt+rDUYpTnRWWzpmVpZuMuJHyoeacmnbhi7m03g7sbdWTvcJ3twYH07CSuXe8rJQJ+CrT4lsXJOmHqckONaGUj4L5/t1xtHxXBRP4htiyi2iEtmTwGRTg+uSpzha71w9qUp/Dvf8SdM71pFSA4GEP8GSi10xw=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.38.138) by
 DM5PR12MB1609.namprd12.prod.outlook.com (10.172.40.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Tue, 19 Mar 2019 18:39:03 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::890d:8adb:6785:6ca1]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::890d:8adb:6785:6ca1%4]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 18:39:03 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Yue Haibing <yuehaibing@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: ccp - Make ccp_register_rsa_alg static
Thread-Topic: [PATCH -next] crypto: ccp - Make ccp_register_rsa_alg static
Thread-Index: AQHU3lrX/0EQ9IIfOketOsF+tKHOnKYTSVMA
Date:   Tue, 19 Mar 2019 18:39:03 +0000
Message-ID: <595b4fe4-acf1-97fc-c49d-5d3be2d83284@amd.com>
References: <20190319135035.22056-1-yuehaibing@huawei.com>
In-Reply-To: <20190319135035.22056-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:805:8e::32) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdacd4c4-0fc6-4f99-1bd9-08d6ac9a28b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM5PR12MB1609;
x-ms-traffictypediagnostic: DM5PR12MB1609:
x-microsoft-antispam-prvs: <DM5PR12MB1609ABD67E2522F6E4884984FD400@DM5PR12MB1609.namprd12.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(39860400002)(136003)(189003)(199004)(2501003)(7736002)(53546011)(76176011)(36756003)(81166006)(26005)(81156014)(8676002)(8936002)(305945005)(110136005)(4326008)(97736004)(25786009)(102836004)(3846002)(186003)(6506007)(6116002)(54906003)(52116002)(316002)(386003)(14454004)(68736007)(53936002)(2906002)(105586002)(6246003)(99286004)(478600001)(446003)(66066001)(229853002)(486006)(72206003)(6486002)(31686004)(106356001)(4744005)(5660300002)(6512007)(71200400001)(6436002)(31696002)(14444005)(71190400001)(2616005)(256004)(476003)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1609;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fvxyf9vWlev6ljOf6RR9WTFJW2YVhxvVaWks71uVg33v5N/rGjgaVyPqRF/4HnVMlRPyoQhM77B+K7cNrFwQSsIB+Wwd9PblvtK4vtF5hQsU1bBsKcebnBvy1BCrmx4uCV7T+VMkZppq/FprTEXas7LDZufeKGpQTj+7lAq+mH5Cm4u8FlP8jOSkvFK0gGtE4Kuf1v7sp1xxWTvZnhpPuKcXQdwhmsgzy7pP+zUzSLwqxh9ZHrF6+uszLqNXEH3aCg3nWmSf9xjlqSxMw1rAt6hz/pbe+0AvMKcL+oNCfmWnjwmjE5hWUgjeHozLkGKokevYhquTeHBHIrNHgPx4IjQ4gtE2HZ666Mvvg8CERveB5MWC4H0wYARRQktG6OCT+56JkEXlWzKxDzc3EPsufuI6zJx108Ou2cXOGJf7dWY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E212AAE6B8538458CD8A73859BCB65C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdacd4c4-0fc6-4f99-1bd9-08d6ac9a28b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 18:39:03.3229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1609
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMy8xOS8xOSA4OjUwIEFNLCBZdWUgSGFpYmluZyB3cm90ZToNCj4gRnJvbTogWXVlSGFpYmlu
ZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KPiANCj4gRml4IHNwYXJzZSB3YXJuaW5nOg0KPiAN
Cj4gZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tcnNhLmM6MjUxOjU6DQo+ICAgd2Fybmlu
Zzogc3ltYm9sICdjY3BfcmVnaXN0ZXJfcnNhX2FsZycgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxk
IGl0IGJlIHN0YXRpYz8NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJp
bmdAaHVhd2VpLmNvbT4NCg0KQWNrZWQtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNv
bS4NCg0KPiAtLS0NCj4gICBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWNyeXB0by1yc2EuYyB8IDMg
KystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5cHRvLXJzYS5jIGIv
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tcnNhLmMNCj4gaW5kZXggMDU4NTBkZi4uMGI4
YWFiMDAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5cHRvLXJzYS5j
DQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5cHRvLXJzYS5jDQo+IEBAIC0yNDgs
NyArMjQ4LDggQEAgc3RhdGljIHN0cnVjdCBjY3BfcnNhX2RlZiByc2FfYWxnc1tdID0gew0KPiAg
IAl9DQo+ICAgfTsNCj4gICANCj4gLWludCBjY3BfcmVnaXN0ZXJfcnNhX2FsZyhzdHJ1Y3QgbGlz
dF9oZWFkICpoZWFkLCBjb25zdCBzdHJ1Y3QgY2NwX3JzYV9kZWYgKmRlZikNCj4gK3N0YXRpYyBp
bnQgY2NwX3JlZ2lzdGVyX3JzYV9hbGcoc3RydWN0IGxpc3RfaGVhZCAqaGVhZCwNCj4gKwkJCSAg
ICAgICAgY29uc3Qgc3RydWN0IGNjcF9yc2FfZGVmICpkZWYpDQo+ICAgew0KPiAgIAlzdHJ1Y3Qg
Y2NwX2NyeXB0b19ha2NpcGhlcl9hbGcgKmNjcF9hbGc7DQo+ICAgCXN0cnVjdCBha2NpcGhlcl9h
bGcgKmFsZzsNCj4gDQoNCg==
