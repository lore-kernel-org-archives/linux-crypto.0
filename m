Return-Path: <SRS0=bFfa=QW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4CEC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 17:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD6A21929
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 17:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="EXzPU1VC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfBOR0g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Feb 2019 12:26:36 -0500
Received: from mail-eopbgr710074.outbound.protection.outlook.com ([40.107.71.74]:23680
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfBOR0g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Feb 2019 12:26:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIfbS+zqHTOyykh9TTb6JkvLVRtOd7P/SmsxVs9YkmY=;
 b=EXzPU1VCanULTXCXQe54qcmxGA7qvi6K5/tmuHwLUPWwetsu8yF6LcHXhBp4BHtHXmDHhVIrmI6XYw2Umnee+zdaAc27QDqIqdsGggWyi+Wba6ciHDKqmBZBXkPbih2dKOI8dXO7yE1J8rju/NmBlaYZSLMPmKOCEXLmbRhytkU=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3385.namprd12.prod.outlook.com (20.178.198.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Fri, 15 Feb 2019 17:26:33 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::2809:46:d708:b9c1]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::2809:46:d708:b9c1%5]) with mapi id 15.20.1622.016; Fri, 15 Feb 2019
 17:26:33 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Borislav Petkov <bp@alien8.de>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Subject: [PATCH] crypto: ccp - Update driver messages to remove some confusion
Thread-Topic: [PATCH] crypto: ccp - Update driver messages to remove some
 confusion
Thread-Index: AQHUxVOYyF+ESvknhEyViohsVlKHFg==
Date:   Fri, 15 Feb 2019 17:26:33 +0000
Message-ID: <155025159161.22636.12469459044882251074.stgit@tlendack-t1.amdoffice.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR16CA0071.namprd16.prod.outlook.com
 (2603:10b6:805:ca::48) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8574a893-a87e-411f-356b-08d6936abae6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR12MB3385;
x-ms-traffictypediagnostic: DM6PR12MB3385:
x-microsoft-exchange-diagnostics: 1;DM6PR12MB3385;20:elpNVuGMNc2HbQQZLRCRLrjjwTFCQr05VUHJUPuouDot89UvmQffymJJaTpR/cQlW34F+wstaRrXunDkIyMHqTPFrtV8wTt1ut+l6cgegxL5PEB8xpFoWi0DDlp/T/ZduUlMIYMIYbC+ajSpTm+KICDIcL+7D329YIsUPG+x/pMtnH8IgwF51m7l+6M3lT1TPb55e5zl4AJlukdQLmk+Z7T2lkm+aDdagCEKY9DvXNHFszOlz4KBfusmYjWJDLsR
x-microsoft-antispam-prvs: <DM6PR12MB33852E47404F9831E50ABBB0EC600@DM6PR12MB3385.namprd12.prod.outlook.com>
x-forefront-prvs: 09497C15EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(396003)(376002)(136003)(39860400002)(199004)(189003)(105586002)(7736002)(81166006)(8676002)(68736007)(305945005)(8936002)(54906003)(14444005)(81156014)(6486002)(2906002)(316002)(103116003)(66066001)(3846002)(478600001)(6916009)(14454004)(6116002)(186003)(72206003)(15650500001)(33896004)(102836004)(26005)(6506007)(486006)(86362001)(25786009)(2501003)(256004)(6512007)(476003)(9686003)(386003)(2351001)(6436002)(53936002)(5640700003)(99286004)(71190400001)(52116002)(71200400001)(4326008)(106356001)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3385;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A6c2mEDL5EioLGGSegXHHvuSfndHxvGDysrxNmRJEkcK0NpRDJ/vNTMsCm4i/WTyOc6yDncQwbG7Eo/zgGmoeYZZCT3lOFi/D2JrfCU9RQKe/ezZlGngGmb8ZM1pRIr95NSr+3Yt0itoKCjSq0BftlDOBvk2/ovS8cGMgpFPDAonCj44zRAys4do6VZqyzU2lBiRyNU0QCTRErG8Gtk4CXEZNmeJ1oguCgOw1RWeQOreimV5iXgE7zIj4lxZuBd0cFZtblL1oAXG08ceMryH4WRa2n0/8kdTebRZlwsfGHwaoPKqIFA9NtsCgUpPYO618QpujDOQ/MvwoWvInJN/k8ptLEK4+dYHaUhcWTkAwKqw4QDOAKWdQA169OuSbpgGn+FJK9RSOvbAfIOhowFffBt0wNgQ7nJb/pkRfC5mXPI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C0A0B566C45304DBB3311800F77FDFB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8574a893-a87e-411f-356b-08d6936abae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2019 17:26:32.6856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3385
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlIGN1cnJlbnQgY29udGVudCBvZiBzb21lIG9mIHRoZSBkcml2ZXIgbWVzc2FnZXMgYW5kIHRo
ZSB3YXkgdGhhdCB0aGV5DQphcmUgaXNzdWVkIHJlc3VsdHMgaW4gc29tZSBjb25mdXNpb24sIGVz
cGVjaWFsbHkgaW4gdGhlIGFyZWEgb2YgdGhlIFBTUA0KYXMgaXQgcmVsYXRlcyB0byBTRVYgc3Vw
cG9ydC4gSWYgU0VWIGlzIG5vdCBzdXBwb3J0ZWQsIGEgbWVzc2FnZSBpcyBpc3N1ZWQNCnRoYXQg
c2F5cyAicHNwIGluaXRpYWxpemF0aW9uIGZhaWxlZC4iIFRoaXMgbWFrZXMgaXQgc2VlbSBsaWtl
IHRoZXJlIHdhcw0KYSBwcm9ibGVtLCB3aGVuIGluIGZhY3QsIHRoZSBQU1Agc3VwcG9ydCBpcyBq
dXN0IGRpc2FibGVkIGlmIFNFViBpcyBub3QNCnN1cHBvcnRlZC4NCg0KVXBkYXRlIHRoZSBkcml2
ZXIgdG8gY2hlY2sgU0VWIHN1cHBvcnQgYSBiaXQgZWFybGllciBhbmQgaXNzdWUgYSBkZWJ1Zy0N
CmxldmVsIG1lc3NhZ2UgaWYgU0VWIGlzIG5vdCBzdXBwb3J0ZWQsIGZvbGxvd2VkIGJ5IGEgZGVi
dWctbGV2ZWwgbWVzc2FnZQ0KdGhhdCB0aGUgUFNQIGlzIGRpc2FibGVkLiBUaGlzIHdheSB5b3Ug
d2lsbCBvbmx5IHNlZSBQU1AgbWVzc2FnZXMgaWYgU0VWDQppcyBzdXBwb3J0ZWQgb3IgaWYgZGVi
dWcgaW5mb3JtYXRpb24gaXMgZGVzaXJlZC4gQWxzbywgcmVtb3ZlIHRoZSBvdmVyYWxsDQoiZW5h
YmxlZCIgYW5kICJkaXNhYmxlZCIgbWVzc2FnZXMgZm9yIHRoZSBkcml2ZXIgYW5kIHJlbHkgb24g
dGhlIENDUCBhbmQNClBTUCBzdXBwb3J0IHRvIGlzc3VlIGNvbXBvbmVudC1zcGVjaWZpYyBtZXNz
YWdlcy4NCg0KU2lnbmVkLW9mZi1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1k
LmNvbT4NCi0tLQ0KIGRyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMgfCAgIDE5ICsrKysrKysr
KysrKysrLS0tLS0NCiBkcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgIHwgICAgNCAtLS0tDQog
MiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYyBiL2RyaXZlcnMvY3J5cHRvL2Nj
cC9wc3AtZGV2LmMNCmluZGV4IDYzOGYxMzhkZWJkNy4uZmFkZjg1OWExNGI4IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYw0KKysrIGIvZHJpdmVycy9jcnlwdG8vY2Nw
L3BzcC1kZXYuYw0KQEAgLTg1OCwxNSArODU4LDE1IEBAIHN0YXRpYyBpbnQgc2V2X21pc2NfaW5p
dChzdHJ1Y3QgcHNwX2RldmljZSAqcHNwKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIGlu
dCBzZXZfaW5pdChzdHJ1Y3QgcHNwX2RldmljZSAqcHNwKQ0KK3N0YXRpYyBpbnQgcHNwX2NoZWNr
X3Nldl9zdXBwb3J0KHN0cnVjdCBwc3BfZGV2aWNlICpwc3ApDQogew0KIAkvKiBDaGVjayBpZiBk
ZXZpY2Ugc3VwcG9ydHMgU0VWIGZlYXR1cmUgKi8NCiAJaWYgKCEoaW9yZWFkMzIocHNwLT5pb19y
ZWdzICsgcHNwLT52ZGF0YS0+ZmVhdHVyZV9yZWcpICYgMSkpIHsNCi0JCWRldl9kYmcocHNwLT5k
ZXYsICJkZXZpY2UgZG9lcyBub3Qgc3VwcG9ydCBTRVZcbiIpOw0KLQkJcmV0dXJuIDE7DQorCQlk
ZXZfZGJnKHBzcC0+ZGV2LCAicHNwIGRvZXMgbm90IHN1cHBvcnQgU0VWXG4iKTsNCisJCXJldHVy
biAtRU5PREVWOw0KIAl9DQogDQotCXJldHVybiBzZXZfbWlzY19pbml0KHBzcCk7DQorCXJldHVy
biAwOw0KIH0NCiANCiBpbnQgcHNwX2Rldl9pbml0KHN0cnVjdCBzcF9kZXZpY2UgKnNwKQ0KQEAg
LTg5MSw2ICs4OTEsMTAgQEAgaW50IHBzcF9kZXZfaW5pdChzdHJ1Y3Qgc3BfZGV2aWNlICpzcCkN
CiANCiAJcHNwLT5pb19yZWdzID0gc3AtPmlvX21hcDsNCiANCisJcmV0ID0gcHNwX2NoZWNrX3Nl
dl9zdXBwb3J0KHBzcCk7DQorCWlmIChyZXQpDQorCQlnb3RvIGVfZGlzYWJsZTsNCisNCiAJLyog
RGlzYWJsZSBhbmQgY2xlYXIgaW50ZXJydXB0cyB1bnRpbCByZWFkeSAqLw0KIAlpb3dyaXRlMzIo
MCwgcHNwLT5pb19yZWdzICsgcHNwLT52ZGF0YS0+aW50ZW5fcmVnKTsNCiAJaW93cml0ZTMyKC0x
LCBwc3AtPmlvX3JlZ3MgKyBwc3AtPnZkYXRhLT5pbnRzdHNfcmVnKTsNCkBAIC05MDIsNyArOTA2
LDcgQEAgaW50IHBzcF9kZXZfaW5pdChzdHJ1Y3Qgc3BfZGV2aWNlICpzcCkNCiAJCWdvdG8gZV9l
cnI7DQogCX0NCiANCi0JcmV0ID0gc2V2X2luaXQocHNwKTsNCisJcmV0ID0gc2V2X21pc2NfaW5p
dChwc3ApOw0KIAlpZiAocmV0KQ0KIAkJZ290byBlX2lycTsNCiANCkBAIC05MjMsNiArOTI3LDEx
IEBAIGludCBwc3BfZGV2X2luaXQoc3RydWN0IHNwX2RldmljZSAqc3ApDQogDQogCWRldl9ub3Rp
Y2UoZGV2LCAicHNwIGluaXRpYWxpemF0aW9uIGZhaWxlZFxuIik7DQogDQorCXJldHVybiByZXQ7
DQorDQorZV9kaXNhYmxlOg0KKwlzcC0+cHNwX2RhdGEgPSBOVUxMOw0KKw0KIAlyZXR1cm4gcmV0
Ow0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgYi9kcml2
ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCmluZGV4IDZkNzMwZDNlM2Y2Zi4uNDFiY2UwYTNmNGJi
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQorKysgYi9kcml2ZXJz
L2NyeXB0by9jY3Avc3AtcGNpLmMNCkBAIC0yMjYsOCArMjI2LDYgQEAgc3RhdGljIGludCBzcF9w
Y2lfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lk
ICppZCkNCiAJaWYgKHJldCkNCiAJCWdvdG8gZV9lcnI7DQogDQotCWRldl9ub3RpY2UoZGV2LCAi
ZW5hYmxlZFxuIik7DQotDQogCXJldHVybiAwOw0KIA0KIGVfZXJyOg0KQEAgLTI0Niw4ICsyNDQs
NiBAQCBzdGF0aWMgdm9pZCBzcF9wY2lfcmVtb3ZlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KIAlz
cF9kZXN0cm95KHNwKTsNCiANCiAJc3BfZnJlZV9pcnFzKHNwKTsNCi0NCi0JZGV2X25vdGljZShk
ZXYsICJkaXNhYmxlZFxuIik7DQogfQ0KIA0KICNpZmRlZiBDT05GSUdfUE0NCg0K
