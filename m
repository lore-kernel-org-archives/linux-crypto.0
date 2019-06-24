Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF62C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B2520657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="k5hnbXrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfFXT3O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:29:14 -0400
Received: from mail-eopbgr810059.outbound.protection.outlook.com ([40.107.81.59]:43760
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT3O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tvi+DyZQ0ggj2D4stciekZ72aj6nZGRaIACm0yaqG44=;
 b=k5hnbXrlKyrjw7hR1EFQwkvy5lSCDdlUYmuaXKiiSFcEqR1ueBBVIhylwqTqCI/fph/EaDQWBPSZ4qKHRlcj4xMLK5aaoJ6aY+giTJQ3CNIqqbgmHRlEf7icixWN74ROweVx5p+wWXoJhxcaNqjYDlE5V/MbfCQEQrm5zZBO5Gs=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:29:11 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:29:11 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 06/11] crypto: ccp - Specify a single CCP via PCI device ID
Thread-Topic: [PATCH 06/11] crypto: ccp - Specify a single CCP via PCI device
 ID
Thread-Index: AQHVKsMZJOOYo98Nvkm0n3SD5UeC6g==
Date:   Mon, 24 Jun 2019 19:29:11 +0000
Message-ID: <156140455020.116890.2457308391471121920.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0005.namprd02.prod.outlook.com
 (2603:10b6:803:2b::15) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 318897fa-b936-4c1d-af94-08d6f8da3c2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB2358FDD8A7F61CCCC302A257FDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(14444005)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Tngj/5bXx22Stl1l9DAJbGdJ3AR7pmRP9IpAOKM9jpAYQJx5s5Y3Inp1OQIdJJC1cuoVxxG2W8b3g3Xw1CsrMC1SqtJ1/NqznHKy0ktCgLtRXJUwAegPaGJiPBUjEtcFG44i0Ih5dNy5Tk5znTKnVddvn1DYFwFbFyGu6FYzWm4bwBt5JDwKM9ZJ6vPiBKWedLCvSlniIw4D1j4A75pEgdFRl5TwWb8+VTqYoIARjGF0slX3pOd/cHgLp+vi0lIfowYn3TH+V5VggtYyv1e4qXtErxc1mf0oUVJJ6UKr+3OTRX6JQmxkfYkSu4c2x1uHb+EUsARfXo4UG1gFxZioP382r8FAnqWIpgIi7Pc87+v4cOvU5GM8HJsDR4p+JEUQEqoCovHTJ6iPPEj0cjHMvn6o2+bbPUvM434oB+/tozg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45DB540D6BC7C346B49E4A67939E5596@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318897fa-b936-4c1d-af94-08d6f8da3c2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:29:11.8285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2358
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

U29tZSBwcm9jZXNzb3JzIGNvbnRhaW4gbXVsdGlwbGUgQ0NQcyB3aXRoIGRpZmZlcmluZyBkZXZp
Y2UgSURzLiBFbmFibGUNCnRoZSBzZWxlY3Rpb24gb2Ygc3BlY2lmaWMgZGV2aWNlcyBiYXNlZCBv
biBJRC4gVGhlIHBhcmFtZXRlciB2YWx1ZSBpcw0KYSBzaW5nbGUgUENJIElELg0KDQpTaWduZWQt
b2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQotLS0NCiBkcml2ZXJzL2Ny
eXB0by9jY3Avc3AtcGNpLmMgfCAgICA3ICsrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgYi9k
cml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCmluZGV4IDI5MTc3ZDExM2M5MC4uYjAyNGI5MmZi
NzQ5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQorKysgYi9kcml2
ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCkBAIC0zNiw2ICszNiw5IEBADQogLyoNCiAgKiBMaW1p
dCBDQ1AgdXNlIHRvIGEgc3BlY2lmZWQgbnVtYmVyIG9mIHF1ZXVlcyBwZXIgZGV2aWNlLg0KICAq
Lw0KK3N0YXRpYyB1bnNpZ25lZCBpbnQgcGNpZGV2Ow0KK21vZHVsZV9wYXJhbShwY2lkZXYsIHVp
bnQsIDA0NDQpOw0KK01PRFVMRV9QQVJNX0RFU0MocGNpZGV2LCAiRGV2aWNlIG51bWJlciBmb3Ig
YSBzcGVjaWZpYyBDQ1AiKTsNCiANCiBzdGF0aWMgc3RydWN0IG11dGV4IGRldmNvdW50X211dGV4
IF9fX19jYWNoZWxpbmVfYWxpZ25lZDsNCiBzdGF0aWMgdW5zaWduZWQgaW50IGRldmNvdW50ID0g
MDsNCkBAIC0yMDQsNiArMjA3LDEwIEBAIHN0YXRpYyBpbnQgc3BfcGNpX3Byb2JlKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpDQogCWlmIChtYXhk
ZXYgJiYgKGRldmNvdW50ID49IG1heGRldikpIC8qIFRvbyBtYW55IGRldmljZXM/ICovDQogCQly
ZXR1cm4gMDsNCiANCisJLyogSWYgYSBzcGVjaWZpYyBkZXZpY2UgSUQgaGFzIGJlZW4gc3BlY2lm
aWVkLCBmaWx0ZXIgZm9yIGl0ICovDQorICAgICAgICBpZiAocGNpZGV2ICYmIChwZGV2LT5kZXZp
Y2UgIT0gcGNpZGV2KSkNCisgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCisNCiAJ
cmV0ID0gLUVOT01FTTsNCiAJc3AgPSBzcF9hbGxvY19zdHJ1Y3QoZGV2KTsNCiAJaWYgKCFzcCkN
Cg0K
