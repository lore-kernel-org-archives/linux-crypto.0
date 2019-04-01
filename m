Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA52C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 13:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA67C2070D
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 13:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="BDS+/IJo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfDAN1a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 09:27:30 -0400
Received: from mail-eopbgr790040.outbound.protection.outlook.com ([40.107.79.40]:42940
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726852AbfDAN1a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 09:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40sV+czkmEHLFNrUUQ5QAKKhqah6HAxHsIy3/Gx2m18=;
 b=BDS+/IJoO2cOQmEg7uANdX5hrbSeGcKikGEoEX6kXfGXvKVVfPAAwo8TgX9pkLeGY0ooNSEEuixA0QPDgKR20N0Gl66CU5J1EirF5zATULKEuMtOpBiskFdxsqq0oM1f0x269NhIsjkxciJkc0RlNc5uht8+b3xbX0fzX9dh1Dw=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.38.138) by
 DM5PR12MB1211.namprd12.prod.outlook.com (10.168.237.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.16; Mon, 1 Apr 2019 13:27:27 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::890d:8adb:6785:6ca1]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::890d:8adb:6785:6ca1%4]) with mapi id 15.20.1750.017; Mon, 1 Apr 2019
 13:27:27 +0000
From:   Gary R Hook <ghook@amd.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: ccp - Use kmemdup in
 ccp_copy_and_save_keypart()
Thread-Topic: [PATCH -next] crypto: ccp - Use kmemdup in
 ccp_copy_and_save_keypart()
Thread-Index: AQHU5phZL/p/UJJpU0uSUfuWvtjJvqYnUBmA
Date:   Mon, 1 Apr 2019 13:27:27 +0000
Message-ID: <133b98b0-829e-ffa8-5fb9-ef952ef3c996@amd.com>
References: <20190330014316.174072-1-yuehaibing@huawei.com>
In-Reply-To: <20190330014316.174072-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR16CA0055.namprd16.prod.outlook.com
 (2603:10b6:805:ca::32) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57279361-e577-4a70-1319-08d6b6a5c897
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM5PR12MB1211;
x-ms-traffictypediagnostic: DM5PR12MB1211:
x-microsoft-antispam-prvs: <DM5PR12MB1211CF370BF0B1762E6186D9FD550@DM5PR12MB1211.namprd12.prod.outlook.com>
x-forefront-prvs: 0994F5E0C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(39860400002)(346002)(136003)(189003)(199004)(6436002)(52116002)(99286004)(31686004)(4326008)(6486002)(2616005)(105586002)(81166006)(110136005)(25786009)(54906003)(106356001)(256004)(6246003)(4744005)(72206003)(71200400001)(71190400001)(31696002)(446003)(11346002)(14454004)(486006)(7736002)(478600001)(476003)(186003)(66066001)(8676002)(229853002)(305945005)(36756003)(6512007)(53546011)(102836004)(6506007)(2906002)(6116002)(53936002)(26005)(68736007)(3846002)(97736004)(5660300002)(8936002)(76176011)(386003)(81156014)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1211;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rGShDvBAlsl9T2xp4NXhiBbCBWntSS9/TDcbrDskFp9XdcTd9YRwLOQ3gHD5J10yr3kPKX2fkOPx3hbnro8TOu9WTaMGObkkdIdO4qtTZhdmn145E+HBYwqUFWlzG9WA9iHn8EPdTtnVU/sCybqy+EBpi/JZlb6HHaCmdRzzG6yOYb2/cr1hYVs6gBs9zFaqRQBm4QVmhr4XHMtIz1YLMPeqmjaT2XzHr/iIoFEpUYwDS4JQZI9L5XAyKA6BY3ge7pydknCaIIf1zeXyuwsXIHjSRH/nBQRAbudeZ8F5Idjcyazk05RzKITvRARU0p99Ua42kEXpyE9HofC59GEsG00Rze9c4rKwNWofK2ub0ENKNq/UbaTQimbMHgH+6deupMH6c+qw0TgJfi5IO58N0VIN9rZkjxIa6VbsoZXd+ZI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <299EC8170B1CA74292DE8D8E34F0D658@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57279361-e577-4a70-1319-08d6b6a5c897
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2019 13:27:27.3359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1211
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMy8yOS8xOSA4OjQzIFBNLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBVc2Uga21lbWR1cCByYXRo
ZXIgdGhhbiBkdXBsaWNhdGluZyBpdHMgaW1wbGVtZW50YXRpb24NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCg0KQWNrZWQtYnk6IEdhcnkg
UiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCg0KPiAtLS0NCj4gICBkcml2ZXJzL2NyeXB0by9j
Y3AvY2NwLWNyeXB0by1yc2EuYyB8IDMgKy0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRv
L2NjcC9jY3AtY3J5cHRvLXJzYS5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1jcnlwdG8tcnNh
LmMNCj4gaW5kZXggMGI4YWFiMDA5ZTdiLi44NDFhY2RmZmJjM2MgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvY3J5cHRvL2NjcC9jY3AtY3J5cHRvLXJzYS5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRv
L2NjcC9jY3AtY3J5cHRvLXJzYS5jDQo+IEBAIC0zNywxMCArMzcsOSBAQCBzdGF0aWMgaW5saW5l
IGludCBjY3BfY29weV9hbmRfc2F2ZV9rZXlwYXJ0KHU4ICoqa3BidWYsIHVuc2lnbmVkIGludCAq
a3BsZW4sDQo+ICAgCQlpZiAoYnVmW25za2lwXSkNCj4gICAJCQlicmVhazsNCj4gICAJKmtwbGVu
ID0gc3ogLSBuc2tpcDsNCj4gLQkqa3BidWYgPSBremFsbG9jKCprcGxlbiwgR0ZQX0tFUk5FTCk7
DQo+ICsJKmtwYnVmID0ga21lbWR1cChidWYgKyBuc2tpcCwgKmtwbGVuLCBHRlBfS0VSTkVMKTsN
Cj4gICAJaWYgKCEqa3BidWYpDQo+ICAgCQlyZXR1cm4gLUVOT01FTTsNCj4gLQltZW1jcHkoKmtw
YnVmLCBidWYgKyBuc2tpcCwgKmtwbGVuKTsNCj4gICANCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0K
PiANCj4gDQo+IA0KDQo=
